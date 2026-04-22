/**
 * Frontend-public/js/cms-loader.js
 * Dynamically loads and renders CMS content on public pages.
 * 
 * Usage:
 *   // Load CMS for current page
 *   const cms = await CMSLoader.loadPage(pageSlug);
 *   
 *   // Render a specific block
 *   CMSLoader.renderBlock(blockElement, blockData);
 *   
 *   // Get processed content with fallback
 *   const html = CMSLoader.processBlockContent(block, 'text');
 */

const CMSLoader = (() => {
  // Cache loaded pages to avoid duplicate API calls
  const cache = new Map();
  
  // Block type renderers
  const blockRenderers = {
    text: (block) => {
      return `<div class="cms-text-block">${block.content_html || ''}</div>`;
    },
    
    hero: (block) => {
      return `
        <section class="cms-hero-block">
          <div class="hero-content">
            ${block.content_html || ''}
          </div>
        </section>
      `;
    },
    
    cta: (block) => {
      return `<div class="cms-cta-block">${block.content_html || ''}</div>`;
    },
    
    faq: (block) => {
      let faqHtml = '<div class="cms-faq-block">';
      try {
        const items = JSON.parse(block.content_html || '[]');
        if (Array.isArray(items)) {
          items.forEach((item) => {
            faqHtml += `
              <details class="faq-item">
                <summary class="faq-question">${escapeHtml(item.q || '')}</summary>
                <div class="faq-answer">${item.a || ''}</div>
              </details>
            `;
          });
        }
      } catch (e) {
        console.warn('Invalid FAQ JSON in block:', block.block_key, e);
      }
      faqHtml += '</div>';
      return faqHtml;
    },
    
    gallery: (block) => {
      let galHtml = '<div class="cms-gallery-block">';
      try {
        const items = JSON.parse(block.content_html || '[]');
        if (Array.isArray(items)) {
          items.forEach((item) => {
            const alt = escapeHtml(item.alt || block.title || 'Gallery item');
            const caption = item.caption ? `<p class="gallery-caption">${escapeHtml(item.caption)}</p>` : '';
            galHtml += `
              <figure class="gallery-item">
                <img src="${escapeHtml(item.src || '')}" alt="${alt}" class="gallery-image" loading="lazy">
                ${caption}
              </figure>
            `;
          });
        }
      } catch (e) {
        console.warn('Invalid gallery JSON in block:', block.block_key, e);
      }
      galHtml += '</div>';
      return galHtml;
    },
    
    image: (block) => {
      let img = {};
      try {
        img = JSON.parse(block.content_html || '{}');
      } catch (e) {
        console.warn('Invalid image JSON in block:', block.block_key, e);
      }
      const alt = escapeHtml(img.alt || block.title || 'Image');
      const caption = img.caption ? `<p class="image-caption">${escapeHtml(img.caption)}</p>` : '';
      return `
        <figure class="cms-image-block">
          <img src="${escapeHtml(img.src || '')}" alt="${alt}" loading="lazy">
          ${caption}
        </figure>
      `;
    }
  };

  /**
   * Escape HTML to prevent XSS
   */
  function escapeHtml(text) {
    const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
    return String(text || '').replace(/[&<>"']/g, (c) => map[c]);
  }

  /**
   * Load CMS content for a specific page
   * @param {string} pageSlug - Page slug (e.g., 'home', 'about')
   * @returns {Promise<Object>} CMS data with blocks, assets, etc.
   */
  async function loadPage(pageSlug) {
    // Return cached data if available
    if (cache.has(pageSlug)) {
      return cache.get(pageSlug);
    }

    try {
      const data = await apiFetch(`/cms.php?page=${encodeURIComponent(pageSlug)}`);
      cache.set(pageSlug, data);
      return data;
    } catch (error) {
      console.error(`Failed to load CMS content for page "${pageSlug}":`, error);
      // Return empty structure with error flag
      return {
        page: pageSlug,
        blocks: {},
        assets: {},
        content: null,
        plans: [],
        error: error.message,
      };
    }
  }

  /**
   * Get a single block from CMS
   * @param {string} pageSlug - Page slug
   * @param {string} blockKey - Block key (e.g., 'hero', 'features')
   * @returns {Promise<Object|null>} Block data or null if not found
   */
  async function getBlock(pageSlug, blockKey) {
    const data = await loadPage(pageSlug);
    return data.blocks?.[blockKey] || null;
  }

  /**
   * Get all blocks for a page
   * @param {string} pageSlug - Page slug
   * @returns {Promise<Array>} Array of block objects
   */
  async function getBlocks(pageSlug) {
    const data = await loadPage(pageSlug);
    // Convert keyed object to array if needed
    const blocks = data.blocks || {};
    return Object.values(blocks).sort((a, b) => (a.sort_order || 0) - (b.sort_order || 0));
  }

  /**
   * Process block content based on block type
   * @param {Object} block - Block data from CMS
   * @param {string} fallbackType - Default block type if not specified
   * @returns {string} HTML content
   */
  function processBlockContent(block, fallbackType = 'text') {
    if (!block) return '';
    
    const type = block.block_type || fallbackType;
    const renderer = blockRenderers[type] || blockRenderers.text;
    
    try {
      return renderer(block);
    } catch (error) {
      console.error(`Error rendering block "${block.block_key}" of type "${type}":`, error);
      return `<div class="cms-block-error">Content unavailable</div>`;
    }
  }

  /**
   * Render a CMS block into a DOM element
   * @param {HTMLElement} element - Target element for rendering
   * @param {Object} block - Block data
   */
  function renderBlock(element, block) {
    if (!element || !block) return;
    const html = processBlockContent(block);
    element.innerHTML = html;
  }

  /**
   * Auto-load and render blocks based on data attributes
   * Elements can use:
   *   data-cms-page="home" data-cms-block="hero" - Load single block
   *   data-cms-page="home" data-cms-blocks="hero,features" - Load multiple blocks
   */
  async function autoRenderBlocks() {
    // Single block elements
    const singleBlocks = document.querySelectorAll('[data-cms-page][data-cms-block]');
    for (const el of singleBlocks) {
      const pageSlug = el.dataset.cmsPage;
      const blockKey = el.dataset.cmsBlock;
      try {
        const block = await getBlock(pageSlug, blockKey);
        if (block) {
          renderBlock(el, block);
        } else {
          console.warn(`CMS block not found: ${pageSlug}/${blockKey}`);
        }
      } catch (error) {
        console.error(`Failed to render block ${pageSlug}/${blockKey}:`, error);
      }
    }

    // Multiple blocks elements
    const multiBlocks = document.querySelectorAll('[data-cms-page][data-cms-blocks]');
    for (const el of multiBlocks) {
      const pageSlug = el.dataset.cmsPage;
      const blockKeys = (el.dataset.cmsBlocks || '').split(',').map(k => k.trim()).filter(Boolean);
      
      const container = el.classList.contains('cms-blocks-container') ? el : null;
      
      for (const blockKey of blockKeys) {
        try {
          const block = await getBlock(pageSlug, blockKey);
          if (block) {
            if (container) {
              // Create wrapper for each block
              const wrapper = document.createElement('div');
              wrapper.className = `cms-block cms-block-${block.block_type}`;
              wrapper.dataset.blockKey = blockKey;
              renderBlock(wrapper, block);
              container.appendChild(wrapper);
            } else {
              // Render into single element (last one will show)
              renderBlock(el, block);
            }
          }
        } catch (error) {
          console.error(`Failed to render block ${pageSlug}/${blockKey}:`, error);
        }
      }
    }
  }

  /**
   * Get page metadata (title, description)
   * @param {string} pageSlug - Page slug
   * @returns {Promise<Object>} Page metadata
   */
  async function getPageMeta(pageSlug) {
    const data = await loadPage(pageSlug);
    return {
      title: data.content?.title || '',
      description: data.content?.description || '',
      content: data.content,
    };
  }

  /**
   * Clear cache (useful for admin refresh scenarios)
   */
  function clearCache() {
    cache.clear();
  }

  // Public API
  return {
    loadPage,
    getBlock,
    getBlocks,
    getBlockContent: processBlockContent,
    renderBlock,
    processBlockContent,
    autoRenderBlocks,
    getPageMeta,
    clearCache,
  };
})();

// Auto-render blocks when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => CMSLoader.autoRenderBlocks());
} else {
  CMSLoader.autoRenderBlocks().catch(console.error);
}
