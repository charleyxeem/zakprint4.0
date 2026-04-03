<?php
/**
 * V4 PDF Generation API – Invoice & Quotation PDFs
 * 
 * GET ?type=invoice&id=X   → Download invoice PDF
 * GET ?type=quotation&id=X → Download quotation PDF
 * GET ?type=invoice&id=X&token=Y → Public token-verified PDF (for WhatsApp)
 */
require_once __DIR__ . '/../_helpers.php';
require_once __DIR__ . '/_guard.php';

$type  = $_GET['type'] ?? 'invoice';
$id    = (int)($_GET['id'] ?? 0);
$token = $_GET['token'] ?? null;

if ($id <= 0) err('ID is required', 400);

// Token-based access (for WhatsApp PDF links) — no session needed
if ($token) {
    $secret = '';
    $settingsFile = dirname(__DIR__, 2) . '/storage/settings.json';
    if (is_file($settingsFile)) {
        $s = json_decode(file_get_contents($settingsFile), true);
        $secret = $s['whatsapp']['pdf_secret'] ?? '';
    }
    if (!$secret || !verify_pdf_token($type, $id, $token, $secret)) {
        err('Invalid or expired token', 403);
    }
} else {
    // Session-based access — require admin login
    requireAdmin();
}

// Load Composer autoload from v3 vendor
$vendorAutoload = dirname(__DIR__, 2) . '/zakprintingv3/vendor/autoload.php';
if (!is_file($vendorAutoload)) {
    err('PDF library not available. Run composer install in zakprintingv3/', 500);
}
require_once $vendorAutoload;

$pdo = require dirname(__DIR__, 2) . '/config/database.php';

/* ========== Fetch data ========== */
if ($type === 'invoice') {
    $st = $pdo->prepare("SELECT * FROM invoices WHERE id=? LIMIT 1");
    $st->execute([$id]);
    $doc = $st->fetch(PDO::FETCH_ASSOC);
    if (!$doc) err('Invoice not found', 404);

    // Role check: admin can only see own invoices
    if (!$token) {
        $role = $_SESSION['role'] ?? 'admin';
        if ($role !== 'super_admin' && ($doc['created_by'] ?? 0) != ($_SESSION['user_id'] ?? 0)) {
            err('Access denied', 403);
        }
    }

    $items = $pdo->prepare("SELECT * FROM invoice_items WHERE invoice_id=? ORDER BY id ASC");
    $items->execute([$id]);
    $items = $items->fetchAll(PDO::FETCH_ASSOC);

    // Sum payments
    $paid = 0.0;
    try {
        $ps = $pdo->prepare("SELECT COALESCE(SUM(amount),0) FROM invoice_payments WHERE invoice_id=?");
        $ps->execute([$id]);
        $paid = (float)$ps->fetchColumn();
    } catch (Throwable $e) {
        $paid = (float)($doc['amount_paid'] ?? 0.0);
    }

    $docNo = $doc['invoice_no'] ?? ('INV-' . $doc['id']);
    $filePrefix = 'Invoice';
} else {
    $st = $pdo->prepare("SELECT * FROM quotations WHERE id=? LIMIT 1");
    $st->execute([$id]);
    $doc = $st->fetch(PDO::FETCH_ASSOC);
    if (!$doc) err('Quotation not found', 404);

    $items = $pdo->prepare("SELECT * FROM quotation_items WHERE quotation_id=? ORDER BY id ASC");
    $items->execute([$id]);
    $items = $items->fetchAll(PDO::FETCH_ASSOC);

    $paid = 0;
    $docNo = $doc['quotation_no'] ?? ('QT-' . $doc['id']);
    $filePrefix = 'Quotation';
}

/* ========== Branding ========== */
$branding = [];
try {
    $bp = $pdo->prepare("SELECT * FROM billing_profiles WHERE owner_user_id=? LIMIT 1");
    $bp->execute([$doc['created_by'] ?? ($_SESSION['user_id'] ?? 0)]);
    $branding = $bp->fetch(PDO::FETCH_ASSOC) ?: [];
} catch (Throwable $e) {}

if (empty($branding)) {
    $branding = [
        'company_name' => 'ZAK Media Private Limited',
        'phone' => '0309-6554946',
        'email' => 'zakmedialtd@gmail.com',
        'gst_no' => '3277876364981',
        'ntn_no' => 'D850334-5',
        'payment_methods' => 'Bank Transfer',
        'terms' => "Meezan Bank Limited\nAccount Title: ZAK Media Private Limited\nAccount Number: 0204-0110453596\nIBAN: PK72MEZN0002040110453596"
    ];
}

/* ========== Calculate totals ========== */
$subtotal = 0.0;
$totalTax = 0.0;
foreach ($items as $r) {
    $qty = (float)($r['quantity'] ?? 0);
    $prc = (float)($r['price'] ?? 0);
    $lt  = (float)($r['line_total'] ?? ($qty * $prc));
    $subtotal += $lt;
    if (isset($r['tax_amount'])) $totalTax += (float)$r['tax_amount'];
}
$taxAmount = $totalTax ?: ($subtotal * ((float)($doc['tax_percent'] ?? 0) / 100));
$total = $subtotal + $taxAmount;
$totalDue = max(0.0, $total - $paid);

$statusText = strtoupper((string)($doc['status'] ?? 'UNPAID'));
if (!in_array($statusText, ['PAID', 'PARTIAL', 'UNPAID'], true)) {
    $statusText = 'UNPAID';
    if ($paid >= $total && $total > 0) $statusText = 'PAID';
    elseif ($paid > 0 && $paid < $total) $statusText = 'PARTIAL';
}

/* ========== Build HTML ========== */
$safe = function($v) { return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8'); };
$money = function($n) { return 'PKR ' . number_format((float)$n, 2); };

$dateStr = substr((string)($doc['created_at'] ?? ''), 0, 10);
$dueDateStr = isset($doc['due_date']) && $doc['due_date'] ? substr((string)$doc['due_date'], 0, 10) : $dateStr;

$itemsHtml = '';
foreach ($items as $i => $r) {
    $qty = (float)($r['quantity'] ?? 0);
    $prc = (float)($r['price'] ?? 0);
    $lt  = (float)($r['line_total'] ?? ($qty * $prc));
    $itemsHtml .= '<tr>
        <td style="padding:10px;border-bottom:1px solid #e5e7eb">' . ($i + 1) . '</td>
        <td style="padding:10px;border-bottom:1px solid #e5e7eb">' . $safe($r['description'] ?? $r['title'] ?? '') . '</td>
        <td style="padding:10px;border-bottom:1px solid #e5e7eb;text-align:center">' . $qty . '</td>
        <td style="padding:10px;border-bottom:1px solid #e5e7eb;text-align:right">' . $money($prc) . '</td>
        <td style="padding:10px;border-bottom:1px solid #e5e7eb;text-align:right">' . $money($lt) . '</td>
    </tr>';
}

$html = '<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
body{font-family:DejaVu Sans,Arial,sans-serif;font-size:11px;color:#0b1225;margin:0;padding:30px}
h1{font-size:28px;margin:0}
.header{display:flex;justify-content:space-between;align-items:center;margin-bottom:30px}
.pill{display:inline-block;padding:4px 14px;border-radius:99px;font-weight:bold;font-size:10px;color:#fff;background:' . ($statusText==='PAID'?'#16a34a':($statusText==='PARTIAL'?'#f59e0b':'#ef4444')) . '}
table{width:100%;border-collapse:collapse;margin:20px 0}
th{background:#f1f5f9;padding:10px;text-align:left;font-size:10px;text-transform:uppercase;letter-spacing:.5px}
.total-row td{font-weight:bold;font-size:13px}
.card{background:#f8fafc;border:1px solid #e5e7eb;padding:15px;border-radius:8px;margin:5px 0}
</style></head><body>
<div class="header">
  <div><h1>' . $safe($branding['company_name'] ?? 'ZAK Printing') . '</h1>
  <p style="color:#667085;margin:5px 0">' . $safe($branding['address'] ?? '') . '</p></div>
  <div style="text-align:right"><span class="pill">' . $statusText . '</span>
  <p style="font-size:22px;font-weight:bold;margin:5px 0">' . $safe($docNo) . '</p></div>
</div>
<table style="margin-bottom:20px"><tr>
<td style="width:50%;vertical-align:top"><div class="card"><strong>Bill To</strong><br>' . $safe($doc['client_name'] ?? '') . '<br>' . $safe($doc['client_phone'] ?? '') . '<br>' . $safe($doc['client_email'] ?? '') . '</div></td>
<td style="width:50%;vertical-align:top"><div class="card"><strong>Details</strong><br>Date: ' . $dateStr . '<br>Due: ' . $dueDateStr . '<br>Phone: ' . $safe($branding['phone'] ?? '') . '</div></td>
</tr></table>
<table>
<thead><tr><th>#</th><th>Description</th><th style="text-align:center">Qty</th><th style="text-align:right">Rate</th><th style="text-align:right">Amount</th></tr></thead>
<tbody>' . $itemsHtml . '</tbody>
</table>
<table style="width:40%;margin-left:auto">
<tr><td style="padding:6px">Subtotal</td><td style="text-align:right;padding:6px">' . $money($subtotal) . '</td></tr>
<tr><td style="padding:6px">Tax</td><td style="text-align:right;padding:6px">' . $money($taxAmount) . '</td></tr>
<tr class="total-row"><td style="padding:8px;border-top:2px solid #0b1225">Total</td><td style="text-align:right;padding:8px;border-top:2px solid #0b1225">' . $money($total) . '</td></tr>
<tr><td style="padding:6px;color:#16a34a">Paid</td><td style="text-align:right;padding:6px;color:#16a34a">' . $money($paid) . '</td></tr>
<tr style="font-size:14px;font-weight:bold"><td style="padding:8px;background:#fef2f2">Balance Due</td><td style="text-align:right;padding:8px;background:#fef2f2;color:#ef4444">' . $money($totalDue) . '</td></tr>
</table>';

if (!empty($branding['terms'])) {
    $html .= '<div class="card" style="margin-top:30px"><strong>Payment Info & Terms</strong><br><pre style="font-size:10px;white-space:pre-wrap;margin:5px 0">' . $safe($branding['terms']) . '</pre></div>';
}

$html .= '</body></html>';

/* ========== Generate PDF ========== */
try {
    $options = new \Dompdf\Options();
    $options->set('isRemoteEnabled', true);
    $options->set('isHtml5ParserEnabled', true);
    $options->set('defaultFont', 'DejaVu Sans');

    $dompdf = new \Dompdf\Dompdf($options);
    $dompdf->loadHtml($html, 'UTF-8');
    $dompdf->setPaper('A4', 'portrait');
    $dompdf->render();
    $pdfBinary = $dompdf->output();
} catch (Throwable $e) {
    // Fallback: try mPDF
    try {
        $mpdf = new \Mpdf\Mpdf(['tempDir' => sys_get_temp_dir() . '/mpdf', 'format' => 'A4']);
        $mpdf->WriteHTML($html);
        $pdfBinary = $mpdf->Output('', 'S');
    } catch (Throwable $e2) {
        err('PDF generation failed: ' . $e->getMessage(), 500);
    }
}

$filename = $filePrefix . '-' . preg_replace('/[^A-Za-z0-9_\-]/', '', (string)$docNo) . '.pdf';
header('Content-Type: application/pdf');
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('Content-Length: ' . strlen($pdfBinary));
header('Cache-Control: private, max-age=0, must-revalidate');
echo $pdfBinary;
exit;

/* ========== Helper: PDF Token ========== */
function verify_pdf_token(string $type, int $id, string $token, string $secret): bool {
    if ($secret === '' || $token === '') return false;
    $now = floor(time() / 900);
    for ($w = 0; $w <= 1; $w++) {
        $window = (string)($now - $w);
        $payload = $type . ':' . $id . ':' . $window;
        $expected = hash_hmac('sha256', $payload, $secret);
        if (hash_equals($expected, $token)) return true;
    }
    return false;
}
