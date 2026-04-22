<?php
declare(strict_types=1);

/**
 * api/admin/appointments.php
 * Admin appointments inbox.
 * GET  -> list appointments
 * PATCH ?id=X -> update status (pending|confirmed|cancelled)
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$method = $_SERVER['REQUEST_METHOD'];
$id = isset($_GET['id']) ? (int)$_GET['id'] : null;
$allowedStatuses = ['pending', 'confirmed', 'cancelled'];

if ($method === 'GET') {
    $limit = min(max((int)($_GET['limit'] ?? 50), 1), 200);
    $offset = max((int)($_GET['offset'] ?? 0), 0);
    $status = queryString('status');

    $where = [];
    $params = [];
    if ($status !== '') {
        $status = requireOneOf($status, $allowedStatuses, 'status');
        $where[] = 'status = ?';
        $params[] = $status;
    }

    $whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';

    $stmt = $pdo->prepare("SELECT id, user_id, name, email, phone, service, message, preferred_date, status, created_at FROM appointments $whereSql ORDER BY created_at DESC LIMIT $limit OFFSET $offset");
    $stmt->execute($params);

    $countStmt = $pdo->prepare("SELECT COUNT(*) FROM appointments $whereSql");
    $countStmt->execute($params);
    $total = (int)$countStmt->fetchColumn();

    respond(['appointments' => $stmt->fetchAll(), 'total' => $total]);
}

if ($method === 'PATCH') {
    if (!$id) err('Appointment id required.');

    $body = getBody();
    $status = requireOneOf(bodyString($body, 'status'), $allowedStatuses, 'status');

    $stmt = $pdo->prepare('UPDATE appointments SET status = ? WHERE id = ?');
    $stmt->execute([$status, $id]);

    respond(['success' => true]);
}

if ($method === 'DELETE') {
    $body = getBody();
    $ids = $body['ids'] ?? [];
    if (!is_array($ids) || !$ids) err('No appointments selected.');

    $ids = array_values(array_filter(array_map('intval', $ids)));
    if (!$ids) err('No appointments selected.');

    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $stmt = $pdo->prepare("DELETE FROM appointments WHERE id IN ($placeholders)");
    $stmt->execute($ids);

    respond(['success' => true, 'deleted' => count($ids)]);
}

err('Method not allowed.', 405);
