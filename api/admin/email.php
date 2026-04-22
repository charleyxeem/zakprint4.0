<?php
/**
 * V4 Email API – Send invoices/quotations via SMTP
 * 
 * POST { type: 'invoice'|'quotation', id: N, to_email: '...', to_name: '...', subject: '...', body: '...' }
 * Optionally attaches the PDF automatically.
 */
require_once __DIR__ . '/../_helpers.php';
require_once __DIR__ . '/_guard.php';
requireAdmin();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') err('POST only', 405);

$data = getBody();
$type     = $data['type'] ?? 'invoice';
$id       = (int)($data['id'] ?? 0);
$toEmail  = trim($data['to_email'] ?? '');
$toName   = trim($data['to_name'] ?? '');
$subject  = trim($data['subject'] ?? '');
$body     = trim($data['body'] ?? '');
$attachPdf = ($data['attach_pdf'] ?? 'true') !== 'false';

if (!$toEmail) err('Recipient email is required', 400);
if (!$subject) $subject = ucfirst($type) . ' from ZAK Printing';
if (!$body)    $body = '<p>Please find the attached ' . htmlspecialchars($type) . '.</p><p>Thank you for your business!</p><p>— ZAK Printing</p>';

// Load SMTP settings from v4 settings.json or v3 config
$smtpConfig = [];
$settingsFile = dirname(__DIR__, 2) . '/storage/settings.json';
if (is_file($settingsFile)) {
    $s = json_decode(file_get_contents($settingsFile), true);
    $smtpConfig = $s['smtp'] ?? [];
}

// Fallback to v3 email config
if (empty($smtpConfig['smtp_password'])) {
    $v3Config = dirname(__DIR__, 2) . '/zakprintingv3/config/email.php';
    if (is_file($v3Config)) {
        $smtpConfig = require $v3Config;
    }
}

if (empty($smtpConfig['smtp_password'])) {
    err('SMTP is not configured. Set password in settings.', 400);
}

// Load PHPMailer from v3 vendor
$vendorAutoload = dirname(__DIR__, 2) . '/zakprintingv3/vendor/autoload.php';
if (!is_file($vendorAutoload)) {
    err('PHPMailer not available. Run composer install in zakprintingv3/', 500);
}
require_once $vendorAutoload;

// Generate PDF attachment if requested
$attachments = [];
if ($attachPdf && $id > 0) {
    $pdo = require dirname(__DIR__, 2) . '/config/database.php';

    // Generate PDF inline using Dompdf
    try {
        // Minimal PDF generation for attachment
        $table = $type === 'invoice' ? 'invoices' : 'quotations';
        $noCol = $type === 'invoice' ? 'invoice_no' : 'quotation_no';
        $st = $pdo->prepare("SELECT $noCol FROM $table WHERE id=? LIMIT 1");
        $st->execute([$id]);
        $docNo = $st->fetchColumn() ?: strtoupper(substr($type, 0, 3)) . '-' . $id;
        $filename = ucfirst($type) . '-' . preg_replace('/[^A-Za-z0-9_\-]/', '', $docNo) . '.pdf';
        
        // Use the PDF endpoint via HTTP to get the binary
        $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
        $host   = $_SERVER['HTTP_HOST'] ?? 'localhost';
        $pdfUrl = $scheme . '://' . $host . (dirname($_SERVER['SCRIPT_NAME'], 2) ?: '') . '/admin/pdf.php?type=' . urlencode($type) . '&id=' . $id;
        
        $ctx = stream_context_create(['http' => [
            'header' => 'Cookie: ' . ($_SERVER['HTTP_COOKIE'] ?? '') . "\r\n",
            'timeout' => 15
        ]]);
        $pdfContent = @file_get_contents($pdfUrl, false, $ctx);
        
        if ($pdfContent && strlen($pdfContent) > 100) {
            $attachments[] = [
                'content'  => $pdfContent,
                'filename' => $filename,
                'mime'     => 'application/pdf'
            ];
        }
    } catch (Throwable $e) {
        // Continue without attachment
    }
}

// Send email via PHPMailer
try {
    $mail = new \PHPMailer\PHPMailer\PHPMailer(true);
    $mail->CharSet  = \PHPMailer\PHPMailer\PHPMailer::CHARSET_UTF8;
    $mail->Encoding = 'base64';
    $mail->isSMTP();
    $mail->Host       = $smtpConfig['smtp_host'] ?? 'smtp.hostinger.com';
    $mail->Port       = (int)($smtpConfig['smtp_port'] ?? 465);
    $mail->SMTPAuth   = true;
    $mail->Username   = $smtpConfig['smtp_username'] ?? $smtpConfig['from_email'] ?? '';
    $mail->Password   = $smtpConfig['smtp_password'];
    $mail->SMTPSecure = ($smtpConfig['smtp_encryption'] ?? 'ssl') === 'tls'
        ? \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS
        : \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS;

    $mail->setFrom(
        $smtpConfig['from_email'] ?? $smtpConfig['smtp_username'] ?? 'noreply@zakprinting.com',
        $smtpConfig['from_name'] ?? 'ZAK Printing'
    );
    $mail->addAddress($toEmail, $toName);
    $mail->Subject = $subject;
    $mail->Body    = $body;
    $mail->AltBody = strip_tags(preg_replace('/<br\s*\/?>/i', "\n", $body));
    $mail->isHTML(true);

    foreach ($attachments as $att) {
        $mail->addStringAttachment($att['content'], $att['filename'], 'base64', $att['mime']);
    }

    $mail->send();
    respond(['success' => true, 'message' => 'Email sent to ' . $toEmail]);
} catch (\PHPMailer\PHPMailer\Exception $e) {
    err('Email failed: ' . $e->getMessage(), 500);
} catch (Throwable $e) {
    err('Email error: ' . $e->getMessage(), 500);
}
