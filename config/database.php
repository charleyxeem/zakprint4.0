<?php
/**
 * config/database.php
 * Reads env.hostinger/.env and returns a PDO connection as $pdo
 */
require_once __DIR__ . '/env.php';

$env = loadAppEnv();

$host    = $env['DB_HOST']    ?? 'localhost';
$dbName  = $env['DB_NAME']    ?? '';
$dbUser  = $env['DB_USER']    ?? '';
$dbPass  = $env['DB_PASS']    ?? '';
$charset = $env['DB_CHARSET'] ?? 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$dbName;charset=$charset";

try {
    $pdo = new PDO($dsn, $dbUser, $dbPass, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed.']);
    exit;
}
