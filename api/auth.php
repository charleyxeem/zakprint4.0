<?php
/**
 * api/auth.php
 * Public auth endpoint: login, logout, session check for users.
 * POST /api/auth.php         → login
 * DELETE /api/auth.php       → logout
 * GET /api/auth.php          → check session
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

// ── GET: session check ─────────────────────────────────────────────────────
if ($method === 'GET') {
    if (!empty($_SESSION['user_id'])) {
        respond([
            'authenticated' => true,
            'user_id' => $_SESSION['user_id'],
            'name'    => $_SESSION['name'] ?? '',
            'email'   => $_SESSION['email'] ?? '',
            'role'    => $_SESSION['role'] ?? 'user',
        ]);
    }
    respond(['authenticated' => false]);
}

// ── POST: login ────────────────────────────────────────────────────────────
if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['email', 'password']);

    $email    = clean($body['email']);
    $password = $body['password'];

    $stmt = $pdo->prepare('SELECT id, name, email, password_hash, role FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($password, $user['password_hash'])) {
        err('Invalid email or password.', 401);
    }

    session_regenerate_id(true);
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['name']    = $user['name'];
    $_SESSION['email']   = $user['email'];
    $_SESSION['role']    = $user['role'];

    respond([
        'success'  => true,
        'user_id'  => $user['id'],
        'name'     => $user['name'],
        'role'     => $user['role'],
        'redirect' => in_array($user['role'], ['admin','super_admin','developer'])
                        ? '../Frontend-admin/admin-dash.html'
                        : 'user-dash.html',
    ]);
}

// ── DELETE: logout ─────────────────────────────────────────────────────────
if ($method === 'DELETE') {
    session_destroy();
    respond(['success' => true]);
}

err('Method not allowed.', 405);
