<?php
declare(strict_types=1);

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

$allowedStatuses = ['pending', 'processing', 'completed', 'cancelled'];

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
    $status = queryString('status');
    $sql = 'SELECT id, code, customer_name, customer_phone, total, status, created_at FROM orders';
    $params = [];

    if ($status !== '') {
        $status = requireOneOf($status, $allowedStatuses, 'status');
        $sql .= ' WHERE status = ?';
        $params[] = $status;
    }

    $sql .= ' ORDER BY created_at DESC';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    respond(['orders' => $stmt->fetchAll()]);
}

if ($method === 'PATCH') {
    if (!$id) err('Order id required.');

    $body = getBody();

    $fields = [];
    $params = [];

    if (array_key_exists('status', $body)) {
        $status = requireOneOf(bodyString($body, 'status'), $allowedStatuses, 'status');
        $fields[] = 'status = ?';
        $params[] = $status;
    }

    if (array_key_exists('cancel_reason', $body)) {
        $reason = bodyString($body, 'cancel_reason');
        if (strlen($reason) > 1000) {
            err('cancel_reason is too long.', 422);
        }
        $fields[] = 'cancel_reason = ?';
        $params[] = $reason;
    }

    if (array_key_exists('invoice_id', $body)) {
        $invoiceId = bodyInt($body, 'invoice_id');
        if ($invoiceId === null) {
            err('Invalid invoice_id.', 422);
        }
        $fields[] = 'invoice_id = ?';
        $params[] = $invoiceId;
    }

    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE orders SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    respond(['success' => true]);
}

err('Method not allowed.', 405);
