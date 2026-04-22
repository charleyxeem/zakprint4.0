<?php
declare(strict_types=1);

// Deployment-safe fallback router for root and subfolder installs.
$uriPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
$scriptDir = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '/')), '/');

if ($scriptDir !== '' && $scriptDir !== '/' && strpos($uriPath, $scriptDir) === 0) {
	$uriPath = substr($uriPath, strlen($scriptDir));
}

$route = trim($uriPath, '/');

$publicRoutes = [
	'home' => 'Frontend-public/home.html',
	'shop' => 'Frontend-public/shop.html',
	'services' => 'Frontend-public/services.html',
	'about' => 'Frontend-public/about.html',
	'contact' => 'Frontend-public/contact.html',
	'blog' => 'Frontend-public/blog.html',
	'appointment' => 'Frontend-public/appointment.html',
	'product-detail' => 'Frontend-public/product-detail.html',
	'checkout' => 'Frontend-public/checkout.html',
	'order-confirm' => 'Frontend-public/order-confirm.html',
	'user-login' => 'Frontend-public/user-login.html',
	'user-dash' => 'Frontend-public/user-dash.html',
	'user-my-order' => 'Frontend-public/user-my-order.html',
	'user-my-settings' => 'Frontend-public/user-my-settings.html',
	'faq' => 'Frontend-public/faq.html',
	'portfolio' => 'Frontend-public/portfolio.html',
	'privacy-policy' => 'Frontend-public/privacy-policy.html',
	'terms' => 'Frontend-public/terms.html',
	'shipping-info' => 'Frontend-public/shipping-info.html',
];

$adminRoutes = [
	'admin/login' => 'Frontend-admin/admin-login.html',
	'admin/dashboard' => 'Frontend-admin/admin-dash.html',
	'admin/appointments' => 'Frontend-admin/appointments.html',
	'admin/billing-settings' => 'Frontend-admin/billing-settings.html',
	'admin/cash-ledger' => 'Frontend-admin/cash-ledger.html',
	'admin/content-studio' => 'Frontend-admin/content studio.html',
	'admin/create-invoice' => 'Frontend-admin/create-invoice.html',
	'admin/create-quotation' => 'Frontend-admin/create-quotation.html',
	'admin/create-user' => 'Frontend-admin/create-user-modal.html',
	'admin/settings' => 'Frontend-admin/general-settings.html',
	'admin/invoices' => 'Frontend-admin/invoice-list.html',
	'admin/invoice-view' => 'Frontend-admin/invoice-view.html',
	'admin/earnings' => 'Frontend-admin/my-earning.html',
	'admin/password-reset' => 'Frontend-admin/password-reset.html',
	'admin/product-editor' => 'Frontend-admin/product-editor.html',
	'admin/products' => 'Frontend-admin/product-inventory.html',
	'admin/queries' => 'Frontend-admin/queries.html',
	'admin/quotations' => 'Frontend-admin/quotation-list.html',
	'admin/quotation-view' => 'Frontend-admin/quotation-view.html',
	'admin/record-payment' => 'Frontend-admin/record-payment-modal.html',
	'admin/security' => 'Frontend-admin/security.html',
	'admin/smtp' => 'Frontend-admin/smtp-config.html',
	'admin/users' => 'Frontend-admin/user-mgmt.html',
	'admin/whatsapp' => 'Frontend-admin/whatsapp-config.html',
];

$adminLegacyAliases = [
	'admin/admin-login' => 'admin/login',
	'admin/admin-dash' => 'admin/dashboard',
	'admin/invoice-list' => 'admin/invoices',
	'admin/quotation-list' => 'admin/quotations',
	'admin/product-inventory' => 'admin/products',
	'admin/my-earning' => 'admin/earnings',
	'admin/general-settings' => 'admin/settings',
	'admin/user-mgmt' => 'admin/users',
	'admin/smtp-config' => 'admin/smtp',
	'admin/whatsapp-config' => 'admin/whatsapp',
	'admin/create-user-modal' => 'admin/create-user',
	'admin/record-payment-modal' => 'admin/record-payment',
	'admin/content%20studio' => 'admin/content-studio',
	'admin/content studio' => 'admin/content-studio',
];

foreach ($adminLegacyAliases as $legacyRoute => $canonicalRoute) {
	if (isset($adminRoutes[$canonicalRoute])) {
		$adminRoutes[$legacyRoute] = $adminRoutes[$canonicalRoute];
	}
}

if ($route === '' || $route === 'index.php') {
	$route = 'home';
}

$route = preg_replace('/\.html$/i', '', $route);

if (preg_match('#^admin/js/(.+)$#i', $route, $m)) {
	$jsRel = 'Frontend-admin/js/' . $m[1];
	$jsPath = __DIR__ . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $jsRel);
	if (is_file($jsPath)) {
		header('Content-Type: application/javascript; charset=UTF-8');
		readfile($jsPath);
		exit;
	}
}

$allRoutes = $publicRoutes + $adminRoutes;

if (isset($allRoutes[$route])) {
	$target = __DIR__ . DIRECTORY_SEPARATOR . str_replace('/', DIRECTORY_SEPARATOR, $allRoutes[$route]);
	if (is_file($target)) {
		header('Content-Type: text/html; charset=UTF-8');
		readfile($target);
		exit;
	}
}

http_response_code(404);
header('Content-Type: text/plain; charset=UTF-8');
echo '404 Not Found';
