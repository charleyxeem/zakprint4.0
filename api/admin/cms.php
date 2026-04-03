<?php
/**
 * api/admin/cms.php
 * Content Studio — manage cms_pages, cms_blocks, page_assets, pages.
 * super_admin only.
 *
 * GET ?page=home           → all blocks + assets for the page
 * POST (blocks)            → upsert a cms_block
 * PATCH ?asset_key=X       → upsert a page_asset
 * DELETE ?block_id=X       → delete a block
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin(['super_admin', 'developer']);

$method = $_SERVER['REQUEST_METHOD'];

// ── GET: load a page's blocks + assets ────────────────────────────────────
if ($method === 'GET') {
    // Pages list
    if (isset($_GET['pages'])) {
        $stmt = $pdo->query('SELECT id, slug, title, is_active FROM cms_pages ORDER BY id');
        respond(['pages' => $stmt->fetchAll()]);
    }

    $pageSlug = clean($_GET['page'] ?? 'home');
    $pageStmt = $pdo->prepare('SELECT * FROM cms_pages WHERE slug = ? LIMIT 1');
    $pageStmt->execute([$pageSlug]);
    $page = $pageStmt->fetch();
    if (!$page) err('Page not found.', 404);

    $blocks = $pdo->prepare('SELECT * FROM cms_blocks WHERE page_id = ? ORDER BY sort_order ASC');
    $blocks->execute([$page['id']]);

    $assets = $pdo->prepare("SELECT * FROM page_assets WHERE tenant_id = 1 AND page_key IN (?, 'global')");
    $assets->execute([$pageSlug]);
    $assetsKeyed = [];
    foreach ($assets->fetchAll() as $a) $assetsKeyed[$a['asset_key']] = $a;

    // Rich text page content
    $content = null;
    if (in_array($pageSlug, ['about','services','contact'])) {
        $cStmt = $pdo->prepare("SELECT title, content FROM pages WHERE tenant_id = 1 AND `key` = ? LIMIT 1");
        $cStmt->execute([$pageSlug]);
        $content = $cStmt->fetch() ?: null;
    }

    respond(['page' => $page, 'blocks' => $blocks->fetchAll(), 'assets' => $assetsKeyed, 'content' => $content]);
}

// ── POST: upsert a block ───────────────────────────────────────────────────
if ($method === 'POST') {
    $body = getBody();
    $action = $body['action'] ?? 'block';

    if ($action === 'block') {
        requireFields($body, ['page_id', 'block_key']);
        $existing = $pdo->prepare('SELECT id FROM cms_blocks WHERE page_id = ? AND block_key = ?');
        $existing->execute([$body['page_id'], $body['block_key']]);
        $row = $existing->fetch();

        if ($row) {
            $pdo->prepare('UPDATE cms_blocks SET title = ?, content_html = ?, image_path = ? WHERE id = ?')
                ->execute([clean($body['title'] ?? ''), $body['content_html'] ?? '', clean($body['image_path'] ?? ''), $row['id']]);
            respond(['success' => true, 'id' => $row['id']]);
        }

        $stmt = $pdo->prepare('INSERT INTO cms_blocks (page_id, block_key, title, content_html, image_path, sort_order) VALUES (?, ?, ?, ?, ?, ?)');
        $stmt->execute([$body['page_id'], clean($body['block_key']), clean($body['title'] ?? ''), $body['content_html'] ?? '', clean($body['image_path'] ?? ''), (int)($body['sort_order'] ?? 0)]);
        respond(['success' => true, 'id' => (int)$pdo->lastInsertId()], 201);
    }

    // Page rich text (about, services)
    if ($action === 'page_content') {
        requireFields($body, ['key', 'content']);
        $pdo->prepare("INSERT INTO pages (tenant_id, `key`, title, content, updated_by) VALUES (1, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE content = VALUES(content), title = VALUES(title), updated_by = VALUES(updated_by)")
            ->execute([clean($body['key']), clean($body['title'] ?? ''), $body['content'], currentUserId()]);
        respond(['success' => true]);
    }

    // Page asset upsert
    if ($action === 'asset') {
        requireFields($body, ['page_key', 'asset_key', 'file_path']);
        $pdo->prepare("INSERT INTO page_assets (tenant_id, page_key, asset_key, label, type, file_path, alt_text, updated_by)
            VALUES (1, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE file_path = VALUES(file_path), alt_text = VALUES(alt_text), updated_by = VALUES(updated_by)")
            ->execute([clean($body['page_key']), clean($body['asset_key']), clean($body['label'] ?? ''), $body['type'] ?? 'image', clean($body['file_path']), clean($body['alt_text'] ?? ''), currentUserId()]);
        respond(['success' => true]);
    }

    // ── File upload for CMS assets ───────────────────────────────────────
    if ($action === 'upload') {
        if (empty($_FILES['file'])) err('No file uploaded.', 400);
        $file = $_FILES['file'];
        if ($file['error'] !== UPLOAD_ERR_OK) err('Upload error: ' . $file['error'], 400);

        // Validate file type
        $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);
        if (!in_array($mime, $allowed)) err('Invalid file type. Allowed: JPG, PNG, GIF, WebP, SVG', 400);

        // Max 5MB
        if ($file['size'] > 5 * 1024 * 1024) err('File too large. Max 5MB.', 400);

        // Determine upload directory
        $uploadDir = dirname(__DIR__, 2) . '/uploads/cms/';
        if (!is_dir($uploadDir)) mkdir($uploadDir, 0755, true);

        // Generate safe filename
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        $safeName = uniqid('cms_', true) . '.' . ($ext ?: 'jpg');
        $destPath = $uploadDir . $safeName;

        if (!move_uploaded_file($file['tmp_name'], $destPath)) {
            err('Failed to save file.', 500);
        }

        $relativePath = 'uploads/cms/' . $safeName;

        // Optionally upsert the page_assets record if page_key and asset_key provided
        $pageKey = clean($_POST['page_key'] ?? '');
        $assetKey = clean($_POST['asset_key'] ?? '');
        if ($pageKey && $assetKey) {
            $pdo->prepare("INSERT INTO page_assets (tenant_id, page_key, asset_key, label, type, file_path, alt_text, updated_by)
                VALUES (1, ?, ?, ?, 'image', ?, ?, ?)
                ON DUPLICATE KEY UPDATE file_path = VALUES(file_path), alt_text = VALUES(alt_text), updated_by = VALUES(updated_by)")
                ->execute([$pageKey, $assetKey, clean($_POST['label'] ?? $file['name']), $relativePath, clean($_POST['alt_text'] ?? ''), currentUserId()]);
        }

        respond(['success' => true, 'file_path' => $relativePath, 'url' => '/' . $relativePath]);
    }
}

// ── DELETE: remove a block ─────────────────────────────────────────────────
if ($method === 'DELETE') {
    $blockId = isset($_GET['block_id']) ? (int)$_GET['block_id'] : null;
    if (!$blockId) err('block_id required.');
    $pdo->prepare('DELETE FROM cms_blocks WHERE id = ?')->execute([$blockId]);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
