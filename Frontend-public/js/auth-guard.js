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
  const session = await getSession();

  if (!session.authenticated) {
    window.location.href = 'user-login.html?redirect=' + encodeURIComponent(window.location.pathname);
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
      window.location.href = 'user-login.html';
    });
  }
})();
