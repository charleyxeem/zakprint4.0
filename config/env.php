<?php
/**
 * config/env.php
 * Shared loader for local and Hostinger environment files.
 */

function loadAppEnv(array $candidates = []): array
{
    if (!$candidates) {
        $candidates = [
            __DIR__ . '/../.env',
            __DIR__ . '/../env.hostinger',
        ];
    }

    foreach ($candidates as $envFile) {
        if (!is_file($envFile)) {
            continue;
        }

        $env = [];
        $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            $trimmed = trim($line);
            if ($trimmed === '' || strpos($trimmed, '#') === 0 || strpos($trimmed, '=') === false) {
                continue;
            }

            [$key, $value] = explode('=', $trimmed, 2);
            $env[trim($key)] = trim($value);
        }

        if ($env) {
            return $env;
        }
    }

    return [];
}