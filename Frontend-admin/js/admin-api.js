/**
 * Frontend-admin/js/admin-api.js
 * Shared fetch wrapper for all admin dashboard pages.
 * Mirrors public api.js but points to /api/admin/.
 */

const ADMIN_BASE_PREFIX = (() => {
  const path = window.location.pathname || '/';
  const lowerPath = path.toLowerCase();

  const frontIdx = lowerPath.indexOf('/frontend-admin/');
  if (frontIdx !== -1) {
    return path.slice(0, frontIdx) || '';
  }

  const adminIdx = lowerPath.indexOf('/admin/');
  if (adminIdx !== -1) {
    return path.slice(0, adminIdx) || '';
  }

  return '';
})();

(function ensureMaterialSymbolsFont() {
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
})();

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
  alarm: '⏰',
  payments_alt: '💰',
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

const withAdminBase = (route) => `${ADMIN_BASE_PREFIX}${route}`;

const ADMIN_ROUTE_MAP = {
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
  'admin-login.html': '/admin/login',
};

function adminRouteUrl(target) {
  if (!target) return target;
  if (/^(?:[a-z]+:)?\/\//i.test(target) || target.startsWith('#')) return target;

  const raw = String(target).trim();
  const [pathPart, queryPart] = raw.split('?');
  const normalizedPath = pathPart
    .replace(/^\.\//, '')
    .replace(/^\.\.\/admin\//, '')
    .replace(/^admin\//, '')
    .toLowerCase();

  const canonical = raw.startsWith('/admin/')
    ? raw
    : (ADMIN_ROUTE_MAP[normalizedPath] || null);

  if (!canonical) {
    return raw;
  }

  const [canonicalPath, canonicalQuery] = canonical.split('?');
  const q = queryPart || canonicalQuery;
  return withAdminBase(canonicalPath) + (q ? `?${q}` : '');
}

const ADMIN_API_BASE = (() => {
  const script = document.currentScript
    || Array.from(document.scripts).find((s) => (s.src || '').includes('/Frontend-admin/js/admin-api.js'));

  if (script && script.src) {
    const u = new URL(script.src, window.location.href);
    const marker = '/Frontend-admin/js/admin-api.js';
    const idx = u.pathname.indexOf(marker);
    if (idx !== -1) {
      const projectBase = u.pathname.slice(0, idx);
      return (projectBase || '') + '/api/admin';
    }
  }

  const path = window.location.pathname;
  const adminIdx = path.indexOf('/Frontend-admin/');
  if (adminIdx !== -1) {
    return path.slice(0, adminIdx) + '/api/admin';
  }

  return withAdminBase('/api/admin');
})();

async function adminFetch(path, options = {}) {
  const { method = 'GET', data = null, ...rest } = options;

  const hasFormDataBody = typeof FormData !== 'undefined' && (
    (typeof rest.body !== 'undefined' && rest.body instanceof FormData) ||
    (typeof data !== 'undefined' && data instanceof FormData)
  );

  const fetchOpts = {
    method,
    credentials: 'include',
    ...rest,
  };

  if (!hasFormDataBody) {
    fetchOpts.headers = {
      'Content-Type': 'application/json',
      ...(rest.headers || {}),
    };
  }

  if (data && method !== 'GET') {
    if (data instanceof FormData) {
      fetchOpts.body = data;
    } else {
      fetchOpts.body = JSON.stringify(data);
    }
  }

  const res  = await fetch(ADMIN_API_BASE + path, fetchOpts);
  const json = await res.json().catch(() => ({}));

  if (res.status === 401) {
    // Avoid redirect loops when already on the login page.
    const pathName = (window.location.pathname || '').toLowerCase();
    const isLoginPage = pathName.includes('/admin/login') || pathName.includes('/frontend-admin/admin-login.html');
    if (!isLoginPage) {
      window.location.href = adminRouteUrl('/admin/login');
      return;
    }
    throw new Error('Unauthorized');
  }

  if (!res.ok) {
    throw new Error(json.error || `HTTP ${res.status}`);
  }

  return json;
}

/** Show toast (same style as public) */
function showAdminToast(message, type = 'info') {
  const colors = { success: '#22c55e', error: '#ef4444', info: '#6366f1', warning: '#f59e0b' };
  const existing = document.getElementById('admin-toast-active');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.id = 'admin-toast-active';
  toast.style.cssText = `
    position:fixed; top:24px; right:24px; z-index:99999;
    background:${colors[type] || colors.info}; color:#fff;
    padding:12px 22px; border-radius:10px; font-size:14px;
    font-family:Inter,sans-serif; box-shadow:0 6px 20px rgba(0,0,0,.18);
    transition: opacity .3s;
  `;
  toast.textContent = message;
  document.body.appendChild(toast);
  setTimeout(() => { toast.style.opacity = '0'; setTimeout(() => toast.remove(), 300); }, 3500);
}

async function updateAdminNotificationUI() {
  try {
    const res = await adminFetch('/notifications.php');
    const counts = (res && res.counts) || {};
    const totalNew = Number(counts.all_new || 0);

    // Header bell badges
    document.querySelectorAll('.material-symbols-outlined').forEach((icon) => {
      if ((icon.textContent || '').trim() !== 'notifications') return;
      const btn = icon.closest('button');
      if (!btn) return;

      let badge = btn.querySelector('[data-notification-badge]');
      if (!badge) {
        badge = btn.querySelector('span.absolute') || document.createElement('span');
        badge.setAttribute('data-notification-badge', '1');
        badge.className = 'absolute -top-1 -right-1 min-w-[18px] h-[18px] px-1 rounded-full bg-red-500 text-white text-[10px] leading-[18px] text-center font-bold';
        btn.classList.add('relative');
        if (!badge.parentElement) btn.appendChild(badge);
      }

      if (totalNew > 0) {
        badge.textContent = totalNew > 99 ? '99+' : String(totalNew);
        badge.style.display = 'inline-block';
      } else {
        badge.style.display = 'none';
      }
    });

    // Sidebar badges
    const qLinks = document.querySelectorAll('a[href="queries.html"]');
    qLinks.forEach((a) => {
      let b = a.querySelector('[data-query-badge]');
      if (!b) {
        b = document.createElement('span');
        b.setAttribute('data-query-badge', '1');
        b.className = 'ml-auto inline-flex items-center justify-center min-w-[18px] h-[18px] px-1 rounded-full bg-red-500 text-white text-[10px] font-bold';
        a.appendChild(b);
      }
      const n = Number(counts.queries_new || 0);
      b.textContent = n > 99 ? '99+' : String(n);
      b.style.display = n > 0 ? 'inline-flex' : 'none';
    });

    const aLinks = document.querySelectorAll('a[href="appointments.html"]');
    aLinks.forEach((a) => {
      let b = a.querySelector('[data-appointment-badge]');
      if (!b) {
        b = document.createElement('span');
        b.setAttribute('data-appointment-badge', '1');
        b.className = 'ml-auto inline-flex items-center justify-center min-w-[18px] h-[18px] px-1 rounded-full bg-red-500 text-white text-[10px] font-bold';
        a.appendChild(b);
      }
      const n = Number(counts.appointments_new || 0);
      b.textContent = n > 99 ? '99+' : String(n);
      b.style.display = n > 0 ? 'inline-flex' : 'none';
    });
  } catch (e) {
    console.warn('Notification UI update failed:', e);
  }
}

/** Format currency in PKR */
function formatPKR(amount) {
  return 'PKR ' + parseFloat(amount || 0).toLocaleString('ur-PK', { minimumFractionDigits: 2 });
}

/** Format date nicely */
function formatDate(dateStr) {
  if (!dateStr) return '—';
  return new Date(dateStr).toLocaleDateString('en-PK', { day: '2-digit', month: 'short', year: 'numeric' });
}

/** Status badge HTML */
function statusBadge(status) {
  const map = {
    paid:       ['#22c55e', 'Paid'],
    unpaid:     ['#ef4444', 'Unpaid'],
    partial:    ['#f59e0b', 'Partial'],
    draft:      ['#94a3b8', 'Draft'],
    sent:       ['#3b82f6', 'Sent'],
    accepted:   ['#a78bfa', 'Accepted'],
    pending:    ['#f59e0b', 'Pending'],
    processing: ['#3b82f6', 'Processing'],
    completed:  ['#22c55e', 'Completed'],
    cancelled:  ['#ef4444', 'Cancelled'],
  };
  const [color, label] = map[status] || ['#94a3b8', status];
  return `<span style="background:${color}22;color:${color};border:1px solid ${color};padding:2px 10px;border-radius:20px;font-size:12px;font-weight:600;">${label}</span>`;
}

function getAdminDocContextFromRow(row) {
  if (!row) return null;
  const cells = Array.from(row.querySelectorAll('td'));
  if (!cells.length) return null;

  const idText = (cells[1]?.textContent || cells[0]?.textContent || '').trim();
  const invoiceMatch = idText.match(/#?INV[-\w]*?(\d{3,})/i);
  if (invoiceMatch) {
    return { kind: 'invoice', id: invoiceMatch[1] };
  }

  const quoteMatch = idText.match(/#?(?:QT|QUO)[-\w]*?(\d{3,})/i);
  if (quoteMatch) {
    return { kind: 'quotation', id: quoteMatch[1] };
  }

  return null;
}

function routeFromDocContext(ctx, action) {
  if (!ctx) return null;

  if (action === 'view' || action === 'pdf') {
    return ctx.kind === 'quotation'
      ? `quotation-view.html?id=${ctx.id}`
      : `invoice-view.html?id=${ctx.id}`;
  }

  if (action === 'edit' || action === 'renew') {
    return ctx.kind === 'quotation'
      ? `create-quotation.html?edit=${ctx.id}`
      : `create-invoice.html?edit=${ctx.id}`;
  }

  if (action === 'duplicate') {
    return ctx.kind === 'quotation'
      ? `create-quotation.html?duplicate=${ctx.id}`
      : `create-invoice.html?duplicate=${ctx.id}`;
  }

  return null;
}

function initAdminQuickActions() {
  document.addEventListener('click', (event) => {
    const button = event.target.closest('button');
    if (!button) return;

    const icon = button.querySelector('.material-symbols-outlined');
    const iconName = (icon?.textContent || '').trim();
    const title = (button.getAttribute('title') || '').toLowerCase();

    if (button.matches('[data-header-notifications], [data-header-chat], [data-profile-toggle], [data-profile-logout], [data-logout]')) {
      return;
    }

    if (!button.getAttribute('type') && (iconName === 'notifications' || iconName === 'chat_bubble' || iconName === 'settings' || iconName === 'person')) {
      event.preventDefault();
      if (iconName === 'settings' || iconName === 'person') {
        window.location.href = adminRouteUrl('general-settings.html');
        return;
      }
      window.location.href = adminRouteUrl('queries.html');
      return;
    }

    if (button.hasAttribute('onclick') || button.type === 'submit' || button.closest('form')) {
      return;
    }

    let action = null;
    if (title.includes('view') || iconName === 'visibility') action = 'view';
    if (title.includes('edit') || iconName === 'edit') action = 'edit';
    if (title.includes('download') || iconName === 'picture_as_pdf') action = 'pdf';
    if (title.includes('email') || iconName === 'mail' || iconName === 'send') action = 'email';
    if (iconName === 'content_copy') action = 'duplicate';
    if (iconName === 'history') action = 'renew';
    if (button.textContent.trim().toLowerCase() === 'convert') action = 'edit';

    if (!action) return;

    const row = button.closest('tr');
    const ctx = getAdminDocContextFromRow(row);
    if (!ctx) return;

    event.preventDefault();

    if (action === 'email') {
      const subject = encodeURIComponent(`${ctx.kind === 'quotation' ? 'Quotation' : 'Invoice'} #${ctx.id}`);
      window.location.href = `mailto:?subject=${subject}`;
      return;
    }

    const target = routeFromDocContext(ctx, action);
    if (target) {
      window.location.href = adminRouteUrl(target);
    }
  });
}

if (typeof document !== 'undefined') {
  document.addEventListener('DOMContentLoaded', () => {
    initAdminQuickActions();
    updateAdminNotificationUI();
  });
}

window.adminFetch     = adminFetch;
window.showAdminToast = showAdminToast;
window.formatPKR      = formatPKR;
window.formatDate     = formatDate;
window.statusBadge    = statusBadge;
window.updateAdminNotificationUI = updateAdminNotificationUI;
window.withAdminBase = withAdminBase;
window.adminRouteUrl = adminRouteUrl;
