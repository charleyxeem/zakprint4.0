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

    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS `users` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `tenant_id` int(11) NOT NULL DEFAULT 1,
          `name` varchar(200) NOT NULL,
          `email` varchar(200) NOT NULL,
          `phone` varchar(50) DEFAULT NULL,
          `password_hash` varchar(255) NOT NULL,
          `role` varchar(30) NOT NULL DEFAULT 'user',
          `reset_token` varchar(255) DEFAULT NULL,
          `reset_expires` datetime DEFAULT NULL,
          `created_at` timestamp NULL DEFAULT current_timestamp(),
          `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
          PRIMARY KEY (`id`),
          UNIQUE KEY `uq_users_email` (`email`),
          KEY `idx_users_role` (`role`),
          KEY `idx_users_tenant` (`tenant_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    );

    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `tenant_id` int(11) NOT NULL DEFAULT 1 AFTER `id`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `name` varchar(200) NOT NULL AFTER `tenant_id`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `email` varchar(200) NOT NULL AFTER `name`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `phone` varchar(50) DEFAULT NULL AFTER `email`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `password_hash` varchar(255) NOT NULL AFTER `phone`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `role` varchar(30) NOT NULL DEFAULT 'user' AFTER `password_hash`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `reset_token` varchar(255) DEFAULT NULL AFTER `role`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `reset_expires` datetime DEFAULT NULL AFTER `reset_token`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `created_at` timestamp NULL DEFAULT current_timestamp() AFTER `reset_expires`");
    $pdo->exec("ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() AFTER `created_at`");
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed.']);
    exit;
}
