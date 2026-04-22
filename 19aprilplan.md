# ZAK Printing V4 — Bug Fix & Update Plan

## Context
Six distinct issues spanning the public frontend, admin panel UI, admin settings persistence, and backend API routing. All fixes are targeted — no scope creep.

---

## Issue 1 — Public Header/Nav Inconsistency

### Root Cause
Every public page has its own **hardcoded** `<header>`. The `home.html` header uses:
- SVG printer icon (not Material Symbols `print`)
- `href="home.html"` style links (with `.html` extension)
- `<button onclick>` for account/cart icons

Other pages (shop, services, etc.) use:
- `<span class="material-symbols-outlined">print</span>` icon
- `href="home"` style links (no extension, relies on `.htaccess` rewrite)
- `<a>` tags for account/cart

### Fix
Copy `home.html`'s header block (lines 132–199) as the canonical template. Update all other public pages to match it exactly — same icon SVG, same `.html` link style, same buttons for account/cart, same mobile nav pattern.

**Files to edit:**
- `Frontend-public/shop.html` — replace header (lines 36–85)
- `Frontend-public/services.html` — replace header
- `Frontend-public/about.html` — replace header
- `Frontend-public/contact.html` — replace header
- `Frontend-public/blog.html` — replace header
- `Frontend-public/appointment.html` — replace header
- `Frontend-public/product-detail.html` — replace header
- `Frontend-public/checkout.html` — replace header
- `Frontend-public/user-dash.html` — replace header
- `Frontend-public/user-my-order.html` — replace header
- `Frontend-public/user-my-settings.html` — replace header
- `Frontend-public/order-confirm.html` — replace header

**Per-page active state**: change only the active nav link's class to `text-primary text-sm font-bold` while others stay `text-slate-600 ... hover:text-primary`.

---

## Issue 2 — Shop Page: 9 Products Shown, No Variations

### Root Cause
The backend `api/products.php` defaults to **12 per page** — not 9. The actual cause of "9 products" is likely that only 9 products exist in the DB, or the frontend `perPage` state was changed. The API is fine.

**Variations** are genuinely absent from the public products API response. `api/products.php` does not query or return variation data. The product detail page handles variations client-side but the shop grid shows none.

### Fix

**Part A — Show all products (remove any accidental limit)**
- Verify `state.perPage` in `shop.html` is `12` (already correct at line 279). If needed, increase to `24` or `48` to show more at once.
- Expose a "per page" control or increase the default `perPage` to `24`.

**Part B — Show variations in the shop card**
- Modify `api/products.php` to include a `variations` array in the single-product response (when `?id=X`) — already partially present via `colors`, `dimensions` fields.
- For the shop grid, add a compact variation indicator to each product card: show size options or color swatches if available. This requires `api/products.php` to return a `sizes` field (from the `product_variations` table if it exists, otherwise from the `dimensions` column).
- If no `product_variations` table exists, show the `colors` field as color swatches and `dimensions` as size chips on the card.

**Files to edit:**
- `Frontend-public/shop.html` — increase `perPage` to `24`, add variation chips to `renderProductGrid()`
- `api/products.php` — include `colors`, `dimensions`, `weight` in list response (not just single-product)

---

## Issue 3 — Home Page "For Our Business Customers" Section

### Current State
The section (lines 352–437 of `home.html`) shows **8 hardcoded product cards** with static images from Google CDN and hardcoded names. All "Shop Now" buttons link to dead anchor `#product-detail-*` fragments.

### Fix
- Load 6 real products from the API (`apiFetch('/products.php?limit=6&sort=popular')`) on page load
- Render them into the 8-card grid dynamically replacing the static HTML
- Each card: product image (with fallback), product name, "Shop Now" button → `shop.html?product_id={id}` or WhatsApp button
- No price shown (keep existing style — just name + button)
- Keep the countdown timer card (left column) as-is; only replace the 8-slot right grid

**Files to edit:**
- `Frontend-public/home.html` — replace static 8-card grid with a `<div id="biz-products-grid">` placeholder; add JS to fetch and render 6–8 products from the API

---

## Issue 4 — Admin Sidebar Toggle Bug

### Root Cause
Two separate toggle systems coexist and conflict on some pages:

1. **`sidebar-controller.js`** — the desktop collapse/expand system. Works by toggling `body.sidebar-collapsed` class, which uses CSS to shrink the `<aside>` width from 288px → 88px. This works correctly on pages where the `<aside>` has no `fixed` positioning conflict.

2. **Inline mobile toggle scripts** — each page has its own `<script>` that toggles `-translate-x-full` on `#sidebar-nav`. On **`billing-settings.html`** the sidebar has class `hidden lg:flex fixed lg:relative` which means on mobile it starts `hidden` (not `-translate-x-full`). The toggle toggles translate but the element is `display:none` so nothing happens — it appears to toggle "an invisible container."

3. **`general-settings.html`** loads `sidebar-controller.js` **twice** (lines 270 and 330), causing double initialization and conflicting toggle state.

4. **`billing-settings.html`** sidebar uses `hidden lg:flex` (not the standard `flex ... -translate-x-full`) pattern, so the controller's CSS rules don't apply.

### Fix

**Fix A — Remove duplicate sidebar-controller.js load:**
- `general-settings.html`: remove the duplicate `<script src="../Frontend-admin/js/sidebar-controller.js" defer></script>` at line 270 (keep only the one at line 330)
- `my-earning.html`: same check — remove duplicates

**Fix B — Standardize billing-settings.html sidebar:**
- Change the `<aside>` classes from `hidden lg:flex fixed lg:relative` → `flex fixed lg:relative -translate-x-full lg:translate-x-0` to match the standard pattern used in `general-settings.html`
- Update the mobile toggle script in `billing-settings.html` to match `general-settings.html`'s toggle (toggle `-translate-x-full` + show overlay)
- Add `id="sidebar-overlay"` div before the aside (matches other pages)

**Files to edit:**
- `Frontend-admin/general-settings.html` — remove duplicate script tag at line 270
- `Frontend-admin/my-earning.html` — remove duplicate script tag
- `Frontend-admin/billing-settings.html` — fix aside classes + mobile toggle script + add overlay div

---

## Issue 5 — Settings Pages Not Saving (Logo Upload + Other Fields)

### Root Cause

**General Settings (`general-settings.html`):**
- The form **does work** — `adminFetch('/settings.php', { method: 'POST', data: { type: 'general', settings: formData } })` is correct.
- The "Change Logo" and "Change Icon" buttons (lines 211, 223) have **no event handlers** — they are orphaned buttons that do nothing.
- Logo is stored as a URL string only; no file upload exists in `settings.php`.

**Billing Settings (`billing-settings.html`):**
- The save logic works (POST to `/settings.php` with `type=invoice|quotation`) but `data-action="save-billing"` button must exist in the HTML. The button needs this attribute — currently it may be missing.
- "Upload New Logo" button (line 170) has no event handler.
- Logo URL field (`name="logo_url"`) works fine for URL-based logos.

**Logo Upload Fix:**
- Add a hidden `<input type="file" id="logo-file-input" accept="image/*">` to both settings pages
- Wire the "Change Logo" / "Upload New Logo" buttons to trigger this input
- On file select, POST the file to `api/admin/cms.php` (the existing upload endpoint: `action=upload`) using FormData
- On success, populate the `logo_url` input with the returned `url` and show a preview

**Save Button Fix (billing-settings):**
- Confirm the Save button has `data-action="save-billing"` attribute — add it if missing

**Files to edit:**
- `Frontend-admin/general-settings.html` — add hidden file input, wire logo upload buttons, show preview
- `Frontend-admin/billing-settings.html` — add hidden file input, wire upload button, confirm save button attribute
- No backend changes needed (upload endpoint already exists at `api/admin/cms.php`)

---

## Issue 6 — Admin Earnings: "Failed to load earnings"

### Root Cause
`my-earning.html` calls `adminFetch('/finance.php?action=earnings')`.

`ADMIN_API_BASE` in `admin-api.js` resolves to `/zakprintingV4/api/admin` (or similar).

So the full URL becomes: `/zakprintingV4/api/admin/finance.php?action=earnings`

The file `api/admin/finance.php` **does exist** and handles `?action=earnings`. However:

1. The PHP parses action via: `$action = $_GET['action'] ?? ($_GET['earnings'] ?? false ? 'earnings' : 'ledger')` — this means `?action=earnings` should work.
2. The likely failure is that `finance.php` requires `billing_profiles` or `invoices` tables which may not exist yet in the database → PDO throws an exception → PHP returns a 500 → `adminFetch` throws → catch shows "Failed to load earnings".
3. Alternative: the `finance_cash_entries` table doesn't exist → same outcome for ledger queries that run before earnings.

### Fix
- Add `try/catch` around the DB queries in `finance.php` to return empty data gracefully instead of a 500 error:
  ```php
  // Wrap earnings query in try/catch, return zeros if tables missing
  respond(['earnings' => ['invoice_count' => 0, 'total_revenue' => 0, 'total_collected' => 0]]);
  ```
- Also improve the frontend error handling in `my-earning.html`: on error, instead of only showing a toast, also render zero-state stat cards (show "PKR 0" in all fields rather than leaving them blank).

**Files to edit:**
- `api/admin/finance.php` — wrap earnings query in try/catch, return safe empty response
- `Frontend-admin/my-earning.html` — improve catch block to populate zero-state UI

---

## Implementation Order

1. **Issue 6** (Finance/Earnings backend) — standalone, quick, unblocks testing
2. **Issue 4** (Sidebar toggle) — structural, affects all admin testing
3. **Issue 5** (Settings save + logo upload) — depends on sidebar being stable
4. **Issue 1** (Public header) — repetitive but mechanical
5. **Issue 2** (Shop products/variations) — requires API + frontend changes
6. **Issue 3** (Home biz section) — depends on shop API working

---

## Verification

- Open `/Frontend-public/home.html`, `/shop.html`, `/services.html` — headers must look identical
- Shop page must show all products with pagination; product cards show variation info
- Home page biz section loads real product cards with working Shop Now links
- Admin sidebar toggle works on all pages without invisible-div behavior
- `billing-settings.html` sidebar opens/closes correctly on mobile
- General settings Save button shows success toast and data persists on reload
- Logo upload button opens file picker, uploads, and populates the URL field
- My Earnings page shows PKR 0.00 stats instead of error toast (or real data if invoices exist)
