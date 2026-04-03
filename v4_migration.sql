-- ============================================================
-- ZakPrinting V4 — Additive Migration SQL
-- Run AFTER importing currect sql.sql
-- This only ADDS new tables/columns — no data is dropped.
-- ============================================================

-- ── 1. appointments table ────────────────────────────────────
CREATE TABLE IF NOT EXISTS `appointments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `service` varchar(200) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `preferred_date` date DEFAULT NULL,
  `status` enum('pending','confirmed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_appointments_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 2. blog_posts table ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS `blog_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `excerpt` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `status` enum('published','draft') DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_blog_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 3. Ensure contact_messages exists, then add subject if needed ─
CREATE TABLE IF NOT EXISTS `contact_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_contact_messages_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `contact_messages`
  ADD COLUMN IF NOT EXISTS `subject` varchar(255) DEFAULT NULL AFTER `phone`;

-- ── 4. Ensure orders table exists + has user_id + items_json ─
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `invoice_no` varchar(100) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `customer_name` varchar(200) NOT NULL,
  `customer_phone` varchar(50) DEFAULT NULL,
  `customer_email` varchar(200) DEFAULT NULL,
  `total` decimal(12,2) DEFAULT 0.00,
  `status` varchar(50) DEFAULT 'pending',
  `cancel_reason` text DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `items_json` text DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_status` (`status`),
  KEY `idx_orders_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `orders`
  ADD COLUMN IF NOT EXISTS `user_id` int(11) DEFAULT NULL AFTER `tenant_id`,
  ADD COLUMN IF NOT EXISTS `items_json` text DEFAULT NULL AFTER `invoice_no`;

-- ── 5. Ensure quotations schema exists + add created_by ───────
CREATE TABLE IF NOT EXISTS `quotations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `quote_no` varchar(120) DEFAULT NULL,
  `quotation_no` varchar(120) DEFAULT NULL,
  `customer_name` varchar(200) DEFAULT NULL,
  `client_name` varchar(200) DEFAULT NULL,
  `client_phone` varchar(50) DEFAULT NULL,
  `client_email` varchar(200) DEFAULT NULL,
  `total` decimal(12,2) DEFAULT 0.00,
  `status` varchar(50) DEFAULT 'draft',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_quotations_created_by` (`created_by`),
  KEY `idx_quotations_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quotations_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quotation_id` int(11) NOT NULL,
  `tenant_id` int(11) DEFAULT 1,
  `product_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `quantity` decimal(12,2) DEFAULT 1.00,
  `price` decimal(12,2) DEFAULT 0.00,
  `line_total` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_quotations_items_qid` (`quotation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `quotation_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quotation_id` int(11) NOT NULL,
  `tenant_id` int(11) DEFAULT 1,
  `product_id` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `quantity` decimal(12,2) DEFAULT 1.00,
  `price` decimal(12,2) DEFAULT 0.00,
  `line_total` decimal(12,2) DEFAULT 0.00,
  `tax_percent` decimal(6,2) DEFAULT 0.00,
  `tax_amount` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_quotation_items_qid` (`quotation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `quotations`
  ADD COLUMN IF NOT EXISTS `created_by` int(11) DEFAULT NULL AFTER `tenant_id`;

-- ── 6. Ensure finance_cash_entries exists + owner_user_id ─────
CREATE TABLE IF NOT EXISTS `finance_cash_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner_user_id` int(11) DEFAULT NULL,
  `direction` enum('in','out') NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `source_type` varchar(100) DEFAULT 'Manual',
  `invoice_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_finance_owner` (`owner_user_id`),
  KEY `idx_finance_direction` (`direction`),
  KEY `idx_finance_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `finance_cash_entries`
  ADD COLUMN IF NOT EXISTS `owner_user_id` int(11) DEFAULT NULL AFTER `id`;

-- ── 7. Sample blog post (so blog.html has data) ──────────────
INSERT IGNORE INTO `blog_posts` (`id`, `tenant_id`, `title`, `slug`, `excerpt`, `content`, `status`) VALUES
(1, 1, 'Welcome to ZAK Printing V4', 'welcome-to-zak-printing-v4',
 'We have upgraded our platform to serve you better with faster invoice management, a new shop, and content studio.',
 'ZAK Printing is excited to announce the launch of our brand new customer portal and admin dashboard. You can now browse our products, place orders, and track your deliveries online. Our admin team has access to a powerful content studio to keep the website fresh.\r\n\r\nWe look forward to serving you better!',
 'published');

COMMIT;
