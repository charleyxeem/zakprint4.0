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

$SETTINGS_FILE = __DIR__ . '/../../config/settings.json';

function loadSettings(string $file): array {
    if (!file_exists($file)) return [];
    return json_decode(file_get_contents($file), true) ?? [];
}

function saveSettings(string $file, array $settings): void {
    file_put_contents($file, json_encode($settings, JSON_PRETTY_PRINT));
}

$method = $_SERVER['REQUEST_METHOD'];
$type   = clean($_GET['type'] ?? 'general');
$userId = currentUserId();

$allowedTypes = ['general', 'smtp', 'whatsapp', 'security', 'invoice'];

if ($method === 'GET') {
    if (!in_array($type, $allowedTypes)) err('Unknown settings type.');
    $all  = loadSettings($SETTINGS_FILE);
    $globalData = $all[$type] ?? [];
    $userData = $all['users'][$userId][$type] ?? [];
    $data = array_merge($globalData, $userData);
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
    saveSettings($SETTINGS_FILE, $all);
    respond(['success' => true]);
}

err('Method not allowed.', 405);
