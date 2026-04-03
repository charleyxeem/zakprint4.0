# ZAK Printing v4 — Content Studio Implementation Guide

## Overview
The Content Studio is a comprehensive CMS interface built into the admin dashboard that allows super admins to manage website content, including pages, reusable content blocks, media assets, and rich text editing.

## Architecture

### Database Schema

#### 1. **cms_pages** table
Stores page definitions and metadata.

| Column | Type | Purpose |
|--------|------|---------|
| `id` | int | Primary key |
| `tenant_id` | int | Multi-tenant support (default: 1) |
| `title` | varchar(255) | Page display title |
| `slug` | varchar(200) | URL-friendly identifier (unique per tenant) |
| `description` | text | Page description |
| `is_active` | tinyint(1) | Publication status |
| `meta_title` | varchar(255) | SEO meta title |
| `meta_description` | varchar(255) | SEO meta description |
| `meta_keywords` | varchar(255) | SEO keywords |
| `sort_order` | int | Menu ordering |
| `created_at` | timestamp | Creation timestamp |
| `updated_at` | timestamp | Last update timestamp |

**Indexes:**
- Primary: `id`
- Unique: `(slug, tenant_id)` - Ensures unique slugs per tenant
- Index: `is_active` - For quick filtering of published pages
- Index: `tenant_id` - For multi-tenant queries

**Sample Data:**
- `home` - Homepage
- `about` - About Us page
- `services` - Services page
- `contact` - Contact page
- `privacy-policy` - Privacy policy
- `terms` - Terms & conditions

#### 2. **cms_blocks** table
Stores reusable content blocks within pages. Blocks are flexible containers that can hold HTML, rich text, images, etc.

| Column | Type | Purpose |
|--------|------|---------|
| `id` | int | Primary key |
| `page_id` | int | FK to cms_pages |
| `block_key` | varchar(100) | Semantic identifier (e.g., "hero_section", "features") |
| `title` | varchar(255) | Block display name |
| `content_html` | longtext | HTML content (allows rich editing) |
| `image_path` | varchar(255) | Optional associated image |
| `sort_order` | int | Display order within page |
| `created_at` | timestamp | Creation timestamp |
| `updated_at` | timestamp | Last update timestamp |

**Indexes:**
- Primary: `id`
- Unique: `(page_id, block_key)` - One block per semantic key per page
- FK: `page_id` CASCADE DELETE

**Common Block Keys:**
- `hero_section` - Hero banner with headline and CTA
- `features` - Feature grid/list
- `call_to_action` - Call-to-action section
- `pricing` - Pricing table
- `testimonials` - Customer testimonials
- `footer_content` - Footer-specific content

#### 3. **page_assets** table
Stores media assets (images, PDFs, etc.) associated with pages or site-wide.

| Column | Type | Purpose |
|--------|------|---------|
| `id` | int | Primary key |
| `tenant_id` | int | Multi-tenant support |
| `page_key` | varchar(100) | Page slug or "global" for site-wide assets |
| `asset_key` | varchar(100) | Asset identifier (e.g., "hero_image", "logo") |
| `label` | varchar(255) | Human-readable asset name |
| `type` | varchar(50) | Asset type: "image", "document", "video" |
| `file_path` | varchar(255) | Relative path to file (e.g., `uploads/cms/logo.svg`) |
| `alt_text` | varchar(255) | Alt text for images (accessibility) |
| `updated_by` | int | User ID of last updater |
| `created_at` | timestamp | Creation timestamp |
| `updated_at` | timestamp | Last update timestamp |

**Indexes:**
- Unique: `(page_key, asset_key, tenant_id)` - One asset reference per page/key combination
- Index: `page_key` - For page-specific asset lookups
- Index: `tenant_id` - For multi-tenant queries

**Common Asset Keys:**
- `logo` - Site logo (page_key: "global")
- `favicon` - Favicon (page_key: "global")
- `hero_image` - Hero section image
- `hero_banner` - Large hero banner
- `contact_background` - Page background image

#### 4. **pages** table
Stores rich text content for specific pages (about, services, contact). Used for full-page editing vs. block-based pages.

| Column | Type | Purpose |
|--------|------|---------|
| `id` | int | Primary key |
| `tenant_id` | int | Multi-tenant support |
| `key` | varchar(100) | Page key ("about", "services", "contact") |
| `title` | varchar(255) | Page title |
| `content` | longtext | Full HTML content |
| `updated_by` | int | User ID of last updater |
| `created_at` | timestamp | Creation timestamp |
| `updated_at` | timestamp | Last update timestamp |

**Indexes:**
- Unique: `(key, tenant_id)` - One content record per page per tenant
- Index: `tenant_id` - For multi-tenant queries

**Default Keys:**
- `about` - About Us page full content
- `services` - Services page full content
- `contact` - Contact page full content

---

## API Endpoints

### Backend: `api/admin/cms.php`

**Authentication:** Super admin or developer role required (`requireAdmin(['super_admin', 'developer'])`)

#### 1. GET - Load Pages List
```
GET /api/admin/cms.php?pages=1
```
**Response:**
```json
{
  "pages": [
    {
      "id": 1,
      "slug": "home",
      "title": "Home",
      "is_active": 1
    }
  ]
}
```

#### 2. GET - Load Page Details & Blocks
```
GET /api/admin/cms.php?page=home
```
**Response:**
```json
{
  "page": {
    "id": 1,
    "slug": "home",
    "title": "Home",
    "is_active": 1
  },
  "blocks": [
    {
      "id": 1,
      "page_id": 1,
      "block_key": "hero_section",
      "title": "Hero Section",
      "content_html": "<h1>Welcome</h1>",
      "image_path": null,
      "sort_order": 1
    }
  ],
  "assets": {
    "logo": {
      "id": 1,
      "asset_key": "logo",
      "file_path": "uploads/cms/logo.svg",
      "alt_text": "Site Logo"
    }
  },
  "content": null
}
```

#### 3. POST - Update/Create Block
```
POST /api/admin/cms.php
Content-Type: application/json

{
  "action": "block",
  "page_id": 1,
  "block_key": "hero_section",
  "title": "Hero Section",
  "content_html": "<h1>New Title</h1>",
  "image_path": "uploads/cms/hero.jpg",
  "sort_order": 1
}
```
**Response:**
```json
{
  "success": true,
  "id": 1
}
```

#### 4. POST - Update Full Page Content
```
POST /api/admin/cms.php
Content-Type: application/json

{
  "action": "page_content",
  "key": "about",
  "title": "About Us",
  "content": "<h1>About ZAK Printing</h1><p>Content here...</p>"
}
```
**Response:**
```json
{
  "success": true
}
```

#### 5. POST - Update Page Asset
```
POST /api/admin/cms.php
Content-Type: application/json

{
  "action": "asset",
  "page_key": "home",
  "asset_key": "hero_image",
  "label": "Hero Banner",
  "type": "image",
  "file_path": "uploads/cms/hero.jpg",
  "alt_text": "Hero banner image"
}
```
**Response:**
```json
{
  "success": true
}
```

#### 6. POST - Upload Media File
```
POST /api/admin/cms.php
Content-Type: multipart/form-data

[multipart form data with file]
- action: "upload"
- file: [binary file data]
- page_key: "home" (optional)
- asset_key: "hero_image" (optional)
- label: "Hero Banner" (optional)
- alt_text: "Hero banner" (optional)
```
**Response:**
```json
{
  "success": true,
  "file_path": "uploads/cms/cms_abc123.jpg",
  "url": "/uploads/cms/cms_abc123.jpg"
}
```

**Upload Restrictions:**
- Allowed types: JPG, PNG, GIF, WebP, SVG
- Max size: 5MB
- Files stored in: `uploads/cms/`
- Filenames are auto-generated with `cms_` prefix

#### 7. DELETE - Remove Block
```
DELETE /api/admin/cms.php?block_id=1
```
**Response:**
```json
{
  "success": true
}
```

---

## Frontend Implementation

### Key Files

#### 1. **Frontend-admin/content studio.html** (Main CMS Interface)

**Features:**
- Tabbed navigation (CMS Pages | Media Library)
- Pages list with status, last edited, URL slug
- Block editor with contenteditable div
- Media gallery with upload dropzone
- Real-time drag-and-drop (if enhanced)

**Key DOM Attributes:**
- `[data-cms="pages-list"]` - Pages list container
- `[data-cms="blocks-container"]` - Blocks display area
- `[data-block-content="${blockId}"]` - Editable block content
- `data-block-id` - Block identifier
- `data-block-key` - Block semantic key

**JavaScript Workflow:**
```javascript
// On page load
loadPages() → fetch /cms.php?pages=1 → render pages

// On page selection
onclick="loadPageBlocks(pageId, slug)" → fetch /cms.php?page=slug → render blocks

// On block save
saveBlock(blockId) → POST /cms.php with block data → show toast

// On file upload
[future] upload to /cms.php with action=upload → get file_path → upsert asset record
```

#### 2. **Frontend-admin/js/admin-api.js** (API Wrapper)
Provides `adminFetch()` function that:
- Routes to `/api/admin/*` endpoints
- Includes credentials for session auth
- Handles 401 redirects to admin login
- Shows toast notifications for errors

**Usage:**
```javascript
const data = await adminFetch('/cms.php?pages=1');
const result = await adminFetch('/cms.php', {
  method: 'POST',
  data: { action: 'block', page_id: 1, ... }
});
```

#### 3. **Frontend-admin/js/sidebar-controller.js**
Manages sidebar navigation and active states. Content Studio is marked with `data-super-only` attribute to restrict access.

---

## Frontend Integration Points

### Home Page (Frontend-public/home.html)
To display CMS content on the home page:

```javascript
// Fetch home page blocks
const response = await fetch('/api/cms.php?page=home');
const data = response.json();

// Render blocks
data.blocks.forEach(block => {
  document.querySelector('[data-block="' + block.block_key + '"]').innerHTML = block.content_html;
});

// Load featured assets
const heroImage = data.assets.hero_image?.file_path;
document.querySelector('[data-asset="hero"]').src = heroImage;
```

### Blog/Services Pages
Use the `pages` table for full-page rich text:

```javascript
// Fetch page content
const response = await fetch('/api/cms.php?page=services');
const data = response.json();

// Display rich text
document.querySelector('.page-content').innerHTML = data.content.content;
```

### Public API (api/cms.php)
Create a public-facing CMS API route that returns published content only:

```php
// api/cms.php

// GET public page content with blocks
if ($method === 'GET' && isset($_GET['page'])) {
    $pageSlug = clean($_GET['page']);
    
    // Fetch ONLY active pages
    $page = $pdo->prepare('SELECT * FROM cms_pages 
                           WHERE slug = ? AND is_active = 1 LIMIT 1');
    $page->execute([$pageSlug]);
    
    $blocks = $pdo->prepare('SELECT block_key, title, content_html, image_path 
                             FROM cms_blocks 
                             WHERE page_id = ? ORDER BY sort_order');
    $blocks->execute([$pageId]);
    
    respond(['page' => ..., 'blocks' => ..., 'assets' => ...]);
}
```

---

## Setup Instructions

### 1. Database Migration

Execute the CMS migration SQL file to create tables and sample data:

```bash
# Via MySQL CLI
mysql -u your_user -p your_database < cms_migration.sql

# Via phpMyAdmin
1. Import cms_migration.sql
2. Verify tables created: cms_pages, cms_blocks, page_assets, pages
3. Check sample data inserted
```

### 2. Create Uploads Directory
```bash
mkdir -p uploads/cms
chmod 755 uploads/cms
```

### 3. Verify Admin Guard (Already implemented)
File: `api/admin/_guard.php`
```php
requireAdmin(['super_admin', 'developer']);
```

### 4. Test Content Studio
1. Log in as super admin
2. Navigate to **Content Studio** in sidebar
3. Click a page to load its blocks
4. Edit block content in the contenteditable div
5. Click **Save Block** to persist changes
6. Test file upload with the dropzone

---

## Block Management Best Practices

### Block Naming Conventions
Use semantic, descriptive keys that indicate purpose and position:

| Block Key | Purpose | Location |
|-----------|---------|----------|
| `hero_section` | Main hero/header content | Top of page |
| `features` | Feature highlights | Below hero |
| `services_grid` | Service offerings | Mid-page |
| `pricing` | Pricing table | Mid-to-lower page |
| `testimonials` | Customer quotes | Lower page |
| `cta` or `call_to_action` | Final call-to-action | Very bottom |
| `team` | Team members display | About page |
| `faq` | FAQ section | Services/Help page |
| `stats_counter` | Statistics/metrics | Home/About page |

### HTML Guidelines for Blocks
- Use semantic HTML5 tags (`<header>`, `<section>`, `<article>`, `<footer>`)
- Include proper heading hierarchy (`<h1>` for titles, `<h2>` for sections)
- Add descriptive `class` names for styling
- Keep content focused; long content should be broken into multiple blocks
- Include `alt` text for any inline images

**Example Block Content:**
```html
<section class="features">
  <h2>Why Choose ZAK Printing?</h2>
  <div class="feature-grid">
    <article class="feature-item">
      <h3>Fast Service</h3>
      <p>Quick turnaround times without compromising quality.</p>
    </article>
    <article class="feature-item">
      <h3>Expert Design</h3>
      <p>Professional design team ready to help with your vision.</p>
    </article>
  </div>
</section>
```

---

## Asset Management

### Supported File Types
- **Images:** JPG, PNG, GIF, WebP, SVG
- **Documents:** Handled via database (type: "document")
- **Videos:** Future expansion (type: "video")

### Asset Path Convention
- All CMS assets stored in: `uploads/cms/`
- Filenames auto-generated: `cms_[uniqid].ext`
- Use relative paths in database: `uploads/cms/cms_abc123.jpg`
- Reference in frontend as: `/uploads/cms/cms_abc123.jpg`

### Global vs. Page-Specific Assets
- **Global Assets:** `page_key = 'global'` (logo, favicon, etc.)
- **Page Assets:** `page_key = 'home'|'about'|'services'` (page-specific images)

**Query Examples:**
```javascript
// Get all global assets
const globalAssets = await fetch('/api/admin/cms.php?page=global');

// Get home page assets
const homeAssets = await fetch('/api/admin/cms.php?page=home');

// Specific asset lookup
const heroImage = assets.hero_image?.file_path;
```

---

## Future Enhancements

1. **Drag-and-Drop Reordering:** Use Sortable.js to reorder blocks
2. **Block Templates:** Pre-built block templates (hero+features, testimonials, etc.)
3. **Revision History:** Track block changes with rollback capability
4. **WYSIWYG Editor:** Replace contenteditable with TinyMCE or Quill
5. **Scheduled Publishing:** Set publish/unpublish dates
6. **Content Versioning:** Draft/preview/publish workflow
7. **SEO Optimization:** Generate sitemaps, meta tags
8. **Analytics Integration:** Track page views and engagement
9. **Multi-language Support:** i18n for page slugs and content
10. **Template System:** Assign different layouts to different pages

---

## Troubleshooting

### Issue: "Page not found" when loading pages
**Solution:**
- Verify `cms_pages` table has sample data
- Check that frontend is using correct page slug
- Ensure `is_active = 1` for pages you want to display

### Issue: Blocks not saving
**Solution:**
- Check browser console for API errors
- Verify `cms_blocks` table exists and has proper structure
- Ensure authenticated user has `super_admin` or `developer` role
- Check `api/admin/_guard.php` is requiring correct permissions

### Issue: File upload fails
**Solution:**
- Verify `uploads/cms/` directory exists and is writable (`chmod 755`)
- Check file size doesn't exceed 5MB
- Verify file type is in allowed list (JPG, PNG, GIF, WebP, SVG)
- Check PHP file upload settings (upload_max_filesize)

### Issue: Session expires in Content Studio
**Solution:**
- Content Studio requires active admin session
- Credentials passed with `credentials: 'include'` in adminFetch
- If `api/admin/_guard.php` returns 401, redirects to admin-login.html

---

## Database Schema Relationships

```
cms_pages (1) ──── (N) cms_blocks
   |
   └── related_to: pages table (for about, services, contact full-page content)
   
page_assets (N) ──── (1) cms_pages (optional, via page_key match)
   └── also_supports: global assets (page_key = 'global')
```

---

## Quick Reference

### Common Queries (for debugging)

```sql
-- List all pages
SELECT id, slug, title, is_active FROM cms_pages;

-- List blocks for specific page
SELECT block_key, title, sort_order 
FROM cms_blocks 
WHERE page_id = 1 
ORDER BY sort_order;

-- List all assets
SELECT page_key, asset_key, file_path, type 
FROM page_assets 
ORDER BY page_key;

-- Check page content (about, services, contact)
SELECT `key`, title, LEFT(content, 100) as preview 
FROM pages;

-- Find orphaned blocks (page_id no longer exists)
SELECT b.* FROM cms_blocks b 
LEFT JOIN cms_pages p ON b.page_id = p.id 
WHERE p.id IS NULL;
```

---

## Summary

The Content Studio provides:
- **Page Management:** Create/edit website pages with SEO metadata
- **Block-Based Editing:** Reusable content blocks with rich HTML editing
- **Asset Management:** Media library for images, documents, etc.
- **Full-Page Rich Text:** Rich text editing for about, services, contact pages
- **Admin Protection:** Super admin/developer access only
- **Scalable Design:** Multi-tenant architecture ready
- **Frontend Ready:** Public API can be built to render managed content

This implementation provides a solid foundation for a professional CMS while maintaining clean separation between admin editing and public content delivery.
