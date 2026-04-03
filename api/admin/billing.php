<?php
/**
 * api/admin/billing.php
 * Billing profiles CRUD.
 * admin → own profile only (owner_user_id = user_id)
 * super_admin → all profiles
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$method = $_SERVER['REQUEST_METHOD'];
$scope  = scopeToUser();

if ($method === 'GET') {
    $mineOnly = (int)($_GET['mine'] ?? 0) === 1;
    if ($scope || $mineOnly) {
        $ownerId = $scope ?: currentUserId();
        $stmt = $pdo->prepare('SELECT * FROM billing_profiles WHERE owner_user_id = ? ORDER BY id DESC');
        $stmt->execute([$ownerId]);
    } else {
        $stmt = $pdo->query('SELECT bp.*, u.name as owner_name FROM billing_profiles bp LEFT JOIN users u ON u.id = bp.owner_user_id ORDER BY bp.id DESC');
    }
    respond(['profiles' => $stmt->fetchAll()]);
}

if ($method === 'POST') {
    $body = getBody();
    requireFields($body, ['company_name']);
    $stmt = $pdo->prepare(
        'INSERT INTO billing_profiles (tenant_id, owner_user_id, company_name, address, phone, email, terms, payment_methods, gst_no, ntn_no)
         VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    );
    $stmt->execute([
        currentUserId(),
        clean($body['company_name']),
        clean($body['address'] ?? ''),
        clean($body['phone'] ?? ''),
        clean($body['email'] ?? ''),
        clean($body['terms'] ?? ''),
        clean($body['payment_methods'] ?? ''),
        clean($body['gst_no'] ?? ''),
        clean($body['ntn_no'] ?? ''),
    ]);
    respond(['success' => true, 'id' => (int)$pdo->lastInsertId()], 201);
}

if ($method === 'PATCH') {
    $id = isset($_GET['id']) ? (int)$_GET['id'] : null;
    if (!$id) err('Profile id required.');

    // Verify ownership
    $check = $pdo->prepare('SELECT owner_user_id FROM billing_profiles WHERE id = ? LIMIT 1');
    $check->execute([$id]);
    $profile = $check->fetch();
    if (!$profile) err('Profile not found.', 404);
    if ($scope && $profile['owner_user_id'] != $scope) err('Access denied.', 403);

    $body = getBody();
    $cols = ['company_name','address','phone','email','terms','payment_methods','gst_no','ntn_no','logo_path'];
    $fields = []; $params = [];
    foreach ($cols as $c) {
        if (array_key_exists($c, $body)) { $fields[] = "$c = ?"; $params[] = clean($body[$c]); }
    }
    if ($fields) {
        $params[] = $id;
        $pdo->prepare('UPDATE billing_profiles SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
    }
    respond(['success' => true]);
}

err('Method not allowed.', 405);
