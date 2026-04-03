<?php
/**
 * api/admin/contact_messages.php
 * Inbox — list contact messages (super_admin only).
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'DELETE') {
	$body = getBody();
	$ids = $body['ids'] ?? [];
	if (!is_array($ids) || !$ids) err('No queries selected.');

	$ids = array_values(array_filter(array_map('intval', $ids)));
	if (!$ids) err('No queries selected.');

	$placeholders = implode(',', array_fill(0, count($ids), '?'));
	$stmt = $pdo->prepare("DELETE FROM contact_messages WHERE id IN ($placeholders)");
	$stmt->execute($ids);

	respond(['success' => true, 'deleted' => count($ids)]);
}

if ($method !== 'GET') err('Method not allowed.', 405);

$limit  = min((int)($_GET['limit'] ?? 50), 200);
$offset = (int)($_GET['offset'] ?? 0);

$stmt = $pdo->query("SELECT id, name, email, phone, subject, message, created_at FROM contact_messages ORDER BY created_at DESC LIMIT $limit OFFSET $offset");
$total = $pdo->query('SELECT COUNT(*) FROM contact_messages')->fetchColumn();

respond(['messages' => $stmt->fetchAll(), 'total' => (int)$total]);
