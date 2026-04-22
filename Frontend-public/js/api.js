/**
 * Frontend-public/js/api.js
 * Shared fetch wrapper for all public-facing pages.
 * Usage:
 *   const { products } = await apiFetch('/products.php');
 *   await apiFetch('/contact.php', { method: 'POST', data: formObj });
 */

const BASE_URL = (() => {
  // Resolve project base from script path so routing works in root and subfolder deployments.
  const script = document.currentScript
    || Array.from(document.scripts).find((s) => (s.src || '').includes('/Frontend-public/js/api.js'));

  if (script && script.src) {
    const u = new URL(script.src, window.location.href);
    const marker = '/Frontend-public/js/api.js';
    const idx = u.pathname.indexOf(marker);
    if (idx !== -1) {
      const projectBase = u.pathname.slice(0, idx);
      return (projectBase || '') + '/api';
    }
  }

  const path = window.location.pathname;
  const frontIdx = path.indexOf('/Frontend-public/');
  if (frontIdx !== -1) {
    return path.slice(0, frontIdx) + '/api';
  }

  return '/api';
})();

/**
 * Core fetch wrapper.
 * @param {string} path    - e.g. '/products.php' or '/products.php?id=5'
 * @param {object} options - { method, data, ... }
 */
async function apiFetch(path, options = {}) {
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

  try {
    const res = await fetch(BASE_URL + path, fetchOpts);
    const json = await res.json().catch(() => ({}));

    if (!res.ok) {
      throw new ApiError(json.error || `HTTP ${res.status}`, res.status);
    }
    return json;
  } catch (err) {
    if (err instanceof ApiError) throw err;
    throw new ApiError('Network error. Please check your connection.', 0);
  }
}

class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.status = status;
    this.name   = 'ApiError';
  }
}

/** Show a toast notification */
function showToast(message, type = 'info') {
  const toast = document.createElement('div');
  toast.className = `zp-toast zp-toast--${type}`;
  toast.textContent = message;
  toast.style.cssText = `
    position:fixed; bottom:24px; right:24px; z-index:9999;
    background:${type === 'error' ? '#ef4444': type === 'success' ? '#22c55e' : '#3b82f6'};
    color:#fff; padding:12px 20px; border-radius:8px;
    font-family:Inter,sans-serif; font-size:14px; box-shadow:0 4px 12px rgba(0,0,0,.2);
    animation: slideIn .3s ease;
  `;
  document.body.appendChild(toast);
  setTimeout(() => toast.remove(), 4000);
}

function buildQuoteUrl(product = {}, options = {}) {
  const params = new URLSearchParams();
  params.set('intent', 'quote');
  if (product.id != null) params.set('product_id', String(product.id));
  if (product.title) params.set('product', String(product.title));
  if (product.handle) params.set('handle', String(product.handle));
  if (options.quantity) params.set('quantity', String(options.quantity));
  if (options.size) params.set('size', String(options.size));
  if (options.material) params.set('material', String(options.material));
  if (options.finishes) {
    const finishes = Array.isArray(options.finishes) ? options.finishes.filter(Boolean).join(', ') : String(options.finishes).trim();
    if (finishes) params.set('finishes', finishes);
  }
  return `contact.html?${params.toString()}`;
}

function buildWhatsAppUrl(product = {}, options = {}) {
  const phone = String(options.phone || '923096554946').replace(/\D/g, '');
  const title = String(product.title || product.name || 'this product').trim();
  const handle = String(product.handle || '').trim();
  const size = String(options.size || '').trim();
  const finishes = Array.isArray(options.finishes)
    ? options.finishes.filter(Boolean).join(', ')
    : String(options.finishes || '').trim();
  const quantity = options.quantity ? String(options.quantity).trim() : '';

  const parts = [
    `Hi ZAK Printing, I want to discuss ${title}.`,
  ];
  if (handle) parts.push(`Handle: ${handle}.`);
  if (quantity) parts.push(`Quantity: ${quantity}.`);
  if (size) parts.push(`Size: ${size}.`);
  if (finishes) parts.push(`Options: ${finishes}.`);
  parts.push('Please share a quote.');

  const message = encodeURIComponent(parts.join(' '));
  return `https://wa.me/${phone}?text=${message}`;
}

/** Check if user is authenticated */
async function getSession() {
  try {
    return await apiFetch('/auth.php');
  } catch {
    return { authenticated: false };
  }
}

window.apiFetch  = apiFetch;
window.showToast = showToast;
window.getSession = getSession;
window.ApiError  = ApiError;
window.buildQuoteUrl = buildQuoteUrl;
window.buildWhatsAppUrl = buildWhatsAppUrl;
