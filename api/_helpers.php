<?php
declare(strict_types=1);

/**
 * api/_helpers.php
 * Shared helpers for ALL api/ endpoints (public + admin).
 */

header('Content-Type: application/json');
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$host   = $_SERVER['HTTP_HOST'] ?? 'localhost';
// Only reflect origin if it matches the server's own host
if ($origin && parse_url($origin, PHP_URL_HOST) === $host) {
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Credentials: true');
    header('Vary: Origin');
} else {
    // No ACAO header for unknown origins — browser will block cross-origin XHR
}
header('Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/** Decode JSON request body */
function getBody(): array {
    $raw = file_get_contents('php://input');
    return json_decode($raw, true) ?? [];
}

/** Send JSON response */
function respond(array $data, int $code = 200): void {
    http_response_code($code);
    echo json_encode($data);
    exit;
}

/** Send error response */
function err(string $msg, int $code = 400): void {
    respond(['error' => $msg], $code);
}

/** Sanitize a string */
function clean(?string $val): string {
    return trim((string)($val ?? ''));
}

/** Escape text for safe HTML output contexts */
function esc(string $val): string {
    return htmlspecialchars($val, ENT_QUOTES, 'UTF-8');
}

/** Validate required fields are present and non-empty */
function requireFields(array $body, array $fields): void {
    foreach ($fields as $f) {
        if (empty($body[$f])) {
            err("Missing required field: $f");
        }
    }
}

/** Return trimmed query string value */
function queryString(string $key, string $default = ''): string {
    if (!isset($_GET[$key])) {
        return $default;
    }

    $raw = $_GET[$key];
    if (is_array($raw)) {
        return $default;
    }

    return clean((string)$raw);
}

/** Return trimmed body string value */
function bodyString(array $body, string $key, string $default = ''): string {
    if (!array_key_exists($key, $body)) {
        return $default;
    }

    $raw = $body[$key];
    if (is_array($raw) || is_object($raw)) {
        return $default;
    }

    return clean((string)$raw);
}

/** Return nullable integer from body value */
function bodyInt(array $body, string $key): ?int {
    if (!array_key_exists($key, $body) || $body[$key] === null || $body[$key] === '') {
        return null;
    }

    if (is_int($body[$key])) {
        return $body[$key];
    }

    if (is_string($body[$key]) && preg_match('/^-?\d+$/', $body[$key]) === 1) {
        return (int)$body[$key];
    }

    return null;
}

/** Validate enum-style value and return normalized value */
function requireOneOf(string $value, array $allowed, string $fieldName): string {
    if (!in_array($value, $allowed, true)) {
        err("Invalid $fieldName.", 422);
    }

    return $value;
}
