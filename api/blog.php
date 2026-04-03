<?php
/**
 * api/blog.php
 * GET /api/blog.php             → list published posts
 * GET /api/blog.php?slug=X      → single post
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') err('Method not allowed.', 405);

$slug = isset($_GET['slug']) ? clean($_GET['slug']) : null;

if ($slug) {
    $stmt = $pdo->prepare(
        "SELECT id, title, slug, excerpt, content, image_path, created_at
         FROM blog_posts WHERE slug = ? AND status = 'published' LIMIT 1"
    );
    $stmt->execute([$slug]);
    $post = $stmt->fetch();
    if (!$post) err('Post not found.', 404);
    respond(['post' => $post]);
}

// List
$stmt = $pdo->query(
    "SELECT id, title, slug, excerpt, image_path, created_at
     FROM blog_posts WHERE status = 'published'
     ORDER BY created_at DESC LIMIT 20"
);
respond(['posts' => $stmt->fetchAll()]);
