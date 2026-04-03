<?php
/**
 * api/products.php
 * Public product listing for the shop & product-detail pages.
 * GET /api/products.php              → all active products
 * GET /api/products.php?id=X         → single product
 * GET /api/products.php?featured=1   → featured products only
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') err('Method not allowed.', 405);

$id       = isset($_GET['id']) ? (int)$_GET['id'] : null;
$featured = isset($_GET['featured']) ? (int)$_GET['featured'] : null;

function productsTableExists(PDO $pdo): bool {
    $stmt = $pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'products'");
    return (int)$stmt->fetchColumn() > 0;
}

function productColumns(PDO $pdo): array {
    $cols = [];
    $stmt = $pdo->query('SHOW COLUMNS FROM products');
    foreach ($stmt->fetchAll() as $row) {
        $field = $row['Field'] ?? null;
        if ($field) {
            $cols[$field] = true;
        }
    }
    return $cols;
}

function colExpr(array $cols, string $name, string $fallback = 'NULL'): string {
    if (isset($cols[$name])) {
        return "`$name`";
    }
    return "$fallback AS `$name`";
}

try {
    if (!productsTableExists($pdo)) {
        if ($id) {
            err('Product not found.', 404);
        }
        respond(['products' => []]);
    }

    $cols = productColumns($pdo);
    $activeWhere = isset($cols['status'])
        ? " WHERE (`status` = 'active' OR `status` = '1' OR `status` = 1)"
        : '';

    $orderBy = isset($cols['created_at']) ? ' ORDER BY `created_at` DESC' : ' ORDER BY `id` DESC';
    $featuredOrder = isset($cols['featured_order']) ? ' ORDER BY `featured_order` ASC,' : ' ORDER BY';
    $featuredTail = isset($cols['created_at']) ? ' `created_at` DESC' : ' `id` DESC';

    // Single product
    if ($id) {
        $stmt = $pdo->prepare(
            "SELECT `id`,
                    " . colExpr($cols, 'title', "''") . ",
                    " . colExpr($cols, 'price', '0') . ",
                    " . colExpr($cols, 'description', "''") . ",
                    " . colExpr($cols, 'image', "''") . ",
                    " . colExpr($cols, 'image2', "''") . ",
                    " . colExpr($cols, 'image3', "''") . ",
                    " . colExpr($cols, 'image4', "''") . ",
                    " . colExpr($cols, 'weight', "''") . ",
                    " . colExpr($cols, 'dimensions', "''") . ",
                    " . colExpr($cols, 'colors', "''") . ",
                    " . colExpr($cols, 'status', "'active'") . "
             FROM `products`
             WHERE `id` = ?" . $activeWhere . "
             LIMIT 1"
        );
        $stmt->execute([$id]);
        $product = $stmt->fetch();
        if (!$product) err('Product not found.', 404);
        respond(['product' => $product]);
    }

    // Featured products
    if ($featured) {
        $featuredWhere = isset($cols['is_featured']) ? ' AND `is_featured` = 1' : '';
        $stmt = $pdo->query(
            "SELECT `id`,
                    " . colExpr($cols, 'title', "''") . ",
                    " . colExpr($cols, 'price', '0') . ",
                    " . colExpr($cols, 'description', "''") . ",
                    " . colExpr($cols, 'image', "''") . ",
                    " . colExpr($cols, 'is_featured', '0') . ",
                    " . colExpr($cols, 'featured_order', '0') . "
             FROM `products`
             WHERE 1=1" . $activeWhere . $featuredWhere .
             $featuredOrder . $featuredTail
        );
        respond(['products' => $stmt->fetchAll()]);
    }

    // All products
    $allOrder = isset($cols['is_featured'])
        ? ' ORDER BY `is_featured` DESC,' . (isset($cols['created_at']) ? ' `created_at` DESC' : ' `id` DESC')
        : $orderBy;

    $stmt = $pdo->query(
        "SELECT `id`,
                " . colExpr($cols, 'title', "''") . ",
                " . colExpr($cols, 'price', '0') . ",
                " . colExpr($cols, 'description', "''") . ",
                " . colExpr($cols, 'image', "''") . ",
                " . colExpr($cols, 'is_featured', '0') . "
         FROM `products`" . $activeWhere . $allOrder
    );
    respond(['products' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    err('Failed to load products.', 500);
}
