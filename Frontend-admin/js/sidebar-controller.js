(function () {
  var STORAGE_KEY = "adminSidebarCollapsed";
  var STORAGE_MANUAL_KEY = "adminSidebarManual";
  var AUTO_BREAKPOINT = 1200;
  var EXPANDED_WIDTH = 288; // w-72
  var COLLAPSED_WIDTH = 88;

  function findSidebar() {
    var asides = Array.prototype.slice.call(document.querySelectorAll("aside"));
    for (var i = 0; i < asides.length; i += 1) {
      var aside = asides[i];
      var nav = aside.querySelector("nav");
      if (!nav) {
        continue;
      }
      var hasDashboardLink = !!nav.querySelector('a[href="admin-dash.html"]');
      if (hasDashboardLink) {
        return aside;
      }
    }
    return null;
  }

  function markSidebarParts(sidebar) {
    sidebar.setAttribute("data-admin-sidebar", "true");

    var brandText = sidebar.querySelector("h1");
    if (brandText && brandText.parentElement) {
      brandText.parentElement.classList.add("sidebar-brand-text");
    }

    var footer = sidebar.querySelector(".mt-auto");
    if (footer) {
      footer.classList.add("sidebar-footer");
    }

    var nav = sidebar.querySelector("nav");
    var logoutLink = nav ? nav.querySelector('a[data-logout]') : null;
    if (nav && !nav.querySelector('a[href="queries.html"]')) {
      var queries = document.createElement('a');
      queries.className = 'flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors';
      queries.href = 'queries.html';
      queries.innerHTML = '<span class="material-symbols-outlined">mail</span><span>Queries</span>';
      if (logoutLink) nav.insertBefore(queries, logoutLink);
      else nav.appendChild(queries);
    }

    if (nav && !nav.querySelector('a[href="appointments.html"]')) {
      var appointments = document.createElement('a');
      appointments.className = 'flex items-center gap-3 px-4 py-3 rounded-xl text-slate-600 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors';
      appointments.href = 'appointments.html';
      appointments.innerHTML = '<span class="material-symbols-outlined">event</span><span>Appointments</span>';
      if (logoutLink) nav.insertBefore(appointments, logoutLink);
      else nav.appendChild(appointments);
    }
  }

  function injectStyles() {
    if (document.getElementById("sidebar-controller-styles")) {
      return;
    }

    var style = document.createElement("style");
    style.id = "sidebar-controller-styles";
    style.textContent = [
      "aside[data-admin-sidebar]{transition:width .2s ease,min-width .2s ease;overflow-y:auto;overflow-x:hidden;height:auto;min-height:100%;align-self:stretch;}",
      "aside[data-admin-sidebar] nav a{transition:all .2s ease;}",
      "body.sidebar-collapsed aside[data-admin-sidebar]{width:" + COLLAPSED_WIDTH + "px !important;min-width:" + COLLAPSED_WIDTH + "px !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar]:hover{width:" + EXPANDED_WIDTH + "px !important;min-width:" + EXPANDED_WIDTH + "px !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar] .sidebar-brand-text,",
      "body.sidebar-collapsed aside[data-admin-sidebar] .sidebar-footer{display:none !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar]:hover .sidebar-brand-text,",
      "body.sidebar-collapsed aside[data-admin-sidebar]:hover .sidebar-footer{display:block !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar] nav a{justify-content:center;padding-left:.75rem;padding-right:.75rem;}",
      "body.sidebar-collapsed aside[data-admin-sidebar] nav a span + span{display:none !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar]:hover nav a{justify-content:flex-start;padding-left:1rem;padding-right:1rem;}",
      "body.sidebar-collapsed aside[data-admin-sidebar]:hover nav a span + span{display:inline !important;}",
      "body.sidebar-collapsed aside[data-admin-sidebar] nav a[data-logout]{margin-top:.5rem;}",
      ".sidebar-toggle-wrap{display:flex;justify-content:flex-end;margin-bottom:.75rem;}",
      "#sidebarToggleBtn{display:inline-flex;align-items:center;justify-content:center;width:2.5rem;height:2.5rem;border-radius:.5rem;}",
      "#sidebarToggleBtn:hover{background:rgba(15,23,42,.08);}",
      "aside[data-admin-sidebar]::-webkit-scrollbar{width:8px;}",
      "aside[data-admin-sidebar]::-webkit-scrollbar-thumb{background:rgba(100,116,139,.4);border-radius:999px;}",
      "aside[data-admin-sidebar]::-webkit-scrollbar-track{background:transparent;}"
    ].join("\n");

    document.head.appendChild(style);
  }

  function updateFixedMainMargin(sidebar, collapsed) {
    var isFixed = sidebar.classList.contains("fixed") || window.getComputedStyle(sidebar).position === "fixed";
    if (!isFixed) {
      return;
    }

    var main = document.querySelector("main");
    if (!main) {
      return;
    }

    main.style.transition = "margin-left .2s ease";
    main.style.marginLeft = (collapsed ? COLLAPSED_WIDTH : EXPANDED_WIDTH) + "px";
  }

  function applyCollapsedState(sidebar, collapsed) {
    document.body.classList.toggle("sidebar-collapsed", collapsed);
    updateFixedMainMargin(sidebar, collapsed);

    var toggleIcon = document.getElementById("sidebarToggleIcon");
    if (toggleIcon) {
      toggleIcon.textContent = collapsed ? "menu_open" : "menu";
    }

    var toggleBtn = document.getElementById("sidebarToggleBtn");
    if (toggleBtn) {
      toggleBtn.setAttribute("aria-pressed", collapsed ? "true" : "false");
      toggleBtn.setAttribute("title", collapsed ? "Expand sidebar" : "Collapse sidebar");
    }
  }

  function mountToggleButton(sidebar) {
    if (document.getElementById("sidebarToggleBtn")) {
      return;
    }

    var topContainer = sidebar.firstElementChild || sidebar;
    if (!topContainer) {
      return;
    }

    var wrap = document.createElement("div");
    wrap.className = "sidebar-toggle-wrap";

    var button = document.createElement("button");
    button.type = "button";
    button.id = "sidebarToggleBtn";
    button.className = "text-slate-600 dark:text-slate-300 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800";
    button.setAttribute("aria-label", "Toggle sidebar");
    button.innerHTML = '<span id="sidebarToggleIcon" class="material-symbols-outlined">menu</span>';

    wrap.appendChild(button);
    topContainer.insertBefore(wrap, topContainer.firstChild);

    button.addEventListener("click", function () {
      var currentlyCollapsed = document.body.classList.contains("sidebar-collapsed");
      var next = !currentlyCollapsed;
      applyCollapsedState(sidebar, next);
      localStorage.setItem(STORAGE_KEY, next ? "1" : "0");
      localStorage.setItem(STORAGE_MANUAL_KEY, "1");
    });
  }

  function resolveInitialState() {
    var manual = localStorage.getItem(STORAGE_MANUAL_KEY) === "1";
    var stored = localStorage.getItem(STORAGE_KEY);

    if (manual && (stored === "1" || stored === "0")) {
      return stored === "1";
    }

    return window.innerWidth < AUTO_BREAKPOINT;
  }

  function mountAutoResize(sidebar) {
    window.addEventListener("resize", function () {
      var manual = localStorage.getItem(STORAGE_MANUAL_KEY) === "1";
      if (manual) {
        return;
      }
      var autoCollapsed = window.innerWidth < AUTO_BREAKPOINT;
      applyCollapsedState(sidebar, autoCollapsed);
      localStorage.setItem(STORAGE_KEY, autoCollapsed ? "1" : "0");
    });
  }

  function init() {
    var sidebar = findSidebar();
    if (!sidebar) {
      return;
    }

    injectStyles();
    markSidebarParts(sidebar);
    mountToggleButton(sidebar);

    var collapsed = resolveInitialState();
    applyCollapsedState(sidebar, collapsed);
    localStorage.setItem(STORAGE_KEY, collapsed ? "1" : "0");

    mountAutoResize(sidebar);

    // Keep sidebar stretched for long pages.
    var syncSidebarHeight = function () {
      var docHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight, window.innerHeight);
      sidebar.style.minHeight = docHeight + 'px';
    };
    syncSidebarHeight();
    window.addEventListener('resize', syncSidebarHeight);
    setTimeout(syncSidebarHeight, 100);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
