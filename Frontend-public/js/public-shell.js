(function () {
  const MATERIAL_SYMBOL_FALLBACKS = {
    admin_panel_settings: '🛡️',
    dashboard: '🏠',
    grid_view: '▦',
    description: '📄',
    request_quote: '📝',
    inventory_2: '📦',
    payments: '💳',
    group: '👥',
    settings: '⚙️',
    brush: '🖌️',
    logout: '🚪',
    menu: '☰',
    search: '🔍',
    notifications: '🔔',
    chat_bubble: '💬',
    add_circle: '➕',
    post_add: '➕',
    event: '📅',
    more_horiz: '⋯',
    chevron_right: '›',
    pending_actions: '⏳',
    person_add: '👤',
    mail: '✉️',
    lock: '🔒',
    visibility: '👁️',
    login: '↪',
    shield: '🛡️',
    print: '🖨️',
    person: '👤',
    shopping_cart: '🛒',
    verified_user: '✅',
    workspace_premium: '🏆',
    history_edu: '🎓',
    handshake: '🤝',
    groups: '👥',
    send: '📨',
    local_shipping: '🚚',
    verified: '✅',
    info: 'ℹ️',
    build: '🛠️',
    help: '❓',
    gavel: '⚖️',
    storefront: '🏪',
    photo_library: '🖼️',
  };

  function applyMaterialSymbolFallbacks() {
    const spans = document.querySelectorAll('.material-symbols-outlined');
    spans.forEach((span) => {
      const iconName = span.textContent.trim();
      const fallback = MATERIAL_SYMBOL_FALLBACKS[iconName];
      if (!fallback || span.dataset.iconFallbackApplied === 'true') {
        return;
      }

      span.textContent = fallback;
      span.style.fontFamily = 'Segoe UI Emoji, Apple Color Emoji, Noto Color Emoji, sans-serif';
      span.style.fontWeight = '400';
      span.dataset.iconFallbackApplied = 'true';
    });
  }

  if (document.fonts && typeof document.fonts.check === 'function') {
    document.fonts.ready.then(() => {
      if (!document.fonts.check('24px "Material Symbols Outlined"')) {
        applyMaterialSymbolFallbacks();
      }
    });
  } else {
    applyMaterialSymbolFallbacks();
  }

  function ensureMaterialSymbolsFont() {
    if (typeof document === 'undefined' || !document.head) {
      return;
    }

    if (!document.querySelector('link[data-material-symbols-outlined]')) {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@100..700&display=swap';
      link.setAttribute('data-material-symbols-outlined', 'true');
      document.head.appendChild(link);
    }

    if (!document.getElementById('material-symbols-outlined-fix')) {
      const style = document.createElement('style');
      style.id = 'material-symbols-outlined-fix';
      style.textContent = '.material-symbols-outlined{font-family:"Material Symbols Outlined" !important;font-weight:normal;font-style:normal;font-size:24px;line-height:1;letter-spacing:normal;text-transform:none;display:inline-block;white-space:nowrap;word-wrap:normal;direction:ltr;-webkit-font-feature-settings:"liga";-webkit-font-smoothing:antialiased}';
      document.head.appendChild(style);
    }
  }

  ensureMaterialSymbolsFont();

  function getBasePrefix() {
    const path = window.location.pathname || '/';
    const publicIdx = path.toLowerCase().indexOf('/frontend-public/');
    if (publicIdx !== -1) {
      return path.slice(0, publicIdx) || '';
    }

    const marker = /\/(home|shop|services|about|contact|blog|appointment|product-detail|checkout|order-confirm|user-login|user-dash|user-my-order|user-my-settings|faq|portfolio|privacy-policy|terms|shipping-info)(?:\.html)?(?:\/|$)/i;
    const match = path.match(marker);
    if (match && typeof match.index === 'number') {
      return path.slice(0, match.index) || '';
    }

    const htmlMarker = /\.html(?:\/|$)/i;
    const htmlMatch = path.match(htmlMarker);
    if (htmlMatch && typeof htmlMatch.index === 'number') {
      return path.slice(0, htmlMatch.index) || '';
    }

    return '';
  }

  const BASE_PREFIX = getBasePrefix();
  const withBase = (route) => `${BASE_PREFIX}${route}`;

  const PUBLIC_ROUTE_MAP = {
    'home': '/home',
    'home.html': '/home',
    'shop': '/shop',
    'shop.html': '/shop',
    'services': '/services',
    'services.html': '/services',
    'about': '/about',
    'about.html': '/about',
    'contact': '/contact',
    'contact.html': '/contact',
    'blog': '/blog',
    'blog.html': '/blog',
    'appointment': '/appointment',
    'appointment.html': '/appointment',
    'product-detail': '/product-detail',
    'product-detail.html': '/product-detail',
    'checkout': '/checkout',
    'checkout.html': '/checkout',
    'order-confirm': '/order-confirm',
    'order-confirm.html': '/order-confirm',
    'user-login': '/user-login',
    'user-login.html': '/user-login',
    'user-dash': '/user-dash',
    'user-dash.html': '/user-dash',
    'user-my-order': '/user-my-order',
    'user-my-order.html': '/user-my-order',
    'user-my-settings': '/user-my-settings',
    'user-my-settings.html': '/user-my-settings',
    'faq': '/faq',
    'faq.html': '/faq',
    'portfolio': '/portfolio',
    'portfolio.html': '/portfolio',
    'privacy-policy': '/privacy-policy',
    'privacy-policy.html': '/privacy-policy',
    'terms': '/terms',
    'terms.html': '/terms',
    'shipping-info': '/shipping-info',
    'shipping-info.html': '/shipping-info'
  };

  function normalizePublicRoute(pathname) {
    const rawPath = String(pathname || '').toLowerCase();
    if (!rawPath || rawPath.endsWith('/') || rawPath.endsWith('/index.php') || rawPath.endsWith('/index.html')) {
      return '/home';
    }

    const fileName = rawPath.split('/').pop() || 'home';
    const withoutExtension = fileName.replace(/\.html$/, '');
    return PUBLIC_ROUTE_MAP[fileName] || PUBLIC_ROUTE_MAP[withoutExtension] || (withoutExtension.startsWith('/') ? withoutExtension : '/' + withoutExtension);
  }

  function publicHref(route) {
    return PUBLIC_ROUTE_MAP[route.replace(/^\//, '')] || route;
  }

  const pageKey = (() => {
    return normalizePublicRoute(window.location.pathname);
  })();

  const pages = [
    { file: '/home', label: 'Home', href: withBase('/home') },
    { file: '/shop', label: 'Shop', href: withBase('/shop') },
    { file: '/services', label: 'Services', href: withBase('/services') },
    { file: '/about', label: 'About', href: withBase('/about') },
    { file: '/contact', label: 'Contact', href: withBase('/contact') },
  ];

  const BRAND = {
    primary: '#ec5b13',
    primarySoft: 'rgba(236, 91, 19, 0.12)',
    primaryBorder: 'rgba(236, 91, 19, 0.18)',
    surfaceLight: 'rgba(248, 246, 246, 0.8)',
    surfaceDark: 'rgba(34, 22, 16, 0.8)',
    text: '#0f172a',
    textMuted: '#475569',
    shadow: '0 12px 28px rgba(236, 91, 19, 0.18)',
    shadowSoft: '0 10px 24px rgba(15, 23, 42, 0.08)',
  };

  const navMarkup = pages.map((page) => {
    const active = page.file === pageKey;
    const className = active
      ? 'text-primary font-bold'
      : 'text-slate-600 dark:text-slate-400 font-medium hover:text-primary dark:hover:text-primary';
    return `<a class="${className} text-sm transition-colors" href="${page.href}">${page.label}</a>`;
  }).join('');

  const headerMarkup = `
    <header class="sticky top-0 z-50 backdrop-blur-md border-b px-6 lg:px-20 py-3" style="background:${BRAND.surfaceLight};border-color:rgba(203,213,225,0.9);font-family:'Public Sans', sans-serif;">
      <div class="max-w-7xl mx-auto flex items-center justify-between whitespace-nowrap gap-6">
        <div class="flex items-center gap-8">
          <a class="flex items-center gap-3" href="${withBase('/home')}" aria-label="ZAK Printing home" style="color:${BRAND.primary};">
            <div class="size-8 flex items-center justify-center rounded-lg text-white" style="background:${BRAND.primary};box-shadow:${BRAND.shadow};">
              <svg viewBox="0 0 24 24" aria-hidden="true" class="h-4.5 w-4.5 fill-current">
                <path d="M7 7V4h10v3H7Zm10 2H7a4 4 0 0 0-4 4v4h3v3h12v-3h3v-4a4 4 0 0 0-4-4Zm-2 9H9v-4h6v4Zm2-7.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3Z"/>
              </svg>
            </div>
            <h2 class="text-xl font-bold leading-tight tracking-tight" style="color:${BRAND.text};">ZAK Printing</h2>
          </a>
          <nav class="hidden lg:flex items-center gap-8">
            ${navMarkup}
          </nav>
        </div>
        <div class="flex items-center gap-4">
          <div class="hidden md:flex items-center rounded-xl px-3 py-1.5 border transition-all" style="background:rgba(255,255,255,0.72);border-color:transparent;box-shadow:${BRAND.shadowSoft};">
            <svg aria-hidden="true" class="h-[18px] w-[18px]" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" style="color:${BRAND.textMuted};">
              <circle cx="11" cy="11" r="6.5" stroke="currentColor" stroke-width="1.8"></circle>
              <path d="M16 16 20 20" stroke="currentColor" stroke-linecap="round" stroke-width="1.8"></path>
            </svg>
            <input class="bg-transparent border-none focus:ring-0 text-sm w-32 xl:w-48 placeholder:text-slate-400" placeholder="Search products..." type="text" />
          </div>
          <div class="flex items-center gap-2">
            <a class="p-2 rounded-xl transition-colors" href="${withBase('/user-login')}" aria-label="Account" style="color:${BRAND.textMuted};">
              <svg aria-hidden="true" class="h-6 w-6" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12" cy="8" r="3.2" stroke="currentColor" stroke-width="1.8"></circle>
                <path d="M5.5 19c1.5-3 4.1-4.5 6.5-4.5s5 1.5 6.5 4.5" stroke="currentColor" stroke-linecap="round" stroke-width="1.8"></path>
              </svg>
            </a>
            <a class="p-2 rounded-xl transition-colors relative" href="${withBase('/shop')}" aria-label="Cart" style="color:${BRAND.textMuted};">
              <svg aria-hidden="true" class="h-6 w-6" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <circle cx="10" cy="18" fill="currentColor" r="1.5"></circle>
                <circle cx="17" cy="18" fill="currentColor" r="1.5"></circle>
                <path d="M3.8 5.5h2.5l1.8 8h9.2l2.1-6.2H7.1" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8"></path>
              </svg>
              <span class="absolute top-1 right-1 size-2 rounded-full" style="background:${BRAND.primary};"></span>
            </a>
            <button id="mobile-menu-toggle" class="lg:hidden p-2.5 min-h-10 min-w-10 flex items-center justify-center rounded-lg transition-colors" aria-label="Menu" aria-expanded="false" type="button" style="color:${BRAND.textMuted};">
              <svg aria-hidden="true" class="h-6 w-6" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-linecap="round" stroke-width="1.8"></path>
              </svg>
            </button>
          </div>
          <a class="hidden sm:flex items-center justify-center px-5 py-2.5 text-white text-sm font-bold rounded-xl hover:scale-[1.02] active:scale-[0.98] transition-all" href="${withBase('/appointment')}" style="background:${BRAND.primary};box-shadow:${BRAND.shadow};">
            Book an Appointment
          </a>
        </div>
      </div>
    </header>`;

  const footerMarkup = `
    <footer class="bg-white dark:bg-slate-950 px-6 lg:px-20 py-16 border-t border-slate-200 dark:border-slate-800">
      <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12">
        <div class="space-y-6">
          <div class="flex items-center gap-3 text-primary">
            <div class="size-8 flex items-center justify-center bg-primary text-white rounded-lg">
              <svg aria-hidden="true" class="h-4.5 w-4.5 fill-current" viewBox="0 0 24 24">
                <path d="M7 7V4h10v3H7Zm10 2H7a4 4 0 0 0-4 4v4h3v3h12v-3h3v-4a4 4 0 0 0-4-4Zm-2 9H9v-4h6v4Zm2-7.5a1.5 1.5 0 1 1 0-3 1.5 1.5 0 0 1 0 3Z"></path>
              </svg>
            </div>
            <h2 class="text-slate-900 dark:text-slate-100 text-xl font-bold">ZAK Printing</h2>
          </div>
          <p class="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">Your one-stop destination for premium printing needs. Quality, precision, and dependable turnaround in every order.</p>
          <div class="flex gap-4">
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="${withBase('/contact')}" aria-label="Social link">
              <span class="material-symbols-outlined sr-only">share</span>
              <svg aria-hidden="true" class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <circle cx="17.5" cy="5.5" r="2" stroke="currentColor" stroke-width="1.8"></circle>
                <circle cx="6.5" cy="12" r="2" stroke="currentColor" stroke-width="1.8"></circle>
                <circle cx="17.5" cy="18.5" r="2" stroke="currentColor" stroke-width="1.8"></circle>
                <path d="m8.2 11 7.2-4.1M8.2 13l7.2 4.1" stroke="currentColor" stroke-linecap="round" stroke-width="1.8"></path>
              </svg>
            </a>
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="${withBase('/contact')}" aria-label="Email us">
              <span class="material-symbols-outlined sr-only">mail</span>
              <svg aria-hidden="true" class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <rect height="12" rx="2" stroke="currentColor" stroke-width="1.8" width="16" x="4" y="6"></rect>
                <path d="m5 8 7 5 7-5" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8"></path>
              </svg>
            </a>
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="${withBase('/contact')}" aria-label="Visit us">
              <span class="material-symbols-outlined sr-only">location_on</span>
              <svg aria-hidden="true" class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 20s6-5 6-10a6 6 0 1 0-12 0c0 5 6 10 6 10Z" stroke="currentColor" stroke-linejoin="round" stroke-width="1.8"></path>
                <circle cx="12" cy="10" r="2.2" stroke="currentColor" stroke-width="1.8"></circle>
              </svg>
            </a>
          </div>
        </div>
        <div>
          <h4 class="text-slate-900 dark:text-white font-bold mb-6">Quick Links</h4>
          <ul class="space-y-4">
            ${pages.map((page) => `<li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="${page.href}">${page.label}</a></li>`).join('')}
          </ul>
        </div>
        <div>
          <h4 class="text-slate-900 dark:text-white font-bold mb-6">Customer Support</h4>
          <ul class="space-y-4">
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="${withBase('/contact')}">Contact Us</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="${withBase('/faq')}">FAQ</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="${withBase('/privacy-policy')}">Privacy Policy</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="${withBase('/shipping-info')}">Shipping Info</a></li>
          </ul>
        </div>
        <div>
          <h4 class="text-slate-900 dark:text-white font-bold mb-6">Newsletter</h4>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Subscribe to get special offers and updates.</p>
          <div class="flex">
            <input class="flex-1 bg-slate-100 dark:bg-slate-800 border-none rounded-l-xl focus:ring-1 focus:ring-primary text-sm px-4" placeholder="Email" type="email" />
            <button class="bg-primary text-white p-3 rounded-r-xl" type="button"><span class="material-symbols-outlined sr-only">send</span><svg aria-hidden="true" class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M4 12 20 4l-4 16-4.4-6.2L4 12Z" stroke="currentColor" stroke-linejoin="round" stroke-width="1.8"></path><path d="m20 4-8.4 9.8" stroke="currentColor" stroke-linecap="round" stroke-width="1.8"></path></svg></button>
          </div>
        </div>
      </div>
      <div class="max-w-7xl mx-auto mt-16 pt-8 border-t border-slate-200 dark:border-slate-800 flex flex-col md:flex-row items-center justify-between gap-4">
        <p class="text-sm text-slate-500 dark:text-slate-400">&copy; 2024 ZAK Printing. All rights reserved.</p>
        <div class="flex gap-6">
          <span class="text-xs text-slate-400">Powered by ZAK Core</span>
        </div>
      </div>
    </footer>`;

  const header = document.querySelector('header');
  if (header) header.outerHTML = headerMarkup;

  const footer = document.querySelector('footer');
  if (footer) footer.outerHTML = footerMarkup;

  applyMaterialSymbolFallbacks();
})();
