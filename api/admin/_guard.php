<?php
/**
 * api/admin/_guard.php
 * Role-Based Access Control helper.
 * Include this at the top of every admin API file.
 */

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/**
 * Terminate request if the session role is not in $allowed.
 * Default: both 'admin' and 'super_admin' are allowed.
 */
function requireAdmin(array $allowed = ['admin', 'super_admin', 'developer']): void {
    $role = $_SESSION['role'] ?? null;
    if (!$role || !in_array($role, $allowed, true)) {
        http_response_code(401);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }
}

/**
 * Return the user_id filter for row-level scoping:
 *   - super_admin / developer  → null  (no filter = see everything)
 *   - admin                    → their own user_id
 */
function scopeToUser(): ?int {
    $role = $_SESSION['role'] ?? 'admin';
    if (in_array($role, ['super_admin', 'developer'], true)) {
        return null;
    }
    return (int) ($_SESSION['user_id'] ?? 0);
}

/** Quick helper: is current user a super-admin or developer? */
function isSuperAdmin(): bool {
    return in_array($_SESSION['role'] ?? '', ['super_admin', 'developer'], true);
}

/** Return current session user_id */
function currentUserId(): int {
    return (int) ($_SESSION['user_id'] ?? 0);
}

/** Send a JSON error response and exit */
function jsonError(int $code, string $message): void {
    http_response_code($code);
    echo json_encode(['error' => $message]);
    exit;
}

/** Send a JSON success response */
function jsonSuccess(array $data = [], int $code = 200): void {
    http_response_code($code);
    echo json_encode($data);
    exit;
}
