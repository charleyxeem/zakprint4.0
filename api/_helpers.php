<?php
/**
 * api/_helpers.php
 * Shared helpers for ALL api/ endpoints (public + admin).
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

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
    return htmlspecialchars(trim($val ?? ''), ENT_QUOTES, 'UTF-8');
}

/** Validate required fields are present and non-empty */
function requireFields(array $body, array $fields): void {
    foreach ($fields as $f) {
        if (empty($body[$f])) {
            err("Missing required field: $f");
        }
    }
}
