<?php
/**
 * api/orders.php
 * POST → place a new order (from checkout.html)
 * GET  → get single order ?id=X or all orders (public-facing)
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['customer_name', 'customer_phone']);

    $items = [];
    if (isset($body['items']) && is_array($body['items'])) {
        $items = $body['items'];
    } elseif (!empty($body['items_json']) && is_string($body['items_json'])) {
        $decoded = json_decode($body['items_json'], true);
        if (is_array($decoded)) {
            $items = $decoded;
        }
    }

    if (!$items) {
        err('Missing required field: items');
    }

    $code  = 'ORD-' . strtoupper(bin2hex(random_bytes(4))) . '-' . date('Ymd');
    // array of {product_id, description, quantity, price}

    // Calculate total
    $total = array_sum(array_map(fn($i) => ($i['quantity'] ?? 1) * ($i['price'] ?? 0), $items));

    $paymentMethod = clean($body['payment_method'] ?? 'card');
    $transferRef = clean($body['bank_transfer_ref'] ?? '');
    $userNotes = clean($body['notes'] ?? '');
    $notes = trim(
        ($userNotes ? $userNotes . "\n" : '')
        . 'Payment Method: ' . strtoupper($paymentMethod)
        . ($transferRef ? "\nBank Transfer Ref: " . $transferRef : '')
    );

    $stmt = $pdo->prepare(
        'INSERT INTO orders (code, customer_name, customer_phone, customer_email, user_id, total, status, items_json, tenant_id)
         VALUES (?, ?, ?, ?, ?, ?, \'pending\', ?, 1)'
    );
    $stmt->execute([
        $code,
        clean($body['customer_name']),
        clean($body['customer_phone']),
        clean($body['customer_email'] ?? ''),
        $_SESSION['user_id'] ?? null,
        $total,
        json_encode([
            'items' => $items,
            'address' => clean($body['address'] ?? ''),
            'notes' => $notes,
        ]),
    ]);
    $orderId = (int)$pdo->lastInsertId();

    respond(['success' => true, 'order_id' => $orderId, 'id' => $orderId, 'code' => $code, 'total' => $total], 201);
}

if ($method === 'GET') {
    $id = isset($_GET['id']) ? (int)$_GET['id'] : null;
    if ($id) {
        $stmt = $pdo->prepare(
            'SELECT id, code, customer_name, customer_phone, total, status, items_json, created_at FROM orders WHERE id = ? LIMIT 1'
        );
        $stmt->execute([$id]);
        $order = $stmt->fetch();
        if (!$order) err('Order not found.', 404);
        $order['items'] = json_decode($order['items_json'], true);
        unset($order['items_json']);
        respond(['order' => $order]);
    }
    err('Specify an order id.', 400);
}

err('Method not allowed.', 405);
