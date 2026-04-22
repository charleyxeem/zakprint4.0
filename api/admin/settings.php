<?php
/**
 * api/admin/settings.php
 * Application settings — super_admin only.
 * GET ?type=general|smtp|whatsapp|security
 * POST → update settings
 *
 * Settings are stored as key-value in a simple JSON file (config/settings.json)
 * to avoid extra DB tables. Sensitive settings (passwords) are excluded from GET.
 */
require_once __DIR__ . '/../../api/_helpers.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/_guard.php';

requireAdmin();

$SETTINGS_FILE = __DIR__ . '/../../storage/settings.json';
$LEGACY_SETTINGS_FILE = __DIR__ . '/../../config/settings.json';

function loadSettings(string $file): array {
    if (!file_exists($file)) return [];
    return json_decode(file_get_contents($file), true) ?? [];
}

function saveSettings(string $file, array $settings): void {
    $dir = dirname($file);
    if (!is_dir($dir)) {
        @mkdir($dir, 0775, true);
    }
    $ok = @file_put_contents($file, json_encode($settings, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    if ($ok === false) {
        err('Failed to persist settings file.', 500);
    }
}

function loadBillingProfile(PDO $pdo, int $userId): array {
    $profile = [];
    try {
        $stmt = $pdo->prepare('SELECT * FROM billing_profiles WHERE owner_user_id = ? ORDER BY id DESC LIMIT 1');
        $stmt->execute([$userId]);
        $profile = $stmt->fetch() ?: [];
    } catch (Throwable $e) {
        $profile = [];
    }

    if (!$profile) {
        try {
            $stmt = $pdo->prepare('SELECT * FROM billing_profiles WHERE user_id = ? ORDER BY id DESC LIMIT 1');
            $stmt->execute([$userId]);
            $profile = $stmt->fetch() ?: [];
        } catch (Throwable $e) {
            $profile = [];
        }
    }

    return $profile;
}

function syncGeneralIntoBillingProfile(PDO $pdo, int $userId, array $settings): void {
    $billingPayload = [
        'company_name' => clean($settings['company_name'] ?? ''),
        'address' => clean($settings['address'] ?? ''),
        'phone' => clean($settings['phone_number'] ?? ''),
        'email' => clean($settings['support_email'] ?? ''),
        'logo_path' => clean($settings['logo_url'] ?? ''),
        'gst_no' => clean($settings['tax_number'] ?? ''),
        'ntn_no' => clean($settings['tax_number'] ?? ''),
        'terms' => clean($settings['invoice_special_notes'] ?? ''),
    ];

    $paymentNotes = [];
    if (!empty($settings['account_number'])) {
        $paymentNotes[] = 'Account Number: ' . clean($settings['account_number']);
    }
    if (!empty($settings['iban'])) {
        $paymentNotes[] = 'IBAN: ' . clean($settings['iban']);
    }
    if ($paymentNotes) {
        $billingPayload['payment_methods'] = implode("\n", $paymentNotes);
    }

    $hasAny = false;
    foreach ($billingPayload as $value) {
        if ($value !== '') {
            $hasAny = true;
            break;
        }
    }
    if (!$hasAny) {
        return;
    }

    $profile = loadBillingProfile($pdo, $userId);
    if ($profile && !empty($profile['id'])) {
        $fields = [];
        $params = [];
        foreach ($billingPayload as $key => $value) {
            if ($value === '') {
                continue;
            }
            $fields[] = "$key = ?";
            $params[] = $value;
        }

        if ($fields) {
            $params[] = (int)$profile['id'];
            $pdo->prepare('UPDATE billing_profiles SET ' . implode(', ', $fields) . ' WHERE id = ?')->execute($params);
        }
        return;
    }

    $pdo->prepare(
        'INSERT INTO billing_profiles (tenant_id, owner_user_id, company_name, address, phone, email, logo_path, terms, payment_methods, gst_no, ntn_no)
         VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
    )->execute([
        $userId,
        $billingPayload['company_name'] ?: 'ZAK Printing',
        $billingPayload['address'],
        $billingPayload['phone'],
        $billingPayload['email'],
        $billingPayload['logo_path'],
        $billingPayload['terms'],
        $billingPayload['payment_methods'] ?? '',
        $billingPayload['gst_no'],
        $billingPayload['ntn_no'],
    ]);
}

$method = $_SERVER['REQUEST_METHOD'];
$type   = clean($_GET['type'] ?? 'general');
$userId = currentUserId();
$action = clean($_GET['action'] ?? '');

$allowedTypes = ['general', 'smtp', 'whatsapp', 'security', 'invoice', 'quotation'];

if ($action === 'upload' && $method === 'POST') {
    $type = clean($_POST['type'] ?? $_GET['type'] ?? 'general');
    if (!in_array($type, $allowedTypes, true)) {
        err('Unknown settings type.', 422);
    }

    if (empty($_FILES['file'])) {
        err('No file uploaded.', 400);
    }

    $file = $_FILES['file'];
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
        err('Upload error: ' . (int)$file['error'], 400);
    }

    $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml', 'image/x-icon'];
    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mime = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    if (!in_array($mime, $allowed, true)) {
        err('Invalid file type. Allowed: JPG, PNG, GIF, WebP, SVG, ICO', 400);
    }

    if (($file['size'] ?? 0) > 5 * 1024 * 1024) {
        err('File too large. Max 5MB.', 400);
    }

    $uploadDir = __DIR__ . '/../../uploads/cms/';
    if (!is_dir($uploadDir)) {
        @mkdir($uploadDir, 0775, true);
    }

    $ext = strtolower(pathinfo((string)$file['name'], PATHINFO_EXTENSION));
    if ($ext === '') {
        $ext = ($mime === 'image/svg+xml') ? 'svg' : (($mime === 'image/x-icon') ? 'ico' : 'png');
    }
    $safeName = uniqid('settings_', true) . '.' . $ext;
    $destPath = $uploadDir . $safeName;

    if (!move_uploaded_file($file['tmp_name'], $destPath)) {
        err('Failed to save file.', 500);
    }

    $relativePath = 'uploads/cms/' . $safeName;
    $publicUrl = '/' . $relativePath;

    $all = loadSettings($SETTINGS_FILE);
    if (!$all) {
        $all = loadSettings($LEGACY_SETTINGS_FILE);
    }
    if (!isset($all['users']) || !is_array($all['users'])) {
        $all['users'] = [];
    }
    if (!isset($all['users'][$userId]) || !is_array($all['users'][$userId])) {
        $all['users'][$userId] = [];
    }
    if (!isset($all['users'][$userId][$type]) || !is_array($all['users'][$userId][$type])) {
        $all['users'][$userId][$type] = [];
    }

    $settingKey = clean($_POST['setting_key'] ?? 'logo_url');
    if ($settingKey === '') {
        $settingKey = 'logo_url';
    }
    $all['users'][$userId][$type][$settingKey] = $publicUrl;
    saveSettings($SETTINGS_FILE, $all);

    if ($type === 'general') {
        syncGeneralIntoBillingProfile($pdo, $userId, $all['users'][$userId]['general'] ?? []);
    }

    respond(['success' => true, 'file_path' => $relativePath, 'url' => $publicUrl, 'mime' => $mime, 'type' => $type]);
}

if ($method === 'GET') {
    if (!in_array($type, $allowedTypes)) err('Unknown settings type.');
    $all  = loadSettings($SETTINGS_FILE);
    if (!$all) {
        $all = loadSettings($LEGACY_SETTINGS_FILE);
    }
    $globalData = $all[$type] ?? [];
    $userData = $all['users'][$userId][$type] ?? [];
    $data = array_merge($globalData, $userData);

    if ($type === 'general') {
        $billing = loadBillingProfile($pdo, $userId);
        $invoiceData = $all['users'][$userId]['invoice'] ?? [];
        $quotationData = $all['users'][$userId]['quotation'] ?? [];
        $data = array_merge([
            'company_name' => $billing['company_name'] ?? ($data['company_name'] ?? ''),
            'support_email' => $billing['email'] ?? ($data['support_email'] ?? ''),
            'phone_number' => $billing['phone'] ?? ($data['phone_number'] ?? ''),
            'address' => $billing['address'] ?? ($data['address'] ?? ''),
            'logo_url' => $billing['logo_path'] ?? ($data['logo_url'] ?? ''),
            'tax_number' => $billing['gst_no'] ?? $billing['ntn_no'] ?? ($data['tax_number'] ?? ''),
            'account_number' => $invoiceData['account_number'] ?? ($data['account_number'] ?? ''),
            'iban' => $invoiceData['iban'] ?? ($data['iban'] ?? ''),
            'invoice_special_notes' => $invoiceData['invoice_special_notes'] ?? ($data['invoice_special_notes'] ?? ''),
            'quotation_special_notes' => $quotationData['quotation_special_notes'] ?? ($data['quotation_special_notes'] ?? ''),
        ], $data);
    }

    // Mask passwords
    $sensitive = ['smtp_password', 'whatsapp_token'];
    foreach ($sensitive as $k) {
        if (isset($data[$k])) $data[$k] = '••••••••';
    }
    respond(['settings' => $data, 'type' => $type]);
}

if ($method === 'POST') {
    $body = getBody();
    $type = clean($body['type'] ?? 'general');
    if (!in_array($type, $allowedTypes)) err('Unknown settings type.');

    $all = loadSettings($SETTINGS_FILE);
    if (!$all) {
        $all = loadSettings($LEGACY_SETTINGS_FILE);
    }
    if (!isset($all['users']) || !is_array($all['users'])) {
        $all['users'] = [];
    }
    if (!isset($all['users'][$userId]) || !is_array($all['users'][$userId])) {
        $all['users'][$userId] = [];
    }
    if (!isset($all['users'][$userId][$type]) || !is_array($all['users'][$userId][$type])) {
        $all['users'][$userId][$type] = [];
    }

    // Merge (don't overwrite masked passwords with bullets)
    foreach (($body['settings'] ?? []) as $k => $v) {
        if (is_string($v) && strpos($v, '••') !== false) {
            continue;
        }
        $all['users'][$userId][$type][$k] = clean((string)$v);
    }

    if ($type === 'general') {
        $general = $all['users'][$userId]['general'] ?? [];
        if (!isset($all['users'][$userId]['invoice']) || !is_array($all['users'][$userId]['invoice'])) {
            $all['users'][$userId]['invoice'] = [];
        }
        if (!isset($all['users'][$userId]['quotation']) || !is_array($all['users'][$userId]['quotation'])) {
            $all['users'][$userId]['quotation'] = [];
        }

        foreach (['account_number', 'iban', 'invoice_special_notes', 'quotation_special_notes', 'tax_number'] as $key) {
            if (isset($general[$key])) {
                $all['users'][$userId]['invoice'][$key] = clean((string)$general[$key]);
            }
        }

        foreach (['account_number', 'iban', 'tax_number'] as $key) {
            if (isset($general[$key])) {
                $all['users'][$userId]['quotation'][$key] = clean((string)$general[$key]);
            }
        }

        if (isset($general['quotation_special_notes'])) {
            $all['users'][$userId]['quotation']['quotation_special_notes'] = clean((string)$general['quotation_special_notes']);
        }

        syncGeneralIntoBillingProfile($pdo, $userId, $general);
    }

    saveSettings($SETTINGS_FILE, $all);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
