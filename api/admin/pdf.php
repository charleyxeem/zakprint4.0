<?php
/**
 * V4 PDF Generation API – Invoice & Quotation PDFs
 * 
 * GET ?type=invoice&id=X   → Download invoice PDF
 * GET ?type=quotation&id=X → Download quotation PDF
 * GET ?type=invoice&id=X&token=Y → Public token-verified PDF (for WhatsApp)
 */
require_once __DIR__ . '/../_helpers.php';
require_once __DIR__ . '/../../config/database.php';
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

/* ========== Fetch data ========== */
if ($type === 'invoice') {
    $st = $pdo->prepare("SELECT * FROM invoices WHERE id=? LIMIT 1");
    $st->execute([$id]);
    $doc = $st->fetch(PDO::FETCH_ASSOC);
    if (!$doc) err('Invoice not found', 404);

    // Role check: admin can only see own invoices
    if (!$token) {
        $role = $_SESSION['role'] ?? 'admin';
        if (!in_array($role, ['super_admin', 'developer'], true) && (int)($doc['created_by'] ?? 0) !== (int)($_SESSION['user_id'] ?? 0)) {
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

    if (!$token) {
        $role = $_SESSION['role'] ?? 'admin';
        $isPrivileged = in_array($role, ['super_admin', 'developer'], true);
        if (!$isPrivileged && isset($doc['created_by']) && (int)$doc['created_by'] !== (int)($_SESSION['user_id'] ?? 0)) {
            err('Access denied', 403);
        }
    }

    try {
        $items = $pdo->prepare("SELECT * FROM quotations_items WHERE quotation_id=? ORDER BY id ASC");
        $items->execute([$id]);
        $items = $items->fetchAll(PDO::FETCH_ASSOC);
    } catch (Throwable $e) {
        $items = $pdo->prepare("SELECT * FROM quotation_items WHERE quotation_id=? ORDER BY id ASC");
        $items->execute([$id]);
        $items = $items->fetchAll(PDO::FETCH_ASSOC);
    }

    $paid = 0;
    $docNo = $doc['quote_no'] ?? $doc['quotation_no'] ?? ('QT-' . $doc['id']);
    $filePrefix = 'Quotation';
}

/* ========== Branding ========== */
$branding = [];
$ownerUserId = (int)($doc['created_by'] ?? ($_SESSION['user_id'] ?? 0));
try {
    $bp = $pdo->prepare("SELECT * FROM billing_profiles WHERE owner_user_id=? LIMIT 1");
    $bp->execute([$ownerUserId]);
    $branding = $bp->fetch(PDO::FETCH_ASSOC) ?: [];
} catch (Throwable $e) {}

if (empty($branding)) {
    try {
        $bp = $pdo->prepare("SELECT * FROM billing_profiles WHERE user_id=? LIMIT 1");
        $bp->execute([$ownerUserId]);
        $branding = $bp->fetch(PDO::FETCH_ASSOC) ?: [];
    } catch (Throwable $e) {}
}

$userDocSettings = [];
try {
    $settingsFile = dirname(__DIR__, 2) . '/storage/settings.json';
    if (is_file($settingsFile)) {
        $allSettings = json_decode((string)file_get_contents($settingsFile), true);
        if (is_array($allSettings)) {
            $docType = $type === 'quotation' ? 'quotation' : 'invoice';
            $uDoc = is_array($allSettings['users'][$ownerUserId][$docType] ?? null) ? $allSettings['users'][$ownerUserId][$docType] : [];
            $uGeneral = is_array($allSettings['users'][$ownerUserId]['general'] ?? null) ? $allSettings['users'][$ownerUserId]['general'] : [];
            $userDocSettings = [
                'company_name' => $uDoc['company_name'] ?? $uGeneral['company_name'] ?? '',
                'address' => $uDoc['address'] ?? $uGeneral['address'] ?? '',
                'phone' => $uDoc['phone_number'] ?? ($uDoc['phone'] ?? ($uGeneral['phone_number'] ?? '')),
                'email' => $uDoc['support_email'] ?? ($uDoc['email'] ?? ($uGeneral['support_email'] ?? '')),
                'logo_path' => $uDoc['logo_url'] ?? ($uDoc['logo_path'] ?? ($uGeneral['logo_url'] ?? '')),
                'terms' => $uDoc['terms'] ?? $uGeneral['terms'] ?? '',
                'payment_methods' => $uDoc['payment_methods'] ?? $uGeneral['payment_methods'] ?? '',
                'account_number' => $uDoc['account_number'] ?? $uGeneral['account_number'] ?? '',
                'tax_number' => $uDoc['tax_number'] ?? $uGeneral['tax_number'] ?? '',
                'iban' => $uDoc['iban'] ?? $uGeneral['iban'] ?? '',
                'invoice_special_notes' => $uDoc['invoice_special_notes'] ?? $uGeneral['invoice_special_notes'] ?? '',
                'quotation_special_notes' => $uDoc['quotation_special_notes'] ?? $uGeneral['quotation_special_notes'] ?? '',
            ];
        }
    }
} catch (Throwable $e) {}

if (!empty($userDocSettings['company_name'])) {
    $branding['company_name'] = clean((string)$userDocSettings['company_name']);
}
if (!empty($userDocSettings['address'])) {
    $branding['address'] = clean((string)$userDocSettings['address']);
}
if (!empty($userDocSettings['phone'])) {
    $branding['phone'] = clean((string)$userDocSettings['phone']);
}
if (!empty($userDocSettings['email'])) {
    $branding['email'] = clean((string)$userDocSettings['email']);
}
if (!empty($userDocSettings['logo_path'])) {
    $branding['logo_path'] = clean((string)$userDocSettings['logo_path']);
}
if (!empty($userDocSettings['terms'])) {
    $branding['terms'] = clean((string)$userDocSettings['terms']);
}
if (!empty($userDocSettings['payment_methods'])) {
    $branding['payment_methods'] = clean((string)$userDocSettings['payment_methods']);
}

if (empty($branding)) {
    $branding = [
        'company_name' => 'ZAK Printing',
        'phone' => '0309-6554946',
        'email' => 'info@zakprinting.com',
        'gst_no' => '',
        'ntn_no' => '',
        'payment_methods' => 'Bank Transfer',
        'terms' => ''
    ];
}

$taxNumber = trim((string)($userDocSettings['tax_number'] ?? ''));
if ($taxNumber === '') {
    $taxNumber = trim((string)($branding['gst_no'] ?? ($branding['ntn_no'] ?? '')));
}

$accountNo = trim((string)($userDocSettings['account_number'] ?? ''));
$iban = trim((string)($userDocSettings['iban'] ?? ''));
$docNote = $type === 'quotation'
    ? trim((string)($userDocSettings['quotation_special_notes'] ?? ''))
    : trim((string)($userDocSettings['invoice_special_notes'] ?? ''));

$logoPath = trim((string)($branding['logo_path'] ?? ''));
$logoMarkup = '';
if ($logoPath !== '') {
    $publicBase = dirname(__DIR__, 2);
    $normalized = str_replace(['\\', '//'], '/', $logoPath);
    $localPath = $publicBase . '/' . ltrim($normalized, '/');
    if (is_file($localPath)) {
        $mime = @mime_content_type($localPath) ?: 'image/png';
        $bytes = @file_get_contents($localPath);
        if ($bytes !== false) {
            $logoMarkup = '<img src="data:' . $mime . ';base64,' . base64_encode($bytes) . '" alt="logo" style="max-height:52px;max-width:220px;display:block" />';
        }
    }
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
        $rowTaxPercent = (float)($r['tax_percent'] ?? ($doc['tax_percent'] ?? 0));
        $rowTaxAmount = array_key_exists('tax_amount', $r)
                ? (float)($r['tax_amount'] ?? 0)
                : ($lt * $rowTaxPercent / 100);
    $itemsHtml .= '<tr>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;font-size:12px;vertical-align:top">' . ($i + 1) . '</td>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;font-size:12px;line-height:1.45;vertical-align:top;word-break:break-word">' . $safe($r['description'] ?? $r['title'] ?? '') . '</td>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;text-align:center;font-size:12px;vertical-align:top;white-space:nowrap">' . $qty . '</td>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;text-align:right;font-size:12px;vertical-align:top;white-space:nowrap">' . $money($prc) . '</td>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;text-align:right;font-size:12px;vertical-align:top;white-space:nowrap">' . ($rowTaxPercent > 0 ? rtrim(rtrim(number_format($rowTaxPercent, 2), '0'), '.') . '%' : $money($rowTaxAmount)) . '</td>
                <td style="padding:8px 10px;border-bottom:1px solid #e5e7eb;text-align:right;font-size:12px;font-weight:700;vertical-align:top;white-space:nowrap">' . $money($lt) . '</td>
    </tr>';
}

$html = '<!DOCTYPE html><html><head><meta charset="UTF-8">
<style>
body{font-family:DejaVu Sans,Arial,sans-serif;font-size:11px;color:#0b1225;margin:0;padding:30px}
h1{font-size:28px;margin:0}
.header{display:flex;justify-content:space-between;align-items:center;margin-bottom:30px}
.pill{display:inline-block;padding:4px 14px;border-radius:99px;font-weight:bold;font-size:10px;color:#fff;background:' . ($statusText==='PAID'?'#16a34a':($statusText==='PARTIAL'?'#f59e0b':'#ef4444')) . '}
table{width:100%;border-collapse:collapse;margin:20px 0}
th{background:#f1f5f9;padding:8px 10px;text-align:left;font-size:12px;text-transform:uppercase;letter-spacing:.5px}
.doc-company{font-size:18px;font-weight:700;line-height:1.25;margin-top:6px}
.info-text{font-size:13px;line-height:1.5;color:#667085}
.items-table{table-layout:fixed}
.items-table th,.items-table td{overflow-wrap:anywhere}
.summary-row{font-size:13.5px}
.summary-grand{font-weight:700;font-size:14px}
.card{background:#f8fafc;border:1px solid #e5e7eb;padding:15px;border-radius:8px;margin:5px 0}
.notes-block,.bank-block{font-size:13px;line-height:1.5}
</style></head><body>
<div class="header">
        <div>' . $logoMarkup . '<div class="doc-company">' . $safe($branding['company_name'] ?? 'ZAK Printing') . '</div>
    <div class="info-text" style="margin:6px 0">' . nl2br($safe($branding['address'] ?? '')) . ($branding['phone'] || $branding['email'] ? '<br>' . $safe(trim(($branding['phone'] ?? '') . ' ' . ($branding['email'] ? ' | ' . $branding['email'] : ''))) : '') . '</div></div>
  <div style="text-align:right"><span class="pill">' . $statusText . '</span>
  <p style="font-size:22px;font-weight:bold;margin:5px 0">' . $safe($docNo) . '</p></div>
</div>
<table style="margin-bottom:20px"><tr>
<td style="width:50%;vertical-align:top"><div class="card"><strong style="font-size:13px">Bill To</strong><div class="info-text" style="margin-top:6px"><div>' . $safe($doc['client_name'] ?? ($doc['customer_name'] ?? '')) . '</div><div>' . $safe($doc['client_phone'] ?? '') . '</div><div>' . $safe($doc['client_email'] ?? '') . '</div></div></div></td>
<td style="width:50%;vertical-align:top"><div class="card"><strong style="font-size:13px">Details</strong><div class="info-text" style="margin-top:6px">Date: ' . $dateStr . '<br>Due: ' . $dueDateStr . '<br>Phone: ' . $safe($branding['phone'] ?? '') . '</div></div></td>
</tr></table>
<table class="items-table">
<colgroup>
<col style="width:6%"><col style="width:40%"><col style="width:10%"><col style="width:16%"><col style="width:12%"><col style="width:16%">
</colgroup>
<thead><tr><th>#</th><th>Description</th><th style="text-align:center">Qty</th><th style="text-align:right">Price</th><th style="text-align:right">Tax</th><th style="text-align:right">Amount</th></tr></thead>
<tbody>' . $itemsHtml . '</tbody>
</table>
<table style="width:40%;margin-left:auto">
<tr class="summary-row"><td style="padding:6px">Subtotal</td><td style="text-align:right;padding:6px">' . $money($subtotal) . '</td></tr>
<tr class="summary-row"><td style="padding:6px">Total Tax</td><td style="text-align:right;padding:6px">' . $money($taxAmount) . '</td></tr>
' . ($paid > 0 ? '<tr class="summary-row"><td style="padding:6px;color:#16a34a">Advance / Paid</td><td style="text-align:right;padding:6px;color:#16a34a">' . $money($paid) . '</td></tr>' : '') . '
<tr class="summary-grand"><td style="padding:8px;border-top:2px solid #0b1225">Grand Total</td><td style="text-align:right;padding:8px;border-top:2px solid #0b1225">' . $money($total) . '</td></tr>
' . ($type === 'invoice' ? '<tr style="font-size:14px;font-weight:bold"><td style="padding:8px;background:#fef2f2">Balance Due</td><td style="text-align:right;padding:8px;background:#fef2f2;color:#ef4444">' . $money($totalDue) . '</td></tr>' : '') . '
</table>';

$metaBits = [];
if ($taxNumber !== '') $metaBits[] = 'Tax ID: ' . $safe($taxNumber);
if ($accountNo !== '') $metaBits[] = 'Account #: ' . $safe($accountNo);
if ($iban !== '') $metaBits[] = 'IBAN: ' . $safe($iban);
if ($metaBits) {
    $html .= '<div class="card bank-block" style="margin-top:18px"><strong>Account Information</strong><br>' . implode('<br>', $metaBits) . '</div>';
}

if (!empty($branding['payment_methods'])) {
    $html .= '<div class="card bank-block" style="margin-top:18px"><strong>Bank Details</strong><br><pre style="font-size:13px;white-space:pre-wrap;line-height:1.5;margin:5px 0">' . $safe($branding['payment_methods']) . '</pre></div>';
}

if ($docNote !== '') {
    $html .= '<div class="card notes-block" style="margin-top:18px"><strong>Document Notes</strong><br><pre style="font-size:13px;white-space:pre-wrap;line-height:1.5;margin:5px 0">' . $safe($docNote) . '</pre></div>';
}

if (!empty($branding['terms'])) {
    $html .= '<div class="card notes-block" style="margin-top:30px"><strong>Payment Info & Terms</strong><br><pre style="font-size:13px;white-space:pre-wrap;line-height:1.5;margin:5px 0">' . $safe($branding['terms']) . '</pre></div>';
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
