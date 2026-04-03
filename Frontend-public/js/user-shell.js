(function () {
  const pageKey = (() => {
    const rawPath = window.location.pathname.toLowerCase();
    return rawPath.split('/').pop() || 'user-dash.html';
  })();

  const userPages = ['user-login.html', 'user-dash.html', 'user-my-order.html', 'user-my-settings.html'];
  if (!userPages.includes(pageKey)) return;

  const navMarkup = `
    <a href="home.html" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Home</a>
    <a href="shop.html" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Shop</a>
    <a href="services.html" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Services</a>
    <a href="about.html" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">About</a>
    <a href="contact.html" class="text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-primary transition-colors">Contact</a>`;

  const loginHeader = `
    <header class="flex items-center justify-between whitespace-nowrap border-b border-solid border-primary/10 px-6 md:px-10 py-4 bg-background-light dark:bg-background-dark">
      <div class="flex items-center gap-4 text-slate-900 dark:text-slate-100">
        <a class="bg-primary p-1.5 rounded-lg flex items-center justify-center" href="home.html" aria-label="ZAK Printing home">
          <span class="material-symbols-outlined text-white text-2xl">print</span>
        </a>
        <h2 class="text-xl font-bold leading-tight tracking-tight">ZAK Printing</h2>
      </div>
      <div class="flex items-center gap-6">
        <nav class="hidden md:flex items-center gap-8">
          ${navMarkup}
        </nav>
        <a class="flex min-w-[100px] items-center justify-center rounded-lg h-10 px-5 bg-primary text-white text-sm font-bold shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all" href="contact.html?intent=signup">Sign Up</a>
      </div>
    </header>`;

  const appHeader = `
    <header class="sticky top-0 z-50 border-b border-primary/10 bg-white/90 dark:bg-background-dark/90 backdrop-blur-md">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-6">
        <a href="user-dash.html" class="flex items-center gap-3 text-primary">
          <span class="size-9 rounded-lg bg-primary text-white flex items-center justify-center">
            <span class="material-symbols-outlined">print</span>
          </span>
          <span class="text-lg font-extrabold tracking-tight">ZAK Printing</span>
        </a>
        <nav class="hidden md:flex items-center gap-6">
          ${navMarkup}
        </nav>
        <div class="flex items-center gap-2">
          <a href="shop.html" class="hidden sm:inline-flex items-center px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold hover:bg-primary/90 transition-colors">New Order</a>
          <a href="user-login.html" class="size-10 rounded-full bg-primary/10 text-primary flex items-center justify-center hover:bg-primary/20 transition-colors" aria-label="Account">
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
          <a class="hover:text-primary transition-colors" href="contact.html?intent=privacy">Privacy Policy</a>
          <a class="hover:text-primary transition-colors" href="contact.html?intent=terms">Terms of Service</a>
          <a class="hover:text-primary transition-colors" href="contact.html?intent=help">Help Center</a>
        </div>
      </div>
    </footer>`;

  const header = document.querySelector('header');
  if (header) {
    header.outerHTML = pageKey === 'user-login.html' ? loginHeader : appHeader;
  }

  const footer = document.querySelector('footer');
  if (footer && pageKey === 'user-login.html') {
    footer.outerHTML = loginFooter;
  }
})();
})();