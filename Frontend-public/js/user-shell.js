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

    const marker = /\/(user-login|user-dash|user-my-order|user-my-settings|home|shop|services|about|contact)(?:\/|$)/i;
    const match = path.match(marker);
    if (match && typeof match.index === 'number') {
      return path.slice(0, match.index) || '';
    }

    return '';
  }

  function normalizeRoute(pathname) {
    const rawPath = String(pathname || '').toLowerCase();
    if (!rawPath || rawPath.endsWith('/') || rawPath.endsWith('/index.php') || rawPath.endsWith('/index.html')) {
      return '/user-dash';
    }

    const fileName = rawPath.split('/').pop() || 'user-dash';
    const routeMap = {
      'user-login': '/user-login',
      'user-login.html': '/user-login',
      'user-dash': '/user-dash',
      'user-dash.html': '/user-dash',
      'user-my-order': '/user-my-order',
      'user-my-order.html': '/user-my-order',
      'user-my-settings': '/user-my-settings',
      'user-my-settings.html': '/user-my-settings',
    };

    return routeMap[fileName] || routeMap[fileName.replace(/\.html$/, '')] || '/user-dash';
  }

  const BASE_PREFIX = getBasePrefix();
  const withBase = (route) => `${BASE_PREFIX}${route}`;
  const pageKey = normalizeRoute(window.location.pathname);
  const userPages = ['/user-login', '/user-dash', '/user-my-order', '/user-my-settings'];
  if (!userPages.includes(pageKey)) return;

  const navMarkup = `
    <a href="${withBase('/home')}" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Home</a>
    <a href="${withBase('/shop')}" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Shop</a>
    <a href="${withBase('/services')}" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Services</a>
    <a href="${withBase('/about')}" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">About</a>
    <a href="${withBase('/contact')}" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Contact</a>`;

  const loginHeader = `
    <header class="flex items-center justify-between whitespace-nowrap border-b border-solid border-primary/10 px-6 md:px-10 py-4 bg-background-light dark:bg-background-dark">
      <div class="flex items-center gap-4 text-slate-900 dark:text-slate-100">
        <a class="bg-primary p-1.5 rounded-lg flex items-center justify-center" href="${withBase('/home')}" aria-label="ZAK Printing home">
          <span class="material-symbols-outlined text-white text-2xl">print</span>
        </a>
        <h2 class="text-xl font-bold leading-tight tracking-tight">ZAK Printing</h2>
      </div>
      <div class="flex items-center gap-6">
        <nav class="hidden md:flex items-center gap-8">
          ${navMarkup}
        </nav>
        <a class="flex min-w-[100px] items-center justify-center rounded-lg h-10 px-5 bg-primary text-white text-sm font-bold shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all" href="${withBase('/contact')}?intent=signup">Sign Up</a>
      </div>
    </header>`;

  const appHeader = `
    <header class="sticky top-0 z-50 border-b border-primary/10 bg-white/90 dark:bg-background-dark/90 backdrop-blur-md">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-6">
        <a href="${withBase('/user-dash')}" class="flex items-center gap-3 text-primary">
          <span class="size-9 rounded-lg bg-primary text-white flex items-center justify-center">
            <span class="material-symbols-outlined">print</span>
          </span>
          <span class="text-lg font-extrabold tracking-tight">ZAK Printing</span>
        </a>
        <nav class="hidden md:flex items-center gap-6">
          ${navMarkup}
        </nav>
        <div class="flex items-center gap-2">
          <a href="${withBase('/shop')}" class="hidden sm:inline-flex items-center px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold hover:bg-primary/90 transition-colors">New Order</a>
          <a href="${withBase('/user-login')}" class="size-10 rounded-full bg-primary/10 text-primary flex items-center justify-center hover:bg-primary/20 transition-colors" aria-label="Account">
            <span class="material-symbols-outlined">person</span>
          </a>
        </div>
      </div>
    </header>`;

  const loginFooter = `
    <footer class="bg-white dark:bg-background-dark border-t border-primary/10 py-8 px-6 md:px-10">
      <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-center gap-6">
        <div class="flex items-center gap-3 opacity-60">
          <div class="bg-primary p-1 rounded-lg">
            <span class="material-symbols-outlined text-white text-xl">print</span>
          </div>
          <span class="text-sm font-medium">&copy; 2024 ZAK Printing Inc. All rights reserved.</span>
        </div>
        <div class="flex gap-8 text-sm font-medium text-slate-500 dark:text-slate-400">
          <a class="hover:text-primary transition-colors" href="${withBase('/contact')}?intent=privacy">Privacy Policy</a>
          <a class="hover:text-primary transition-colors" href="${withBase('/contact')}?intent=terms">Terms of Service</a>
          <a class="hover:text-primary transition-colors" href="${withBase('/contact')}?intent=help">Help Center</a>
        </div>
      </div>
    </footer>`;

  const header = document.querySelector('header');
  if (header) {
    header.outerHTML = pageKey === '/user-login' ? loginHeader : appHeader;
  }

  const footer = document.querySelector('footer');
  if (footer && pageKey === '/user-login') {
    footer.outerHTML = loginFooter;
  }

  applyMaterialSymbolFallbacks();
})();