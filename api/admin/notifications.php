<?php
/**
 * api/admin/notifications.php
 * Dashboard notification counters for admin.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    err('Method not allowed.', 405);
}

$since = $_GET['since'] ?? null;
$sinceSql = null;
if ($since) {
    $ts = strtotime($since);
    if ($ts !== false) {
        $sinceSql = date('Y-m-d H:i:s', $ts);
    }
}
if (!$sinceSql) {
    $sinceSql = date('Y-m-d H:i:s', strtotime('-24 hours'));
}

$qTotal = (int)$pdo->query('SELECT COUNT(*) FROM contact_messages')->fetchColumn();
$aTotal = (int)$pdo->query('SELECT COUNT(*) FROM appointments')->fetchColumn();

$qNewStmt = $pdo->prepare('SELECT COUNT(*) FROM contact_messages WHERE created_at >= ?');
$qNewStmt->execute([$sinceSql]);
$qNew = (int)$qNewStmt->fetchColumn();

$aNewStmt = $pdo->prepare('SELECT COUNT(*) FROM appointments WHERE created_at >= ?');
$aNewStmt->execute([$sinceSql]);
$aNew = (int)$aNewStmt->fetchColumn();

$recent = $pdo->prepare(
    "SELECT 'query' AS type, id, name, subject AS summary, created_at
     FROM contact_messages
     UNION ALL
     SELECT 'appointment' AS type, id, name, service AS summary, created_at
     FROM appointments
     ORDER BY created_at DESC
     LIMIT 10"
);
$recent->execute();

respond([
    'counts' => [
        'queries_total' => $qTotal,
        'appointments_total' => $aTotal,
        'queries_new' => $qNew,
        'appointments_new' => $aNew,
        'all_new' => $qNew + $aNew,
    ],
    'recent' => $recent->fetchAll(),
    'since' => $sinceSql,
]);
