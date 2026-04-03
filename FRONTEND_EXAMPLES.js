/**
 * Frontend Implementation Examples
 * How to use the Content Studio API in frontend pages
 */

// ========================================================================
// EXAMPLE 1: Render CMS Blocks on Home Page
// ========================================================================

async function loadHomePageContent() {
  try {
    const response = await fetch('/api/cms.php?page=home');
    const data = await response.json();
    
    console.log('Page:', data.page);
    console.log('Blocks:', data.blocks);
    console.log('Assets:', data.assets);
    
    // Render hero section
    if (data.blocks.hero_section) {
      document.querySelector('.hero-container').innerHTML = 
        data.blocks.hero_section.content_html;
    }
    
    // Render features section
    if (data.blocks.features) {
      document.querySelector('.features-container').innerHTML = 
        data.blocks.features.content_html;
    }
    
    // Render call-to-action
    if (data.blocks.cta) {
      document.querySelector('.cta-container').innerHTML = 
        data.blocks.cta.content_html;
    }
    
    // Set hero image if available
    if (data.assets.hero_image) {
      const img = document.querySelector('.hero-bg');
      img.src = data.assets.hero_image.url;
      img.alt = data.assets.hero_image.alt_text;
    }
    
  } catch (error) {
    console.error('Failed to load home content:', error);
  }
}

// Call on page load
document.addEventListener('DOMContentLoaded', loadHomePageContent);


// ========================================================================
// EXAMPLE 2: Render Full-Page Content (About, Services)
// ========================================================================

async function loadAboutPage() {
  try {
    const response = await fetch('/api/cms.php?page=about');
    const data = await response.json();
    
    // Use either blocks OR rich text content
    if (data.content) {
      // Full-page rich text
      document.querySelector('.page-title').textContent = data.content.title;
      document.querySelector('.page-content').innerHTML = data.content.content;
    } else if (Object.keys(data.blocks).length > 0) {
      // Block-based page
      Object.entries(data.blocks).forEach(([blockKey, block]) => {
        const section = document.querySelector(`[data-block="${blockKey}"]`);
        if (section) {
          section.innerHTML = block.content_html;
        }
      });
    }
    
    // Load any page-specific assets
    if (data.assets.about_image) {
      document.querySelector('.about-image').src = data.assets.about_image.url;
    }
    
  } catch (error) {
    console.error('Failed to load about page:', error);
  }
}


// ========================================================================
// EXAMPLE 3: Dynamic Navigation Menu
// ========================================================================

async function loadNavigation() {
  try {
    // Fetch all published pages for menu
    const response = await fetch('/api/cms.php?pages=1');
    const data = await response.json();
    
    const nav = document.querySelector('nav .menu');
    nav.innerHTML = '';
    
    data.pages.forEach(page => {
      const link = document.createElement('a');
      link.href = `/${page.slug}.html`;
      link.textContent = page.title;
      link.className = page.slug === 'home' ? 'active' : '';
      nav.appendChild(link);
    });
    
  } catch (error) {
    console.error('Failed to load navigation:', error);
  }
}


// ========================================================================
// EXAMPLE 4: Search Content
// ========================================================================

async function searchContent(keyword) {
  try {
    const response = await fetch(`/api/cms.php?search=${encodeURIComponent(keyword)}`);
    const data = await response.json();
    
    const results = document.querySelector('.search-results');
    results.innerHTML = '';
    
    data.pages.forEach(page => {
      const item = document.createElement('div');
      item.className = 'search-result-item';
      item.innerHTML = `
        <h3><a href="/${page.slug}.html">${page.title}</a></h3>
        <p>${page.description || 'No description available'}</p>
      `;
      results.appendChild(item);
    });
    
    if (data.pages.length === 0) {
      results.innerHTML = '<p>No results found.</p>';
    }
    
  } catch (error) {
    console.error('Search failed:', error);
  }
}


// ========================================================================
// EXAMPLE 5: Component-Based Loading (Vue.js)
// ========================================================================

/**
 * Vue component to render a CMS page
 */
const CmsPage = {
  template: `
    <div class="cms-page">
      <h1>{{ page.title }}</h1>
      <div v-if="content" class="page-content" v-html="content.content"></div>
      <div v-else class="blocks-container">
        <section v-for="block in blocks" :key="block.id" 
          :data-block="block.block_key" 
          v-html="block.content_html"></section>
      </div>
      <div class="assets">
        <img v-for="asset in Object.values(assets)" :key="asset.label" 
          :src="asset.url" :alt="asset.alt_text" />
      </div>
    </div>
  `,
  
  data() {
    return {
      page: {},
      blocks: [],
      assets: {},
      content: null
    };
  },
  
  props: ['pageSlug'],
  
  async mounted() {
    try {
      const response = await fetch(`/api/cms.php?page=${this.pageSlug}`);
      const data = await response.json();
      
      this.page = data.page;
      this.blocks = data.blocks;
      this.assets = data.assets;
      this.content = data.content;
    } catch (error) {
      console.error('Failed to load CMS page:', error);
    }
  }
};


// ========================================================================
// EXAMPLE 6: React Component
// ========================================================================

/**
 * React component to render CMS content
 */
import React, { useState, useEffect } from 'react';

function CmsPage({ pageSlug }) {
  const [page, setPage] = useState(null);
  const [blocks, setBlocks] = useState([]);
  const [assets, setAssets] = useState({});
  const [content, setContent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const loadContent = async () => {
      try {
        const response = await fetch(`/api/cms.php?page=${pageSlug}`);
        if (!response.ok) throw new Error('Failed to load content');
        
        const data = await response.json();
        setPage(data.page);
        setBlocks(data.blocks);
        setAssets(data.assets);
        setContent(data.content);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };
    
    loadContent();
  }, [pageSlug]);
  
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  
  return (
    <div className="cms-page">
      <h1>{page?.title}</h1>
      
      {content ? (
        <div 
          className="page-content" 
          dangerouslySetInnerHTML={{ __html: content.content }}
        />
      ) : (
        <div className="blocks-container">
          {blocks.map(block => (
            <section 
              key={block.id} 
              data-block={block.block_key}
              dangerouslySetInnerHTML={{ __html: block.content_html }}
            />
          ))}
        </div>
      )}
    </div>
  );
}

export default CmsPage;


// ========================================================================
// EXAMPLE 7: Footer with Dynamic Content
// ========================================================================

async function loadFooterContent() {
  try {
    const response = await fetch('/api/cms.php?page=home');
    const data = await response.json();
    
    // You can store company info in a block or asset
    if (data.assets.company_logo) {
      document.querySelector('.footer-logo').src = data.assets.company_logo.url;
    }
    
    // Or use a custom block for footer content
    if (data.blocks.footer_content) {
      document.querySelector('.footer-content').innerHTML = 
        data.blocks.footer_content.content_html;
    }
    
  } catch (error) {
    console.error('Failed to load footer:', error);
  }
}


// ========================================================================
// EXAMPLE 8: Responsive Image Loading with Assets
// ========================================================================

async function loadResponsiveAssets() {
  try {
    const response = await fetch('/api/cms.php?page=services');
    const data = await response.json();
    
    // Load hero image with multiple resolution support
    if (data.assets.hero_image) {
      const img = new Image();
      img.src = data.assets.hero_image.url;
      img.alt = data.assets.hero_image.alt_text;
      
      // Lazy load with observer
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.src = img.src;
            observer.unobserve(entry.target);
          }
        });
      });
      
      document.querySelectorAll('[data-cms-hero]').forEach(el => {
        observer.observe(el);
      });
    }
    
  } catch (error) {
    console.error('Failed to load assets:', error);
  }
}


// ========================================================================
// EXAMPLE 9: Cache Management
// ========================================================================

class CmsCache {
  constructor(ttl = 3600000) { // 1 hour TTL
    this.cache = {};
    this.ttl = ttl;
  }
  
  set(key, value) {
    this.cache[key] = {
      value,
      timestamp: Date.now()
    };
  }
  
  get(key) {
    const item = this.cache[key];
    if (!item) return null;
    
    if (Date.now() - item.timestamp > this.ttl) {
      delete this.cache[key];
      return null;
    }
    
    return item.value;
  }
  
  clear() {
    this.cache = {};
  }
}

// Usage
const cmsCache = new CmsCache(3600000); // 1 hour cache

async function getCmsPage(pageSlug) {
  // Check cache first
  const cached = cmsCache.get(`page-${pageSlug}`);
  if (cached) return cached;
  
  // Fetch from API
  const response = await fetch(`/api/cms.php?page=${pageSlug}`);
  const data = await response.json();
  
  // Cache result
  cmsCache.set(`page-${pageSlug}`, data);
  
  return data;
}


// ========================================================================
// EXAMPLE 10: Error Handling & Fallbacks
// ========================================================================

async function loadPageWithFallback(pageSlug, fallbackHTML) {
  try {
    const response = await fetch(`/api/cms.php?page=${pageSlug}`);
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    
    const data = await response.json();
    
    if (data.content) {
      document.querySelector('.page-content').innerHTML = data.content.content;
    } else if (data.blocks.length > 0) {
      document.querySelector('.page-content').innerHTML = 
        data.blocks.map(b => b.content_html).join('');
    } else {
      throw new Error('No content available');
    }
    
  } catch (error) {
    console.warn(`Failed to load ${pageSlug}, using fallback:`, error);
    document.querySelector('.page-content').innerHTML = fallbackHTML;
  }
}

// Usage
loadPageWithFallback('services', '<p>Our services page is temporarily unavailable.</p>');
