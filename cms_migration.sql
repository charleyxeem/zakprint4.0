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
  `block_type` varchar(50) NOT NULL DEFAULT 'text',
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

-- ── 2.5. Navigation Items table ───────────────────────────
CREATE TABLE IF NOT EXISTS `nav_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `label` varchar(100) NOT NULL,
  `href` varchar(200) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_visible` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_nav_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── 2.6. Site Settings table ───────────────────────────────
CREATE TABLE IF NOT EXISTS `site_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT 1,
  `setting_key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_setting` (`tenant_id`, `setting_key`)
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

-- ── 4.5. Backward-Compatibility Column Sync ────────────────
-- Ensure legacy installs have required columns used by API/UI and seed data.
ALTER TABLE `cms_pages`
  ADD COLUMN IF NOT EXISTS `tenant_id` int(11) DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `description` text DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `is_active` tinyint(1) DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `meta_title` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `meta_description` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `meta_keywords` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `sort_order` int(11) DEFAULT 0,
  ADD COLUMN IF NOT EXISTS `created_at` timestamp NULL DEFAULT current_timestamp(),
  ADD COLUMN IF NOT EXISTS `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp();

ALTER TABLE `pages`
  ADD COLUMN IF NOT EXISTS `tenant_id` int(11) DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `title` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `content` longtext DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `updated_by` int(11) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `created_at` timestamp NULL DEFAULT current_timestamp(),
  ADD COLUMN IF NOT EXISTS `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp();

ALTER TABLE `page_assets`
  ADD COLUMN IF NOT EXISTS `tenant_id` int(11) DEFAULT 1,
  ADD COLUMN IF NOT EXISTS `label` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `type` varchar(50) DEFAULT 'image',
  ADD COLUMN IF NOT EXISTS `alt_text` varchar(255) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `updated_by` int(11) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS `created_at` timestamp NULL DEFAULT current_timestamp(),
  ADD COLUMN IF NOT EXISTS `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp();

-- ── 5. Insert default CMS pages ────────────────────────────
-- NOTE: tenant_id is intentionally omitted for backward compatibility
-- with older installs where cms_pages may not have tenant_id yet.
INSERT IGNORE INTO `cms_pages` (`title`, `slug`, `description`, `is_active`, `meta_title`, `meta_description`, `sort_order`) VALUES
('Home', 'home', 'Home page content', 1, 'Home - ZAK Printing', 'Welcome to ZAK Printing', 1),
('About', 'about', 'About page content', 1, 'About Us - ZAK Printing', 'Learn about ZAK Printing', 2),
('Services', 'services', 'Services page content', 1, 'Services - ZAK Printing', 'Our printing services', 3),
('Contact', 'contact', 'Contact page content', 1, 'Contact Us - ZAK Printing', 'Get in touch with us', 4),
('Privacy Policy', 'privacy-policy', 'Privacy policy content', 1, 'Privacy Policy - ZAK Printing', 'Our privacy policy', 5),
('Terms & Conditions', 'terms', 'Terms and conditions content', 1, 'Terms & Conditions - ZAK Printing', 'Our terms and conditions', 6),
('FAQ', 'faq', 'Frequently asked questions', 1, 'FAQ - ZAK Printing', 'Common questions answered', 7),
('Portfolio', 'portfolio', 'Our work showcase', 1, 'Portfolio - ZAK Printing', 'See our printing portfolio', 8),
('Shipping Info', 'shipping-info', 'Shipping and delivery information', 1, 'Shipping Info - ZAK Printing', 'Delivery timelines and zones', 9);

-- ── 5.5. Insert default navigation items ────────────────────
INSERT IGNORE INTO `nav_items` (`tenant_id`, `label`, `href`, `sort_order`, `is_visible`) VALUES
(1, 'Home', '/home', 1, 1),
(1, 'Shop', '/shop', 2, 1),
(1, 'Services', '/services', 3, 1),
(1, 'About', '/about', 4, 1),
(1, 'Contact', '/contact', 5, 1),
(1, 'Portfolio', '/portfolio', 6, 0),
(1, 'Blog', '/blog', 7, 0);

-- ── 5.6. Insert default site settings ───────────────────────
INSERT IGNORE INTO `site_settings` (`tenant_id`, `setting_key`, `value`) VALUES
(1,'site_name','ZAK Printing'),
(1,'site_tagline','You Think, We Create.'),
(1,'contact_email',''),
(1,'contact_phone',''),
(1,'social_facebook',''),
(1,'social_instagram',''),
(1,'social_twitter','');

-- ── 6. Page Assets table content ────────────────────────────
-- NOTE: tenant_id is intentionally omitted for backward compatibility
-- with older installs where pages may not have tenant_id yet.
INSERT IGNORE INTO `pages` (`key`, `title`, `content`) VALUES
('about', 'About Us', '<p>Welcome to ZAK Printing, your trusted partner for all printing needs.</p><p>With years of experience in the printing industry, we deliver quality results and exceptional customer service.</p>'),
('services', 'Our Services', '<h2>Professional Printing Services</h2><p>We offer a wide range of printing services including:</p><ul><li>Business cards</li><li>Brochures and flyers</li><li>Banners and signage</li><li>Packaging solutions</li></ul>'),
('contact', 'Get In Touch', '<h2>Contact Information</h2><p>Reach out to us for any inquiries or custom quote requests.</p><p>We are here to help you with all your printing needs.</p>');

-- ── 7. Insert sample blocks for Home page ──────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`) 
SELECT id, 'hero_section', 'hero', 'Hero Section', 
  '<h1>Welcome to ZAK Printing</h1><p>Your one-stop solution for professional printing services</p>', 
  1 
FROM cms_pages WHERE slug='home' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`) 
SELECT id, 'features', 'text', 'Features Section', 
  '<h2>Why Choose Us?</h2><ul><li>Fast turnaround time</li><li>High quality printing</li><li>Competitive pricing</li></ul>', 
  2 
FROM cms_pages WHERE slug='home' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`) 
SELECT id, 'call_to_action', 'cta', 'Call to Action', 
  '<h2>Ready to Start Your Project?</h2><p>Contact us today for a free quote!</p><button>Get a Quote</button>', 
  3 
FROM cms_pages WHERE slug='home' LIMIT 1;

-- ── 7.5. Insert blocks for About page ───────────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'about_hero', 'hero', 'About Hero', 
  '<h1>About ZAK Printing</h1><p>Learn about our journey and commitment to quality</p>',
  1
FROM cms_pages WHERE slug='about' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'about_content', 'text', 'About Content',
  '<h2>Our Story</h2><p>Founded with a passion for quality printing, ZAK Printing has grown into a trusted partner for businesses across Pakistan. We combine traditional craftsmanship with modern technology to deliver exceptional results.</p><h2>Our Mission</h2><p>To provide affordable, high-quality printing solutions that help businesses succeed.</p>',
  2
FROM cms_pages WHERE slug='about' LIMIT 1;

-- ── 7.6. Insert blocks for Services page ────────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'services_hero', 'hero', 'Services Hero',
  '<h1>Our Services</h1><p>Comprehensive printing solutions for every need</p>',
  1
FROM cms_pages WHERE slug='services' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'services_list', 'text', 'Services List',
  '<h2>What We Offer</h2><ul><li><strong>Business Cards</strong> - Professional, high-quality business cards</li><li><strong>Brochures</strong> - Eye-catching marketing materials</li><li><strong>Banners & Signage</strong> - Large format printing for maximum impact</li><li><strong>Packaging</strong> - Custom packaging solutions</li><li><strong>Offset Printing</strong> - High-volume orders with competitive pricing</li></ul>',
  2
FROM cms_pages WHERE slug='services' LIMIT 1;

-- ── 7.7. Insert blocks for FAQ page ────────────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'faq_hero', 'hero', 'FAQ Hero',
  '<h1>Frequently Asked Questions</h1><p>Find answers to common questions about our services.</p>',
  1
FROM cms_pages WHERE slug='faq' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'faq_items', 'faq', 'FAQ Items',
  '[{\"q\":\"What file formats do you accept?\",\"a\":\"We accept PDF, AI, EPS, and high-res PNG/JPG.\"},{\"q\":\"What is your standard turnaround time?\",\"a\":\"Standard orders complete in 3-5 business days.\"},{\"q\":\"Do you offer bulk discounts?\",\"a\":\"Yes — contact us for a custom quote.\"}]',
  2
FROM cms_pages WHERE slug='faq' LIMIT 1;

-- ── 7.8. Insert blocks for Portfolio page ───────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'portfolio_hero', 'hero', 'Portfolio Hero',
  '<h1>Our Work</h1><p>Explore our portfolio of premium printing projects.</p>',
  1
FROM cms_pages WHERE slug='portfolio' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'portfolio_intro', 'text', 'Portfolio Intro',
  '<p>We take pride in every project. Browse our work below to see the quality we deliver.</p>',
  2
FROM cms_pages WHERE slug='portfolio' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'portfolio_gallery', 'gallery', 'Gallery',
  '[]',
  3
FROM cms_pages WHERE slug='portfolio' LIMIT 1;

-- ── 7.9. Insert blocks for Terms page ──────────────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'terms_hero', 'hero', 'Terms Hero',
  '<h1>Terms & Conditions</h1><p>Please read these terms carefully before placing an order.</p>',
  1
FROM cms_pages WHERE slug='terms' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'terms_content', 'text', 'Terms Content',
  '<h2>1. Acceptance of Terms</h2><p>By using our services you agree to these terms.</p><h2>2. Order Policy</h2><p>All orders are subject to approval and availability.</p><h2>3. Payment</h2><p>Payment is required before production begins.</p>',
  2
FROM cms_pages WHERE slug='terms' LIMIT 1;

-- ── 7.10. Insert blocks for Privacy Policy page ─────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'privacy_hero', 'hero', 'Privacy Hero',
  '<h1>Privacy Policy</h1><p>How we collect, use, and protect your information.</p>',
  1
FROM cms_pages WHERE slug='privacy-policy' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'privacy_content', 'text', 'Privacy Content',
  '<h2>Data We Collect</h2><p>We collect your name, email, and order details to process purchases.</p><h2>How We Use It</h2><p>Your data is used solely for order fulfilment and opted-in communications.</p>',
  2
FROM cms_pages WHERE slug='privacy-policy' LIMIT 1;

-- ── 7.11. Insert blocks for Shipping Info page ──────────────
INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'shipping_hero', 'hero', 'Shipping Hero',
  '<h1>Shipping & Delivery</h1><p>Everything you need to know about how we get your order to you.</p>',
  1
FROM cms_pages WHERE slug='shipping-info' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'shipping_policy', 'text', 'Shipping Policy',
  '<h2>Delivery Timelines</h2><p>Standard: 3-5 business days. Express: 1-2 business days.</p><h2>Delivery Zones</h2><p>We deliver across Pakistan. Charges apply based on location.</p>',
  2
FROM cms_pages WHERE slug='shipping-info' LIMIT 1;

INSERT IGNORE INTO `cms_blocks` (`page_id`, `block_key`, `block_type`, `title`, `content_html`, `sort_order`)
SELECT id, 'shipping_cta', 'cta', 'Contact CTA',
  '<h3>Need a custom delivery arrangement?</h3><p>Contact us and we will find a solution.</p>',
  3
FROM cms_pages WHERE slug='shipping-info' LIMIT 1;

-- ── 8. Insert sample assets ────────────────────────────────
-- NOTE: tenant_id is intentionally omitted for backward compatibility
-- with older installs where page_assets may not have tenant_id yet.
INSERT IGNORE INTO `page_assets` (`page_key`, `asset_key`, `label`, `type`, `file_path`) VALUES
('global', 'logo', 'Site Logo', 'image', 'uploads/cms/logo.svg'),
('global', 'favicon', 'Favicon', 'image', 'uploads/cms/favicon.ico'),
('home', 'hero_banner', 'Hero Banner', 'image', 'uploads/cms/hero_banner.jpg'),
('about', 'about_image', 'About Section Image', 'image', 'uploads/cms/about_image.jpg'),
('contact', 'contact_background', 'Contact Page Background', 'image', 'uploads/cms/contact_bg.jpg');

COMMIT;
