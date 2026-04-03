<?php
/**
 * api/admin/invoices.php
 * Full invoice CRUD. Scope:
 *   admin       → own invoices only (created_by = user_id)
 *   super_admin → all invoices
 *
 * GET  ?id=X         → single invoice with items + payments
 * GET  (no id)       → invoice list
 * POST               → create invoice
 * PATCH ?id=X        → update invoice
 * DELETE ?id=X       → delete invoice (super_admin only)
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$method = $_SERVER['REQUEST_METHOD'];
$scope  = scopeToUser();
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

// ── GET ────────────────────────────────────────────────────────────────────
if ($method === 'GET') {
    // Stats endpoint
    if (($_GET['action'] ?? '') === 'stats') {
        $where   = $scope ? 'WHERE i.created_by = ?' : '';
        $params  = $scope ? [$scope] : [];

        // Overall totals
        $stmt = $pdo->prepare("SELECT SUM(i.amount_paid) as total_received, SUM(i.total - i.amount_paid) as total_pending, COUNT(*) as total_invoices FROM invoices i $where");
        $stmt->execute($params);
        $totals = $stmt->fetch();

        // Count by status
        $statuses = $pdo->prepare("SELECT i.status, COUNT(*) as count FROM invoices i $where GROUP BY i.status");
        $statuses->execute($params);
        $statusCounts = [];
        foreach ($statuses->fetchAll() as $row) {
            $statusCounts[$row['status']] = (int)$row['count'];
        }

        respond([
            'total_received' => (float)($totals['total_received'] ?? 0),
            'total_pending' => (float)($totals['total_pending'] ?? 0),
            'total_invoices' => (int)($totals['total_invoices'] ?? 0),
            'paid_count' => (int)($statusCounts['paid'] ?? 0),
            'unpaid_count' => (int)($statusCounts['unpaid'] ?? 0),
            'partial_count' => (int)($statusCounts['partial'] ?? 0),
        ]);
    }
    
    if ($id) {
        $whereId  = $scope ? 'WHERE i.id = ? AND i.created_by = ?' : 'WHERE i.id = ?';
        $paramsId = $scope ? [$id, $scope] : [$id];

        $stmt = $pdo->prepare(
            "SELECT i.*, u.name as creator_name, bp.company_name, bp.address, bp.phone as bp_phone,
                    bp.email as bp_email, bp.logo_path, bp.terms, bp.payment_methods
             FROM invoices i
             LEFT JOIN users u ON u.id = i.created_by
             LEFT JOIN billing_profiles bp ON bp.owner_user_id = i.created_by
             $whereId LIMIT 1"
        );
        $stmt->execute($paramsId);
        $invoice = $stmt->fetch();
        if (!$invoice) err('Invoice not found.', 404);

        // Items
        $items = $pdo->prepare('SELECT * FROM invoice_items WHERE invoice_id = ?');
        $items->execute([$id]);
        $invoice['items'] = $items->fetchAll();

        // Payments
        $payments = $pdo->prepare('SELECT * FROM invoice_payments WHERE invoice_id = ? ORDER BY paid_at DESC');
        $payments->execute([$id]);
        $invoice['payments'] = $payments->fetchAll();

        $subtotal = 0.0;
        $taxAmount = 0.0;
        foreach ($invoice['items'] as $item) {
            $qty = (float)($item['quantity'] ?? 0);
            $price = (float)($item['price'] ?? 0);
            $lineTotal = (float)($item['line_total'] ?? ($qty * $price));
            $subtotal += $lineTotal;
            $taxAmount += (float)($item['tax_amount'] ?? 0);
        }
        if ($taxAmount <= 0 && !empty($invoice['include_tax'])) {
            $taxAmount = $subtotal * ((float)($invoice['tax_percent'] ?? 0) / 100);
        }
        $invoice['subtotal'] = $subtotal;
        $invoice['tax'] = $taxAmount;
        $invoice['total'] = (float)($invoice['total'] ?? ($subtotal + $taxAmount));
        $invoice['balance_due'] = max(0, $invoice['total'] - (float)($invoice['amount_paid'] ?? 0));
        $invoice['discount'] = (float)($invoice['discount'] ?? 0);

        respond(['invoice' => $invoice]);
    }

    // List
    $search = isset($_GET['search']) ? '%' . $_GET['search'] . '%' : null;
    $status = $_GET['status'] ?? null;
    $limit  = min((int)($_GET['limit'] ?? 50), 200);
    $offset = (int)($_GET['offset'] ?? 0);

    $where   = $scope ? ['i.created_by = ?'] : [];
    $params  = $scope ? [$scope] : [];

    if ($search) { $where[] = '(i.invoice_no LIKE ? OR i.client_name LIKE ? OR i.client_phone LIKE ?)'; $params = array_merge($params, [$search, $search, $search]); }
    if ($status) { $where[] = 'i.status = ?'; $params[] = $status; }

    $whereClause = $where ? 'WHERE ' . implode(' AND ', $where) : '';

    $stmt = $pdo->prepare(
        "SELECT i.id, i.invoice_no, i.client_name, i.client_phone, i.client_company,
                i.total, i.amount_paid, i.status, i.created_at, i.due_date,
                u.name as creator_name
         FROM invoices i LEFT JOIN users u ON u.id = i.created_by
         $whereClause ORDER BY i.created_at DESC LIMIT $limit OFFSET $offset"
    );
    $stmt->execute($params);
    $invoices = $stmt->fetchAll();

    // Total count
    $countStmt = $pdo->prepare("SELECT COUNT(*) FROM invoices i $whereClause");
    $countStmt->execute($params);
    $total = $countStmt->fetchColumn();

    respond(['invoices' => $invoices, 'total' => (int)$total]);
}

// ── POST: create invoice ───────────────────────────────────────────────────
if ($method === 'POST') {
    if (($_GET['action'] ?? '') === 'payment' && $id) {
        $body = getBody();
        $amt = (float)($body['amount'] ?? $body['payment_amount'] ?? 0);
        if ($amt <= 0) err('Payment amount is required.', 400);

        $check = $pdo->prepare('SELECT id, created_by FROM invoices WHERE id = ? LIMIT 1');
        $check->execute([$id]);
        $inv = $check->fetch();
        if (!$inv) err('Invoice not found.', 404);
        if ($scope && $inv['created_by'] != $scope) err('Access denied.', 403);

        $pdo->prepare('INSERT INTO invoice_payments (invoice_id, amount, method) VALUES (?, ?, ?)')->execute([
            $id,
            $amt,
            clean($body['method'] ?? 'Cash')
        ]);
        $pdo->prepare('UPDATE invoices SET amount_paid = amount_paid + ?, status = CASE WHEN amount_paid + ? >= total THEN \'paid\' WHEN amount_paid + ? > 0 THEN \'partial\' ELSE status END WHERE id = ?')
            ->execute([$amt, $amt, $amt, $id]);

        respond(['success' => true]);
    }

    $body = getBody();
    requireFields($body, ['client_name', 'items']);

    $items    = $body['items'];
    $subtotal = array_sum(array_map(fn($i) => ($i['quantity'] ?? 1) * ($i['price'] ?? 0), $items));
    $taxPct   = (float)($body['tax_percent'] ?? 0);
    $taxAmt   = $body['include_tax'] ? round($subtotal * $taxPct / 100, 2) : 0;
    $total    = $subtotal + $taxAmt;

    // Generate collision-resistant invoice number.
    $invoiceNo = 'ZAK-' . date('Ymd-His') . '-' . strtoupper(substr(bin2hex(random_bytes(2)), 0, 4));

    $stmt = $pdo->prepare(
        'INSERT INTO invoices (tenant_id, created_by, invoice_no, client_name, client_phone, client_email,
          client_company, subtotal, total, amount_paid, status, due_date, include_tax, tax_percent, notes,
          design_file, external_design_link)
         VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, 0, \'unpaid\', ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        currentUserId(),
        $invoiceNo,
        clean($body['client_name']),
        clean($body['client_phone'] ?? ''),
        clean($body['client_email'] ?? ''),
        clean($body['client_company'] ?? ''),
        $subtotal, $total,
        $body['due_date'] ?? null,
        (int)($body['include_tax'] ?? 0),
        $taxPct,
        clean($body['notes'] ?? ''),
        clean($body['design_file'] ?? ''),
        clean($body['external_design_link'] ?? ''),
    ]);
    $invoiceId = (int)$pdo->lastInsertId();

    // Insert items
    $itemStmt = $pdo->prepare(
        'INSERT INTO invoice_items (invoice_id, product_id, description, quantity, price, line_total, tax_percent, tax_amount)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
    );
    foreach ($items as $item) {
        $qty      = (int)($item['quantity'] ?? 1);
        $price    = (float)($item['price'] ?? 0);
        $lineTotal = $qty * $price;
        $itemTaxPct = (float)($item['tax_percent'] ?? $taxPct);
        $itemTaxAmt = $body['include_tax'] ? round($lineTotal * $itemTaxPct / 100, 2) : 0;
        $itemStmt->execute([
            $invoiceId,
            $item['product_id'] ?? null,
            clean($item['description'] ?? ''),
            $qty, $price, $lineTotal, $itemTaxPct, $itemTaxAmt,
        ]);
    }

    respond(['success' => true, 'id' => $invoiceId, 'invoice_id' => $invoiceId, 'invoice_no' => $invoiceNo], 201);
}

// ── PATCH: update invoice ──────────────────────────────────────────────────
if ($method === 'PATCH') {
    if (!$id) err('Invoice id required.');
    requireAdmin(); // already done above, just reaffirm

    // Verify ownership
    $check = $pdo->prepare('SELECT id, created_by FROM invoices WHERE id = ? LIMIT 1');
    $check->execute([$id]);
    $inv = $check->fetch();
    if (!$inv) err('Invoice not found.', 404);
    if ($scope && $inv['created_by'] != $scope) err('Access denied.', 403);

    $body = getBody();
    $updatable = ['client_name','client_phone','client_email','client_company','status','due_date','notes','include_tax','tax_percent'];
    $fields = []; $params = [];
    foreach ($updatable as $col) {
        if (array_key_exists($col, $body)) {
            $fields[] = "$col = ?";
            $params[]  = is_string($body[$col]) ? clean($body[$col]) : $body[$col];
        }
    }

    // Recalculate totals if items passed
    if (!empty($body['items'])) {
        $pdo->prepare('DELETE FROM invoice_items WHERE invoice_id = ?')->execute([$id]);
        $subtotal = 0;
        $itemStmt = $pdo->prepare(
            'INSERT INTO invoice_items (invoice_id, product_id, description, quantity, price, line_total, tax_percent, tax_amount)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        );
        $taxPct = (float)($body['tax_percent'] ?? 0);
        $includeTax = (int)($body['include_tax'] ?? 0);
        foreach ($body['items'] as $item) {
            $qty = (int)($item['quantity'] ?? 1);
            $price = (float)($item['price'] ?? 0);
            $lineTotal = $qty * $price;
            $subtotal += $lineTotal;
            $itPct = (float)($item['tax_percent'] ?? $taxPct);
            $itAmt = $includeTax ? round($lineTotal * $itPct / 100, 2) : 0;
            $itemStmt->execute([$id, $item['product_id'] ?? null, clean($item['description'] ?? ''), $qty, $price, $lineTotal, $itPct, $itAmt]);
        }
        $taxAmt = $includeTax ? round($subtotal * $taxPct / 100, 2) : 0;
        $fields[] = 'subtotal = ?'; $params[] = $subtotal;
        $fields[] = 'total = ?';    $params[] = $subtotal + $taxAmt;
    }

    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE invoices SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }

    // Record payment if passed
    if (!empty($body['payment_amount'])) {
        $amt = (float)$body['payment_amount'];
        $pdo->prepare('INSERT INTO invoice_payments (invoice_id, amount) VALUES (?, ?)')->execute([$id, $amt]);
        $pdo->prepare('UPDATE invoices SET amount_paid = amount_paid + ?,
            status = CASE WHEN amount_paid + ? >= total THEN \'paid\' WHEN amount_paid + ? > 0 THEN \'partial\' ELSE status END
            WHERE id = ?')->execute([$amt, $amt, $amt, $id]);
    }

    respond(['success' => true]);
}

// ── DELETE: remove invoice (super_admin only) ──────────────────────────────
if ($method === 'DELETE') {
    requireAdmin(['super_admin', 'developer']);
    if (!$id) err('Invoice id required.');
    $pdo->prepare('DELETE FROM invoices WHERE id = ?')->execute([$id]);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
