<?php
/**
 * api/billing.php
 * Public billing/payment instructions for checkout.
 * GET -> latest billing profile payment details
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    err('Method not allowed.', 405);
}

$stmt = $pdo->query(
    'SELECT company_name, phone, email, payment_methods, terms
     FROM billing_profiles
     ORDER BY id DESC
     LIMIT 1'
);
$profile = $stmt->fetch();

if (!$profile) {
    respond([
        'billing' => [
            'company_name' => 'ZAK Printing',
            'phone' => '',
            'email' => '',
            'payment_methods' => "Bank Transfer\nMeezan Bank Limited\nAccount Title: ZAK Media Private Limited\nAccount Number: 0204-0110453596\nIBAN: PK72MEZN0002040110453596",
            'terms' => 'Payment is due before production starts.',
        ],
    ]);
}

respond(['billing' => $profile]);
