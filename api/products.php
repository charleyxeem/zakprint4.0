<?php
/**
 * api/products.php
 * Public product listing for the shop & product-detail pages.
 * GET /api/products.php              ? paginated active products
 * GET /api/products.php?id=X         ? single product
 * GET /api/products.php?featured=1   ? featured products only
 */
require_once __DIR__ . '/_helpers.php';
require_once __DIR__ . '/../config/database.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') err('Method not allowed.', 405);

$id       = isset($_GET['id']) ? (int)$_GET['id'] : null;
$featured = isset($_GET['featured']) ? (int)$_GET['featured'] : null;
$category = isset($_GET['category']) ? trim((string)$_GET['category']) : null;
$limit    = isset($_GET['limit']) ? (int)$_GET['limit'] : null;
$query    = isset($_GET['q']) ? trim((string)$_GET['q']) : '';
$sort     = isset($_GET['sort']) ? trim((string)$_GET['sort']) : 'popular';
$page     = max(1, (int)($_GET['page'] ?? 1));
$perPage  = (int)($_GET['per_page'] ?? 12);
$perPage  = max(1, min(48, $perPage));
$minPrice = isset($_GET['min_price']) ? (float)$_GET['min_price'] : null;
$maxPrice = isset($_GET['max_price']) ? (float)$_GET['max_price'] : null;

$allowedSorts = ['popular', 'newest', 'price-asc', 'price-desc', 'random'];
if (!in_array($sort, $allowedSorts, true)) {
    $sort = 'popular';
}

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

function parseDelimitedValues($value): array {
    $raw = trim((string)$value);
    if ($raw === '') {
        return [];
    }

    $parts = preg_split('/[\r\n,|]+/', $raw) ?: [];
    $values = [];
    foreach ($parts as $part) {
        $item = trim((string)$part);
        if ($item === '') continue;
        $values[$item] = true;
    }

    return array_keys($values);
}

function parseGroupedValues($value): array {
    $raw = trim((string)$value);
    if ($raw === '') {
        return [];
    }

    $values = [];
    foreach (explode('||', $raw) as $part) {
        $item = trim((string)$part);
        if ($item === '') continue;
        $values[$item] = true;
    }

    return array_keys($values);
}

function normalizeCategorySlug($value): string {
    $raw = strtolower(trim((string)$value));
    if ($raw === '') {
        return '';
    }
    $raw = str_replace(['_', ' '], '-', $raw);
    $raw = preg_replace('/[^a-z0-9\-]+/', '-', $raw) ?? '';
    $raw = preg_replace('/-+/', '-', $raw) ?? '';
    return trim($raw, '-');
}

function categoryLabelFromSlug($slug): string {
    $raw = trim((string)$slug);
    if ($raw === '') {
        return '';
    }
    $words = str_replace(['-', '_'], ' ', strtolower($raw));
    return ucwords($words);
}

function isInternalCategory($slug): bool {
    return (bool)preg_match('/^(admin|import|stg|staging|tmp|temp|debug)(?:-|$)/i', trim((string)$slug));
}

function sanitizePublicDescription($description, int $variantCount = 0): string {
    $text = preg_replace('/\s+/', ' ', trim((string)$description)) ?? '';
    if ($text === '') {
        return '';
    }

    if (preg_match('/^Imported from refactored_products\.csv\./i', $text)) {
        if ($variantCount > 0) {
            return "Available in {$variantCount} configurable options. Select your preferred variation and request a custom quote.";
        }
        return 'Multiple configuration options available. Request a custom quote for accurate pricing.';
    }

    return $text;
}

function productVariantsTableExists(PDO $pdo): bool {
    $stmt = $pdo->query("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'product_variants'");
    return (int)$stmt->fetchColumn() > 0;
}

function loadVariantSummaries(PDO $pdo, array $productIds): array {
    if (!$productIds) {
        return [];
    }

    $placeholders = implode(',', array_fill(0, count($productIds), '?'));
    $sql = "SELECT
              product_id,
              COUNT(*) AS variant_count,
              GROUP_CONCAT(DISTINCT NULLIF(TRIM(size), '') ORDER BY size SEPARATOR '||') AS sizes_raw,
              GROUP_CONCAT(DISTINCT NULLIF(TRIM(CONCAT_WS(' ', NULLIF(paper_type, ''), NULLIF(paper_grammage, ''))), '') ORDER BY paper_type, paper_grammage SEPARATOR '||') AS materials_raw,
              GROUP_CONCAT(DISTINCT NULLIF(TRIM(COALESCE(NULLIF(lamination_or_color, ''), specialty)), '') ORDER BY COALESCE(lamination_or_color, specialty) SEPARATOR '||') AS finishes_raw,
              GROUP_CONCAT(DISTINCT NULLIF(TRIM(sub_product_type), '') ORDER BY sub_product_type SEPARATOR '||') AS styles_raw
            FROM product_variants
            WHERE product_id IN ($placeholders)
              AND (status IS NULL OR status = '' OR status = 'active' OR status = '1' OR status = 1)
            GROUP BY product_id";

    $stmt = $pdo->prepare($sql);
    $stmt->execute($productIds);

    $map = [];
    foreach ($stmt->fetchAll() as $row) {
        $pid = (int)($row['product_id'] ?? 0);
        if ($pid < 1) continue;

        $map[$pid] = [
            'variant_count' => (int)($row['variant_count'] ?? 0),
            'sizes' => parseGroupedValues($row['sizes_raw'] ?? ''),
            'materials' => parseGroupedValues($row['materials_raw'] ?? ''),
            'finishes' => parseGroupedValues($row['finishes_raw'] ?? ''),
            'styles' => parseGroupedValues($row['styles_raw'] ?? ''),
        ];
    }

    return $map;
}

function mapProductForPublic(array $product, array $variantSummary = []): array {
    $dimensions = parseDelimitedValues($product['dimensions'] ?? '');
    $sizes = parseDelimitedValues($product['sizes'] ?? '') ?: $dimensions;
    $colors = parseDelimitedValues($product['colors'] ?? '');

    if (!empty($variantSummary['sizes'])) {
        $sizes = $variantSummary['sizes'];
    }

    $finishOptions = $colors;
    if (!empty($variantSummary['finishes']) || !empty($variantSummary['styles'])) {
        $finishOptions = array_values(array_unique(array_merge(
            $variantSummary['finishes'] ?? [],
            $variantSummary['styles'] ?? []
        )));
    }

    $materialOptions = $variantSummary['materials'] ?? [];
    $variantCount = (int)($variantSummary['variant_count'] ?? 0);

    $rawCategory = trim((string)($product['category'] ?? ''));
    $categorySlug = normalizeCategorySlug($rawCategory);
    $categoryLabel = categoryLabelFromSlug($categorySlug);

    $product['description'] = sanitizePublicDescription($product['description'] ?? '', $variantCount);
    $product['colors_list'] = $finishOptions;
    $product['dimensions_list'] = $dimensions;
    $product['sizes'] = $sizes;
    $product['finish_options'] = $finishOptions;
    $product['size_options'] = $sizes;
    $product['material_options'] = $materialOptions;
    $product['variant_count'] = $variantCount;
    $product['category_slug'] = $categorySlug;
    $product['category_label'] = $categoryLabel !== '' ? $categoryLabel : categoryLabelFromSlug($product['title'] ?? '');
    $product['variations'] = [
        'sizes' => $sizes,
        'materials' => $materialOptions,
        'finishes' => $finishOptions,
        'weight' => trim((string)($product['weight'] ?? '')),
        'count' => $variantCount,
    ];

    return $product;
}

try {
    if (!productsTableExists($pdo)) {
        if ($id) {
            err('Product not found.', 404);
        }
        respond(['products' => [], 'pagination' => ['page' => 1, 'per_page' => 12, 'total' => 0, 'total_pages' => 1], 'categories' => []]);
    }

    $cols = productColumns($pdo);
    $activeExpr = isset($cols['status'])
        ? "(`status` = 'active' OR `status` = '1' OR `status` = 1)"
        : '1=1';

    $defaultOrder = isset($cols['created_at']) ? '`created_at` DESC' : '`id` DESC';
    $featuredOrderPart = isset($cols['featured_order']) ? '`featured_order` ASC, ' : '';

    $hasVariantsTable = productVariantsTableExists($pdo);

    if ($id) {
        $stmt = $pdo->prepare(
            "SELECT `id`,
                    " . colExpr($cols, 'title', "''") . ",
                    " . colExpr($cols, 'price', '0') . ",
                    " . colExpr($cols, 'sale_price', 'NULL') . ",
                    " . colExpr($cols, 'category', "''") . ",
                    " . colExpr($cols, 'description', "''") . ",
                    " . colExpr($cols, 'image', "''") . ",
                    " . colExpr($cols, 'image2', "''") . ",
                    " . colExpr($cols, 'image3', "''") . ",
                    " . colExpr($cols, 'image4', "''") . ",
                    " . colExpr($cols, 'weight', "''") . ",
                    " . colExpr($cols, 'dimensions', "''") . ",
                    " . colExpr($cols, 'colors', "''") . ",
                    " . colExpr($cols, 'sizes', "''") . ",
                    " . colExpr($cols, 'status', "'active'") . "
             FROM `products`
             WHERE `id` = ? AND $activeExpr
             LIMIT 1"
        );
        $stmt->execute([$id]);
        $product = $stmt->fetch();
        if (!$product) err('Product not found.', 404);

        $variantSummary = [];
        if ($hasVariantsTable) {
            $variantMap = loadVariantSummaries($pdo, [(int)$product['id']]);
            $variantSummary = $variantMap[(int)$product['id']] ?? [];
        }

        $product = mapProductForPublic($product, $variantSummary);
        respond(['product' => $product]);
    }

    $where = [$activeExpr];
    $params = [];

    if ($featured && isset($cols['is_featured'])) {
        $where[] = '`is_featured` = 1';
    }

    $categorySlug = normalizeCategorySlug((string)$category);
    if ($categorySlug !== '' && isset($cols['category'])) {
        $where[] = "LOWER(REPLACE(REPLACE(TRIM(`category`), '_', '-'), ' ', '-')) = ?";
        $params[] = $categorySlug;
    }

    if ($query !== '') {
        $searchParts = [];
        if (isset($cols['title'])) {
            $searchParts[] = '`title` LIKE ?';
            $params[] = '%' . $query . '%';
        }
        if (isset($cols['description'])) {
            $searchParts[] = '`description` LIKE ?';
            $params[] = '%' . $query . '%';
        }
        if (!empty($searchParts)) {
            $where[] = '(' . implode(' OR ', $searchParts) . ')';
        }
    }

    if ($minPrice !== null) {
        $where[] = '`price` >= ?';
        $params[] = $minPrice;
    }

    if ($maxPrice !== null) {
        $where[] = '`price` <= ?';
        $params[] = $maxPrice;
    }

    $whereSql = ' WHERE ' . implode(' AND ', $where);

    $orderSql = ' ORDER BY ';
    switch ($sort) {
        case 'random':
            $orderSql .= 'RAND()';
            break;
        case 'newest':
            $orderSql .= $defaultOrder;
            break;
        case 'price-asc':
            $orderSql .= '`price` ASC, ' . $defaultOrder;
            break;
        case 'price-desc':
            $orderSql .= '`price` DESC, ' . $defaultOrder;
            break;
        case 'popular':
        default:
            if (isset($cols['is_featured'])) {
                $orderSql .= '`is_featured` DESC, ' . $featuredOrderPart . $defaultOrder;
            } else {
                $orderSql .= $defaultOrder;
            }
            break;
    }

    $effectivePerPage = $limit ? max(1, $limit) : $perPage;
    $offset = $limit ? 0 : (($page - 1) * $effectivePerPage);

    $countStmt = $pdo->prepare("SELECT COUNT(*) FROM `products`" . $whereSql);
    $countStmt->execute($params);
    $total = (int)$countStmt->fetchColumn();

    $listSql =
        "SELECT `id`,
                " . colExpr($cols, 'title', "''") . ",
                " . colExpr($cols, 'price', '0') . ",
                " . colExpr($cols, 'sale_price', 'NULL') . ",
                " . colExpr($cols, 'category', "''") . ",
                " . colExpr($cols, 'description', "''") . ",
                " . colExpr($cols, 'image', "''") . ",
                " . colExpr($cols, 'weight', "''") . ",
                " . colExpr($cols, 'dimensions', "''") . ",
                " . colExpr($cols, 'colors', "''") . ",
                " . colExpr($cols, 'sizes', "''") . ",
                " . colExpr($cols, 'is_featured', '0') . ",
                " . colExpr($cols, 'featured_order', '0') . "
         FROM `products`" . $whereSql . $orderSql . " LIMIT $effectivePerPage OFFSET $offset";

    $listStmt = $pdo->prepare($listSql);
    $listStmt->execute($params);
    $products = $listStmt->fetchAll();

    $variantMap = [];
    if ($hasVariantsTable && $products) {
        $productIds = array_values(array_filter(array_map(static function (array $p): int {
            return (int)($p['id'] ?? 0);
        }, $products), static function (int $idValue): bool {
            return $idValue > 0;
        }));

        if ($productIds) {
            $variantMap = loadVariantSummaries($pdo, $productIds);
        }
    }

    $products = array_map(static function (array $product) use ($variantMap): array {
        $pid = (int)($product['id'] ?? 0);
        return mapProductForPublic($product, $variantMap[$pid] ?? []);
    }, $products);

    $categories = [];
    if (isset($cols['category'])) {
        $catStmt = $pdo->query(
            "SELECT `category`, COUNT(*) AS `count`
             FROM `products`
             WHERE $activeExpr AND `category` IS NOT NULL AND `category` <> ''
             GROUP BY `category`
             ORDER BY `count` DESC, `category` ASC"
        );
        $catMap = [];
        foreach ($catStmt->fetchAll() as $row) {
            $raw = trim((string)($row['category'] ?? ''));
            if ($raw === '') continue;
            $slug = normalizeCategorySlug($raw);
            if ($slug === '' || isInternalCategory($slug)) continue;

            if (!isset($catMap[$slug])) {
                $catMap[$slug] = [
                    'slug' => $slug,
                    'name' => categoryLabelFromSlug($slug),
                    'count' => 0,
                ];
            }
            $catMap[$slug]['count'] += (int)($row['count'] ?? 0);
        }

        $categories = array_values($catMap);
        usort($categories, static function (array $a, array $b): int {
            if ($a['count'] === $b['count']) {
                return strcmp((string)$a['name'], (string)$b['name']);
            }
            return $b['count'] <=> $a['count'];
        });
    }

    $totalPages = max(1, (int)ceil($total / max(1, $effectivePerPage)));

    respond([
        'products' => $products,
        'pagination' => [
            'page' => min($page, $totalPages),
            'per_page' => $effectivePerPage,
            'total' => $total,
            'total_pages' => $totalPages,
        ],
        'categories' => $categories,
    ]);
} catch (Throwable $e) {
    err('Failed to load products.', 500);
}