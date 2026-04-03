<?php
/**
 * api/user.php
 * Logged-in user profile & settings endpoints.
 * GET  /api/user.php          → profile
 * GET  /api/user.php?orders   → my orders
 * PATCH /api/user.php         → update profile
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

// Must be logged in
if (empty($_SESSION['user_id'])) err('Not authenticated.', 401);

$userId = (int)$_SESSION['user_id'];
$method = $_SERVER['REQUEST_METHOD'];

// My orders
if ($method === 'GET' && isset($_GET['orders'])) {
    $stmt = $pdo->prepare(
        "SELECT id, code, total, status, created_at, customer_name
         FROM orders WHERE user_id = ? ORDER BY created_at DESC"
    );
    $stmt->execute([$userId]);
    respond(['orders' => $stmt->fetchAll()]);
}

// Profile
if ($method === 'GET') {
    $stmt = $pdo->prepare('SELECT id, name, email, phone, role FROM users WHERE id = ? LIMIT 1');
    $stmt->execute([$userId]);
    $user = $stmt->fetch();
    respond(['user' => $user]);
}

// Update profile
if ($method === 'PATCH') {
    $body = getBody();
    $fields = [];
    $params = [];

    if (!empty($body['name']))  { $fields[] = 'name = ?';  $params[] = clean($body['name']); }
    if (!empty($body['phone'])) { $fields[] = 'phone = ?'; $params[] = clean($body['phone']); }
    if (!empty($body['password'])) {
        $fields[] = 'password_hash = ?';
        $params[] = password_hash($body['password'], PASSWORD_BCRYPT);
    }

    if (!$fields) err('Nothing to update.');

    $params[] = $userId;
    $pdo->prepare('UPDATE users SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    respond(['success' => true, 'message' => 'Profile updated.']);
}

err('Method not allowed.', 405);
