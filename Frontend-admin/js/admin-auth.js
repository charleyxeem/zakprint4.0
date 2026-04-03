/**
 * Frontend-admin/js/admin-auth.js
 * Include on all admin pages. Checks session, guards by role,
 * populates nav with user info, handles logout.
 *
 * Include AFTER admin-api.js.
 * Options (set before including this file):
 *   window.REQUIRED_ROLE = 'super_admin' | 'admin' (default: allow both)
 */
(async () => {
  let session;
  try {
    session = await adminFetch('/auth.php?action=check');
  } catch {
    window.location.href = 'admin-login.html';
    return;
  }

  if (!session || !session.authenticated) {
    window.location.href = 'admin-login.html';
    return;
  }

  const adminRoles = ['admin', 'super_admin', 'developer'];
  if (!adminRoles.includes(session.role)) {
    window.location.href = 'admin-login.html';
    return;
  }

  // If page requires super_admin specifically
  const required = window.REQUIRED_ROLE;
  if (required === 'super_admin' && !['super_admin', 'developer'].includes(session.role)) {
    showAdminToast('Access denied. Super Admin only.', 'error');
    setTimeout(() => window.location.href = 'admin-dash.html', 1500);
    return;
  }

  // Store session globally
  window.adminUser = {
    id:   session.user_id,
    name: session.name,
    role: session.role,
    isSuperAdmin: ['super_admin', 'developer'].includes(session.role),
  };

  // Populate UI
  document.querySelectorAll('[data-admin-name]').forEach(el => el.textContent = session.name);
  document.querySelectorAll('[data-admin-role]').forEach(el => el.textContent = session.role.replace('_', ' ').toUpperCase());

  // Hide super_admin-only nav items for plain admins
  if (!window.adminUser.isSuperAdmin) {
    document.querySelectorAll('[data-super-only]').forEach(el => el.style.display = 'none');
  }

  // Logout
  const logoutBtn = document.getElementById('adminLogoutBtn') || document.querySelector('[data-logout]');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', async (e) => {
      e.preventDefault();
      await adminFetch('/auth.php', { method: 'DELETE' }).catch(() => {});
      window.location.href = 'admin-login.html';
    });
  }
})();
