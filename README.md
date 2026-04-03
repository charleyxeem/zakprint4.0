# 🤖 AI Agent Context Document — ZakPrinting V4

**ATTENTION AI AGENTS:** Read this document first before making any modifications to the codebase. This file serves as the definitive source of truth for the ZakPrinting V4 architecture, history, and goals.

---

## Hostinger Deployment

Use the project only inside `public_html` on Hostinger.

1. Upload the application so `api/`, `config/`, `Frontend-public/`, and `Frontend-admin/` all sit under `public_html`.
2. Place `env.hostinger` in the `public_html` root and fill in the live domain plus database credentials.
3. Rename `.htaccess-hostinger` to `.htaccess` in `public_html` before going live.
4. Keep writable permissions for `storage/` and `uploads/`.
5. Keep `.env` only for local development if you still need it.

The app now prefers `env.hostinger` first, then falls back to `.env`.

## 1. What the User Originally Asked For (The Prompt)
The user initiated a massive upgrade from a messy, spaghetti-code application (`zakprintingv3`) to a modern, decoupled architecture (`zakprintingV4`). 

**Core Requirements:**
*   **Zero Data Loss:** Preserve the existing V3 MySQL database exactly. Do not truncate or drop `invoices`, `users`, `quotations`, or `products`.
*   **UI/UX Overhaul:** The user provided purely static HTML/CSS/Tailwind UI templates for both the Public site (`Frontend-public/`) and the Admin portal (`Frontend-admin/`).
*   **Clean Architecture:** Eliminate mixed PHP/HTML pages. Build a strictly separated JSON REST API backend to power the static HTML pages via JavaScript `fetch()`.
*   **Role-Based Access Control (RBAC):** Implement a strict 3-tier matrix:
    *   **User:** Public access to their own orders/appointments.
    *   **Admin:** Dashboard access restricted *strictly* to their own generated invoices, quotations, and ledgers (`WHERE created_by = session_id`).
    *   **Super Admin:** Unrestricted access to all data across the platform, plus user management and settings.
*   **Content Studio:** Allow Super Admins to edit public pages dynamically without code (saving to DB and rendering on the frontend).
*   **Root Replacement:** V4 must operate at the web root, fully replacing V3.

---

## 2. How It Was Done (Architecture & Logic)

The project was reconstructed using a **"Static Frontend + Pure REST API"** pattern.

### A. The Backend Engine (`api/`)
*   **Configuration:** Sensitive data was moved to a `.env` file. `config/database.php` reads this to return a single global `$pdo` instance.
*   **Routing:** An `.htaccess` rule intercepts all `/api/*` requests and directs them to the backend PHP files. It also blocks direct access to `.env` and `config/`.
*   **Helpers & Guards:** 
    *   `api/_helpers.php` provides JSON parsing (`getBody()`) and sanitized responses (`respond()`, `err()`).
    *   `api/admin/_guard.php` handles session checking and data scoping (`requireAdmin()`, `scopeToUser()`).
*   **Legacy Porting:** Certain complex V3 features were ported directly to avoid rebuilding wheels:
    *   `pdf.php`: Uses `Dompdf` (with `mPDF` fallback) to generate INVOICE/QUOTATION documents. Supports token-verified public URLs.
    *   `email.php`: Uses `PHPMailer` (SMTP) to send emails with auto-attached PDFs.
    *   `whatsapp.php`: Integrates with Meta's Cloud API to send PDFs directly to Pakistani phone numbers.

### B. The Frontend Wiring (`Frontend-*`)
*   **No PHP in Views:** The provided HTML templates were kept 100% intact as static `.html` files.
*   **JavaScript Injection:** Included custom JS files (`api.js`, `auth-guard.js`, `admin-api.js`, `admin-auth.js`) at the bottom of the HTML templates.
*   **Hydration:** Upon page load, the JS files identify the base URL, enforce authentication redirects (to `user-login.html` or `admin-login.html`), fetch JSON from the API, and populate the DOM dynamically.

---

## 3. What Has Been Done So Far (Current State)

*   **Database:** Additive migration (`v4_migration.sql`) created new tables (`cms_blocks`, `page_assets`, `blog_posts`, `appointments`) without hurting the old schema.
*   **Backend (100% Complete):** 26 REST API PHP files built, syntax-checked, and tested.
*   **Public Frontend (100% Complete):** 15 pages securely wired to the `/api/` endpoints.
*   **Admin Frontend (100% Complete):** 21 pages (including the newly created `admin-login.html` and modal windows) securely wired to `/api/admin/`.
*   **Content Studio:** Image uploads (Max 5MB) are supported and saving correctly to `/uploads/cms/`.
*   **Bug Fixes:** Resolved 404 Apache routing loops, JS DOM selector crashes, and 401 API auth drops.

---

## 4. What Needs to Be Done (Pending Tasks)

As a subsequent AI agent, if the user asks you to "continue" or "test", focus on these areas:

1.  **Live End-to-End Testing Flow:** The application is fully wired, but needs to be tested with the user's *actual active database*.
    *   Create a test invoice as an Admin. Verify it doesn't show up in another Admin's dashboard.
    *   Test the checkout flow on `Frontend-public/checkout.html` and watch it hit the admin dashboard.
2.  **Edge Case UI Polish:** The DOM injection logic relies on specific classes in the user's provided HTML. If a user complains about "data not showing", check the JavaScript `querySelector` paths in `admin-dash.html` or `invoice-view.html` to ensure they match the DOM.
3.  **Production Deployment prep:** Ensure `.env` is swapped with production host credentials and the v3 `vendor/` folder is intact on the live server.

---

## 5. File and Folder Structure (Map)

```text
c:\xampp\htdocs\zakprintingV4\
│
├── .env                  # [SECURE] DB credentials (DO NOT COMMIT)
├── .htaccess             # [ROUTING] Protects config, routes /api/ traffic, handles HTML fallbacks
├── index.php             # [REDIRECT] Points root domain to Frontend-public/home.html
├── v4_migration.sql      # [SCHEMA] Safe additive SQL to run on top of v3 database
│
├── config/               
│   ├── app.php           # App-wide constants (Timezone, APP_URL)
│   └── database.php      # Connects PDO using .env
│
├── api/                  # [CORE] Public API Logic
│   ├── _helpers.php      # Required by all APIs -> getBody(), respond(), err()
│   ├── auth.php          # Public Customer login logic
│   ├── products.php      # Feeds shop.html with catalog data
│   ├── ...               # Other public data endpoints
│   │
│   └── admin/            # [CORE] Admin API Logic
│       ├── _guard.php    # RBAC Engine -> requireAdmin(), scopeToUser()
│       ├── auth.php      # Admin login/session validation
│       ├── dashboard.php # Aggregates metrics for admin-dash.html
│       ├── pdf.php       # Generates PDFs / verifies public WhatsApp tokens
│       └── ...           # Invoice, quotation, user, setting CRUD controllers
│
├── Frontend-public/      # [UI] Static Customer Facing Pages
│   ├── js/   
│   │   ├── api.js        # Global fetch wrapper for public APIs
│   │   └── auth-guard.js # Protects user-dash.html by bouncing unauthenticated traffic
│   └── *.html            # 15 HTML Templates injected with JS
│
├── Frontend-admin/       # [UI] Static Staff Facing Pages
│   ├── js/   
│   │   ├── admin-api.js  # Global fetch wrapper for admin APIs (injects formatPKR, date formatters)
│   │   └── admin-auth.js # Checks session/role, hides super-admin buttons, bounces to admin-login
│   ├── admin-login.html  # Secure entry point built from scratch
│   └── *.html            # 20 HTML Templates injected with JS
│
├── storage/              # JSON settings storage (SMTP passwords, WhatsApp API keys)
├── uploads/cms/          # Publicly accessible folder for Content Studio images
│
└── zakprintingv3/        # [LEGACY] The old V3 application.
    └── vendor/           # **CRITICAL**: Reused to load PHPMailer & Dompdf without running `composer install`.
```
