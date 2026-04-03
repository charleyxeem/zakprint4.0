<?php
/**
 * config/app.php
 * Global application constants
 */

require_once __DIR__ . '/env.php';

$env = loadAppEnv();

define('APP_URL',  $env['APP_URL']  ?? 'http://localhost/zakprintingV4');
define('APP_NAME', $env['APP_NAME'] ?? 'ZAK Printing');
define('APP_ENV',  $env['APP_ENV']  ?? 'production');

date_default_timezone_set('Asia/Karachi');
