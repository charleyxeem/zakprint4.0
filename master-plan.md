ZAK Printing V4 — Full CMS + Missing Pages Implementation Plan
Context
ZAK Printing V4 is a PHP 8 / Vanilla JS / Tailwind printing business web app running on XAMPP/MySQL. Routing is handled by both .htaccess Apache rewrites and index.php fallback. Public pages live in Frontend-public/, admin in Frontend-admin/, APIs at /api/ (public) and /api/admin/ (super_admin only).

Problems being solved:

Footer links (#faq, #privacy-policy, #shipping-info) point to nowhere — pages don't exist
Portfolio page is referenced in intent but has no route or HTML file
Content Studio (Frontend-admin/content studio.html) is a basic flat-scroll table — no WYSIWYG, no block types, no SEO editing, only home has CMS blocks, no live-preview concept
Critical bug: api/admin/email.php:70 uses hardcoded http://localhost breaking PDF emails in production
CORS reflects any origin in api/_helpers.php:10 — security risk
public-shell.js:178 only injects header/footer on the 5 main nav pages — new pages won't get the shell
Critical Files
File	Purpose	Changes Needed
index.php	PHP fallback router	Add 5 new public routes
.htaccess	Apache URL rewriter	Add 5 new RewriteRules
Frontend-public/js/public-shell.js	Header/footer injection + nav	Loosen injection condition, fix footer links, add new page routes to map
Frontend-admin/content studio.html	CMS editor UI	Full redesign to 3-panel layout
api/admin/cms.php	Admin CMS API	Add block_type, update_seo, update_nav, update_settings, reorder_blocks actions; generalize block seeding
api/cms.php	Public CMS API	Add new slugs to rich-text page list
api/admin/email.php:70	Email sender	Fix hardcoded localhost
api/_helpers.php:10-16	Shared API helpers	Restrict CORS origin reflection
cms_migration.sql	DB schema	Add block_type column, nav_items table, site_settings table, seed new pages
New files (5): Frontend-public/faq.html, portfolio.html, privacy-policy.html, terms.html, shipping-info.html	Public pages	Create from scratch
Phase 1 — Bug Fixes (do first, isolated changes)
Bug 1 — CRITICAL: Hardcoded localhost in email.php
File: api/admin/email.php line 70

Replace:

$pdfUrl = 'http://localhost' . (dirname($_SERVER['SCRIPT_NAME'], 2) ?: '') . '/admin/pdf.php?type=' . urlencode($type) . '&id=' . $id;
With:

$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$host   = $_SERVER['HTTP_HOST'] ?? 'localhost';
$pdfUrl = $scheme . '://' . $host . (dirname($_SERVER['SCRIPT_NAME'], 2) ?: '') . '/admin/pdf.php?type=' . urlencode($type) . '&id=' . $id;
Bug 2 — MEDIUM: Open CORS in _helpers.php
File: api/_helpers.php lines 10-16

Replace the open CORS block with an allowlist approach. Since this is a session-cookie app (same-origin), the safest fix is to only allow same origin (no CORS for external origins, which aren't needed):

$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$host   = ($_SERVER['HTTP_HOST'] ?? 'localhost');
// Only reflect origin if it matches the server's own host
if ($origin && parse_url($origin, PHP_URL_HOST) === $host) {
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Access-Control-Allow-Credentials: true');
    header('Vary: Origin');
} else {
    // No ACAO header for unknown origins — browser will block cross-origin XHR
}
Phase 2 — Database Schema (run as migration SQL)
Add to cms_migration.sql (or run separately in phpMyAdmin):

-- 1. Add block_type to cms_blocks (use VARCHAR not ENUM for extensibility)
ALTER TABLE `cms_blocks`
  ADD COLUMN IF NOT EXISTS `block_type` VARCHAR(50) NOT NULL DEFAULT 'text' AFTER `block_key`;

-- 2. Navigation management table
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

INSERT IGNORE INTO `nav_items` (`tenant_id`, `label`, `href`, `sort_order`, `is_visible`) VALUES
(1, 'Home', '/home', 1, 1), (1, 'Shop', '/shop', 2, 1), (1, 'Services', '/services', 3, 1),
(1, 'About', '/about', 4, 1), (1, 'Contact', '/contact', 5, 1),
(1, 'Portfolio', '/portfolio', 6, 0), (1, 'Blog', '/blog', 7, 0);

-- 3. Global site settings table
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

INSERT IGNORE INTO `site_settings` (`tenant_id`, `setting_key`, `value`) VALUES
(1,'site_name','ZAK Printing'),(1,'site_tagline','You Think, We Create.'),
(1,'contact_email',''),(1,'contact_phone',''),
(1,'social_facebook',''),(1,'social_instagram',''),(1,'social_twitter','');

-- 4. Seed new CMS pages (faq, portfolio, shipping-info already partially exist via terms/privacy in migration)
INSERT IGNORE INTO `cms_pages` (`title`, `slug`, `description`, `is_active`, `meta_title`, `meta_description`, `sort_order`) VALUES
('FAQ', 'faq', 'Frequently asked questions', 1, 'FAQ - ZAK Printing', 'Common questions answered', 7),
('Portfolio', 'portfolio', 'Our work showcase', 1, 'Portfolio - ZAK Printing', 'See our printing portfolio', 8),
('Shipping Info', 'shipping-info', 'Shipping and delivery information', 1, 'Shipping Info - ZAK Printing', 'Delivery timelines and zones', 9);
-- Note: terms (slug='terms') and privacy-policy already seeded in cms_migration.sql lines 115-116

-- 5. Seed blocks for new pages (block_type included)
-- FAQ
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'faq_hero','hero','FAQ Hero','<h1>Frequently Asked Questions</h1><p>Find answers to common questions about our services.</p>',1 FROM cms_pages p WHERE p.slug='faq';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'faq_items','faq','FAQ Items','[{"q":"What file formats do you accept?","a":"We accept PDF, AI, EPS, and high-res PNG/JPG."},{"q":"What is your standard turnaround time?","a":"Standard orders complete in 3-5 business days."},{"q":"Do you offer bulk discounts?","a":"Yes — contact us for a custom quote."}]',2 FROM cms_pages p WHERE p.slug='faq';

-- Portfolio
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'portfolio_hero','hero','Portfolio Hero','<h1>Our Work</h1><p>Explore our portfolio of premium printing projects.</p>',1 FROM cms_pages p WHERE p.slug='portfolio';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'portfolio_intro','text','Portfolio Intro','<p>We take pride in every project. Browse our work below to see the quality we deliver.</p>',2 FROM cms_pages p WHERE p.slug='portfolio';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'portfolio_gallery','gallery','Gallery','[]',3 FROM cms_pages p WHERE p.slug='portfolio';

-- Shipping Info
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'shipping_hero','hero','Shipping Hero','<h1>Shipping & Delivery</h1><p>Everything you need to know about how we get your order to you.</p>',1 FROM cms_pages p WHERE p.slug='shipping-info';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'shipping_policy','text','Shipping Policy','<h2>Delivery Timelines</h2><p>Standard: 3-5 business days. Express: 1-2 business days.</p><h2>Delivery Zones</h2><p>We deliver across Pakistan. Charges apply based on location.</p>',2 FROM cms_pages p WHERE p.slug='shipping-info';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'shipping_cta','cta','Contact CTA','<h3>Need a custom delivery arrangement?</h3><p>Contact us and we will find a solution.</p>',3 FROM cms_pages p WHERE p.slug='shipping-info';

-- Terms
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'terms_hero','hero','Terms Hero','<h1>Terms & Conditions</h1><p>Please read these terms carefully before placing an order.</p>',1 FROM cms_pages p WHERE p.slug='terms';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'terms_content','text','Terms Content','<h2>1. Acceptance of Terms</h2><p>By using our services you agree to these terms.</p><h2>2. Order Policy</h2><p>All orders are subject to approval and availability.</p><h2>3. Payment</h2><p>Payment is required before production begins.</p>',2 FROM cms_pages p WHERE p.slug='terms';

-- Privacy Policy blocks (page already seeded, add blocks)
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'privacy_hero','hero','Privacy Hero','<h1>Privacy Policy</h1><p>How we collect, use, and protect your information.</p>',1 FROM cms_pages p WHERE p.slug='privacy-policy';
INSERT IGNORE INTO `cms_blocks` (page_id, block_key, block_type, title, content_html, sort_order)
SELECT p.id,'privacy_content','text','Privacy Content','<h2>Data We Collect</h2><p>We collect your name, email, and order details to process purchases.</p><h2>How We Use It</h2><p>Your data is used solely for order fulfilment and opted-in communications.</p>',2 FROM cms_pages p WHERE p.slug='privacy-policy';

-- Update existing home blocks to have correct block_type
UPDATE cms_blocks SET block_type='hero' WHERE block_key='hero_section';
UPDATE cms_blocks SET block_type='cta' WHERE block_key='call_to_action';
UPDATE cms_blocks SET block_type='faq' WHERE block_key LIKE '%faq%';
Phase 3 — API Changes (api/admin/cms.php)
3a. Update block INSERT/UPDATE to include block_type (line 303 and 308-309)
In the UPDATE cms_blocks query: add block_type = ? and pass clean($body['block_type'] ?? 'text')
In the INSERT INTO cms_blocks query: add block_type column and value
3b. Generalize cmsEnsureHomeBlocks → cmsEnsurePageBlocks
Rename/extract the function so it works for any page (not just home). Then call it for all pages when loading:

function cmsEnsurePageBlocks(PDO $pdo, int $pageId, string $pageSlug): void {
    // existing logic but use cmsTemplatePathFromPageKey($pageSlug) instead of hardcoded path
    // title cleanup: remove '$pageSlug_' prefix instead of only 'home_'
}
Call it from the GET handler: cmsEnsurePageBlocks($pdo, (int)$page['id'], $pageSlug);

3c. Add to GET handler: new query params
// GET ?nav=1 → nav_items
if (isset($_GET['nav'])) {
    $rows = $pdo->query('SELECT id, label, href, sort_order, is_visible FROM nav_items WHERE tenant_id = 1 ORDER BY sort_order ASC')->fetchAll();
    respond(['nav' => $rows]);
}

// GET ?settings=1 → site_settings
if (isset($_GET['settings'])) {
    $rows = $pdo->query('SELECT setting_key, value FROM site_settings WHERE tenant_id = 1')->fetchAll();
    $out = []; foreach ($rows as $r) $out[$r['setting_key']] = $r['value'];
    respond(['settings' => $out]);
}
3d. Add to POST handler: new actions
// action=update_seo
if ($action === 'update_seo') {
    requireFields($body, ['page_id']);
    $sets = ['meta_title = ?', 'meta_description = ?']; 
    $params = [clean($body['meta_title'] ?? ''), clean($body['meta_description'] ?? '')];
    if (!empty($body['title'])) { $sets[] = 'title = ?'; $params[] = clean($body['title']); }
    if (isset($body['is_active'])) { $sets[] = 'is_active = ?'; $params[] = (int)$body['is_active'] ? 1 : 0; }
    $params[] = (int)$body['page_id'];
    $pdo->prepare('UPDATE cms_pages SET ' . implode(', ', $sets) . ' WHERE id = ?')->execute($params);
    respond(['success' => true]);
}

// action=update_nav
if ($action === 'update_nav') {
    $items = $body['items'] ?? []; if (!is_array($items)) err('items must be array', 422);
    $upsert = $pdo->prepare('INSERT INTO nav_items (id, tenant_id, label, href, sort_order, is_visible)
        VALUES (?, 1, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label=VALUES(label), href=VALUES(href),
        sort_order=VALUES(sort_order), is_visible=VALUES(is_visible)');
    foreach ($items as $item) {
        $upsert->execute([(int)($item['id'] ?? 0) ?: null, clean($item['label'] ?? ''), 
                          clean($item['href'] ?? ''), (int)($item['sort_order'] ?? 0), (int)($item['is_visible'] ?? 1)]);
    }
    respond(['success' => true]);
}

// action=update_settings
if ($action === 'update_settings') {
    $settings = $body['settings'] ?? []; if (!is_array($settings)) err('settings must be object', 422);
    $upsert = $pdo->prepare('INSERT INTO site_settings (tenant_id, setting_key, value, updated_by) VALUES (1,?,?,?)
        ON DUPLICATE KEY UPDATE value=VALUES(value), updated_by=VALUES(updated_by)');
    foreach ($settings as $key => $val) $upsert->execute([clean($key), clean((string)$val), currentUserId()]);
    respond(['success' => true]);
}

// action=reorder_blocks
if ($action === 'reorder_blocks') {
    requireFields($body, ['page_id', 'order']);
    $order = array_values(array_map('intval', (array)$body['order']));
    $upd = $pdo->prepare('UPDATE cms_blocks SET sort_order = ? WHERE id = ? AND page_id = ?');
    foreach ($order as $pos => $blockId) $upd->execute([$pos + 1, $blockId, (int)$body['page_id']]);
    respond(['success' => true]);
}
3e. Extend cmsTemplatePathFromPageKey map (lines 138-154)
Add the 5 new pages to the $map array:

'faq'            => 'Frontend-public/faq.html',
'portfolio'      => 'Frontend-public/portfolio.html',
'shipping-info'  => 'Frontend-public/shipping-info.html',
'shipping_info'  => 'Frontend-public/shipping-info.html',
'terms'          => 'Frontend-public/terms.html',
'privacy-policy' => 'Frontend-public/privacy-policy.html',
'privacy_policy' => 'Frontend-public/privacy-policy.html',
3f. Update GET response (line 288)
Include meta_title, meta_description, is_active from $page — already returned via SELECT * on cms_pages. Just confirm. Also add new slugs to the rich-text content list (line 282):

if (in_array($pageSlug, ['about','services','contact','faq','portfolio','terms','privacy-policy','shipping-info'])) { ... }
Phase 4 — Route Additions
4a. .htaccess — add after line 20 (public routes line), before admin block:
# New public informational pages
RewriteRule ^faq/?$              Frontend-public/faq.html             [L,QSA,NC]
RewriteRule ^portfolio/?$        Frontend-public/portfolio.html        [L,QSA,NC]
RewriteRule ^privacy-policy/?$   Frontend-public/privacy-policy.html  [L,QSA,NC]
RewriteRule ^terms/?$            Frontend-public/terms.html           [L,QSA,NC]
RewriteRule ^shipping-info/?$    Frontend-public/shipping-info.html   [L,QSA,NC]
4b. index.php — add to $publicRoutes array (lines 14-29):
'faq'            => 'Frontend-public/faq.html',
'portfolio'      => 'Frontend-public/portfolio.html',
'privacy-policy' => 'Frontend-public/privacy-policy.html',
'terms'          => 'Frontend-public/terms.html',
'shipping-info'  => 'Frontend-public/shipping-info.html',
Phase 5 — public-shell.js Fixes
File: Frontend-public/js/public-shell.js

5a. Add new routes to PUBLIC_ROUTE_MAP (after line 49):
'faq': '/faq', 'faq.html': '/faq',
'portfolio': '/portfolio', 'portfolio.html': '/portfolio',
'privacy-policy': '/privacy-policy', 'privacy-policy.html': '/privacy-policy',
'terms': '/terms', 'terms.html': '/terms',
'shipping-info': '/shipping-info', 'shipping-info.html': '/shipping-info',
5b. Also update the marker regex (line 9) to include new slugs:
const marker = /\/(home|shop|services|about|contact|blog|appointment|product-detail|checkout|order-confirm|user-login|user-dash|user-my-order|user-my-settings|faq|portfolio|privacy-policy|terms|shipping-info)(?:\/|$)/i;
5c. Fix header/footer injection condition (lines 177-181):
Change from gating on nav pages[] to always injecting for any page that loads the shell:

// Replace: if (header && pages.some((page) => page.file === pageKey)) header.outerHTML = headerMarkup;
// With:
const header = document.querySelector('header');
if (header) header.outerHTML = headerMarkup;

const footer = document.querySelector('footer');
if (footer) footer.outerHTML = footerMarkup;
5d. Fix broken footer hash links (lines 155-157):
// Replace #faq, #privacy-policy, #shipping-info with real routes:
<li><a ... href="${withBase('/faq')}">FAQ</a></li>
<li><a ... href="${withBase('/privacy-policy')}">Privacy Policy</a></li>
<li><a ... href="${withBase('/shipping-info')}">Shipping Info</a></li>
Phase 6 — New Public HTML Pages (5 files)
All pages follow the exact same pattern as about.html:

Same <head> with Tailwind CDN, Google Fonts (Public Sans), Material Symbols
Same Tailwind config (primary #ec5b13, background-light #f8f6f6, font Public Sans)
⚠️ Note: Content Studio uses #1337ec (blue) — public pages use #ec5b13 (orange)
Placeholder <header> and <footer> that public-shell.js replaces
data-cms-block="..." on editable container divs (static fallback content inside each)
Script block at bottom: public-shell.js, api.js, public-ui.js, then inline CMS loader
CMS loader script pattern (same for all 5 pages, change slug and block handling):

<script>
document.addEventListener('DOMContentLoaded', async () => {
  try {
    const res = await fetch(window._apiBase ? window._apiBase + '/cms.php?page=faq' : '/api/cms.php?page=faq');
    const cms = await res.json();
    (cms.blocks ? Object.values(cms.blocks) : []).forEach(b => {
      const el = document.querySelector(`[data-cms-block="${b.block_key}"]`);
      if (!el) return;
      if (b.block_type === 'faq') {
        try {
          const items = JSON.parse(b.content_html || '[]');
          el.innerHTML = items.map(item => `<details class="border border-slate-200 rounded-xl p-5 mb-3 group">
            <summary class="font-bold cursor-pointer list-none">${item.q}</summary>
            <p class="mt-3 text-slate-600 text-sm">${item.a}</p></details>`).join('');
        } catch(e) { el.innerHTML = b.content_html || ''; }
      } else { el.innerHTML = b.content_html || ''; }
    });
  } catch(e) { /* static fallback content stays */ }
});
</script>
Pages to create:
File	Slug	data-cms-block keys	Special rendering
faq.html	faq	faq_hero, faq_items	faq_items: JSON→accordion <details>
portfolio.html	portfolio	portfolio_hero, portfolio_intro, portfolio_gallery	portfolio_gallery: JSON→card grid
privacy-policy.html	privacy-policy	privacy_hero, privacy_content	plain HTML rich text
terms.html	terms	terms_hero, terms_content	plain HTML rich text
shipping-info.html	shipping-info	shipping_hero, shipping_policy, shipping_cta	plain HTML rich text
Each page has substantial static fallback content inside the data-cms-block divs (never empty) so the page looks complete even before CMS data loads.

Phase 7 — Content Studio Full Redesign
File: Frontend-admin/content studio.html (keep filename; routing already handles the space)

Completely replace the inner HTML and the <script> block. Keep all the same <head> dependencies (Tailwind CDN, fonts, admin-auth.js, admin-api.js, sidebar-controller.js).

Layout (3-panel + top bar, full-viewport height):
┌── TOP BAR (h-16, sticky) ─────────────────────────────────────────────────┐
│ ← Admin  |  ✏ Content Studio  >  [page breadcrumb]    [Nav] [Settings] [Save All] │
├── LEFT PANEL (w-64) ──┬── CENTER CANVAS (flex-1) ──┬── RIGHT PANEL (w-80) ─┤
│ Page Navigator         │ Block Cards                 │ Page Settings         │
│ • Search box           │ Each card:                  │ • Page title          │
│ • Page cards w/ icons  │  - Drag handle              │ • Meta title (60ch)   │
│   (icon, title, slug,  │  - Block type badge         │ • Meta description    │
│    status badge)       │  - Block title (editable)   │ • Status toggle       │
│                        │  - Editor widget per type   │ • Preview link        │
│                        │  - Delete button            │                       │
│                        │ [+ Add Block] at bottom     │                       │
├───────────────────────┴────────────────────────────┴───────────────────────┤
│ TABS: [Page Editor (default)] [Media Library]                               │
└──────────────────────────────────────────────────────────────────────────────┘
Outer flex container: <div class="flex flex-col h-screen overflow-hidden">
Inner 3-panel area: <div class="flex flex-1 overflow-hidden">

Block type editors:
block_type	Editor widget
text, hero, cta	Rich text toolbar (execCommand: bold/italic/lists/link) + contenteditable div
faq	JSON-driven Q&A pair list: <input> for Q, <textarea> for A, add/remove rows. Serializes to JSON on save
team	JSON-driven card list: name, title, bio, photo URL inputs
testimonial	JSON-driven: quote, author, company inputs
image	File upload + preview <img> + alt text input
gallery	Multiple image entries with upload/URL input per item
JS Architecture (ContentStudio object):
const CS = {
  state: { pages: [], currentPage: null, blocks: [], dirty: new Set(), undoStack: [], redoStack: [] },
  
  async init()              // boot: load pages, wire all events
  async loadPages()         // GET /api/admin/cms.php?pages=1 → render left panel cards
  async selectPage(id, slug) // load blocks + settings, populate center + right panels
  async loadBlocks(pageId, slug) // GET ?page=slug → blocks + assets + page meta
  renderBlocks(blocks)      // build block cards in #cs-blocks-list
  renderBlockCard(block)    // returns DOM element with correct editor for block.block_type
  collectBlockData(card)    // read current values from card (handles JSON types)
  markDirty(blockId)        // add to Set, enable Save button
  async saveAll()           // iterate ALL blocks (dirty-aware), call saveBlock + saveSeo
  async saveBlock(data)     // POST /api/admin/cms.php (action=block, includes block_type)
  async saveSeo()           // POST /api/admin/cms.php (action=update_seo)
  async deleteBlock(id)     // DELETE ?block_id=X, remove card from DOM
  async addBlock(type)      // POST new block with chosen type, re-render
  openAddBlockModal()       // show type-picker modal (8 block types as icon tiles)
  initDragDrop()            // HTML5 drag on .cs-drag-handle → reorder + POST action=reorder_blocks
  pushUndo()                // snapshot current block HTML to undoStack (max 20)
  undo() / redo()
  async openNavModal()      // GET ?nav=1, show sortable nav editor modal, save via update_nav
  async openSettingsModal() // GET ?settings=1, show site settings form modal
  async uploadImage(file, pageKey, assetKey) // POST action=upload, update img preview
}
Key JS patterns:
Page cards icons: JS map {home:'home', shop:'storefront', services:'build', about:'info', contact:'mail', faq:'help', portfolio:'photo_library', 'privacy-policy':'lock', terms:'gavel', 'shipping-info':'local_shipping'}
Save All button: iterates ALL cards (not just dirty), collects data via collectBlockData(), bulk saves, shows toast on completion
FAQ serialization: collectBlockData() detects block_type === 'faq', reads all .cs-faq-item rows, returns JSON.stringify([{q,a}...])
Gallery serialization: similar, returns JSON.stringify([{src, alt, caption}...])
Undo: client-side only — snapshot = map of blockId → innerHTML before each save
adminFetch: reuse window.adminFetch from Frontend-admin/js/admin-api.js (already loaded)
Modals needed:
Add Block modal — 8 block type tiles in grid, click to select type
Nav Management modal — sortable list with label/href inputs + visibility toggle per item, Save triggers update_nav
Site Settings modal — key/value form for site_name, tagline, contact info, social URLs, Save triggers update_settings
Create Page modal — reuse existing logic already in current Content Studio
Media Library tab:
Full-width grid of all uploaded assets from page_assets table
Uses existing assets section from current Content Studio (migrated into tab)
Adds drag-and-drop upload zone (drop→action=upload)
Shows asset_key, page_key, file path, replace/delete buttons per asset
Execution Order
Run migration SQL in phpMyAdmin (schema changes + seed data)
Fix email.php:70 (critical, 3-line change)
Fix _helpers.php:10-16 (CORS, ~10-line change)
Update api/admin/cms.php (block_type in INSERT/UPDATE, new actions, generalize seeding, extend template map)
Add routes to .htaccess and index.php
Update public-shell.js (route map, regex, injection condition, footer links)
Create 5 new public HTML pages (privacy-policy, terms first — simplest; then shipping-info, faq, portfolio)
Rebuild Content Studio (replace HTML + JS in content studio.html)
Test end-to-end (see below)
Verification
New pages: Browse /faq, /portfolio, /privacy-policy, /terms, /shipping-info — each should load with header/footer from shell and static fallback content
Footer links: From any public page, click "FAQ", "Privacy Policy", "Shipping Info" in footer — should navigate to correct pages (not hash anchors)
CMS seeding: In phpMyAdmin, verify cms_pages has 11+ rows and cms_blocks has blocks for all new slugs
Content Studio — page list: Open /admin/content-studio, verify all pages appear in left panel including faq, portfolio, etc.
Content Studio — block editing: Select "FAQ" page, edit a question in the FAQ editor, click Save All, refresh /faq page — edited content should appear
Content Studio — SEO: Edit meta title for Home, save, verify cms_pages.meta_title updated in DB
Content Studio — Nav modal: Open Nav modal, toggle Portfolio visibility, save, verify nav_items.is_visible updated
Content Studio — drag reorder: Drag blocks within a page, save, reload Content Studio — blocks appear in new order
Email fix: Verify /admin/smtp is configured, send a test invoice email — PDF should attach (or gracefully skip) without localhost errors
CORS fix: Verify API requests from same domain still work (no regressions in shop, user auth, etc.)
