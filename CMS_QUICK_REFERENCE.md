# CMS Integration Quick Reference

## TL;DR - 30 Second Setup

1. **Add scripts to your HTML**:
```html
<script src="js/api.js"></script>
<script src="js/cms-loader.js"></script>
```

2. **Add placeholder for CMS content**:
```html
<!-- Load single block -->
<div data-cms-page="home" data-cms-block="hero"></div>

<!-- Load multiple blocks -->
<main data-cms-page="home" data-cms-blocks="hero,features,pricing" 
      class="cms-blocks-container"></main>
```

3. Done! Content loads automatically.

---

## Instant Copy-Paste Snippets

### Load and render specific block
```javascript
const block = await CMSLoader.getBlock('home', 'hero');
CMSLoader.renderBlock(document.querySelector('#hero'), block);
```

### Load all blocks for a page
```javascript
const blocks = await CMSLoader.getBlocks('shop');
blocks.forEach(block => console.log(block.title));
```

### Get raw CMS data
```javascript
const data = await CMSLoader.loadPage('home');
console.log(data.blocks);    // All blocks
console.log(data.assets);    // Images, logos
console.log(data.plans);     // Pricing
```

### Direct API (no CMSLoader)
```javascript
const data = await apiFetch('/cms.php?page=home');
document.querySelector('#hero').innerHTML = data.blocks.hero.content_html;
```

### Conditional rendering
```javascript
const data = await CMSLoader.loadPage('home');
if (data.blocks.promo) {
  CMSLoader.renderBlock(el, data.blocks.promo);
} else {
  el.textContent = 'No special offers right now';
}
```

### Clear cache (after admin update)
```javascript
CMSLoader.clearCache();
```

---

## Common Patterns

### Pattern 1: Hybrid (CMS + Static Fallback)
```html
<section data-cms-page="home" data-cms-block="hero">
  <!-- Static fallback, replaced by CMS content if available -->
  <h1>Welcome!</h1>
  <p>Default content</p>
</section>
```

### Pattern 2: Pure CMS
```html
<main data-cms-page="home" data-cms-blocks="hero,features,faq" 
      class="cms-blocks-container">
  <!-- Empty, filled by CMS blocks -->
</main>
```

### Pattern 3: Custom Rendering
```javascript
const cmsData = await CMSLoader.loadPage('home');
cmsData.blocks.featured.custom_field = "extra data";
// Now render with custom logic
renderMyCustomComponent(cmsData.blocks.featured);
```

---

## Block Types Quick Reference

| Type | Content Format | Renders As |
|------|---|---|
| **text** | HTML string | `<div class="cms-text-block">` |
| **hero** | HTML string | `<section class="cms-hero-block">` |
| **cta** | HTML string | `<div class="cms-cta-block">` |
| **faq** | JSON array `[{q,a},...]` | `<details>` elements |
| **gallery** | JSON array `[{src,alt,caption},...]` | `<figure>` elements w/ images |
| **image** | JSON `{src,alt,caption}` | `<figure><img/>` |

---

## Properties Available on Each Block

```javascript
{
  id: 1,
  page_id: 1,
  block_key: "hero",           // Unique identifier
  title: "Hero Section",       // Display name
  block_type: "hero",          // Type (text, hero, faq, etc)
  content_html: "...",         // Main content
  content: "...",              // Alias for content_html
  image_path: "/uploads/...",  // Optional image
  sort_order: 0,               // Position on page
  is_active: 1,                // Published?
}
```

---

## CSS Classes for Styling

```css
/* Container */
.cms-blocks-container {}
.cms-block {}
.cms-block-text {}
.cms-block-hero {}
.cms-block-gallery {}
.cms-block-faq {}
.cms-block-image {}
.cms-block-cta {}

/* FAQ specific */
.faq-item { /* <details> */ }
.faq-question { /* <summary> */ }
.faq-answer { /* <div> */ }

/* Gallery specific */
.gallery-item { /* <figure> */ }
.gallery-image { /* <img> */ }
.gallery-caption { /* <p> */ }

/* Error state */
.cms-block-error {}
```

---

## Troubleshooting Checklist

- [ ] Scripts included in correct order? (`api.js` → `cms-loader.js`)
- [ ] Block `block_key` matches `data-cms-block` attribute?
- [ ] Page `slug` matches `data-cms-page` attribute?
- [ ] Content published? (`is_active = 1` in database)
- [ ] Check Console tab for errors
- [ ] Check Network tab - is `/api/cms.php?page=X` request successful?
- [ ] Try clearing browser cache
- [ ] Try `CMSLoader.clearCache()` in console

---

## Best Practices

| Do | Don't |
|----|----|
| ✅ Use `data-cms-block` for single blocks | ❌ Put multiple blocks in one data attribute |
| ✅ Keep blocks focused (one concept) | ❌ Make mega-blocks with everything |
| ✅ Use meaningful `block_key` names | ❌ Use generic names like "content1" |
| ✅ Test pages without CMS (static fallback) | ❌ Assume CMS will always be available |
| ✅ Cache blocks for performance | ❌ Call the API on every page load |
| ✅ Validate HTML in admin before publishing | ❌ Let non-technical users edit raw HTML |

---

## File Locations

```
Frontend-public/
├── js/
│   ├── api.js                   # API wrapper (apiFetch)
│   ├── cms-loader.js            # CMS utility (CMSLoader)
│   ├── cms-examples.js          # Code examples
│   ├── auth-guard.js            # User authentication
│   ├── public-shell.js          # Shared layout
│   └── public-ui.js             # UI utilities
├── *.html                       # Your pages
└── css/style.css               # Styling
```

---

## API Endpoint Reference

```
GET /api/cms.php?page={slug}

Response:
{
  page: "home",
  blocks: {
    "block_key": { id, title, block_type, content_html, ... }
  },
  assets: {
    "asset_key": { file_path, alt_text, width, height, ... }
  },
  content: {
    title: "Page Title",
    description: "..."
  },
  plans: [ { id, key, title, price, period, features } ]
}
```

---

## Example: Converting Static Page to CMS

### Before (Static)
```html
<h1>Welcome!</h1>
<p>High quality printing...</p>
<section id="features">
  <h2>Our Features</h2>
  <ul>...</ul>
</section>
```

### After (CMS-Powered)
```html
<main data-cms-page="home" data-cms-blocks="hero,features" 
      class="cms-blocks-container"></main>

<script src="js/api.js"></script>
<script src="js/cms-loader.js"></script>
```

That's it! Admin now controls content via Content Studio.

---

## Performance Tips

1. **Cache blocks** - CMSLoader does this automatically
2. **Lazy load images** - CMSLoader does this automatically
3. **Minimize API calls** - Load once per page, not per element
4. **Monitor console** - Check for warnings about missing blocks
5. **Use production API endpoints** - Don't dev mode endpoints in production

---

## When to Use Each Approach

| Scenario | Use |
|----------|-----|
| Content Studio doesn't have block | Static HTML |
| Simple page layout | Auto `data-cms-blocks` |
| Complex custom logic | Programmatic `CMSLoader` |
| Mixing CMS + static | Hybrid with `data-cms-block` |
| Publishing site for first time | Start static, migrate gradually |
| Updating existing page | Keep static, add CMS sections |

---

## Getting Help

1. Check `CMS_INTEGRATION_GUIDE.md` for detailed docs
2. Check `cms-examples.js` for code samples
3. Review `cms-integration-example.html` for HTML patterns
4. Check browser console for errors/warnings
5. Ask admin to verify Content Studio content is published

---

## Admin Integration Note

When admin publishes content in Content Studio:
- Content updates in database immediately
- Frontend gets cached version until `CMSLoader.clearCache()` is called
- Add this to admin pages to auto-refresh on publish:
```javascript
// In app startup or page reload
CMSLoader.clearCache(); 
window.location.reload();
```

