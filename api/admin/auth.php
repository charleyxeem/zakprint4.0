<?php
/**
 * api/admin/auth.php
 * Admin-specific auth: login (must be admin/super_admin/developer), session check, logout, password reset.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

$method = $_SERVER['REQUEST_METHOD'];

// ── GET: session check ─────────────────────────────────────────────────────
if ($method === 'GET') {
    $action = $_GET['action'] ?? 'check';

    if ($action === 'check') {
        $allowedRoles = ['admin', 'super_admin', 'developer'];
        if (!empty($_SESSION['role']) && in_array($_SESSION['role'], $allowedRoles, true)) {
            respond([
                'authenticated' => true,
                'user_id' => $_SESSION['user_id'],
                'name'    => $_SESSION['name'],
                'email'   => $_SESSION['email'],
                'role'    => $_SESSION['role'],
            ]);
        }
        respond(['authenticated' => false]);
    }
}

// ── POST: admin login ──────────────────────────────────────────────────────
if ($method === 'POST') {
    $body   = getBody();
    $action = $body['action'] ?? 'login';

    // --- Login ---
    if ($action === 'login') {
        requireFields($body, ['email', 'password']);
        $email    = clean($body['email']);
        $password = $body['password'];

        $stmt = $pdo->prepare(
            'SELECT id, name, email, password_hash, role FROM users 
             WHERE email = ? AND role IN (\'admin\',\'super_admin\',\'developer\') LIMIT 1'
        );
        $stmt->execute([$email]);
        $user = $stmt->fetch();

        if (!$user || !password_verify($password, $user['password_hash'])) {
            err('Invalid credentials or insufficient permissions.', 401);
        }

        session_regenerate_id(true);
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['name']    = $user['name'];
        $_SESSION['email']   = $user['email'];
        $_SESSION['role']    = $user['role'];

        respond(['success' => true, 'role' => $user['role'], 'name' => $user['name']]);
    }

    // --- Password reset request ---
    if ($action === 'reset_request') {
        requireFields($body, ['email']);
        $email = clean($body['email']);
        $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        if ($user) {
            $token   = bin2hex(random_bytes(32));
            $expires = date('Y-m-d H:i:s', strtotime('+1 hour'));
            $pdo->prepare('UPDATE users SET reset_token = ?, reset_expires = ? WHERE id = ?')
                ->execute([$token, $expires, $user['id']]);
            // TODO: send email with token link (Phase 7)
        }
        // Always respond OK to prevent email enumeration
        respond(['success' => true, 'message' => 'If that email exists, a reset link has been sent.']);
    }

    // --- Password change (token) ---
    if ($action === 'reset_password') {
        requireFields($body, ['token', 'password']);
        $token = clean($body['token']);
        $stmt  = $pdo->prepare(
            'SELECT id FROM users WHERE reset_token = ? AND reset_expires > NOW() LIMIT 1'
        );
        $stmt->execute([$token]);
        $user = $stmt->fetch();
        if (!$user) err('Invalid or expired reset token.', 400);

        $hash = password_hash($body['password'], PASSWORD_BCRYPT);
        $pdo->prepare('UPDATE users SET password_hash = ?, reset_token = NULL, reset_expires = NULL WHERE id = ?')
            ->execute([$hash, $user['id']]);
        respond(['success' => true, 'message' => 'Password updated.']);
    }
}

// ── DELETE: logout ─────────────────────────────────────────────────────────
if ($method === 'DELETE') {
    requireAdmin();
    session_destroy();
    respond(['success' => true]);
}

err('Method not allowed.', 405);
