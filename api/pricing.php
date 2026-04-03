<?php
/**
 * api/pricing.php
 * GET → return all active pricing plans
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') err('Method not allowed.', 405);

$stmt = $pdo->query(
    "SELECT id, `key`, title, price, period, features, is_active, sort_order
     FROM pricing_plans WHERE is_active = 1 ORDER BY sort_order ASC"
);
$plans = $stmt->fetchAll();

foreach ($plans as &$plan) {
    $plan['features'] = array_values(array_filter(explode("\n", $plan['features'] ?? '')));
}
unset($plan);

respond(['plans' => $plans]);
