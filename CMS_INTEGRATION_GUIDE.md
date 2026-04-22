# CMS Content Integration Guide

This guide explains how to dynamically load and render CMS content on Frontend-public pages. The system provides both a direct API approach and an automatic block-rendering utility.

## Architecture Overview

```
┌─────────────────────────────────────────┐
│ Frontend-public (*.html pages)          │
├─────────────────────────────────────────┤
│ Uses: apiFetch() + CMSLoader utility    │
└──────────────┬──────────────────────────┘
               │
               ▼
┌──────────────────────────────┐
│ /api/cms.php (public API)    │
│ Returns: blocks, assets,     │
│          content, plans      │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│ Database (CMS, pages, blocks)│
└──────────────────────────────┘
```

---

## Method 1: Automatic Block Rendering (Recommended for Static Pages)

Use HTML data attributes to automatically load and render CMS blocks.

### Setup

1. Include the necessary scripts in your HTML page:

```html
<!-- Load API wrapper first -->
<script src="../Frontend-public/js/api.js"></script>
<!-- Load CMS loader utility -->
<script src="../Frontend-public/js/cms-loader.js"></script>
```

The `cms-loader.js` automatically runs `autoRenderBlocks()` when the DOM is ready.

### Single Block Rendering

```html
<!-- Load the "hero" block from "home" page and render it here -->
<section data-cms-page="home" data-cms-block="hero"></section>
```

### Multiple Blocks Rendering

For pages with many blocks, create a container and list all blocks:

```html
<!-- Will create a div for each block inside this container -->
<main data-cms-page="home" data-cms-blocks="hero,features,pricing,testimonials" 
      class="cms-blocks-container"></main>
```

This creates and populates divs with classes `cms-block` and `cms-block-{type}`.

### Example: Home Page with CMS

```html
<!DOCTYPE html>
<html>
<head>
  <title>Home - ZAK Printing</title>
  <link rel="stylesheet" href="../Frontend-public/css/style.css">
</head>
<body>
  <!-- Header -->
  <header>...</header>

  <!-- Main Content - Auto-loaded from CMS -->
  <main data-cms-page="home" data-cms-blocks="hero,features,cta,faq,testimonials" 
        class="cms-blocks-container"></main>

  <!-- Footer -->
  <footer>...</footer>

  <!-- Scripts -->
  <script src="../Frontend-public/js/api.js"></script>
  <script src="../Frontend-public/js/cms-loader.js"></script>
</body>
</html>
```

---

## Method 2: Programmatic Loading (For Dynamic Behavior)

Use JavaScript to manually load and manipulate CMS content.

### Load Page Content

```javascript
// Load all CMS data for a page
const cmsData = await CMSLoader.loadPage('home');
console.log(cmsData.blocks);   // { hero: {...}, features: {...}, ... }
console.log(cmsData.assets);   // { 'hero-image': {...}, ... }
console.log(cmsData.content);  // Page metadata
console.log(cmsData.plans);    // Pricing plans
```

### Get a Single Block

```javascript
// Get the "hero" block from "home" page
const heroBlock = await CMSLoader.getBlock('home', 'hero');
if (heroBlock) {
  console.log(heroBlock.title);
  console.log(heroBlock.content_html);
}
```

### Render Block into Element

```javascript
// Load and manually render into a specific element
const container = document.querySelector('#my-hero-section');
const block = await CMSLoader.getBlock('home', 'hero');
if (block) {
  CMSLoader.renderBlock(container, block);
}
```

### Get All Blocks for a Page

```javascript
// Load all blocks sorted by order
const blocks = await CMSLoader.getBlocks('home');
blocks.forEach((block) => {
  console.log(`${block.block_key}: ${block.block_type}`);
});
```

### Process Block Content with Custom Rendering

```javascript
// Get processed HTML for a block (with proper escaping)
const block = await CMSLoader.getBlock('home', 'features');
const html = CMSLoader.processBlockContent(block, 'text');
// html is safe and ready to insert into the DOM
```

### Conditional Block Rendering

```javascript
// Load page and selectively render blocks based on conditions
const cmsData = await CMSLoader.loadPage('shop');

if (cmsData.blocks.featured_products) {
  const container = document.querySelector('#featured');
  CMSLoader.renderBlock(container, cmsData.blocks.featured_products);
}

if (cmsData.blocks.promotions) {
  const container = document.querySelector('#promotions');
  CMSLoader.renderBlock(container, cmsData.blocks.promotions);
}
```

---

## Block Types and Content Format

### Text Block
```javascript
{
  block_type: "text",
  block_key: "features",
  content_html: "<h2>Our Features</h2><p>High quality...</p>"
}
// Renders as: <div class="cms-text-block">{content_html}</div>
```

### Hero Block
```javascript
{
  block_type: "hero",
  block_key: "hero",
  content_html: "<h1>Welcome</h1><p>You Think, We Create</p>"
}
// Renders as: <section class="cms-hero-block">...</section>
```

### FAQ Block
```javascript
{
  block_type: "faq",
  block_key: "faq",
  content_html: '[{"q":"What is your turnaround?","a":"2-3 days"},...]'
}
// Renders as: <details><summary>Q</summary>A</details> structure
```

### Gallery Block
```javascript
{
  block_type: "gallery",
  block_key: "portfolio",
  content_html: '[{"src":"image.jpg","alt":"Photo","caption":""},...]'
}
// Renders as: <figure> elements with lazy-loaded images
```

### Image Block
```javascript
{
  block_type: "image",
  block_key: "shop-banner",
  content_html: '{"src":"banner.jpg","alt":"Shop","caption":"Visit our store"}'
}
// Renders as: <figure><img .../><p class="caption">...</p></figure>
```

### CTA Block
```javascript
{
  block_type: "cta",
  block_key: "contact_cta",
  content_html: "<div class=\"cta\"><h3>Ready?</h3><a href=\"contact.html\">Contact Us</a></div>"
}
```

---

## Fallback and Error Handling

The CMSLoader automatically handles failures gracefully:

```javascript
// If CMS loading fails, the error is logged but page doesn't break
// Elements remain empty (or show placeholder content)
const block = await CMSLoader.getBlock('home', 'hero');
// If block doesn't exist: block === null
// If page doesn't exist: returns empty blocks object
// If API fails: returns error flag in data
```

For more robust handling:

```javascript
try {
  const cmsData = await CMSLoader.loadPage('home');
  if (cmsData.error) {
    console.error('CMS error:', cmsData.error);
    // Show fallback UI or static content
  } else {
    // Process cmsData
  }
} catch (error) {
  console.error('Failed to load CMS:', error);
  // Show fallback UI
}
```

---

## Asset References

Pages can also include asset metadata for things like logos, featured images, etc.

```javascript
const cmsData = await CMSLoader.loadPage('home');
const heroImage = cmsData.assets['hero-image'];
if (heroImage) {
  console.log(heroImage.file_path);
  console.log(heroImage.width);
  console.log(heroImage.height);
  console.log(heroImage.alt_text);
}
```

---

## Performance Considerations

### Caching

CMSLoader caches loaded pages automatically:

```javascript
// First call loads from API
const data1 = await CMSLoader.loadPage('home');

// Second call returns cached data (no API call)
const data2 = await CMSLoader.loadPage('home');

// Clear cache if needed (e.g., after CMS update in admin)
CMSLoader.clearCache();
```

### Lazy Loading

Images in gallery and image blocks are rendered with `loading="lazy"` for performance.

### Async/Await

All CMS operations are async:

```javascript
// Correct: Wait for results
await CMSLoader.autoRenderBlocks();

// Or with .then()
CMSLoader.loadPage('home').then(data => {
  console.log(data);
});
```

---

## Styling CMS Blocks

Each block renders with specific CSS classes for styling:

```css
/* Text blocks */
.cms-text-block { }

/* Hero sections */
.cms-hero-block { }

/* FAQ sections */
.cms-faq-block { }
.faq-item { }
.faq-question { }
.faq-answer { }

/* Gallery */
.cms-gallery-block { }
.gallery-item { }
.gallery-image { }
.gallery-caption { }

/* Image */
.cms-image-block { }
.image-caption { }

/* CTA */
.cms-cta-block { }

/* Error state */
.cms-block-error { }

/* Block container (multiple blocks) */
.cms-blocks-container { }
.cms-block { }
.cms-block-text { }
.cms-block-hero { }
.cms-block-gallery { }
/* etc. */
```

---

## Migration Path

### Phase 1: Static Fallback
Keep pages as-is with static HTML. Pages work the same.

### Phase 2: CMS Enhancement
Add data attributes to specific content sections:

```html
<section class="hero">
  <div data-cms-page="home" data-cms-block="hero">
    <!-- Fallback static hero content -->
    <h1>...</h1>
  </div>
</section>
```

When CMS block loads, it replaces the static content. While loading, static content is visible.

### Phase 3: Full CMS
Convert pages to use empty containers:

```html
<main data-cms-page="home" data-cms-blocks="hero,features,pricing" 
      class="cms-blocks-container"></main>
```

---

## Direct API Usage (Without CMSLoader)

If you prefer direct API calls:

```javascript
// Get raw CMS data
const cmsData = await apiFetch('/cms.php?page=home');

// cmsData.blocks is keyed by block_key
console.log(cmsData.blocks.hero.content_html);

// Manually render
document.querySelector('#hero').innerHTML = 
  DOMPurify.sanitize(cmsData.blocks.hero.content_html);
```

Note: CMSLoader handles HTML escaping and rendering automatically, so this is less safe unless you use DOMPurify or similar.

---

## Troubleshooting

### Block not showing up?
1. Check browser console for errors
2. Verify block `block_key` matches the data attribute
3. Verify page `slug` matches the data attribute  
4. Check that page/block is published (`is_active = 1`) in CMS
5. Check network tab to see if `/api/cms.php` request succeeds

### XSS Security Issues?
CMSLoader escapes all non-HTML content automatically. HTML content (like `content_html`) is rendered as-is, so ensure CMS admins only input trusted HTML.

### Performance issues?
- CMSLoader caches pages - only first call hits the API
- Use `data-cms-block` (single) instead of `data-cms-blocks` (multiple) when possible
- Consider pagination for large galleries
- Clear cache periodically if content changes frequently

---

## Best Practices

1. **Always include both scripts**: `api.js` must load before `cms-loader.js`
2. **Use meaningful block keys**: e.g., `hero`, `featured_products`, `testimonials`
3. **Keep blocks focused**: One concept per block, easier to manage
4. **Test fallbacks**: Ensure pages degrade gracefully if CMS is unavailable
5. **Cache strategy**: Use `CMSLoader.clearCache()` after admin changes
6. **Monitor errors**: Check console for loading/rendering warnings
7. **Validate in CMS**: Admin should validate HTML content before publishing

