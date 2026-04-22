# CMS Frontend Integration - Developer Implementation Checklist

Use this checklist as you integrate CMS content into your pages.

## Initial Setup (Do This Once)

- [ ] Read `CMS_INTEGRATION_GUIDE.md` (full documentation)
- [ ] Read `CMS_QUICK_REFERENCE.md` (quick lookups)
- [ ] Review `cms-examples.js` (code examples)
- [ ] Review `cms-integration-example.html` (HTML patterns)
- [ ] Verify `/api/cms.php?page=home` works (test in browser)
- [ ] Verify scripts have been added to your pages:
  - [ ] `<script src="js/api.js"></script>`
  - [ ] `<script src="js/cms-loader.js"></script>`

## For Each Page You Convert

### 1. Plan the Content Structure

- [ ] Meet with content team to identify content sections
- [ ] Create list of blocks needed:
  - [ ] Block key name (e.g., "hero", "features_section")
  - [ ] Block type (text, hero, gallery, faq, etc.)
  - [ ] Content description
  - [ ] Display location on page
  
  Example:
  ```
  Block Key: hero
  Type: hero
  Content: Page banner with headline and CTA
  Location: Top of page
  
  Block Key: features
  Type: text
  Content: List of features
  Location: Below hero
  ```

### 2. Prepare the HTML

#### Option A: Auto-Render (Recommended for Most Pages)

- [ ] Choose where to place CMS content placeholders
- [ ] Add data attributes:
  ```html
  <!-- Single block -->
  <section data-cms-page="home" data-cms-block="hero"></section>
  
  <!-- Multiple blocks -->
  <main data-cms-page="home" 
        data-cms-blocks="hero,features,faq" 
        class="cms-blocks-container"></main>
  ```
- [ ] Add placeholder/fallback HTML (optional):
  ```html
  <section data-cms-page="home" data-cms-block="hero">
    <h1>Loading page content...</h1>
  </section>
  ```

#### Option B: Hybrid (CMS + Static)

- [ ] Identify sections that admin will control (CMS)
- [ ] Identify sections that don't change (static HTML)
- [ ] Wrap CMS sections with data attributes
- [ ] Keep static sections as regular HTML

#### Option C: Programmatic (Most Complex)

- [ ] Create minimal HTML structure
- [ ] Write JavaScript to load and render blocks:
  ```javascript
  const cmsData = await CMSLoader.loadPage('home');
  if (cmsData.blocks.hero) {
    CMSLoader.renderBlock(heroElement, cmsData.blocks.hero);
  }
  ```

### 3. Add Styling

- [ ] Add CSS classes for CMS blocks:
  ```css
  .cms-block { margin-bottom: 2rem; }
  .cms-block-hero { background: gradient; padding: 3rem; }
  .cms-block-gallery { display: grid; gap: 1rem; }
  .cms-block-faq { max-width: 800px; }
  ```
- [ ] Style block-specific elements:
  - [ ] `.cms-text-block`
  - [ ] `.cms-hero-block h1`, `.cms-hero-block p`
  - [ ] `.gallery-item`, `.gallery-image`, `.gallery-caption`
  - [ ] `.faq-item`, `.faq-question`, `.faq-answer`
  - [ ] `.cms-block-error`

### 4. Test the Page

- [ ] Load page in browser
- [ ] Check console for errors (F12 → Console tab)
- [ ] Check that blocks load (should see CMS content populate)
- [ ] Check fallback HTML shows while loading
- [ ] Test with network throttled (F12 → Network → Throttle)
- [ ] Mobile test: responsive layout
- [ ] Check all links work in CMS content

### 5. Prepare Content for Admin

- [ ] Document block structure in spreadsheet or document:
  
  | Page | Block Key | Block Type | Content | Notes |
  |------|-----------|-----------|----------|-------|
  | home | hero | hero | Page hero section | Uses h1 + p + CTA |
  | home | features | text | Features HTML | Rich formatting ok |
  | home | faq | faq | FAQ items | JSON format |

- [ ] Share admin instructions:
  - [ ] How to access Content Studio
  - [ ] How to create new blocks
  - [ ] Block naming conventions
  - [ ] HTML allowed / not allowed
  - [ ] Image requirements (size, format)
  - [ ] How to publish/preview

- [ ] Create sample content in CMS for testing

### 6. Final Verification

#### Auto-Render Checklist
- [ ] `data-cms-page` attribute correct
- [ ] `data-cms-block` names match created blocks
- [ ] Blocks render without errors
- [ ] Styling looks correct
- [ ] Mobile layout works

#### Programmatic Checklist
- [ ] `CMSLoader.loadPage()` works
- [ ] `CMSLoader.getBlock()` returns correct data
- [ ] Rendering logic handles missing blocks
- [ ] Error messages show if CMS unavailable
- [ ] Fallback UI displays appropriately

#### All Pages
- [ ] No JavaScript console errors
- [ ] No network errors in Network tab
- [ ] Page loads without CMS (fallback works)
- [ ] Page loads with CMS (content populates)
- [ ] Content updates in <1 second typically
- [ ] Images load (not broken img links)
- [ ] All hyperlinks work
- [ ] Responsive on mobile/tablet/desktop

### 7. Common Issues & Fixes

| Issue | Symptoms | Fix |
|-------|----------|-----|
| Scripts not loading | No content appears | Check script src paths |
| Wrong block key | Placeholder stays | Verify exact block key name |
| Block not published | Content missing | Check is_active=1 in CMS |
| API error | Network failure | Check /api/cms.php endpoint |
| Cache issue | Old content shows | Call `CMSLoader.clearCache()` |
| Styling broken | Wrong layout | Check CSS class names |

### 8. Documentation

- [ ] Add comments to HTML explaining CMS blocks:
  ```html
  <!-- CMS Block: hero (managed in Content Studio) -->
  <section data-cms-page="home" data-cms-block="hero"></section>
  
  <!-- CMS Blocks: features and faq -->
  <main data-cms-page="home" 
        data-cms-blocks="features,faq"
        class="cms-blocks-container"></main>
  ```

- [ ] Update page comments with content structure

- [ ] Add to team wiki/docs with page conversion status

### 9. Performance Tuning (If Needed)

- [ ] Monitor page load time:
  - Before: X ms
  - After: Y ms
  
- [ ] If CMS blocks slow page:
  - Use `CMSLoader.clearCache()` less frequently
  - Reduce number of blocks per page
  - Combine multiple small blocks into one

- [ ] Check bundle size (should be minimal)

### 10. Go Live

- [ ] Test on staging environment
- [ ] Get admin approval
- [ ] Brief admin on how to update content
- [ ] Deploy to production
- [ ] Monitor for errors in first 24 hours
- [ ] Handle any urgent fixes

---

## Page Conversion Tracker

Keep track of which pages have been converted:

| Page | Status | Blocks | Notes |
|------|--------|--------|-------|
| home.html | ⬜ Not started | — | — |
| about.html | ⬜ Not started | — | — |
| shop.html | ⬜ Not started | — | — |
| contact.html | ⬜ Not started | — | — |
| services.html | ⬜ Not started | — | — |

Legend: ⬜ Not started | 🟨 In progress | 🟩 Complete | ⚠️ Needs fixes

---

## Block Naming Conventions

Suggested naming for consistency:

| Page | Block Key | Type | Purpose |
|------|-----------|------|---------|
| Any | `hero` | hero | Main hero/banner section |
| Any | `cta` | cta | Call-to-action section |
| Any | `faq` | faq | FAQ accordion |
| Blog | `article-{n}` | text | Blog post n |
| Shop | `featured` | text | Featured products |
| Contact | `contact-form` | text | Contact form description |
| Home | `features` | text | Feature list |
| Home | `testimonials` | text | Customer testimonials |
| Home | `pricing` | text | Pricing info |

---

## Quick Commands for Testing

### In Browser Console (F12)

```javascript
// Load CMS data
const data = await CMSLoader.loadPage('home');
console.log(data);

// Get single block
const hero = await CMSLoader.getBlock('home', 'hero');
console.log(hero);

// Clear cache
CMSLoader.clearCache();

// Get all blocks
const blocks = await CMSLoader.getBlocks('home');
console.log(blocks);
```

### Check API Directly

```
Visit: /api/cms.php?page=home
Should see JSON with: blocks, assets, content, plans
```

---

## Tips & Tricks

### Tip 1: Fallback Content
Always include fallback HTML inside data attributes. While CMS loads, user sees something:

```html
<div data-cms-page="home" data-cms-block="hero">
  <h1>Welcome to ZAK Printing</h1>
  <p>Professional printing services</p>
</div>
```

### Tip 2: Testing Without CMS
Disable cms-loader.js temporarily to see fallback content:

```html
<!-- Temporary - remove later -->
<!-- <script src="js/cms-loader.js"></script> -->
```

### Tip 3: Block Preview
Create preview in CMS before publishing:
1. Create block (unpublished)
2. View page - should see fallback
3. Edit block content
4. Publish
5. Refresh page - should see new content

### Tip 4: Debugging
Add to JavaScript for debugging:

```javascript
// Show what blocks loaded
CMSLoader.loadPage('home').then(data => {
  console.log('Blocks available:', Object.keys(data.blocks));
  console.log('Each block:', data.blocks);
});
```

### Tip 5: Cache Management
If content doesn't update:

```javascript
CMSLoader.clearCache();
window.location.reload();
```

---

## Training Checklist (For Admin)

Help admin learn the system:

- [ ] Show Content Studio interface
- [ ] Explain page creation
- [ ] Explain block creation
- [ ] Show HTML editor for text blocks
- [ ] Show JSON editor for structured blocks (faq, gallery)
- [ ] Explain publish/draft status
- [ ] Show how content appears on frontend
- [ ] Show how to preview before publishing
- [ ] Explain block key naming (must be unique)
- [ ] Show image upload process
- [ ] Explain when to use each block type
- [ ] Q&A session

---

## Success Criteria

Your implementation is successful when:

✅ Page loads without errors
✅ CMS content appears on page
✅ Fallback HTML shows while loading
✅ Admin can create/edit blocks in Content Studio
✅ Changes in CMS appear on frontend within seconds
✅ Page works on mobile/tablet/desktop
✅ No console errors or warnings
✅ Page loading time acceptable
✅ Team understands the system
✅ Documented and ready for maintenance

---

## Getting Help

- **Quick answers**: Check `CMS_QUICK_REFERENCE.md`
- **Detailed docs**: Check `CMS_INTEGRATION_GUIDE.md`  
- **Code examples**: Check `cms-examples.js`
- **HTML example**: Check `cms-integration-example.html`
- **Summary**: Check `CMS_FRONTEND_INTEGRATION_SUMMARY.md`

---

**Last Updated**: 2025
**Version**: 1.0
