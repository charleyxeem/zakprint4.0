/**
 * Frontend-public/js/auth-guard.js
 * Include on pages that require the user to be logged in.
 * Redirect to login page if not authenticated.
 *
 * Usage (at top of page-specific script):
 *   import './auth-guard.js' or include via <script src="js/auth-guard.js">
 *   after api.js is loaded.
 */
(async () => {
  function getBasePrefix() {
    const path = window.location.pathname || '/';
    const publicIdx = path.toLowerCase().indexOf('/frontend-public/');
    if (publicIdx !== -1) {
      return path.slice(0, publicIdx) || '';
    }

    const marker = /\/(home|shop|services|about|contact|blog|appointment|product-detail|checkout|order-confirm|user-login|user-dash|user-my-order|user-my-settings)(?:\.html)?(?:\/|$)/i;
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

  const session = await getSession();

  if (!session.authenticated) {
    window.location.href = withBase('/user-login') + '?redirect=' + encodeURIComponent(window.location.pathname + window.location.search);
    return;
  }

  // Expose session data globally for the page script
  window.currentUser = {
    id:    session.user_id,
    name:  session.name,
    email: session.email,
    role:  session.role,
  };

  // Populate any .user-name elements
  document.querySelectorAll('[data-user-name]').forEach(el => {
    el.textContent = session.name;
  });

  // Logout button handler
  const logoutBtn = document.getElementById('logoutBtn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', async () => {
      await apiFetch('/auth.php', { method: 'DELETE' });
      window.location.href = withBase('/user-login');
    });
  }
})();
