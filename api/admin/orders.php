<?php
/**
 * api/admin/orders.php
 * Admin orders management — super_admin only.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin(['super_admin', 'developer']);

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    if ($id) {
        $stmt = $pdo->prepare('SELECT * FROM orders WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        $o = $stmt->fetch();
        if (!$o) err('Order not found.', 404);
        $o['items'] = json_decode($o['items_json'] ?? '[]', true);
        unset($o['items_json']);
        respond(['order' => $o]);
    }
    $status = $_GET['status'] ?? null;
    $where  = $status ? "WHERE status = '" . clean($status) . "'" : '';
    $stmt   = $pdo->query("SELECT id, code, customer_name, customer_phone, total, status, created_at FROM orders $where ORDER BY created_at DESC");
    respond(['orders' => $stmt->fetchAll()]);
}

if ($method === 'PATCH') {
    if (!$id) err('Order id required.');
    $body = getBody();
    $allowed = ['status','cancel_reason','invoice_id'];
    $fields = []; $params = [];
    foreach ($allowed as $f) {
        if (array_key_exists($f, $body)) { $fields[] = "$f = ?"; $params[] = clean((string)$body[$f]); }
    }
    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE orders SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    respond(['success' => true]);
}

err('Method not allowed.', 405);
