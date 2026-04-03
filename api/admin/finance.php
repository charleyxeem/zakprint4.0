<?php
/**
 * api/admin/finance.php
 * Cash ledger + earnings.
 * admin       → own entries (owner_user_id = user_id)
 * super_admin → everything
 *
 * GET ?ledger  → finance_cash_entries
 * GET ?earnings → aggregated earnings by admin user
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();
$scope = scopeToUser();
$currentUserId = currentUserId();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $currentUserId <= 0) {
    err('Invalid session.', 401);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $body = getBody();

    $direction = strtolower(trim((string)($body['direction'] ?? '')));
    if (!in_array($direction, ['in', 'out'], true)) {
        err('Invalid direction.', 422);
    }

    $amount = (float) ($body['amount'] ?? 0);
    if ($amount <= 0) {
        err('Amount must be greater than zero.', 422);
    }

    $description = clean($body['description'] ?? '');
    if ($description === '') {
        err('Description is required.', 422);
    }

    $sourceType = clean($body['source_type'] ?? 'Manual');
    $invoiceId = isset($body['invoice_id']) && $body['invoice_id'] !== '' ? (int) $body['invoice_id'] : null;

    $stmt = $pdo->prepare(
        'INSERT INTO finance_cash_entries (owner_user_id, direction, amount, description, source_type, invoice_id, created_at)
         VALUES (?, ?, ?, ?, ?, ?, NOW())'
    );
    $stmt->execute([
        $currentUserId,
        $direction,
        $amount,
        $description,
        $sourceType,
        $invoiceId,
    ]);

    respond([
        'success' => true,
        'id' => (int) $pdo->lastInsertId(),
    ], 201);
}

$action = $_GET['action'] ?? ($_GET['earnings'] ?? false ? 'earnings' : 'ledger');

// ── Ledger ─────────────────────────────────────────────────────────────────
if ($action === 'ledger' || isset($_GET['ledger'])) {
    $where  = $scope ? ['owner_user_id = ?'] : [];
    $params = $scope ? [$scope] : [];

    if (isset($_GET['direction'])) {
        $where[]  = 'direction = ?';
        $params[] = $_GET['direction'];
    }
    $whereStr = $where ? 'WHERE ' . implode(' AND ', $where) : '';

    $stmt = $pdo->prepare(
        "SELECT id, direction, amount, description, source_type, invoice_id, created_at
         FROM finance_cash_entries $whereStr ORDER BY created_at DESC LIMIT 200"
    );
    $stmt->execute($params);
    $entries = $stmt->fetchAll();

    // Totals
    $inStmt  = $pdo->prepare("SELECT COALESCE(SUM(amount),0) FROM finance_cash_entries WHERE direction='in'" . ($scope ? ' AND owner_user_id = ?' : ''));
    $outStmt = $pdo->prepare("SELECT COALESCE(SUM(amount),0) FROM finance_cash_entries WHERE direction='out'" . ($scope ? ' AND owner_user_id = ?' : ''));
    $inStmt->execute($scope ? [$scope] : []);
    $outStmt->execute($scope ? [$scope] : []);

    respond([
        'entries'  => $entries,
        'total_in' => (float)$inStmt->fetchColumn(),
        'total_out' => (float)$outStmt->fetchColumn(),
    ]);
}

// ── Earnings ───────────────────────────────────────────────────────────────
if ($action === 'earnings' || isset($_GET['earnings'])) {
    if (isSuperAdmin()) {
        // Per-user breakdown
        $stmt = $pdo->query(
            "SELECT u.name as user_name, u.id as user_id,
                    COUNT(i.id) as invoice_count,
                    COALESCE(SUM(i.total),0) as total_revenue,
                    COALESCE(SUM(i.amount_paid),0) as total_collected
             FROM users u LEFT JOIN invoices i ON i.created_by = u.id
             WHERE u.role IN ('admin','super_admin')
             GROUP BY u.id ORDER BY total_revenue DESC"
        );
        respond(['earnings' => $stmt->fetchAll()]);
    } else {
        // Own earnings only
        $stmt = $pdo->prepare(
            "SELECT COUNT(id) as invoice_count, COALESCE(SUM(total),0) as total_revenue,
                    COALESCE(SUM(amount_paid),0) as total_collected
             FROM invoices WHERE created_by = ?"
        );
        $stmt->execute([$scope]);
        respond(['earnings' => $stmt->fetch()]);
    }
}

err('Unknown action.', 400);
