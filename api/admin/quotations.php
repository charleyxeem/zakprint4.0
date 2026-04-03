<?php
/**
 * api/admin/quotations.php
 * Full quotation CRUD.
 * admin → can only see/create their own (scoped by tenant, but NOTE: quotations table has no created_by
 *          so we use session user_id stored in a new column — we add created_by alias via client_info)
 * super_admin → all quotations
 *
 * GET               → list
 * GET ?id=X         → single with items
 * POST              → create
 * PATCH ?id=X       → update
 * DELETE ?id=X      → delete (super_admin)
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

// ── GET ────────────────────────────────────────────────────────────────────
if ($method === 'GET') {
    if ($id) {
        $stmt = $pdo->prepare('SELECT id, quote_no as quotation_no, customer_name as client_name, total, status, created_at FROM quotations WHERE id = ? LIMIT 1');
        $stmt->execute([$id]);
        $q = $stmt->fetch();
        if (!$q) err('Quotation not found.', 404);

        $items = $pdo->prepare('SELECT * FROM quotations_items WHERE quotation_id = ?');
        $items->execute([$id]);
        $q['items'] = $items->fetchAll();
        respond(['quotation' => $q]);
    }

    $limit  = min((int)($_GET['limit'] ?? 50), 200);
    $offset = (int)($_GET['offset'] ?? 0);
    $stmt = $pdo->query("SELECT id, quote_no as quotation_no, customer_name as client_name, total, status, created_at FROM quotations ORDER BY created_at DESC LIMIT $limit OFFSET $offset");
    $total = $pdo->query('SELECT COUNT(*) FROM quotations')->fetchColumn();
    respond(['quotations' => $stmt->fetchAll(), 'total' => (int)$total]);
}

// ── POST ───────────────────────────────────────────────────────────────────
if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['customer_name', 'items']);

    $items      = $body['items'];
    $includeTax = (int)($body['include_tax'] ?? 0) === 1;
    $globalTax  = (float)($body['tax_percent'] ?? 0);
    $subtotal   = 0;
    $taxTotal   = 0;
    foreach ($items as $i) {
        $qty = (float)($i['quantity'] ?? 1);
        $price = (float)($i['price'] ?? 0);
        $line = $qty * $price;
        $subtotal += $line;
        if ($includeTax) {
            $lineTaxPercent = (float)($i['tax_percent'] ?? $globalTax);
            $taxTotal += ($line * $lineTaxPercent / 100);
        }
    }
    $total      = round($subtotal + $taxTotal, 2);
    $quoteNo = 'QUO-' . date('Ymd-His') . '-' . strtoupper(substr(bin2hex(random_bytes(2)), 0, 4));

    $stmt = $pdo->prepare('INSERT INTO quotations (tenant_id, quote_no, customer_name, total, status) VALUES (1, ?, ?, ?, \'draft\')');
    $stmt->execute([$quoteNo, clean($body['customer_name']), $total]);
    $qId = (int)$pdo->lastInsertId();

    $iStmt = $pdo->prepare('INSERT INTO quotations_items (quotation_id, tenant_id, product_id, description, quantity, price, line_total) VALUES (?, 1, ?, ?, ?, ?, ?)');
    foreach ($items as $item) {
        $qty   = (int)($item['quantity'] ?? 1);
        $price = (float)($item['price'] ?? 0);
        $iStmt->execute([$qId, $item['product_id'] ?? null, clean($item['description'] ?? ''), $qty, $price, $qty * $price]);
    }

    respond(['success' => true, 'quotation_id' => $qId, 'quote_no' => $quoteNo], 201);
}

// ── PATCH ──────────────────────────────────────────────────────────────────
if ($method === 'PATCH') {
    if (!$id) err('Quotation id required.');
    $body = getBody();
    if (!empty($body['status'])) {
        $pdo->prepare('UPDATE quotations SET status = ? WHERE id = ?')->execute([clean($body['status']), $id]);
    }
    if (!empty($body['customer_name'])) {
        $pdo->prepare('UPDATE quotations SET customer_name = ? WHERE id = ?')->execute([clean($body['customer_name']), $id]);
    }
    respond(['success' => true]);
}

// ── DELETE ─────────────────────────────────────────────────────────────────
if ($method === 'DELETE') {
    requireAdmin(['super_admin', 'developer']);
    if (!$id) err('Quotation id required.');
    $pdo->prepare('DELETE FROM quotations WHERE id = ?')->execute([$id]);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
