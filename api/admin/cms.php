<?php
declare(strict_types=1);

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

function cmsPageColumns(PDO $pdo): array {
    $stmt = $pdo->query("SHOW COLUMNS FROM cms_pages");
    $cols = [];
    foreach ($stmt->fetchAll() as $row) {
        $name = $row['Field'] ?? null;
        if ($name) {
            $cols[$name] = true;
        }
    }
    return $cols;
}

function hasCmsPageColumn(array $cols, string $name): bool {
    return isset($cols[$name]);
}

function cmsPageWhereTenant(array $cols, string $alias = ''): string {
    if (!hasCmsPageColumn($cols, 'tenant_id')) {
        return '1=1';
    }
    $prefix = $alias !== '' ? ($alias . '.') : '';
    return $prefix . 'tenant_id = 1';
}

function cmsNodeInnerHtml(DOMNode $node): string {
    $html = '';
    foreach ($node->childNodes as $child) {
        $html .= $node->ownerDocument->saveHTML($child);
    }
    return $html;
}

function cmsExtractPageTemplateBlocks(string $pageTemplatePath, string $pageSlug = ''): array {
    if (!is_file($pageTemplatePath)) {
        return [];
    }

    $raw = file_get_contents($pageTemplatePath);
    if ($raw === false || $raw === '') {
        return [];
    }

    $dom = new DOMDocument();
    libxml_use_internal_errors(true);
    $dom->loadHTML($raw, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
    libxml_clear_errors();

    $xpath = new DOMXPath($dom);
    $nodes = $xpath->query('//*[@data-cms-block]');

    $blocks = [];
    $order = 1;
    foreach ($nodes as $node) {
        if (!($node instanceof DOMElement)) {
            continue;
        }

        $key = trim((string)$node->getAttribute('data-cms-block'));
        if ($key === '') {
            continue;
        }

        // Remove page slug prefix (e.g., 'home_', 'about_', etc.)
        $stripPrefix = ($pageSlug !== '' ? preg_quote($pageSlug . '_', '/') : 'home_');
        $cleanKey = preg_replace('/^' . $stripPrefix . '/', '', $key);
        
        $title = ucwords(str_replace('_', ' ', $cleanKey));
        $blocks[] = [
            'block_key' => $key,
            'title' => $title !== '' ? $title : 'Block',
            'content_html' => cmsNodeInnerHtml($node),
            'sort_order' => $order,
        ];
        $order += 1;
    }

    return $blocks;
}

// Kept for backward compatibility
function cmsExtractHomeTemplateBlocks(string $homeTemplatePath): array {
    return cmsExtractPageTemplateBlocks($homeTemplatePath, 'home');
}

function cmsEnsurePageBlocks(PDO $pdo, int $pageId, string $pageSlug): void {
    if ($pageId <= 0) {
        return;
    }

    $existingStmt = $pdo->prepare('SELECT block_key FROM cms_blocks WHERE page_id = ?');
    $existingStmt->execute([$pageId]);
    $existing = [];
    foreach ($existingStmt->fetchAll() as $row) {
        $k = trim((string)($row['block_key'] ?? ''));
        if ($k !== '') {
            $existing[$k] = true;
        }
    }

    $templatePath = cmsTemplatePathFromPageKey($pageSlug);
    if ($templatePath === null) {
        return;
    }
    
    $templateBlocks = cmsExtractPageTemplateBlocks($templatePath, $pageSlug);
    if (!$templateBlocks) {
        return;
    }

    $insert = $pdo->prepare('INSERT INTO cms_blocks (page_id, block_key, block_type, title, content_html, image_path, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?)');
    foreach ($templateBlocks as $b) {
        $key = (string)$b['block_key'];
        if (isset($existing[$key])) {
            continue;
        }

        $insert->execute([
            $pageId,
            $key,
            'text',
            $b['title'],
            $b['content_html'],
            '',
            (int)$b['sort_order'],
        ]);
    }
}

// Kept for backward compatibility
function cmsEnsureHomeBlocks(PDO $pdo, int $pageId): void {
    cmsEnsurePageBlocks($pdo, $pageId, 'home');
}

function cmsTemplatePathFromPageKey(string $pageKey): ?string {
    $root = dirname(__DIR__, 2);
    $map = [
        'home' => 'Frontend-public/home.html',
        'about' => 'Frontend-public/about.html',
        'services' => 'Frontend-public/services.html',
        'contact' => 'Frontend-public/contact.html',
        'blog' => 'Frontend-public/blog.html',
        'blog_insights' => 'Frontend-public/blog.html',
        'shop' => 'Frontend-public/shop.html',
        'appointment' => 'Frontend-public/appointment.html',
        'book_appointment' => 'Frontend-public/appointment.html',
        'product-detail' => 'Frontend-public/product-detail.html',
        'checkout' => 'Frontend-public/checkout.html',
        'order-confirm' => 'Frontend-public/order-confirm.html',
        'user-login' => 'Frontend-public/user-login.html',
        'user-dash' => 'Frontend-public/user-dash.html',
        'user-my-order' => 'Frontend-public/user-my-order.html',
        'user-my-settings' => 'Frontend-public/user-my-settings.html',
        'faq' => 'Frontend-public/faq.html',
        'portfolio' => 'Frontend-public/portfolio.html',
        'shipping-info' => 'Frontend-public/shipping-info.html',
        'shipping_info' => 'Frontend-public/shipping-info.html',
        'terms' => 'Frontend-public/terms.html',
        'privacy-policy' => 'Frontend-public/privacy-policy.html',
        'privacy_policy' => 'Frontend-public/privacy-policy.html',
    ];

    $k = trim($pageKey);
    if ($k === '') {
        return null;
    }

    $candidate = $map[$k] ?? null;
    if ($candidate === null) {
        $slugFile = 'Frontend-public/' . str_replace('_', '-', $k) . '.html';
        $fullSlug = $root . '/' . $slugFile;
        if (is_file($fullSlug)) {
            return $fullSlug;
        }
        return null;
    }

    $full = $root . '/' . $candidate;
    return is_file($full) ? $full : null;
}

function cmsNormalizeAssetPath(string $src): string {
    $s = trim($src);
    if ($s === '') {
        return '';
    }

    if (preg_match('/^https?:\/\//i', $s) === 1) {
        return $s;
    }

    $s = preg_replace('#^\.\./#', '', $s);
    $s = preg_replace('#^\./#', '', $s);
    $s = ltrim($s, '/');
    return $s;
}

function cmsExtractTemplateAssets(string $templatePath): array {
    $raw = file_get_contents($templatePath);
    if ($raw === false || $raw === '') {
        return [];
    }

    $dom = new DOMDocument();
    libxml_use_internal_errors(true);
    $dom->loadHTML($raw, LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
    libxml_clear_errors();

    $xpath = new DOMXPath($dom);
    $nodes = $xpath->query('//*[@data-cms-asset]');

    $assets = [];
    foreach ($nodes as $node) {
        if (!($node instanceof DOMElement)) {
            continue;
        }

        $assetKey = trim((string)$node->getAttribute('data-cms-asset'));
        if ($assetKey === '') {
            continue;
        }

        $src = trim((string)$node->getAttribute('src'));
        $fallback = trim((string)$node->getAttribute('data-fallback-src'));
        $filePath = cmsNormalizeAssetPath($src !== '' ? $src : $fallback);
        if ($filePath === '') {
            continue;
        }

        $alt = trim((string)$node->getAttribute('alt'));
        $label = ucwords(str_replace('_', ' ', $assetKey));

        $assets[$assetKey] = [
            'asset_key' => $assetKey,
            'label' => $label,
            'type' => 'image',
            'file_path' => $filePath,
            'alt_text' => $alt,
        ];
    }

    return array_values($assets);
}

// ── GET: load a page's blocks + assets ────────────────────────────────────
if ($method === 'GET') {
    // Pages list
    if (isset($_GET['pages'])) {
        $cols = cmsPageColumns($pdo);

        $select = ['id', 'slug', 'title', 'is_active'];
        if (hasCmsPageColumn($cols, 'created_at')) {
            $select[] = 'created_at';
        }
        if (hasCmsPageColumn($cols, 'updated_at')) {
            $select[] = 'updated_at';
        }

        $orderBy = hasCmsPageColumn($cols, 'sort_order')
            ? 'sort_order ASC, id ASC'
            : 'id ASC';

        $sql = 'SELECT ' . implode(', ', $select) . ' FROM cms_pages ORDER BY ' . $orderBy;
        $stmt = $pdo->query($sql);
        respond(['pages' => $stmt->fetchAll()]);
    }

    // Navigation items
    if (isset($_GET['nav'])) {
        $rows = $pdo->query('SELECT id, label, href, sort_order, is_visible FROM nav_items WHERE tenant_id = 1 ORDER BY sort_order ASC')->fetchAll();
        respond(['nav' => $rows]);
    }

    // Site settings
    if (isset($_GET['settings'])) {
        $rows = $pdo->query('SELECT setting_key, value FROM site_settings WHERE tenant_id = 1')->fetchAll();
        $out = [];
        foreach ($rows as $r) {
            $out[$r['setting_key']] = $r['value'];
        }
        respond(['settings' => $out]);
    }

    $pageSlug = clean($_GET['page'] ?? 'home');
    $pageStmt = $pdo->prepare('SELECT * FROM cms_pages WHERE slug = ? LIMIT 1');
    $pageStmt->execute([$pageSlug]);
    $page = $pageStmt->fetch();
    if (!$page) err('Page not found.', 404);

    // Ensure blocks are seeded from template
    cmsEnsurePageBlocks($pdo, (int)($page['id'] ?? 0), $pageSlug);

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
    $action = $body['action'] ?? ($_POST['action'] ?? 'block');

    if ($action === 'block') {
        requireFields($body, ['page_id', 'block_key']);
        $existing = $pdo->prepare('SELECT id FROM cms_blocks WHERE page_id = ? AND block_key = ?');
        $existing->execute([$body['page_id'], $body['block_key']]);
        $row = $existing->fetch();

        if ($row) {
            $pdo->prepare('UPDATE cms_blocks SET block_type = ?, title = ?, content_html = ?, image_path = ? WHERE id = ?')
                ->execute([clean($body['block_type'] ?? 'text'), clean($body['title'] ?? ''), $body['content_html'] ?? '', clean($body['image_path'] ?? ''), $row['id']]);
            respond(['success' => true, 'id' => $row['id']]);
        }

        $stmt = $pdo->prepare('INSERT INTO cms_blocks (page_id, block_key, block_type, title, content_html, image_path, sort_order) VALUES (?, ?, ?, ?, ?, ?, ?)');
        $stmt->execute([$body['page_id'], clean($body['block_key']), clean($body['block_type'] ?? 'text'), clean($body['title'] ?? ''), $body['content_html'] ?? '', clean($body['image_path'] ?? ''), (int)($body['sort_order'] ?? 0)]);
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

    // Sync assets declared in public page template via data-cms-asset
    if ($action === 'sync_template_assets') {
        $pageKey = clean($body['page_key'] ?? '');
        if ($pageKey === '') {
            err('page_key is required.', 422);
        }

        $templatePath = cmsTemplatePathFromPageKey($pageKey);
        if ($templatePath === null) {
            err('No public template found for this page.', 404);
        }

        $assets = cmsExtractTemplateAssets($templatePath);
        if (empty($assets)) {
            respond(['success' => true, 'imported' => 0, 'page_key' => $pageKey]);
        }

        $upsert = $pdo->prepare("INSERT INTO page_assets (tenant_id, page_key, asset_key, label, type, file_path, alt_text, updated_by)
            VALUES (1, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                label = VALUES(label),
                type = VALUES(type),
                file_path = VALUES(file_path),
                alt_text = VALUES(alt_text),
                updated_by = VALUES(updated_by)");

        foreach ($assets as $a) {
            $upsert->execute([
                $pageKey,
                clean($a['asset_key']),
                clean($a['label']),
                clean($a['type']),
                clean($a['file_path']),
                clean($a['alt_text']),
                currentUserId(),
            ]);
        }

        respond(['success' => true, 'imported' => count($assets), 'page_key' => $pageKey]);
    }

    // Update page SEO metadata
    if ($action === 'update_seo') {
        requireFields($body, ['page_id']);
        $sets = ['meta_title = ?', 'meta_description = ?'];
        $params = [clean($body['meta_title'] ?? ''), clean($body['meta_description'] ?? '')];
        if (!empty($body['title'])) {
            $sets[] = 'title = ?';
            $params[] = clean($body['title']);
        }
        if (isset($body['is_active'])) {
            $sets[] = 'is_active = ?';
            $params[] = (int)$body['is_active'] ? 1 : 0;
        }
        $params[] = (int)$body['page_id'];
        $pdo->prepare('UPDATE cms_pages SET ' . implode(', ', $sets) . ' WHERE id = ?')->execute($params);
        respond(['success' => true]);
    }

    // Update navigation items
    if ($action === 'update_nav') {
        $items = $body['items'] ?? [];
        if (!is_array($items)) err('items must be array', 422);
        $upsert = $pdo->prepare('INSERT INTO nav_items (id, tenant_id, label, href, sort_order, is_visible)
            VALUES (?, 1, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE label=VALUES(label), href=VALUES(href), sort_order=VALUES(sort_order), is_visible=VALUES(is_visible)');
        foreach ($items as $item) {
            $upsert->execute([
                (int)($item['id'] ?? 0) ?: null,
                clean($item['label'] ?? ''),
                clean($item['href'] ?? ''),
                (int)($item['sort_order'] ?? 0),
                (int)($item['is_visible'] ?? 1)
            ]);
        }
        respond(['success' => true]);
    }

    // Update site settings
    if ($action === 'update_settings') {
        $settings = $body['settings'] ?? [];
        if (!is_array($settings)) err('settings must be object', 422);
        $upsert = $pdo->prepare('INSERT INTO site_settings (tenant_id, setting_key, value, updated_by)
            VALUES (1, ?, ?, ?)
            ON DUPLICATE KEY UPDATE value=VALUES(value), updated_by=VALUES(updated_by)');
        foreach ($settings as $key => $val) {
            $upsert->execute([clean($key), clean((string)$val), currentUserId()]);
        }
        respond(['success' => true]);
    }

    // Reorder blocks
    if ($action === 'reorder_blocks') {
        requireFields($body, ['page_id', 'order']);
        $order = array_values(array_map('intval', (array)$body['order']));
        $upd = $pdo->prepare('UPDATE cms_blocks SET sort_order = ? WHERE id = ? AND page_id = ?');
        foreach ($order as $pos => $blockId) {
            $upd->execute([$pos + 1, $blockId, (int)$body['page_id']]);
        }
        respond(['success' => true]);
    }

    // Create a new CMS page
    if ($action === 'create_page') {
        requireFields($body, ['title', 'slug']);

        $cols = cmsPageColumns($pdo);

        $title = trim((string)($body['title'] ?? ''));
        $slugInput = trim((string)($body['slug'] ?? ''));

        $slug = strtolower($slugInput);
        $slug = preg_replace('/[^a-z0-9-]/', '-', $slug);
        $slug = preg_replace('/-+/', '-', $slug);
        $slug = trim($slug, '-');

        if ($title === '') err('Page title is required.', 400);
        if ($slug === '') err('Valid page slug is required.', 400);

        $existsSql = 'SELECT id FROM cms_pages WHERE ' . cmsPageWhereTenant($cols) . ' AND slug = ? LIMIT 1';
        $exists = $pdo->prepare($existsSql);
        $exists->execute([$slug]);
        if ($exists->fetch()) err('A page with this slug already exists.', 409);

        $isActive = (int)($body['is_active'] ?? 1) === 1 ? 1 : 0;

        if (hasCmsPageColumn($cols, 'sort_order')) {
            $nextSortSql = 'SELECT COALESCE(MAX(sort_order), 0) + 1 AS next_sort FROM cms_pages WHERE ' . cmsPageWhereTenant($cols);
            $nextSortStmt = $pdo->query($nextSortSql);
            $nextSort = (int)($nextSortStmt->fetch()['next_sort'] ?? 1);

            if (hasCmsPageColumn($cols, 'tenant_id')) {
                $insert = $pdo->prepare('INSERT INTO cms_pages (tenant_id, title, slug, is_active, sort_order) VALUES (1, ?, ?, ?, ?)');
                $insert->execute([
                    $title,
                    $slug,
                    $isActive,
                    $nextSort
                ]);
            } else {
                $insert = $pdo->prepare('INSERT INTO cms_pages (title, slug, is_active, sort_order) VALUES (?, ?, ?, ?)');
                $insert->execute([
                    $title,
                    $slug,
                    $isActive,
                    $nextSort
                ]);
            }
        } else {
            if (hasCmsPageColumn($cols, 'tenant_id')) {
                $insert = $pdo->prepare('INSERT INTO cms_pages (tenant_id, title, slug, is_active) VALUES (1, ?, ?, ?)');
                $insert->execute([
                    $title,
                    $slug,
                    $isActive
                ]);
            } else {
                $insert = $pdo->prepare('INSERT INTO cms_pages (title, slug, is_active) VALUES (?, ?, ?)');
                $insert->execute([
                    $title,
                    $slug,
                    $isActive
                ]);
            }
        }

        $pageId = (int)$pdo->lastInsertId();
        respond([
            'success' => true,
            'page' => [
                'id' => $pageId,
                'title' => $title,
                'slug' => $slug,
                'is_active' => $isActive
            ]
        ], 201);
    }

    // ── File upload for CMS assets ───────────────────────────────────────
    if ($action === 'upload') {
        if (empty($_FILES['file'])) err('No file uploaded.', 400);
        $file = $_FILES['file'];
        if ($file['error'] !== UPLOAD_ERR_OK) err('Upload error: ' . $file['error'], 400);

        // Validate file type
        $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml', 'application/pdf'];
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);
        if (!in_array($mime, $allowed)) err('Invalid file type. Allowed: JPG, PNG, GIF, WebP, SVG, PDF', 400);

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
            $assetType = strpos($mime, 'image/') === 0 ? 'image' : 'document';
            $pdo->prepare("INSERT INTO page_assets (tenant_id, page_key, asset_key, label, type, file_path, alt_text, updated_by)
                VALUES (1, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE type = VALUES(type), file_path = VALUES(file_path), alt_text = VALUES(alt_text), updated_by = VALUES(updated_by)")
                ->execute([$pageKey, $assetKey, clean($_POST['label'] ?? $file['name']), $assetType, $relativePath, clean($_POST['alt_text'] ?? ''), currentUserId()]);
        }

        respond(['success' => true, 'file_path' => $relativePath, 'url' => '/' . $relativePath, 'mime' => $mime]);
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
