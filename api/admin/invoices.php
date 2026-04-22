<?php
declare(strict_types=1);

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
$allowedStatuses = ['draft', 'sent', 'accepted', 'unpaid', 'partial', 'paid', 'cancelled'];

function loadUserInvoiceSettings(int $userId): array {
    $settingsFile = __DIR__ . '/../../storage/settings.json';
    if (!is_file($settingsFile)) {
        return [];
    }
    $all = json_decode((string)file_get_contents($settingsFile), true);
    if (!is_array($all)) {
        return [];
    }

    $globalInvoice = is_array($all['invoice'] ?? null) ? $all['invoice'] : [];
    $userInvoice = is_array($all['users'][$userId]['invoice'] ?? null) ? $all['users'][$userId]['invoice'] : [];
    $general = is_array($all['users'][$userId]['general'] ?? null) ? $all['users'][$userId]['general'] : [];

    return array_merge($globalInvoice, $userInvoice, [
        'company_name' => $userInvoice['company_name'] ?? $general['company_name'] ?? '',
        'address' => $userInvoice['address'] ?? $general['address'] ?? '',
        'phone_number' => $userInvoice['phone_number'] ?? ($userInvoice['phone'] ?? ($general['phone_number'] ?? '')),
        'support_email' => $userInvoice['support_email'] ?? ($userInvoice['email'] ?? ($general['support_email'] ?? '')),
        'logo_url' => $userInvoice['logo_url'] ?? ($userInvoice['logo_path'] ?? ($general['logo_url'] ?? '')),
        'terms' => $userInvoice['terms'] ?? $general['terms'] ?? '',
        'payment_methods' => $userInvoice['payment_methods'] ?? $general['payment_methods'] ?? '',
        'account_number' => $userInvoice['account_number'] ?? $general['account_number'] ?? '',
        'tax_number' => $userInvoice['tax_number'] ?? $general['tax_number'] ?? '',
        'iban' => $userInvoice['iban'] ?? $general['iban'] ?? '',
        'invoice_special_notes' => $userInvoice['invoice_special_notes'] ?? $general['invoice_special_notes'] ?? '',
        'quotation_special_notes' => $userInvoice['quotation_special_notes'] ?? $general['quotation_special_notes'] ?? '',
    ]);
}

function toAmount($value): float {
    if (is_int($value) || is_float($value)) {
        return (float)$value;
    }
    if ($value === null) {
        return 0.0;
    }
    $normalized = preg_replace('/[^\d.\-]/', '', (string)$value);
    return is_numeric($normalized) ? (float)$normalized : 0.0;
}

function generateInvoiceNumber(PDO $pdo): string {
    $alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    $length = strlen($alphabet);

    for ($attempt = 0; $attempt < 20; $attempt += 1) {
        $value = '';
        for ($i = 0; $i < 6; $i += 1) {
            $value .= $alphabet[random_int(0, $length - 1)];
        }

        $check = $pdo->prepare('SELECT COUNT(*) FROM invoices WHERE invoice_no = ?');
        $check->execute([$value]);
        if ((int)$check->fetchColumn() === 0) {
            return $value;
        }
    }

    throw new RuntimeException('Unable to generate unique invoice number.');
}

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

        // Load base invoice first; enrichments are optional to stay compatible with legacy schemas.
        $stmt = $pdo->prepare("SELECT i.* FROM invoices i $whereId LIMIT 1");
        $stmt->execute($paramsId);
        $invoice = $stmt->fetch();
        if (!$invoice) err('Invoice not found.', 404);

        $invoice['creator_name'] = null;
        $invoice['company_name'] = null;
        $invoice['address'] = null;
        $invoice['bp_phone'] = null;
        $invoice['bp_email'] = null;
        $invoice['logo_path'] = null;
        $invoice['terms'] = null;
        $invoice['payment_methods'] = null;
        $invoice['account_number'] = '';
        $invoice['tax_number'] = '';
        $invoice['iban'] = '';
        $invoice['invoice_special_notes'] = '';
        $invoice['quotation_special_notes'] = '';

        if (!empty($invoice['created_by'])) {
            $invoiceSettings = loadUserInvoiceSettings((int)$invoice['created_by']);

            if (!empty($invoiceSettings['company_name'])) {
                $invoice['company_name'] = clean($invoiceSettings['company_name']);
            }
            if (!empty($invoiceSettings['address'])) {
                $invoice['address'] = clean($invoiceSettings['address']);
            }
            if (!empty($invoiceSettings['phone_number'])) {
                $invoice['bp_phone'] = clean($invoiceSettings['phone_number']);
            }
            if (!empty($invoiceSettings['support_email'])) {
                $invoice['bp_email'] = clean($invoiceSettings['support_email']);
            }
            if (!empty($invoiceSettings['logo_url'])) {
                $invoice['logo_path'] = clean($invoiceSettings['logo_url']);
            }
            if (!empty($invoiceSettings['terms'])) {
                $invoice['terms'] = clean($invoiceSettings['terms']);
            }
            if (!empty($invoiceSettings['payment_methods'])) {
                $invoice['payment_methods'] = clean($invoiceSettings['payment_methods']);
            }

            $invoice['account_number'] = clean($invoiceSettings['account_number'] ?? '');
            $invoice['tax_number'] = clean($invoiceSettings['tax_number'] ?? '');
            $invoice['iban'] = clean($invoiceSettings['iban'] ?? '');
            $invoice['invoice_special_notes'] = clean($invoiceSettings['invoice_special_notes'] ?? '');
            $invoice['quotation_special_notes'] = clean($invoiceSettings['quotation_special_notes'] ?? '');

            try {
                $creatorStmt = $pdo->prepare('SELECT name FROM users WHERE id = ? LIMIT 1');
                $creatorStmt->execute([(int)$invoice['created_by']]);
                $creator = $creatorStmt->fetch();
                if ($creator && isset($creator['name'])) {
                    $invoice['creator_name'] = $creator['name'];
                }
            } catch (Throwable $e) {
                // Keep invoice view available even if users schema differs.
            }

            try {
                $bpStmt = $pdo->prepare(
                    'SELECT company_name, address, phone as bp_phone, email as bp_email, logo_path, terms, payment_methods
                     FROM billing_profiles WHERE owner_user_id = ? LIMIT 1'
                );
                $bpStmt->execute([(int)$invoice['created_by']]);
                $bp = $bpStmt->fetch();
                if ($bp) {
                    foreach (['company_name', 'address', 'bp_phone', 'bp_email', 'logo_path', 'terms', 'payment_methods'] as $field) {
                        if (!array_key_exists($field, $bp)) {
                            continue;
                        }
                        $value = is_string($bp[$field]) ? trim($bp[$field]) : $bp[$field];
                        if ($value === null || $value === '') {
                            continue;
                        }
                        $invoice[$field] = $bp[$field];
                    }
                }
            } catch (Throwable $e) {
                // Legacy installations may use user_id instead of owner_user_id.
                try {
                    $bpStmt = $pdo->prepare(
                        'SELECT company_name, address, phone as bp_phone, email as bp_email, logo_path, terms, payment_methods
                         FROM billing_profiles WHERE user_id = ? LIMIT 1'
                    );
                    $bpStmt->execute([(int)$invoice['created_by']]);
                    $bp = $bpStmt->fetch();
                    if ($bp) {
                        foreach (['company_name', 'address', 'bp_phone', 'bp_email', 'logo_path', 'terms', 'payment_methods'] as $field) {
                            if (!array_key_exists($field, $bp)) {
                                continue;
                            }
                            $value = is_string($bp[$field]) ? trim($bp[$field]) : $bp[$field];
                            if ($value === null || $value === '') {
                                continue;
                            }
                            $invoice[$field] = $bp[$field];
                        }
                    }
                } catch (Throwable $ignored) {
                    // Ignore billing profile lookup failures.
                }
            }
        }

        if (empty($invoice['tax_number'])) {
            $invoice['tax_number'] = clean($invoice['gst_no'] ?? ($invoice['ntn_no'] ?? ''));
        }

        // Items
        try {
            $items = $pdo->prepare('SELECT * FROM invoice_items WHERE invoice_id = ?');
            $items->execute([$id]);
            $invoice['items'] = $items->fetchAll();
        } catch (Throwable $e) {
            $invoice['items'] = [];
        }

        // Payments
        $invoice['payments'] = [];
        try {
            $payments = $pdo->prepare('SELECT * FROM invoice_payments WHERE invoice_id = ? ORDER BY paid_at DESC');
            $payments->execute([$id]);
            $invoice['payments'] = $payments->fetchAll();
        } catch (Throwable $e) {
            try {
                $payments = $pdo->prepare('SELECT * FROM invoice_payments WHERE invoice_id = ? ORDER BY created_at DESC');
                $payments->execute([$id]);
                $invoice['payments'] = $payments->fetchAll();
            } catch (Throwable $ignored) {
                try {
                    $payments = $pdo->prepare('SELECT * FROM invoice_payments WHERE invoice_id = ? ORDER BY id DESC');
                    $payments->execute([$id]);
                    $invoice['payments'] = $payments->fetchAll();
                } catch (Throwable $ignoredToo) {
                    $invoice['payments'] = [];
                }
            }
        }

        $subtotal = 0.0;
        $taxAmount = 0.0;
        foreach ($invoice['items'] as $item) {
            $qty = toAmount($item['quantity'] ?? 0);
            $price = toAmount($item['price'] ?? 0);
            $lineTotal = toAmount($item['line_total'] ?? ($qty * $price));
            $subtotal += $lineTotal;
            $taxAmount += toAmount($item['tax_amount'] ?? 0);
        }
        if ($taxAmount <= 0 && !empty($invoice['include_tax'])) {
            $taxAmount = $subtotal * (toAmount($invoice['tax_percent'] ?? 0) / 100);
        }

        $paymentsSum = 0.0;
        foreach ($invoice['payments'] as $payment) {
            $paymentsSum += toAmount($payment['amount'] ?? 0);
        }

        $invoice['subtotal'] = $subtotal;
        $invoice['tax'] = $taxAmount;
        $invoice['total'] = toAmount($invoice['total'] ?? ($subtotal + $taxAmount));

        $paidAmount = max(
            toAmount($invoice['amount_paid'] ?? 0),
            $paymentsSum
        );
        $statusNormalized = strtolower((string)($invoice['status'] ?? ''));
        if ($paidAmount <= 0 && $statusNormalized === 'paid' && $invoice['total'] > 0) {
            // Legacy records may only carry "paid" status without amount snapshot.
            $paidAmount = $invoice['total'];
        }

        $invoice['amount_paid'] = $paidAmount;
        $invoice['balance_due'] = max(0, $invoice['total'] - $paidAmount);
        $invoice['discount'] = toAmount($invoice['discount'] ?? 0);

        respond(['invoice' => $invoice]);
    }

    // List
    $searchRaw = queryString('search');
    $search = $searchRaw !== '' ? '%' . $searchRaw . '%' : null;
    $status = queryString('status');
    $limit  = min((int)($_GET['limit'] ?? 50), 200);
    $offset = (int)($_GET['offset'] ?? 0);

    $where   = $scope ? ['i.created_by = ?'] : [];
    $params  = $scope ? [$scope] : [];

    if ($search) { $where[] = '(i.invoice_no LIKE ? OR i.client_name LIKE ? OR i.client_phone LIKE ?)'; $params = array_merge($params, [$search, $search, $search]); }
    if ($status !== '') {
        $status = requireOneOf($status, $allowedStatuses, 'status');
        $where[] = 'i.status = ?';
        $params[] = $status;
    }

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

    if ($invoices) {
        $invoiceIds = array_map(static fn($row) => (int)$row['id'], $invoices);
        $invoiceIds = array_values(array_filter($invoiceIds, static fn($v) => $v > 0));

        $paymentSums = [];
        if ($invoiceIds) {
            $placeholders = implode(',', array_fill(0, count($invoiceIds), '?'));
            try {
                $payStmt = $pdo->prepare("SELECT invoice_id, SUM(amount) AS paid_sum FROM invoice_payments WHERE invoice_id IN ($placeholders) GROUP BY invoice_id");
                $payStmt->execute($invoiceIds);
                foreach ($payStmt->fetchAll() as $row) {
                    $paymentSums[(int)$row['invoice_id']] = toAmount($row['paid_sum'] ?? 0);
                }
            } catch (Throwable $e) {
                $paymentSums = [];
            }
        }

        foreach ($invoices as &$inv) {
            $totalAmount = toAmount($inv['total'] ?? 0);
            $storedPaid = toAmount($inv['amount_paid'] ?? 0);
            $paidFromPayments = $paymentSums[(int)$inv['id']] ?? 0.0;

            $resolvedPaid = max($storedPaid, $paidFromPayments);
            $statusNormalized = strtolower((string)($inv['status'] ?? ''));
            if ($resolvedPaid <= 0 && $statusNormalized === 'paid' && $totalAmount > 0) {
                $resolvedPaid = $totalAmount;
            }

            $inv['amount_paid'] = $resolvedPaid;
        }
        unset($inv);
    }

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
        $pdo->prepare('UPDATE invoices SET amount_paid = COALESCE(amount_paid, 0) + ?, status = CASE WHEN COALESCE(amount_paid, 0) + ? >= total THEN \'paid\' WHEN COALESCE(amount_paid, 0) + ? > 0 THEN \'partial\' ELSE status END WHERE id = ?')
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

    $invoiceNo = generateInvoiceNumber($pdo);

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
            if ($col === 'status') {
                $status = requireOneOf(bodyString($body, 'status'), $allowedStatuses, 'status');
                $fields[] = "$col = ?";
                $params[] = $status;
                continue;
            }

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
        $pdo->prepare('UPDATE invoices SET amount_paid = COALESCE(amount_paid, 0) + ?,
            status = CASE WHEN COALESCE(amount_paid, 0) + ? >= total THEN \'paid\' WHEN COALESCE(amount_paid, 0) + ? > 0 THEN \'partial\' ELSE status END
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
