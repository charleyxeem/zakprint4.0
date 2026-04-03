<?php
/**
 * V4 WhatsApp API – Send invoices/quotations via WhatsApp Business Cloud API
 * 
 * POST { type: 'invoice'|'quotation', id: N, phone: '03xx...', caption: '...' }
 * Generates a tokenized PDF URL and sends it as a document via Meta Graph API.
 */
require_once __DIR__ . '/../_helpers.php';
require_once __DIR__ . '/_guard.php';
requireAdmin();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') err('POST only', 405);

$data = getBody();
$type    = $data['type'] ?? 'invoice';
$id      = (int)($data['id'] ?? 0);
$phone   = trim($data['phone'] ?? '');
$caption = trim($data['caption'] ?? '');

if ($id <= 0) err('Document ID is required', 400);
if (!$phone)  err('Phone number is required', 400);

// Load WhatsApp settings
$waConfig = [];
$settingsFile = dirname(__DIR__, 2) . '/storage/settings.json';
if (is_file($settingsFile)) {
    $s = json_decode(file_get_contents($settingsFile), true);
    $waConfig = $s['whatsapp'] ?? [];
}

// Fallback to v3 config
if (empty($waConfig['access_token'])) {
    $v3Config = dirname(__DIR__, 2) . '/zakprintingv3/config/whatsapp.php';
    if (is_file($v3Config)) {
        $waConfig = require $v3Config;
    }
}

if (empty($waConfig['enabled']) || empty($waConfig['access_token']) || empty($waConfig['phone_number_id'])) {
    err('WhatsApp is not configured or disabled.', 400);
}

// Normalize phone to E.164
$digits = preg_replace('/\D/', '', $phone);
if (strlen($digits) === 11 && substr($digits, 0, 1) === '0') {
    $digits = '92' . substr($digits, 1);
}
if (strlen($digits) === 10 && substr($digits, 0, 1) === '3') {
    $digits = '92' . $digits;
}
if (strlen($digits) < 10) {
    err('Invalid phone number.', 400);
}

// Generate tokenized PDF URL
$secret = $waConfig['pdf_secret'] ?? 'default-secret-change-me';
$window = (string)floor(time() / 900);
$tokenPayload = $type . ':' . $id . ':' . $window;
$token = hash_hmac('sha256', $tokenPayload, $secret);

// Build public PDF URL
$baseUrl = '';
$envLoader = dirname(__DIR__, 2) . '/config/env.php';
if (is_file($envLoader)) {
    require_once $envLoader;
    $env = loadAppEnv();
    $baseUrl = $env['APP_URL'] ?? '';
}
if (!$baseUrl) $baseUrl = 'https://' . ($_SERVER['HTTP_HOST'] ?? 'zakprinting.com');

$pdfUrl = $baseUrl . '/api/admin/pdf.php?type=' . urlencode($type) . '&id=' . $id . '&token=' . $token;

// Fetch document number for filename
$pdo = require dirname(__DIR__, 2) . '/config/database.php';
$docNo = '';
if ($type === 'invoice') {
    $st = $pdo->prepare("SELECT invoice_no FROM invoices WHERE id=? LIMIT 1");
    $st->execute([$id]);
    $docNo = $st->fetchColumn() ?: ('INV-' . $id);
} else {
    $st = $pdo->prepare("SELECT quotation_no FROM quotations WHERE id=? LIMIT 1");
    $st->execute([$id]);
    $docNo = $st->fetchColumn() ?: ('QT-' . $id);
}

$filename = ucfirst($type) . '-' . preg_replace('/[^A-Za-z0-9_\-]/', '', $docNo) . '.pdf';
if (!$caption) {
    $caption = ucfirst($type) . ' ' . $docNo . ' from ZAK Printing';
}

// Send via WhatsApp Cloud API
$payload = [
    'messaging_product' => 'whatsapp',
    'recipient_type'    => 'individual',
    'to'                => $digits,
    'type'              => 'document',
    'document'          => [
        'link'     => $pdfUrl,
        'filename' => $filename,
    ],
];
if ($caption && strlen($caption) <= 1024) {
    $payload['document']['caption'] = $caption;
}

$apiVersion = $waConfig['api_version'] ?? 'v21.0';
$url = 'https://graph.facebook.com/' . $apiVersion . '/' . $waConfig['phone_number_id'] . '/messages';

$ch = curl_init($url);
curl_setopt_array($ch, [
    CURLOPT_POST           => true,
    CURLOPT_POSTFIELDS     => json_encode($payload),
    CURLOPT_HTTPHEADER     => [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $waConfig['access_token'],
    ],
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT        => 30,
]);
$response = curl_exec($ch);
$httpCode = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlErr  = curl_error($ch);
curl_close($ch);

if ($curlErr) {
    err('WhatsApp request failed: ' . $curlErr, 500);
}

$respData = json_decode($response, true);

if ($httpCode >= 200 && $httpCode < 300 && !empty($respData['messages'][0]['id'])) {
    respond([
        'success'    => true,
        'message'    => 'WhatsApp message sent to ' . $phone,
        'message_id' => $respData['messages'][0]['id']
    ]);
} else {
    $errMsg = $respData['error']['message'] ?? ('HTTP ' . $httpCode);
    if (!empty($respData['error']['error_user_msg'])) {
        $errMsg = $respData['error']['error_user_msg'];
    }
    err('WhatsApp failed: ' . $errMsg, 500);
}
