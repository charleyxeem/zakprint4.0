-- ============================================================
-- ZakPrinting V4 — CMS Content Studio Migration
-- Adds all tables required for the Content Studio feature
-- ============================================================

-- ── 1. CMS Pages table ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS `cms_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `slug` varchar(200) NOT NULL UNIQUE,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug_tenant` (`slug`, `tenant_id`),
  KEY `idx_cms_pages_active` (`is_active`),
  KEY `idx_cms_pages_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 2. CMS Blocks table ────────────────────────────────────
CREATE TABLE IF NOT EXISTS `cms_blocks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `block_key` varchar(100) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content_html` longtext DEFAULT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_block_key` (`page_id`, `block_key`),
  KEY `idx_cms_blocks_page` (`page_id`),
  FOREIGN KEY (`page_id`) REFERENCES `cms_pages`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 3. Page Assets table ────────────────────────────────────
CREATE TABLE IF NOT EXISTS `page_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `page_key` varchar(100) NOT NULL,
  `asset_key` varchar(100) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'image',
  `file_path` varchar(255) NOT NULL,
  `alt_text` varchar(255) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_asset_key` (`page_key`, `asset_key`, `tenant_id`),
  KEY `idx_page_assets_page_key` (`page_key`),
  KEY `idx_page_assets_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 4. Pages table (for rich text content) ─────────────────
CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `key` varchar(100) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_key_tenant` (`key`, `tenant_id`),
  KEY `idx_pages_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 5. Insert default CMS pages ────────────────────────────
INSERT IGNORE INTO `cms_pages` (`tenant_id`, `title`, `slug`, `description`, `is_active`, `meta_title`, `meta_description`, `sort_order`) VALUES
(1, 'Home', 'home', 'Home page content', 1, 'Home - ZAK Printing', 'Welcome to ZAK Printing', 1),
(1, 'About', 'about', 'About page content', 1, 'About Us - ZAK Printing', 'Learn about ZAK Printing', 2),
(1, 'Services', 'services', 'Services page content', 1, 'Services - ZAK Printing', 'Our printing services', 3),
(1, 'Contact', 'contact', 'Contact page content', 1, 'Contact Us - ZAK Printing', 'Get in touch with us', 4),
(1, 'Privacy Policy', 'privacy-policy', 'Privacy policy content', 1, 'Privacy Policy - ZAK Printing', 'Our privacy policy', 5),
(1, 'Terms & Conditions', 'terms', 'Terms and conditions content', 1, 'Terms & Conditions - ZAK Printing', 'Our terms and conditions', 6);

-- ── 6. Insert default page content for rich text pages ──────
INSERT IGNORE INTO `pages` (`tenant_id`, `key`, `title`, `content`) VALUES
(1, 'about', 'About Us', '<p>Welcome to ZAK Printing, your trusted partner for all printing needs.</p><p>With years of experience in the printing industry, we deliver quality results and exceptional customer service.</p>'),
(1, 'services', 'Our Services', '<h2>Professional Printing Services</h2><p>We offer a wide range of printing services including:</p><ul><li>Business cards</li><li>Brochures and flyers</li><li>Banners and signage</li><li>Packaging solutions</li></ul>'),
(1, 'contact', 'Get In Touch', '<h2>Contact Information</h2><p>Reach out to us for any inquiries or custom quote requests.</p><p>We are here to help you with all your printing needs.</p>');

-- ── 7. Insert sample blocks for Home page ──────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `title`, `content_html`, `sort_order`) 
SELECT id, 'hero_section', 'Hero Section', 
  '<h1>Welcome to ZAK Printing</h1><p>Your one-stop solution for professional printing services</p>', 
  1 
FROM cms_pages WHERE slug='home' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `title`, `content_html`, `sort_order`) 
SELECT id, 'features', 'Features Section', 
  '<h2>Why Choose Us?</h2><ul><li>Fast turnaround time</li><li>High quality printing</li><li>Competitive pricing</li></ul>', 
  2 
FROM cms_pages WHERE slug='home' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `title`, `content_html`, `sort_order`) 
SELECT id, 'call_to_action', 'Call to Action', 
  '<h2>Ready to Start Your Project?</h2><p>Contact us today for a free quote!</p><button>Get a Quote</button>', 
  3 
FROM cms_pages WHERE slug='home' LIMIT 1;

-- ── 8. Insert sample assets ────────────────────────────────
INSERT IGNORE INTO `page_assets` (`tenant_id`, `page_key`, `asset_key`, `label`, `type`, `file_path`) VALUES
(1, 'global', 'logo', 'Site Logo', 'image', 'uploads/cms/logo.svg'),
(1, 'global', 'favicon', 'Favicon', 'image', 'uploads/cms/favicon.ico'),
(1, 'home', 'hero_banner', 'Hero Banner', 'image', 'uploads/cms/hero_banner.jpg'),
(1, 'about', 'about_image', 'About Section Image', 'image', 'uploads/cms/about_image.jpg'),
(1, 'contact', 'contact_background', 'Contact Page Background', 'image', 'uploads/cms/contact_bg.jpg');

COMMIT;
