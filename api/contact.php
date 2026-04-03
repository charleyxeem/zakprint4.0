<?php
/**
 * api/contact.php
 * POST /api/contact.php → save to contact_messages table
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') err('Method not allowed.', 405);

$body = getBody();
requireFields($body, ['name', 'email', 'message']);

$stmt = $pdo->prepare(
    'INSERT INTO contact_messages (name, email, phone, subject, message)
     VALUES (?, ?, ?, ?, ?)'
);
$stmt->execute([
    clean($body['name']),
    clean($body['email']),
    clean($body['phone'] ?? ''),
    clean($body['subject'] ?? ''),
    clean($body['message']),
]);

respond(['success' => true, 'message' => 'Message received. We will contact you soon!']);
