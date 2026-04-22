<?php
declare(strict_types=1);

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
$scope  = scopeToUser();
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;
$allowedStatuses = ['draft', 'sent', 'approved', 'rejected', 'expired'];

function hasQuotationsCreatedBy(PDO $pdo): bool {
    try {
        $stmt = $pdo->query("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'quotations' AND column_name = 'created_by'");
        return (int)$stmt->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function loadQuotationOwnerSettings(int $userId): array {
    $settingsFile = __DIR__ . '/../../storage/settings.json';
    if (!is_file($settingsFile)) {
        return [];
    }
    $all = json_decode((string)file_get_contents($settingsFile), true);
    if (!is_array($all)) {
        return [];
    }

    $globalQuotation = is_array($all['quotation'] ?? null) ? $all['quotation'] : [];
    $userQuotation = is_array($all['users'][$userId]['quotation'] ?? null) ? $all['users'][$userId]['quotation'] : [];
    $general = is_array($all['users'][$userId]['general'] ?? null) ? $all['users'][$userId]['general'] : [];

    return array_merge($globalQuotation, $userQuotation, [
        'company_name' => clean($userQuotation['company_name'] ?? $general['company_name'] ?? ''),
        'address' => clean($userQuotation['address'] ?? $general['address'] ?? ''),
        'bp_phone' => clean($userQuotation['phone_number'] ?? ($userQuotation['phone'] ?? ($general['phone_number'] ?? ''))),
        'bp_email' => clean($userQuotation['support_email'] ?? ($userQuotation['email'] ?? ($general['support_email'] ?? ''))),
        'logo_path' => clean($userQuotation['logo_url'] ?? ($userQuotation['logo_path'] ?? ($general['logo_url'] ?? ''))),
        'terms' => clean($userQuotation['terms'] ?? $general['terms'] ?? ''),
        'payment_methods' => clean($userQuotation['payment_methods'] ?? $general['payment_methods'] ?? ''),
        'account_number' => clean($userQuotation['account_number'] ?? $general['account_number'] ?? ''),
        'tax_number' => clean($userQuotation['tax_number'] ?? $general['tax_number'] ?? ''),
        'iban' => clean($userQuotation['iban'] ?? $general['iban'] ?? ''),
        'invoice_special_notes' => clean($userQuotation['invoice_special_notes'] ?? $general['invoice_special_notes'] ?? ''),
        'quotation_special_notes' => clean($userQuotation['quotation_special_notes'] ?? $general['quotation_special_notes'] ?? ''),
    ]);
}

function generateQuotationNumber(PDO $pdo): string {
    $alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    $length = strlen($alphabet);

    for ($attempt = 0; $attempt < 20; $attempt += 1) {
        $value = '';
        for ($i = 0; $i < 6; $i += 1) {
            $value .= $alphabet[random_int(0, $length - 1)];
        }

        $check = $pdo->prepare('SELECT COUNT(*) FROM quotations WHERE quote_no = ?');
        $check->execute([$value]);
        if ((int)$check->fetchColumn() === 0) {
            return $value;
        }
    }

    throw new RuntimeException('Unable to generate unique quotation number.');
}

$createdByEnabled = hasQuotationsCreatedBy($pdo);
if (!$createdByEnabled) {
    try {
        $pdo->exec('ALTER TABLE quotations ADD COLUMN IF NOT EXISTS created_by INT NULL AFTER tenant_id');
    } catch (Throwable $e) {
        // Ignore migration failure; legacy installs may not allow ALTER.
    }
    $createdByEnabled = hasQuotationsCreatedBy($pdo);
}

// ── GET ────────────────────────────────────────────────────────────────────
if ($method === 'GET') {
    if ($id) {
        $detailWhere = $createdByEnabled && $scope ? 'WHERE id = ? AND created_by = ?' : 'WHERE id = ?';
        $detailParams = $createdByEnabled && $scope ? [$id, $scope] : [$id];
        $stmt = $pdo->prepare("SELECT id, quote_no as quotation_no, customer_name as client_name, total, status, created_at"
            . ($createdByEnabled ? ', created_by' : '')
            . " FROM quotations $detailWhere LIMIT 1");
        $stmt->execute($detailParams);
        $q = $stmt->fetch();
        if (!$q) err('Quotation not found.', 404);

        $ownerId = (int)($q['created_by'] ?? 0);

        $q['company_name'] = null;
        $q['address'] = null;
        $q['bp_phone'] = null;
        $q['bp_email'] = null;
        $q['logo_path'] = null;
        $q['terms'] = null;
        $q['payment_methods'] = null;
        $q['account_number'] = '';
        $q['tax_number'] = '';
        $q['iban'] = '';
        $q['invoice_special_notes'] = '';
        $q['quotation_special_notes'] = '';

        if ($ownerId > 0) {
            try {
                $bp = $pdo->prepare('SELECT company_name, address, phone as bp_phone, email as bp_email, logo_path, terms, payment_methods, gst_no, ntn_no FROM billing_profiles WHERE owner_user_id = ? ORDER BY id DESC LIMIT 1');
                $bp->execute([$ownerId]);
                $row = $bp->fetch();
                if ($row) {
                    $q = array_merge($q, $row);
                    $q['tax_number'] = clean($row['gst_no'] ?? ($row['ntn_no'] ?? ''));
                }
            } catch (Throwable $e) {
                // Keep quotation response alive on branding lookup failure.
            }

            $settings = loadQuotationOwnerSettings($ownerId);
            foreach ($settings as $key => $value) {
                if ($value !== '') {
                    $q[$key] = $value;
                }
            }
        }

        try {
            $items = $pdo->prepare('SELECT * FROM quotations_items WHERE quotation_id = ?');
            $items->execute([$id]);
            $q['items'] = $items->fetchAll();
        } catch (Throwable $e) {
            $items = $pdo->prepare('SELECT * FROM quotation_items WHERE quotation_id = ?');
            $items->execute([$id]);
            $q['items'] = $items->fetchAll();
        }
        respond(['quotation' => $q]);
    }

    $status = queryString('status');
    $limit  = max(1, min((int)($_GET['limit'] ?? 50), 200));
    $offset = max(0, (int)($_GET['offset'] ?? 0));

    $where = [];
    $params = [];
    if ($status !== '') {
        $status = requireOneOf($status, $allowedStatuses, 'status');
        $where[] = 'status = ?';
        $params[] = $status;
    }

    if ($createdByEnabled && $scope) {
        $where[] = 'created_by = ?';
        $params[] = (int)$scope;
    }

    $whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
    $listSql = "SELECT id, quote_no as quotation_no, customer_name as client_name, total, status, created_at"
                . ($createdByEnabled ? ', created_by' : '')
                . "
                FROM quotations
                $whereSql
                ORDER BY created_at DESC
                LIMIT ? OFFSET ?";
    $stmt = $pdo->prepare($listSql);
    $stmt->execute(array_merge($params, [$limit, $offset]));

    $countSql = "SELECT COUNT(*) FROM quotations $whereSql";
    $countStmt = $pdo->prepare($countSql);
    $countStmt->execute($params);
    $total = $countStmt->fetchColumn();

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
    $quoteNo = generateQuotationNumber($pdo);

    if ($createdByEnabled) {
        $stmt = $pdo->prepare('INSERT INTO quotations (tenant_id, created_by, quote_no, customer_name, total, status) VALUES (1, ?, ?, ?, ?, \'draft\')');
        $stmt->execute([currentUserId(), $quoteNo, clean($body['customer_name']), $total]);
    } else {
        $stmt = $pdo->prepare('INSERT INTO quotations (tenant_id, quote_no, customer_name, total, status) VALUES (1, ?, ?, ?, \'draft\')');
        $stmt->execute([$quoteNo, clean($body['customer_name']), $total]);
    }
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

    if ($createdByEnabled && $scope) {
        $check = $pdo->prepare('SELECT id FROM quotations WHERE id = ? AND created_by = ? LIMIT 1');
        $check->execute([$id, $scope]);
        if (!$check->fetch()) err('Access denied.', 403);
    }

    $body = getBody();
    if (!empty($body['status'])) {
        $status = requireOneOf(bodyString($body, 'status'), $allowedStatuses, 'status');
        $pdo->prepare('UPDATE quotations SET status = ? WHERE id = ?')->execute([$status, $id]);
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
