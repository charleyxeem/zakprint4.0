# Content Studio — Implementation Checklist

## Phase 1: Database Setup ✓

- [ ] Execute `cms_migration.sql` to create database tables:
  - [ ] `cms_pages` table created
  - [ ] `cms_blocks` table created  
  - [ ] `page_assets` table created
  - [ ] `pages` table created
  - [ ] Sample data inserted (home, about, services, contact pages)
  - [ ] Default blocks created for home page

**Command:**
```bash
mysql -u root -p zakprinting < cms_migration.sql
```

---

## Phase 2: File System Setup

- [ ] Create uploads directory for CMS media:
  ```bash
  mkdir -p uploads/cms
  chmod 755 uploads/cms
  ```

- [ ] Verify directory permissions (should be writable by web server)

---

## Phase 3: Backend API Verification

- [ ] Verify `api/admin/cms.php` exists and has:
  - [ ] GET endpoint for pages list
  - [ ] GET endpoint for page blocks
  - [ ] POST endpoint for block updates
  - [ ] POST endpoint for file uploads
  - [ ] DELETE endpoint for block deletion
  - [ ] Admin guard (`requireAdmin()`) protecting endpoints

- [ ] Verify `api/cms.php` exists for public API

- [ ] Check `api/admin/_guard.php` exists and requires auth

---

## Phase 4: Frontend Admin Interface

- [ ] Verify `Frontend-admin/content studio.html` exists with:
  - [ ] Sidebar navigation (Content Studio menu item)
  - [ ] Tabbed interface (CMS Pages | Media Library)
  - [ ] Pages list table
  - [ ] Block editor container
  - [ ] Media gallery grid
  - [ ] Upload dropzone

- [ ] Verify admin API wrapper exists:
  - [ ] `Frontend-admin/js/admin-api.js` loaded in HTML
  - [ ] `adminFetch()` function available
  - [ ] `showAdminToast()` for notifications

- [ ] Test admin login redirect on 401

---

## Phase 5: Basic Functionality Testing

### 5.1 Admin Dashboard Access
- [ ] Log in as super admin
- [ ] Navigate to admin dashboard
- [ ] Verify "Content Studio" appears in sidebar
- [ ] Click Content Studio to load page

### 5.2 Pages List Loading
- [ ] Click on Content Studio
- [ ] Verify pages list loads from database
- [ ] Check for: Home, About, Services, Contact pages
- [ ] Verify each page shows title and slug

### 5.3 Block Editing
- [ ] Click on "Home" page
- [ ] Verify blocks load below pages list
- [ ] Check for default blocks:
  - [ ] hero_section
  - [ ] features
  - [ ] call_to_action
- [ ] Edit block content (contenteditable div)
- [ ] Click "Save Block"
- [ ] Verify success toast appears
- [ ] Refresh page and verify changes persisted

### 5.4 File Upload
- [ ] Click upload dropzone in Media Library
- [ ] Upload a JPG, PNG, or WebP image
- [ ] Verify:
  - [ ] File uploaded to `uploads/cms/`
  - [ ] Filename is prefixed with `cms_`
  - [ ] Success message shows file path
  - [ ] Image appears in media gallery

### 5.5 Permission Testing
- [ ] Log in as regular user (not super_admin)
- [ ] Verify Content Studio is hidden or inaccessible
- [ ] Verify 403 error if trying to access `/api/admin/cms.php`

---

## Phase 6: Public API Testing

### 6.1 Fetch Home Page
```bash
curl http://localhost/api/cms.php?page=home
```
Expected response should include:
- [ ] `page` object with title, slug, metadata
- [ ] `blocks` array with all page blocks
- [ ] `assets` object with image references
- [ ] JSON error if page not found

### 6.2 Fetch Pages List
```bash
curl http://localhost/api/cms.php?pages=1
```
Expected response:
- [ ] Array of published pages (title, slug, sort_order)

### 6.3 Fetch About Page
```bash
curl http://localhost/api/cms.php?page=about
```
Expected response:
- [ ] `page` object for about
- [ ] `content` object with rich text content OR
- [ ] `blocks` array if block-based

---

## Phase 7: Frontend Integration

### 7.1 Test Rendering on Home Page
- [ ] Update `Frontend-public/home.html` to load CMS content
- [ ] Add script to fetch `/api/cms.php?page=home`
- [ ] Render blocks into page sections
- [ ] Test hero image lazy-loading

### 7.2 Test About/Services/Contact Pages
- [ ] Load full-page content from `pages` table
- [ ] Render as rich HTML

### 7.3 Dynamic Navigation Menu
- [ ] Add script to load pages list
- [ ] Build navigation from page slugs
- [ ] Test menu links

### 7.4 Mobile Responsiveness
- [ ] Test Content Studio on tablet/mobile
- [ ] Verify blocks editable on small screens
- [ ] Test media gallery on mobile

---

## Phase 8: Admin Features

- [ ] Block sorting/reordering (implement Sortable.js if needed)
- [ ] Status filtering (draft/published)
- [ ] Sort ordering (newest first, etc.)
- [ ] Block deletion
- [ ] Asset deletion
- [ ] Search functionality (if implemented)

---

## Phase 9: Content Population

- [ ] Populate home page blocks:
  - [ ] Edit hero_section with compelling headline
  - [ ] Edit features with service highlights
  - [ ] Edit call_to_action with main CTA button

- [ ] Populate about page:
  - [ ] Add company story/mission
  - [ ] Add team introduction
  - [ ] Add company values

- [ ] Populate services page:
  - [ ] Add service descriptions
  - [ ] Add service pricing/features
  - [ ] Add service images

- [ ] Populate contact page:
  - [ ] Add contact form info
  - [ ] Add office address
  - [ ] Add hours of operation

- [ ] Upload media assets:
  - [ ] Company logo
  - [ ] Hero banner image
  - [ ] Team photos
  - [ ] Service/product images

---

## Phase 10: Security & Performance

- [ ] Verify CSRF protection on admin endpoints
- [ ] Verify SQL injection prevention (using prepared statements)
- [ ] Test with malicious HTML input (should sanitize)
- [ ] Verify file upload restrictions (type, size)
- [ ] Test concurrent block edits (last-write-wins?)
- [ ] Add caching for public API responses (optional)
- [ ] Set cache headers for media assets

---

## Phase 11: SEO & Metadata

- [ ] Verify meta_title appears in page `<head>`
- [ ] Verify meta_description in page `<head>`
- [ ] Verify meta_keywords in page `<head>`
- [ ] Test Open Graph tags (if implemented)
- [ ] Test Twitter Card tags (if implemented)
- [ ] Verify canonical URLs (if multi-version content)

---

## Phase 12: Deployment Checklist

### Before Going Live
- [ ] All database migrations applied
- [ ] `uploads/cms/` directory writable
- [ ] Admin users have `super_admin` or `developer` role
- [ ] All links point to correct URLs (no localhost)
- [ ] HTTPS enabled (if applicable)
- [ ] CDN configured for media assets (optional)
- [ ] Email notifications for new content (optional)
- [ ] Backup strategy in place for database
- [ ] Monitoring/logging configured

### Production Configuration
- [ ] Error logging enabled (not visible to users)
- [ ] Debug mode disabled
- [ ] File upload size limits appropriate
- [ ] Rate limiting on public API (optional)
- [ ] API response caching optimized
- [ ] Database backups scheduled

---

## Phase 13: Monitoring & Maintenance

### Regular Tasks
- [ ] Review admin logs for suspicious activity
- [ ] Check disk space for uploads directory
- [ ] Monitor database growth
- [ ] Review failed API requests
- [ ] Test content rendering regularly

### Quarterly Tasks
- [ ] Backup database and uploads
- [ ] Review and update content for freshness
- [ ] Check for broken image links
- [ ] Review page analytics/performance
- [ ] Security audit of admin access

---

## Phase 14: Future Enhancements

Priority Order (1=High, 2=Medium, 3=Low):

- [ ] **[1]** WYSIWYG Editor (TinyMCE integration)
- [ ] **[1]** Drag-drop block reordering
- [ ] **[2]** Content versioning/revision history
- [ ] **[2]** Scheduled publishing (date-based)
- [ ] **[2]** Draft/Preview/Publish workflow
- [ ] **[2]** Block templates/presets
- [ ] **[3]** Multi-language support
- [ ] **[3]** Analytics dashboard
- [ ] **[3]** SEO suggestions/optimization
- [ ] **[3]** Backup & restore functionality

---

## Troubleshooting Quick Reference

### Pages not loading
- Check: `cms_pages` table has records with `is_active=1`
- Check: `api/admin/cms.php` returns correct response
- Check: Browser console for errors

### Blocks not saving
- Check: User is authenticated (super_admin)
- Check: `cms_blocks` table structure correct
- Check: DB permissions allow INSERT/UPDATE
- Check: Browser console for network errors

### File upload fails
- Check: `uploads/cms/` directory exists and writable
- Check: File type is JPG/PNG/GIF/WebP/SVG
- Check: File size < 5MB
- Check: PHP upload_max_filesize setting
- Check: API response for specific error message

### 404 on public API
- Check: `/api/cms.php` file exists
- Check: Database entries have `is_active=1`
- Check: Page slug matches request parameter

### Admin access denied
- Check: User role is `super_admin` or `developer`
- Check: Session is active (not timed out)
- Check: `_guard.php` auth verification

---

## Files Reference

| File | Purpose |
|------|---------|
| `cms_migration.sql` | Database setup script |
| `CONTENT_STUDIO_GUIDE.md` | Comprehensive documentation (THIS FILE) |
| `FRONTEND_EXAMPLES.js` | Frontend integration code examples |
| `IMPLEMENTATION_CHECKLIST.md` | Step-by-step implementation guide (THIS FILE) |
| `api/admin/cms.php` | Admin CMS API (edit endpoints) |
| `api/cms.php` | Public CMS API (read-only) |
| `Frontend-admin/content studio.html` | Admin CMS interface |
| `Frontend-admin/js/admin-api.js` | Admin API wrapper |

---

## Support & Questions

For implementation questions, refer to:
1. **CONTENT_STUDIO_GUIDE.md** - Full technical documentation
2. **FRONTEND_EXAMPLES.js** - Code examples
3. **Error messages** - Check browser console and server logs
4. **API responses** - Use curl/Postman to test endpoints directly

---

## Sign-Off

- [ ] Database setup complete
- [ ] Admin interface tested
- [ ] Public API tested
- [ ] Frontend integrated
- [ ] Content populated
- [ ] Security verified
- [ ] Performance optimized
- [ ] Ready for production ✓

**Implementation Date:** _______________

**Completed By:** _______________

**Testing Status:** ☐ Passed  ☐ Failed (details: _______________________)
