<?php
/**
 * api/admin/products.php
 * Product management — super_admin only.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin(['super_admin', 'developer']);

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    if ($id) {
        $stmt = $pdo->prepare('SELECT * FROM products WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        $p = $stmt->fetch();
        if (!$p) err('Product not found.', 404);
        respond(['product' => $p]);
    }
    $status = $_GET['status'] ?? null;
    $where  = $status ? "WHERE status = '" . clean($status) . "'" : '';
    $stmt   = $pdo->query("SELECT id, title, price, status, is_featured, featured_order, image, created_at FROM products $where ORDER BY created_at DESC");
    respond(['products' => $stmt->fetchAll()]);
}

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['title', 'price']);
    $stmt = $pdo->prepare(
        'INSERT INTO products (title, price, status, description, image, image2, image3, image4, weight, dimensions, colors, is_featured, tenant_id)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)'
    );
    $stmt->execute([
        clean($body['title']),
        (float)$body['price'],
        $body['status'] ?? 'active',
        clean($body['description'] ?? ''),
        clean($body['image'] ?? ''),
        clean($body['image2'] ?? ''),
        clean($body['image3'] ?? ''),
        clean($body['image4'] ?? ''),
        clean($body['weight'] ?? ''),
        clean($body['dimensions'] ?? ''),
        clean($body['colors'] ?? ''),
        (int)($body['is_featured'] ?? 0),
    ]);
    respond(['success' => true, 'id' => (int)$pdo->lastInsertId()], 201);
}

if ($method === 'PATCH') {
    if (!$id) err('Product id required.');
    $body = getBody();
    $updatable = ['title','price','status','description','image','image2','image3','image4','weight','dimensions','colors','is_featured','featured_order'];
    $fields = []; $params = [];
    foreach ($updatable as $col) {
        if (array_key_exists($col, $body)) {
            $fields[] = "$col = ?";
            $params[]  = is_numeric($body[$col]) ? $body[$col] : clean($body[$col]);
        }
    }
    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE products SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    respond(['success' => true]);
}

if ($method === 'DELETE') {
    if (!$id) err('Product id required.');
    $pdo->prepare("UPDATE products SET status = 'draft' WHERE id = ?")->execute([$id]);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
