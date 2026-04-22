/**
 * Frontend-public/js/cms-examples.js
 * 
 * Practical examples of using CMSLoader programmatically.
 * These patterns can be adapted for various use cases.
 */

// ============================================================================
// EXAMPLE 1: Simple Page Load with Error Handling
// ============================================================================

async function loadHomePageWithFallback() {
  const container = document.querySelector('#main-content');
  
  try {
    // Load CMS data
    const cmsData = await CMSLoader.loadPage('home');
    
    // Check for errors
    if (cmsData.error) {
      console.error('CMS Error:', cmsData.error);
      container.innerHTML = '<p>Unable to load page content. Please refresh.</p>';
      return;
    }

    // Render blocks
    const blockKeys = ['hero', 'features', 'pricing'];
    for (const key of blockKeys) {
      const block = cmsData.blocks[key];
      if (block) {
        const wrapper = document.createElement('div');
        wrapper.className = `cms-block cms-block-${block.block_type}`;
        CMSLoader.renderBlock(wrapper, block);
        container.appendChild(wrapper);
      }
    }
  } catch (error) {
    console.error('Failed to load page:', error);
    container.innerHTML = '<p>Page content unavailable.</p>';
  }
}

// ============================================================================
// EXAMPLE 2: Conditional Block Rendering
// ============================================================================

async function loadPageWithConditions() {
  const cmsData = await CMSLoader.loadPage('shop');
  
  // Only show featured products if they exist
  if (cmsData.blocks.featured_products) {
    const container = document.querySelector('#featured');
    CMSLoader.renderBlock(container, cmsData.blocks.featured_products);
  } else {
    document.querySelector('#featured').innerHTML = 
      '<p>No featured products at this time.</p>';
  }

  // Show special offer if available
  if (cmsData.blocks.special_offer) {
    const container = document.querySelector('#promo');
    CMSLoader.renderBlock(container, cmsData.blocks.special_offer);
  }

  // Render testimonials with dynamic styling
  if (cmsData.blocks.testimonials) {
    const container = document.querySelector('#testimonials');
    const block = cmsData.blocks.testimonials;
    CMSLoader.renderBlock(container, block);
    
    // Apply animation after render
    setTimeout(() => {
      container.classList.add('fade-in');
    }, 100);
  }
}

// ============================================================================
// EXAMPLE 3: Dynamic Gallery Loading
// ============================================================================

async function loadGalleryFromCMS() {
  const gallery = await CMSLoader.getBlock('home', 'portfolio');
  
  if (!gallery) {
    console.warn('Gallery block not found');
    return;
  }

  try {
    const items = JSON.parse(gallery.content_html || '[]');
    const container = document.querySelector('#gallery-grid');
    
    items.forEach((item, index) => {
      const figure = document.createElement('figure');
      figure.className = 'gallery-item';
      figure.style.animationDelay = `${index * 100}ms`;
      
      const img = document.createElement('img');
      img.src = item.src;
      img.alt = item.alt || 'Gallery image';
      img.loading = 'lazy';
      
      figure.appendChild(img);
      
      if (item.caption) {
        const caption = document.createElement('p');
        caption.className = 'gallery-caption';
        caption.textContent = item.caption;
        figure.appendChild(caption);
      }
      
      container.appendChild(figure);

      // Add click to lightbox or modal
      figure.addEventListener('click', () => {
        showImageModal(item.src, item.alt);
      });
    });
  } catch (error) {
    console.error('Failed to parse gallery:', error);
  }
}

// ============================================================================
// EXAMPLE 4: FAQ Accordion with Search
// ============================================================================

async function loadFAQWithSearch() {
  const faqBlock = await CMSLoader.getBlock('home', 'faq');
  
  if (!faqBlock) return;

  try {
    const items = JSON.parse(faqBlock.content_html || '[]');
    const container = document.querySelector('#faq-container');
    const searchInput = document.querySelector('#faq-search');

    function renderFAQ(filteredItems = items) {
      container.innerHTML = '';
      
      filteredItems.forEach((item) => {
        const details = document.createElement('details');
        
        const summary = document.createElement('summary');
        summary.className = 'faq-question';
        summary.textContent = item.q;
        
        const answer = document.createElement('div');
        answer.className = 'faq-answer';
        answer.innerHTML = item.a; // HTML content assumed safe from CMS
        
        details.appendChild(summary);
        details.appendChild(answer);
        container.appendChild(details);
      });
    }

    // Initial render
    renderFAQ();

    // Search functionality
    if (searchInput) {
      searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filtered = items.filter((item) =>
          item.q.toLowerCase().includes(query) ||
          item.a.toLowerCase().includes(query)
        );
        renderFAQ(filtered);
      });
    }
  } catch (error) {
    console.error('Failed to load FAQ:', error);
  }
}

// ============================================================================
// EXAMPLE 5: Multi-Page Navigation with CMS
// ============================================================================

async function setupNavigationWithCMS() {
  // Load navigation/menu from CMS
  const homeCMS = await CMSLoader.loadPage('home');
  const aboutCMS = await CMSLoader.loadPage('about');
  
  // Update nav labels dynamically if needed
  const navLinks = document.querySelectorAll('nav a[href*="home"]');
  if (homeCMS.content?.title) {
    navLinks.forEach(link => link.textContent = homeCMS.content.title);
  }

  // Set up page transitions
  document.querySelectorAll('nav a').forEach((link) => {
    link.addEventListener('click', async (e) => {
      e.preventDefault();
      
      const href = link.getAttribute('href');
      const pageSlug = href.split('.')[0].replace(/^.*[/\\]/, '');
      
      // Fade out
      document.querySelector('main').style.opacity = '0';
      
      // Load new CMS content
      await CMSLoader.loadPage(pageSlug);
      
      // Navigate
      window.location.href = href;
    });
  });
}

// ============================================================================
// EXAMPLE 6: Blog/Articles from CMS
// ============================================================================

async function loadBlogArticles() {
  const cmsData = await CMSLoader.loadPage('blog');
  
  // Get all blog blocks (assuming they're keyed as article-1, article-2, etc.)
  const articles = Object.values(cmsData.blocks)
    .filter(b => b.block_key.startsWith('article'))
    .sort((a, b) => (a.sort_order || 0) - (b.sort_order || 0));

  const container = document.querySelector('#blog-grid');
  
  articles.forEach((article) => {
    const articleEl = document.createElement('article');
    articleEl.className = 'blog-card';
    
    // Extract title and excerpt from content_html
    const parser = new DOMParser();
    const doc = parser.parseFromString(article.content_html || '', 'text/html');
    const title = doc.querySelector('h2, h3, h1')?.textContent || article.title;
    const excerpt = doc.querySelector('p')?.textContent || '';
    
    articleEl.innerHTML = `
      <h3>${title}</h3>
      <p class="excerpt">${excerpt}</p>
      <a href="#">Read More →</a>
    `;
    
    container.appendChild(articleEl);
  });
}

// ============================================================================
// EXAMPLE 7: Dynamic Header/Footer from CMS
// ============================================================================

async function loadHeaderFooterFromCMS() {
  const globalAssets = await CMSLoader.loadPage('home');
  
  // Update logo from CMS asset
  const logo = globalAssets.assets['site-logo'];
  if (logo) {
    const logoEl = document.querySelector('header .logo');
    if (logoEl) {
      logoEl.innerHTML = `<img src="${logo.file_path}" alt="${logo.alt_text || 'Logo'}">`;
    }
  }

  // Update footer content
  const footerCMS = await CMSLoader.loadPage('footer');
  if (footerCMS.blocks['footer-content']) {
    CMSLoader.renderBlock(
      document.querySelector('footer'),
      footerCMS.blocks['footer-content']
    );
  }
}

// ============================================================================
// EXAMPLE 8: Dynamic Pricing Table from Plans
// ============================================================================

async function loadPricingFromCMS() {
  const cmsData = await CMSLoader.loadPage('pricing');
  
  if (!cmsData.plans || cmsData.plans.length === 0) {
    console.warn('No pricing plans found');
    return;
  }

  const container = document.querySelector('#pricing-cards');
  
  cmsData.plans.forEach((plan) => {
    const card = document.createElement('div');
    card.className = 'pricing-card';
    
    const features = Array.isArray(plan.features) 
      ? plan.features 
      : (plan.features || '').split('\n');
    
    card.innerHTML = `
      <h3>${plan.title}</h3>
      <div class="price">
        <span class="amount">$${plan.price || '0'}</span>
        <span class="period">/${plan.period || 'month'}</span>
      </div>
      <ul class="features">
        ${features.map(f => `<li>✓ ${f}</li>`).join('')}
      </ul>
      <button class="cta-button">Get Started</button>
    `;
    
    container.appendChild(card);
  });
}

// ============================================================================
// EXAMPLE 9: API-First Approach (Direct apiFetch)
// ============================================================================

async function directAPIApproach() {
  // If you prefer not to use CMSLoader, use apiFetch directly
  const cmsData = await apiFetch('/cms.php?page=home');
  
  // Access blocks by key
  const heroBlock = cmsData.blocks['hero'];
  if (heroBlock) {
    document.querySelector('#hero').innerHTML = heroBlock.content_html;
  }

  // Access assets
  const heroBg = cmsData.assets['hero-background'];
  if (heroBg) {
    document.querySelector('#hero').style.backgroundImage = 
      `url('${heroBg.file_path}')`;
  }

  // Get pricing plans
  cmsData.plans.forEach((plan) => {
    console.log(`${plan.title}: $${plan.price}/${plan.period}`);
  });
}

// ============================================================================
// EXAMPLE 10: Cache Management
// ============================================================================

async function manageCMSCache() {
  // First load - hits API
  console.time('first-load');
  const data1 = await CMSLoader.loadPage('home');
  console.timeEnd('first-load');

  // Second load - from cache (instant)
  console.time('cached-load');
  const data2 = await CMSLoader.loadPage('home');
  console.timeEnd('cached-load');

  // Clear cache (use after admin updates)
  CMSLoader.clearCache();

  // Next load - hits API again
  const data3 = await CMSLoader.loadPage('home');
}

// ============================================================================
// Helper Functions
// ============================================================================

function showImageModal(src, alt) {
  const modal = document.createElement('div');
  modal.className = 'image-modal';
  modal.innerHTML = `
    <div class="modal-content">
      <button class="close" onclick="this.closest('.image-modal').remove()">×</button>
      <img src="${src}" alt="${alt}">
    </div>
  `;
  document.body.appendChild(modal);

  // Close on background click
  modal.addEventListener('click', (e) => {
    if (e.target === modal) modal.remove();
  });
}

// ============================================================================
// Initialization
// ============================================================================

// Run example on page load
document.addEventListener('DOMContentLoaded', () => {
  // Choose which example to run based on current page
  const pageName = document.body.getAttribute('data-page') || 'home';
  
  switch (pageName) {
    case 'home':
      loadHomePageWithFallback();
      break;
    case 'portfolio':
      loadGalleryFromCMS();
      break;
    case 'faq':
      loadFAQWithSearch();
      break;
    case 'blog':
      loadBlogArticles();
      break;
    case 'pricing':
      loadPricingFromCMS();
      break;
  }

  // Always set up common elements
  loadHeaderFooterFromCMS();
});
