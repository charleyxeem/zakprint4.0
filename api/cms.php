<?php
/**
 * api/cms.php
 * Serves CMS content for public pages.
 * GET /api/cms.php?page=home  → returns cms_blocks + page_assets for that page
 * GET /api/cms.php?page=about → returns page text content from `pages` table
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') err('Method not allowed.', 405);

$page = clean($_GET['page'] ?? 'home');

// 1. CMS blocks (for home/structured pages)
$stmt = $pdo->prepare(
    'SELECT b.block_key, b.title, b.content_html, b.image_path
     FROM cms_blocks b
     JOIN cms_pages p ON p.id = b.page_id
     WHERE p.slug = ? AND p.is_active = 1
     ORDER BY b.sort_order ASC'
);
$stmt->execute([$page]);
$blocks = $stmt->fetchAll();

// Key blocks by block_key for easy frontend access
$blocksKeyed = [];
foreach ($blocks as $b) {
    $blocksKeyed[$b['block_key']] = $b;
}

// 2. Page assets (images, logos)
$stmt2 = $pdo->prepare(
    "SELECT asset_key, label, type, file_path, width, height, alt_text
     FROM page_assets WHERE tenant_id = 1 AND page_key IN (?, 'global')"
);
$stmt2->execute([$page]);
$assetsKeyed = [];
foreach ($stmt2->fetchAll() as $a) {
    $assetsKeyed[$a['asset_key']] = $a;
}

// 3. Rich text pages (about, services from `pages` table)
$pageContent = null;
if (in_array($page, ['about', 'services', 'contact'], true)) {
    $stmt3 = $pdo->prepare("SELECT title, content FROM pages WHERE tenant_id = 1 AND `key` = ? LIMIT 1");
    $stmt3->execute([$page]);
    $pageContent = $stmt3->fetch() ?: null;
}

// 4. Pricing plans (for home / services)
$plans = [];
if (in_array($page, ['home', 'services'], true)) {
    $stmt4 = $pdo->query("SELECT id, `key`, title, price, period, features FROM pricing_plans WHERE is_active = 1 ORDER BY sort_order ASC");
    $plans = $stmt4->fetchAll();
    // Convert features string → array
    foreach ($plans as &$plan) {
        $plan['features'] = array_filter(explode("\n", $plan['features'] ?? ''));
    }
    unset($plan);
}

respond([
    'page'    => $page,
    'blocks'  => $blocksKeyed,
    'assets'  => $assetsKeyed,
    'content' => $pageContent,
    'plans'   => $plans,
]);
