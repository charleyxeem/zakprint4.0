(function () {
  const pageKey = (() => {
    const rawPath = window.location.pathname.toLowerCase();
    if (rawPath.endsWith('/') || rawPath.endsWith('/index.php')) return 'home.html';
    return rawPath.split('/').pop() || 'home.html';
  })();

  const pages = [
    { file: 'home.html', label: 'Home', href: 'home.html' },
    { file: 'shop.html', label: 'Shop', href: 'shop.html' },
    { file: 'services.html', label: 'Services', href: 'services.html' },
    { file: 'about.html', label: 'About', href: 'about.html' },
    { file: 'contact.html', label: 'Contact', href: 'contact.html' },
  ];

  const navMarkup = pages.map((page) => {
    const active = page.file === pageKey;
    const className = active
      ? 'text-primary font-bold'
      : 'text-slate-600 dark:text-slate-400 font-medium hover:text-primary dark:hover:text-primary';
    return `<a class="${className} text-sm transition-colors" href="${page.href}">${page.label}</a>`;
  }).join('');

  const headerMarkup = `
    <header class="sticky top-0 z-50 bg-background-light/80 dark:bg-background-dark/80 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 px-6 lg:px-20 py-3">
      <div class="max-w-7xl mx-auto flex items-center justify-between whitespace-nowrap gap-6">
        <div class="flex items-center gap-8">
          <a class="flex items-center gap-3 text-primary" href="home.html" aria-label="ZAK Printing home">
            <div class="size-8 flex items-center justify-center bg-primary text-white rounded-lg">
              <span class="material-symbols-outlined">print</span>
            </div>
            <h2 class="text-slate-900 dark:text-slate-100 text-xl font-bold leading-tight tracking-tight">ZAK Printing</h2>
          </a>
          <nav class="hidden lg:flex items-center gap-8">
            ${navMarkup}
          </nav>
        </div>
        <div class="flex items-center gap-4">
          <div class="hidden md:flex items-center bg-slate-100 dark:bg-slate-800 rounded-xl px-3 py-1.5 border border-transparent focus-within:border-primary transition-all">
            <span class="material-symbols-outlined text-slate-400 text-lg">search</span>
            <input class="bg-transparent border-none focus:ring-0 text-sm w-32 xl:w-48 placeholder:text-slate-400" placeholder="Search products..." type="text" />
          </div>
          <div class="flex items-center gap-2">
            <a class="p-2 text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-colors" href="user-login.html" aria-label="Account">
              <span class="material-symbols-outlined">person</span>
            </a>
            <a class="p-2 text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-colors relative" href="shop.html" aria-label="Cart">
              <span class="material-symbols-outlined">shopping_cart</span>
              <span class="absolute top-1 right-1 size-2 bg-primary rounded-full"></span>
            </a>
          </div>
          <a class="hidden sm:flex items-center justify-center px-5 py-2.5 bg-primary text-white text-sm font-bold rounded-xl shadow-lg shadow-primary/20 hover:scale-[1.02] active:scale-[0.98] transition-all" href="appointment.html">
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
              <span class="material-symbols-outlined">print</span>
            </div>
            <h2 class="text-slate-900 dark:text-slate-100 text-xl font-bold">ZAK Printing</h2>
          </div>
          <p class="text-sm text-slate-600 dark:text-slate-400 leading-relaxed">Your one-stop destination for premium printing needs. Quality, precision, and dependable turnaround in every order.</p>
          <div class="flex gap-4">
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="contact.html" aria-label="Social link">
              <span class="material-symbols-outlined text-xl">share</span>
            </a>
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="contact.html" aria-label="Email us">
              <span class="material-symbols-outlined text-xl">mail</span>
            </a>
            <a class="size-10 flex items-center justify-center rounded-full bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400 hover:bg-primary hover:text-white transition-all" href="contact.html" aria-label="Visit us">
              <span class="material-symbols-outlined text-xl">location_on</span>
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
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="contact.html">Contact Us</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="#faq">FAQ</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="#privacy-policy">Privacy Policy</a></li>
            <li><a class="text-sm text-slate-600 dark:text-slate-400 hover:text-primary transition-colors" href="#shipping-info">Shipping Info</a></li>
          </ul>
        </div>
        <div>
          <h4 class="text-slate-900 dark:text-white font-bold mb-6">Newsletter</h4>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Subscribe to get special offers and updates.</p>
          <div class="flex">
            <input class="flex-1 bg-slate-100 dark:bg-slate-800 border-none rounded-l-xl focus:ring-1 focus:ring-primary text-sm px-4" placeholder="Email" type="email" />
            <button class="bg-primary text-white p-3 rounded-r-xl" type="button"><span class="material-symbols-outlined">send</span></button>
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
  if (header && pages.some((page) => page.file === pageKey)) header.outerHTML = headerMarkup;

  const footer = document.querySelector('footer');
  if (footer && pages.some((page) => page.file === pageKey)) footer.outerHTML = footerMarkup;
})();
