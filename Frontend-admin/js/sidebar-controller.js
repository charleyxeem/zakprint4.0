(function () {
  if (window.__adminSidebarControllerInitialized) {
    return;
  }
  window.__adminSidebarControllerInitialized = true;

  var adminUrl = function (target) {
    if (typeof window.adminRouteUrl === 'function') {
      return window.adminRouteUrl(target);
    }
    return target;
  };

  var ADMIN_ROUTE_MAP = {
    'admin-dash.html': '/admin/dashboard',
    'invoice-list.html': '/admin/invoices',
    'quotation-list.html': '/admin/quotations',
    'product-inventory.html': '/admin/products',
    'my-earning.html': '/admin/earnings',
    'general-settings.html': '/admin/settings',
    'billing-settings.html': '/admin/billing-settings',
    'cash-ledger.html': '/admin/cash-ledger',
    'appointments.html': '/admin/appointments',
    'queries.html': '/admin/queries',
    'security.html': '/admin/security',
    'smtp-config.html': '/admin/smtp',
    'whatsapp-config.html': '/admin/whatsapp',
    'user-mgmt.html': '/admin/users',
    'content studio.html': '/admin/content-studio',
    'content%20studio.html': '/admin/content-studio',
    'content-studio.html': '/admin/content-studio',
    'password-reset.html': '/admin/password-reset',
    'create-invoice.html': '/admin/create-invoice',
    'create-quotation.html': '/admin/create-quotation',
    'invoice-view.html': '/admin/invoice-view',
    'quotation-view.html': '/admin/quotation-view',
    'create-user-modal.html': '/admin/create-user',
    'record-payment-modal.html': '/admin/record-payment',
    'product-editor.html': '/admin/product-editor',
    'admin-login.html': '/admin/login'
  };

  var CANONICAL_LINKS = [
    { href: '/admin/dashboard', icon: 'grid_view', label: 'Dashboard' },
    { href: '/admin/invoices', icon: 'description', label: 'Invoices' },
    { href: '/admin/quotations', icon: 'request_quote', label: 'Quotations' },
    { href: '/admin/products', icon: 'inventory_2', label: 'Products' },
    { href: '/admin/earnings', icon: 'payments', label: 'Earnings' },
    { href: '/admin/settings', icon: 'settings', label: 'Settings' },
    { href: '/admin/billing-settings', icon: 'payments', label: 'Billing Settings' },
    { href: '/admin/cash-ledger', icon: 'account_balance', label: 'Cash Ledger' },
    { href: '/admin/appointments', icon: 'event', label: 'Appointments' },
    { href: '/admin/queries', icon: 'mail', label: 'Queries' },
    { href: '/admin/security', icon: 'security', label: 'Security' },
    { href: '/admin/smtp', icon: 'alternate_email', label: 'SMTP Config' },
    { href: '/admin/whatsapp', icon: 'chat', label: 'WhatsApp Config' },
    { href: '/admin/users', icon: 'group', label: 'Users', superOnly: true },
    { href: '/admin/content-studio', icon: 'brush', label: 'Content Studio', superOnly: true }
  ];

  var STORAGE_KEY = 'adminSidebarCollapsed';
  var STORAGE_MANUAL_KEY = 'adminSidebarManual';
  var AUTO_BREAKPOINT = 1200;
  var EXPANDED_WIDTH = 288;
  var COLLAPSED_WIDTH = 88;

  function isSuperAdmin() {
    return !!(window.adminUser && window.adminUser.isSuperAdmin);
  }

  function normalizeAdminRoute(pathname) {
    var rawPath = String(pathname || '').toLowerCase();
    if (!rawPath || rawPath.endsWith('/') || rawPath.endsWith('/index.php') || rawPath.endsWith('/index.html')) {
      return '/admin/dashboard';
    }

    var fileName = rawPath.split('/').pop() || 'admin-dash.html';
    var cleanName = fileName.replace(/\.html$/, '');

    if (ADMIN_ROUTE_MAP[fileName]) {
      return ADMIN_ROUTE_MAP[fileName];
    }

    if (ADMIN_ROUTE_MAP[cleanName + '.html']) {
      return ADMIN_ROUTE_MAP[cleanName + '.html'];
    }

    if (rawPath.indexOf('/admin/') !== -1) {
      return rawPath;
    }

    return '/admin/' + cleanName;
  }

  function findSidebar() {
    var byId = document.getElementById('sidebar-nav');
    if (byId && byId.tagName && byId.tagName.toLowerCase() === 'aside') {
      return byId;
    }

    var asides = Array.prototype.slice.call(document.querySelectorAll('aside'));
    for (var i = 0; i < asides.length; i += 1) {
      var aside = asides[i];
      var nav = aside.querySelector('nav');
      if (!nav) {
        continue;
      }
      var hasAdminLink = !!nav.querySelector('a[href*="admin-dash.html"],a[href*="/admin/dashboard"],a[href*="invoice-list.html"],a[href*="/admin/invoices"]');
      if (hasAdminLink) {
        aside.id = aside.id || 'sidebar-nav';
        return aside;
      }
    }

    return null;
  }

  function shouldSkipInject() {
    var path = (window.location.pathname || '').toLowerCase();
    var skips = [
      '/admin/login',
      '/frontend-admin/admin-login.html',
      '/frontend-admin/create-user-modal.html',
      '/frontend-admin/record-payment-modal.html',
      '/frontend-admin/content%20studio.html',
      '/frontend-admin/content studio.html',
      '/frontend-admin/password-reset.html'
    ];

    for (var i = 0; i < skips.length; i += 1) {
      if (path.indexOf(skips[i]) !== -1) {
        return true;
      }
    }

    return false;
  }

  function ensureSidebarForPage() {
    var existing = findSidebar();
    if (existing) {
      return existing;
    }

    if (shouldSkipInject()) {
      return null;
    }

    var aside = document.createElement('aside');
    aside.id = 'sidebar-nav';
    aside.className = 'w-72 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 flex flex-col fixed lg:relative h-full lg:h-auto z-40 lg:z-auto -translate-x-full lg:translate-x-0 transition-transform duration-300 overflow-y-auto';
    aside.innerHTML = '' +
      '<div class="p-6">' +
      '  <div class="flex items-center gap-3 mb-8">' +
      '    <div class="size-10 rounded-lg bg-primary flex items-center justify-center text-white">' +
      '      <span class="material-symbols-outlined">dashboard</span>' +
      '    </div>' +
      '    <div>' +
      '      <h1 class="text-slate-900 dark:text-slate-100 font-bold text-lg leading-none">Admin Panel</h1>' +
      '      <p class="text-slate-500 dark:text-slate-400 text-xs mt-1">Dashboard</p>' +
      '    </div>' +
      '  </div>' +
      '  <nav class="space-y-1"></nav>' +
      '</div>' +
      '<div class="mt-auto p-6 border-t border-slate-200 dark:border-slate-800 sidebar-footer">' +
      '  <div class="text-center">' +
      '    <p class="text-xs font-medium text-slate-600 dark:text-slate-400 mb-1">v4.0</p>' +
      '    <p class="text-xs text-slate-500 dark:text-slate-400">Design and Developed by</p>' +
      '    <a href="http://theamadeuslab.com" target="_blank" class="text-xs font-semibold text-primary hover:underline">Amadeus Lab</a>' +
      '  </div>' +
      '</div>';

    var host = document.querySelector('body > .layout-container') || document.body;
    host.insertBefore(aside, host.firstChild);

    if (!document.getElementById('sidebar-overlay')) {
      var overlay = document.createElement('div');
      overlay.id = 'sidebar-overlay';
      overlay.className = 'hidden lg:hidden fixed inset-0 z-30 bg-black/50';
      document.body.appendChild(overlay);
    }

    if (!document.getElementById('sidebar-toggle') && !document.getElementById('mobile-menu-toggle')) {
      var mobileToggle = document.createElement('button');
      mobileToggle.id = 'sidebar-toggle';
      mobileToggle.className = 'fixed bottom-6 right-6 z-40 lg:hidden p-3 min-h-12 min-w-12 flex items-center justify-center bg-primary text-white rounded-full shadow-lg hover:scale-110 transition-transform';
      mobileToggle.setAttribute('aria-label', 'Toggle sidebar menu');
      mobileToggle.innerHTML = '<span class="material-symbols-outlined">menu</span>';
      document.body.appendChild(mobileToggle);
    }

    return aside;
  }

  function injectStyles() {
    if (document.getElementById('sidebar-controller-styles')) {
      return;
    }

    var style = document.createElement('style');
    style.id = 'sidebar-controller-styles';
    style.textContent = [
      'aside[data-admin-sidebar]{transition:width .2s ease,min-width .2s ease;overflow-y:auto;overflow-x:hidden;height:auto;min-height:100%;align-self:stretch;}',
      'aside[data-admin-sidebar] nav a{transition:all .2s ease;}',
      'body.sidebar-collapsed aside[data-admin-sidebar]{width:' + COLLAPSED_WIDTH + 'px !important;min-width:' + COLLAPSED_WIDTH + 'px !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar]:hover{width:' + EXPANDED_WIDTH + 'px !important;min-width:' + EXPANDED_WIDTH + 'px !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar] .sidebar-brand-text,',
      'body.sidebar-collapsed aside[data-admin-sidebar] .sidebar-footer{display:none !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar]:hover .sidebar-brand-text,',
      'body.sidebar-collapsed aside[data-admin-sidebar]:hover .sidebar-footer{display:block !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar] nav a{justify-content:center;padding-left:.75rem;padding-right:.75rem;}',
      'body.sidebar-collapsed aside[data-admin-sidebar] nav a span + span{display:none !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar]:hover nav a{justify-content:flex-start;padding-left:1rem;padding-right:1rem;}',
      'body.sidebar-collapsed aside[data-admin-sidebar]:hover nav a span + span{display:inline !important;}',
      'body.sidebar-collapsed aside[data-admin-sidebar] nav a[data-logout]{margin-top:.5rem;}',
      '.sidebar-toggle-wrap{display:flex;justify-content:flex-end;margin-bottom:.75rem;}',
      '#sidebarToggleBtn{display:inline-flex;align-items:center;justify-content:center;width:2.5rem;height:2.5rem;border-radius:.5rem;}',
      '#sidebarToggleBtn:hover{background:rgba(15,23,42,.08);}',
      'aside[data-admin-sidebar]::-webkit-scrollbar{width:8px;}',
      'aside[data-admin-sidebar]::-webkit-scrollbar-thumb{background:rgba(100,116,139,.4);border-radius:999px;}',
      'aside[data-admin-sidebar]::-webkit-scrollbar-track{background:transparent;}'
    ].join('\n');

    document.head.appendChild(style);
  }

  function normalizeSidebarNav(sidebar) {
    var nav = sidebar.querySelector('nav');
    if (!nav) {
      nav = document.createElement('nav');
      nav.className = 'space-y-1';
      var block = sidebar.firstElementChild || sidebar;
      block.appendChild(nav);
    }

    var current = normalizeAdminRoute(window.location.pathname || '');
    nav.innerHTML = '';

    for (var i = 0; i < CANONICAL_LINKS.length; i += 1) {
      var item = CANONICAL_LINKS[i];
      if (item.superOnly && !isSuperAdmin()) {
        continue;
      }

      var isActive = current.indexOf(item.href) !== -1;
      var a = document.createElement('a');
      a.href = adminUrl(item.href);
      a.className = isActive
        ? 'flex items-center gap-3 px-4 py-3 rounded-xl bg-primary text-white font-medium'
        : 'flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors';
      if (item.superOnly) {
        a.setAttribute('data-super-only', 'true');
      }
      a.innerHTML = '<span class="material-symbols-outlined">' + item.icon + '</span><span>' + item.label + '</span>';
      nav.appendChild(a);
    }

    var logout = document.createElement('a');
    logout.href = '#';
    logout.setAttribute('data-logout', 'true');
    logout.className = 'flex items-center gap-3 px-4 py-3 rounded-xl text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors mt-4';
    logout.innerHTML = '<span class="material-symbols-outlined">logout</span><span>Logout</span>';
    nav.appendChild(logout);
  }

  function markSidebarParts(sidebar) {
    sidebar.setAttribute('data-admin-sidebar', 'true');

    var brandText = sidebar.querySelector('h1');
    if (brandText && brandText.parentElement) {
      brandText.parentElement.classList.add('sidebar-brand-text');
    }

    var footer = sidebar.querySelector('.mt-auto');
    if (footer) {
      footer.classList.add('sidebar-footer');
    }

    normalizeSidebarNav(sidebar);
  }

  function updateFixedMainMargin(sidebar, collapsed) {
    // Tailwind responsive classes keep "fixed" in classList even when lg:relative wins;
    // rely on computed style so we only offset main when sidebar is truly fixed.
    var main = document.querySelector('main');
    if (!main) {
      return;
    }

      // Layout uses a flex row shell, so offsetting <main> creates a fake spacer.
      // Keep main pinned and let sidebar width/transform handle collapse behavior.
      main.style.transition = 'margin-left .2s ease';
      main.style.marginLeft = '0px';
  }

  function setSidebarWidth(sidebar, widthPx) {
    if (!sidebar) {
      return;
    }

    var px = widthPx + 'px';
    sidebar.style.setProperty('width', px, 'important');
    sidebar.style.setProperty('min-width', px, 'important');
    sidebar.style.setProperty('flex-basis', px, 'important');
    sidebar.style.setProperty('max-width', px, 'important');
  }

  function applyCollapsedState(sidebar, collapsed) {
    document.body.classList.toggle('sidebar-collapsed', collapsed);

    // Enforce actual sidebar box sizing so page-level layout CSS cannot
    // accidentally collapse/expand a neighboring container instead.
    setSidebarWidth(sidebar, collapsed ? COLLAPSED_WIDTH : EXPANDED_WIDTH);

    updateFixedMainMargin(sidebar, collapsed);

    var toggleIcon = document.getElementById('sidebarToggleIcon');
    if (toggleIcon) {
      toggleIcon.textContent = collapsed ? 'menu_open' : 'menu';
    }

    var toggleBtn = document.getElementById('sidebarToggleBtn');
    if (toggleBtn) {
      toggleBtn.setAttribute('aria-pressed', collapsed ? 'true' : 'false');
      toggleBtn.setAttribute('title', collapsed ? 'Expand sidebar' : 'Collapse sidebar');
    }
  }

  function mountToggleButton(sidebar) {
    if (document.getElementById('sidebarToggleBtn')) {
      return;
    }

    var topContainer = sidebar.firstElementChild || sidebar;
    if (!topContainer) {
      return;
    }

    var wrap = document.createElement('div');
    wrap.className = 'sidebar-toggle-wrap';

    var button = document.createElement('button');
    button.type = 'button';
    button.id = 'sidebarToggleBtn';
    button.className = 'text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800';
    button.setAttribute('aria-label', 'Toggle sidebar');
    button.innerHTML = '<span id="sidebarToggleIcon" class="material-symbols-outlined">menu</span>';

    wrap.appendChild(button);
    topContainer.insertBefore(wrap, topContainer.firstChild);

    button.addEventListener('click', function () {
      var next = !document.body.classList.contains('sidebar-collapsed');
      applyCollapsedState(sidebar, next);
      localStorage.setItem(STORAGE_KEY, next ? '1' : '0');
      localStorage.setItem(STORAGE_MANUAL_KEY, '1');
    });
  }

  function resolveInitialState() {
    var manual = localStorage.getItem(STORAGE_MANUAL_KEY) === '1';
    var stored = localStorage.getItem(STORAGE_KEY);

    // Always start expanded on desktop to avoid hidden/collapsed first paint confusion.
    if (window.innerWidth >= AUTO_BREAKPOINT) {
      return false;
    }

    if (manual && (stored === '1' || stored === '0')) {
      return stored === '1';
    }

    return true;
  }

  function mountAutoResize(sidebar) {
    window.addEventListener('resize', function () {
      var manual = localStorage.getItem(STORAGE_MANUAL_KEY) === '1';
      if (!manual) {
        var autoCollapsed = window.innerWidth < AUTO_BREAKPOINT;
        applyCollapsedState(sidebar, autoCollapsed);
        localStorage.setItem(STORAGE_KEY, autoCollapsed ? '1' : '0');
      } else {
        applyCollapsedState(sidebar, document.body.classList.contains('sidebar-collapsed'));
      }
    });
  }

  function mountDesktopHoverExpand(sidebar) {
    if (!sidebar || sidebar.dataset.sidebarHoverBound === 'true') {
      return;
    }

    sidebar.dataset.sidebarHoverBound = 'true';

    sidebar.addEventListener('mouseenter', function () {
      if (window.innerWidth < AUTO_BREAKPOINT) {
        return;
      }

      if (document.body.classList.contains('sidebar-collapsed')) {
        setSidebarWidth(sidebar, EXPANDED_WIDTH);
      }
    });

    sidebar.addEventListener('mouseleave', function () {
      if (window.innerWidth < AUTO_BREAKPOINT) {
        return;
      }

      if (document.body.classList.contains('sidebar-collapsed')) {
        setSidebarWidth(sidebar, COLLAPSED_WIDTH);
      }
    });
  }

  function mountMobileSidebarToggle() {
    var toggle = document.getElementById('sidebar-toggle') || document.getElementById('mobile-menu-toggle');
    var overlay = document.getElementById('sidebar-overlay');
    var nav = document.getElementById('sidebar-nav');

    if (!toggle || !overlay || !nav) {
      return;
    }

    if (toggle.dataset.sidebarBound === 'true') {
      return;
    }

    toggle.dataset.sidebarBound = 'true';
    overlay.onclick = null;
    toggle.setAttribute('aria-expanded', 'false');

    toggle.addEventListener('click', function (event) {
      event.preventDefault();
      event.stopImmediatePropagation();

      var open = overlay.classList.contains('hidden');
      if (open) {
        overlay.classList.remove('hidden');
        nav.classList.remove('-translate-x-full');
        toggle.setAttribute('aria-expanded', 'true');
      } else {
        overlay.classList.add('hidden');
        nav.classList.add('-translate-x-full');
        toggle.setAttribute('aria-expanded', 'false');
      }
    }, true);

    overlay.addEventListener('click', function () {
      overlay.classList.add('hidden');
      nav.classList.add('-translate-x-full');
      toggle.setAttribute('aria-expanded', 'false');
    }, true);
  }

  function mountLogoutHandler() {
    document.addEventListener('click', async function (event) {
      var target = event.target && event.target.closest ? event.target.closest('[data-logout]') : null;
      if (!target) {
        return;
      }

      event.preventDefault();

      try {
        if (typeof window.adminFetch === 'function') {
          await window.adminFetch('/auth.php', { method: 'DELETE' });
        }
      } catch (e) {
        // no-op
      }

      window.location.href = adminUrl('/admin/login');
    });
  }

  function init() {
    var sidebar = ensureSidebarForPage();
    if (!sidebar) {
      return;
    }

    injectStyles();
    markSidebarParts(sidebar);
    mountToggleButton(sidebar);

    var collapsed = resolveInitialState();
    applyCollapsedState(sidebar, collapsed);
    localStorage.setItem(STORAGE_KEY, collapsed ? '1' : '0');

    mountAutoResize(sidebar);
    mountDesktopHoverExpand(sidebar);
    mountMobileSidebarToggle();
    mountLogoutHandler();

    var syncSidebarHeight = function () {
      var docHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight, window.innerHeight);
      sidebar.style.minHeight = docHeight + 'px';
    };

    syncSidebarHeight();
    window.addEventListener('resize', syncSidebarHeight);
    setTimeout(syncSidebarHeight, 120);

    setTimeout(function () {
      normalizeSidebarNav(sidebar);
    }, 400);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
