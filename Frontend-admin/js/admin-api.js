/**
 * Frontend-admin/js/admin-api.js
 * Shared fetch wrapper for all admin dashboard pages.
 * Mirrors public api.js but points to /api/admin/.
 */

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

  return '/api/admin';
})();

async function adminFetch(path, options = {}) {
  const { method = 'GET', data = null, ...rest } = options;

  const fetchOpts = {
    method,
    credentials: 'include',
    headers: { 'Content-Type': 'application/json' },
    ...rest,
  };

  if (data && method !== 'GET') {
    fetchOpts.body = JSON.stringify(data);
  }

  const res  = await fetch(ADMIN_API_BASE + path, fetchOpts);
  const json = await res.json().catch(() => ({}));

  if (res.status === 401) {
    // Not authenticated — redirect to admin login
    window.location.href = 'admin-login.html';
    return;
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

window.adminFetch     = adminFetch;
window.showAdminToast = showAdminToast;
window.formatPKR      = formatPKR;
window.formatDate     = formatDate;
window.statusBadge    = statusBadge;
window.updateAdminNotificationUI = updateAdminNotificationUI;

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function () {
    updateAdminNotificationUI();
  });
} else {
  updateAdminNotificationUI();
}
