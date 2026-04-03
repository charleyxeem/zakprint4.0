<?php
require_once __DIR__ . '/config/database.php';
header('Content-Type: text/plain');

echo "=== Users Table Schema ===\n";
$st = $pdo->query('DESCRIBE users');
while ($r = $st->fetch(PDO::FETCH_ASSOC)) {
    echo $r['Field'] . ' | ' . $r['Type'] . "\n";
}

echo "\n=== Admin Users (first 5) ===\n";
$st = $pdo->query("SELECT id, name, email, role FROM users WHERE role IN ('admin','super_admin','developer') LIMIT 5");
while ($r = $st->fetch(PDO::FETCH_ASSOC)) {
    echo $r['id'] . ' | ' . $r['name'] . ' | ' . $r['email'] . ' | ' . $r['role'] . "\n";
}

echo "\n=== Check password_hash column exists ===\n";
$st = $pdo->query("SHOW COLUMNS FROM users LIKE 'password%'");
while ($r = $st->fetch(PDO::FETCH_ASSOC)) {
    echo $r['Field'] . ' | ' . $r['Type'] . "\n";
}

echo "\n=== Session test ===\n";
session_start();
echo 'Session ID: ' . session_id() . "\n";
echo 'Role: ' . ($_SESSION['role'] ?? 'NOT SET') . "\n";
echo 'User ID: ' . ($_SESSION['user_id'] ?? 'NOT SET') . "\n";
