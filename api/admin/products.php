<?php
declare(strict_types=1);

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

$allowedStatuses = ['active', 'draft', 'archived'];

if ($method === 'GET') {
    if ($id) {
        $stmt = $pdo->prepare('SELECT * FROM products WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        $p = $stmt->fetch();
        if (!$p) err('Product not found.', 404);
        respond(['product' => $p]);
    }
    $status = queryString('status');
    $q = trim((string)queryString('q'));
    $hasVariantsTableStmt = $pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'product_variants'");
    $hasVariantsTable = (int)$hasVariantsTableStmt->fetchColumn() > 0;

    $variantJoin = '';
    if ($hasVariantsTable) {
        $variantJoin = " LEFT JOIN (
            SELECT product_id, COUNT(*) AS variant_count
            FROM product_variants
            WHERE (status IS NULL OR status = '' OR status = 'active' OR status = '1' OR status = 1)
            GROUP BY product_id
        ) v ON v.product_id = p.id";
    }

    $sql = 'SELECT p.id, p.title, p.price, p.sale_price, p.category, p.status, p.is_featured, p.featured_order, p.image, p.created_at, '
        . ($hasVariantsTable ? 'COALESCE(v.variant_count, 0) AS variant_count' : '0 AS variant_count')
        . ' FROM products p' . $variantJoin;
    $params = [];
    $where = [];

    if ($status !== '') {
        $status = requireOneOf($status, $allowedStatuses, 'status');
        $where[] = 'p.status = ?';
        $params[] = $status;
    }

    if ($q !== '') {
        $where[] = '(p.title LIKE ? OR p.category LIKE ? OR p.description LIKE ?)';
        $params[] = '%' . $q . '%';
        $params[] = '%' . $q . '%';
        $params[] = '%' . $q . '%';
    }

    if ($where) {
        $sql .= ' WHERE ' . implode(' AND ', $where);
    }

    $sql .= ' ORDER BY p.created_at DESC';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    respond(['products' => $stmt->fetchAll()]);
}

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['title', 'price']);

    $status = bodyString($body, 'status', 'active');
    $status = requireOneOf($status, $allowedStatuses, 'status');

    $stmt = $pdo->prepare(
        'INSERT INTO products (title, price, sale_price, category, status, description, image, image2, image3, image4, weight, dimensions, colors, is_featured, tenant_id)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)'
    );
    $stmt->execute([
        clean($body['title']),
        (float)$body['price'],
        isset($body['sale_price']) && $body['sale_price'] !== '' ? (float)$body['sale_price'] : null,
        bodyString($body, 'category'),
        $status,
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

    $updatable = ['title','price','sale_price','category','status','description','image','image2','image3','image4','weight','dimensions','colors','is_featured','featured_order'];
    $fields = []; $params = [];
    foreach ($updatable as $col) {
        if (array_key_exists($col, $body)) {
            if ($col === 'status') {
                $status = requireOneOf(bodyString($body, 'status'), $allowedStatuses, 'status');
                $fields[] = "$col = ?";
                $params[] = $status;
                continue;
            }

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
