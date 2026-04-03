<?php
/**
 * api/admin/users.php
 * User management — super_admin only.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin(['super_admin', 'developer']);

$method = $_SERVER['REQUEST_METHOD'];
$id     = isset($_GET['id']) ? (int)$_GET['id'] : null;

if ($method === 'GET') {
    $stmt = $pdo->query(
        "SELECT id, name, email, phone, role, created_at FROM users ORDER BY created_at DESC"
    );
    respond(['users' => $stmt->fetchAll()]);
}

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['name', 'email', 'password', 'role']);
    $allowed = ['user','admin','super_admin','developer'];
    if (!in_array($body['role'], $allowed)) err('Invalid role.');
    // Check duplicate
    $dup = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $dup->execute([clean($body['email'])]);
    if ($dup->fetch()) err('Email already exists.', 409);

    $stmt = $pdo->prepare(
        'INSERT INTO users (name, email, phone, password_hash, role, tenant_id) VALUES (?, ?, ?, ?, ?, 1)'
    );
    $stmt->execute([
        clean($body['name']),
        clean($body['email']),
        clean($body['phone'] ?? ''),
        password_hash($body['password'], PASSWORD_BCRYPT),
        clean($body['role']),
    ]);
    respond(['success' => true, 'id' => (int)$pdo->lastInsertId()], 201);
}

if ($method === 'PATCH') {
    if (!$id) err('User id required.');
    $body = getBody();
    $fields = []; $params = [];
    $allowed = ['name','email','phone','role'];
    foreach ($allowed as $f) {
        if (array_key_exists($f, $body)) { $fields[] = "$f = ?"; $params[] = clean($body[$f]); }
    }
    if (!empty($body['password'])) {
        $fields[] = 'password_hash = ?';
        $params[]  = password_hash($body['password'], PASSWORD_BCRYPT);
    }
    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE users SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    respond(['success' => true]);
}

if ($method === 'DELETE') {
    if (!$id) err('User id required.');
    if ($id === currentUserId()) err('Cannot delete yourself.', 400);
    $pdo->prepare('DELETE FROM users WHERE id = ?')->execute([$id]);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
