<?php
declare(strict_types=1);

/**
 * Lightweight regression smoke checks for API validation helpers.
 * Run manually: php tests/regression/api_validation_smoke.php
 */

$_SERVER['REQUEST_METHOD'] = 'CLI';

require_once __DIR__ . '/../../api/_helpers.php';

$failures = [];

$assert = static function (bool $condition, string $message) use (&$failures): void {
    if (!$condition) {
        $failures[] = $message;
    }
};

$assert(clean("  O'Reilly & Sons  ") === "O'Reilly & Sons", 'clean should trim only and not HTML-escape input');
$assert(esc("O'Reilly & Sons") === 'O&#039;Reilly &amp; Sons', 'esc should HTML-escape output');

$_GET = ['status' => ' active ', 'invalid' => ['x']];
$assert(queryString('status') === 'active', 'queryString should trim scalar query values');
$assert(queryString('invalid', 'fallback') === 'fallback', 'queryString should reject array query values');

$body = [
    'status' => 'pending',
    'invoice_id' => '42',
    'reason' => '  delayed  ',
    'obj' => ['bad' => true],
];

$assert(bodyString($body, 'reason') === 'delayed', 'bodyString should trim text values');
$assert(bodyString($body, 'obj', 'fallback') === 'fallback', 'bodyString should reject array/object values');
$assert(bodyInt($body, 'invoice_id') === 42, 'bodyInt should parse integer-like strings');
$assert(bodyInt(['invoice_id' => 'x42'], 'invoice_id') === null, 'bodyInt should return null on invalid integer input');

$status = requireOneOf('pending', ['pending', 'processing', 'completed', 'cancelled'], 'status');
$assert($status === 'pending', 'requireOneOf should return validated enum value');

if (!empty($failures)) {
    fwrite(STDERR, "Validation smoke checks failed:\n");
    foreach ($failures as $failure) {
        fwrite(STDERR, " - {$failure}\n");
    }
    exit(1);
}

echo "Validation smoke checks passed.\n";
