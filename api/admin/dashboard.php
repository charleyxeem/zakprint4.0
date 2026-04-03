<?php
/**
 * api/admin/dashboard.php
 * Returns stats scoped by role:
 *   super_admin/developer → all tenants
 *   admin                 → only their own data (created_by = user_id)
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$scope = scopeToUser(); // null = all, int = own rows only

$where = $scope ? 'WHERE created_by = ?' : '';
$params = $scope ? [$scope] : [];

// Invoice stats
$stmt = $pdo->prepare("SELECT COUNT(*) as total, SUM(total) as revenue, SUM(amount_paid) as collected FROM invoices $where");
$stmt->execute($params);
$invStats = $stmt->fetch();

// Unpaid invoices count
$whereUnpaid = $scope ? "WHERE created_by = ? AND status = 'unpaid'" : "WHERE status = 'unpaid'";
$stmt2 = $pdo->prepare("SELECT COUNT(*) as unpaid FROM invoices $whereUnpaid");
$stmt2->execute($params);
$unpaid = $stmt2->fetchColumn();

// Quotations
$qWhere = $scope ? 'WHERE tenant_id = 1 AND created_at IS NOT NULL' : ''; // quotations have no created_by
if ($scope) {
    // admin: show their own quotations count would need a join — approximate
    $qWhere = '';
}
$stmt3 = $pdo->query("SELECT COUNT(*) as total FROM quotations");
$qCount = isSuperAdmin() ? $stmt3->fetchColumn() : 0;

// Monthly revenue (current month for admin, all for super)
$monthWhere = $scope ? 'WHERE created_by = ? AND MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())'
                     : 'WHERE MONTH(created_at) = MONTH(NOW()) AND YEAR(created_at) = YEAR(NOW())';
$stmtM = $pdo->prepare("SELECT COALESCE(SUM(amount_paid),0) as month_revenue FROM invoices $monthWhere");
$stmtM->execute($params);
$monthRevenue = $stmtM->fetchColumn();

// Product count (super only)
$productCount = 0;
if (isSuperAdmin()) {
    $productCount = $pdo->query("SELECT COUNT(*) FROM products WHERE status='active'")->fetchColumn();
}

// Recent 5 invoices
$recentStmt = $pdo->prepare(
    "SELECT id, invoice_no, client_name, total, amount_paid, status, created_at
     FROM invoices $where ORDER BY created_at DESC LIMIT 5"
);
$recentStmt->execute($params);
$recentInvoices = $recentStmt->fetchAll();

respond([
    'invoices' => [
        'total'        => (int)$invStats['total'],
        'revenue'      => (float)$invStats['revenue'],
        'collected'    => (float)$invStats['collected'],
        'outstanding'  => (float)$invStats['revenue'] - (float)$invStats['collected'],
        'unpaid_count' => (int)$unpaid,
    ],
    'month_revenue'   => (float)$monthRevenue,
    'quotation_count' => (int)$qCount,
    'product_count'   => (int)$productCount,
    'recent_invoices' => $recentInvoices,
    'role'            => $_SESSION['role'],
]);
