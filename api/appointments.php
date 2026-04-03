<?php
/**
 * api/appointments.php
 * POST → book an appointment (saved to appointments table)
 * GET  → list appointments for logged-in user
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['name', 'phone']);

    $stmt = $pdo->prepare(
        'INSERT INTO appointments (user_id, name, email, phone, service, message, preferred_date)
         VALUES (?, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        $_SESSION['user_id'] ?? null,
        clean($body['name']),
        clean($body['email']   ?? ''),
        clean($body['phone']),
        clean($body['service'] ?? ''),
        clean($body['message'] ?? ''),
        $body['preferred_date'] ?? null,
    ]);
    respond(['success' => true, 'message' => 'Appointment booked! We will confirm shortly.']);
}

if ($method === 'GET') {
    $userId = $_SESSION['user_id'] ?? null;
    if (!$userId) err('Not authenticated.', 401);
    $stmt = $pdo->prepare(
        'SELECT id, name, service, preferred_date, status, created_at FROM appointments WHERE user_id = ? ORDER BY created_at DESC'
    );
    $stmt->execute([$userId]);
    respond(['appointments' => $stmt->fetchAll()]);
}

err('Method not allowed.', 405);
