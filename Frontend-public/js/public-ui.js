document.addEventListener('DOMContentLoaded', () => {
  function notify(message, type) {
    if (typeof window.showToast === 'function') {
      window.showToast(message, type || 'info');
      return;
    }
    console.log(message);
  }

  async function copyText(text) {
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text);
        return true;
      }
    } catch (error) {
      console.warn('Clipboard API unavailable', error);
    }

    try {
      const input = document.createElement('textarea');
      input.value = text;
      input.setAttribute('readonly', '');
      input.style.position = 'absolute';
      input.style.left = '-9999px';
      document.body.appendChild(input);
      input.select();
      document.execCommand('copy');
      document.body.removeChild(input);
      return true;
    } catch (error) {
      console.warn('Fallback copy failed', error);
      return false;
    }
  }

  const header = document.querySelector('header');
  if (header) {
    header.querySelectorAll('button').forEach((button) => {
      const icon = button.querySelector('.material-symbols-outlined')?.textContent.trim();
      if (icon === 'person') {
        button.type = 'button';
        button.setAttribute('aria-label', 'Open login page');
        button.addEventListener('click', () => {
          window.location.href = 'user-login.html';
        });
      }

      if (icon === 'shopping_cart') {
        button.type = 'button';
        button.setAttribute('aria-label', 'Open checkout page');
        button.addEventListener('click', () => {
          window.location.href = 'checkout.html';
        });
      }
    });
  }

  document.querySelectorAll('footer a').forEach((link) => {
    const icon = link.querySelector('.material-symbols-outlined')?.textContent.trim();
    const label = link.textContent.replace(/\s+/g, ' ').trim();

    if (icon === 'share') {
      link.setAttribute('href', '');
      link.setAttribute('aria-label', 'Share this page');
      link.addEventListener('click', async (event) => {
        event.preventDefault();
        const shareData = { title: document.title, url: window.location.href };

        try {
          if (navigator.share) {
            await navigator.share(shareData);
            return;
          }
        } catch (error) {
          console.warn('Native share failed', error);
        }

        const copied = await copyText(window.location.href);
        notify(copied ? 'Page link copied.' : 'Share is unavailable on this device.', copied ? 'success' : 'error');
      });
      return;
    }

    if (icon === 'mail' || icon === 'location_on') {
      link.setAttribute('href', 'contact.html');
      return;
    }

    if (label === 'FAQ' || label === 'Help Center') {
      link.setAttribute('href', 'contact.html?intent=help');
      return;
    }

    if (label === 'Privacy Policy') {
      link.setAttribute('href', 'contact.html?intent=privacy');
      return;
    }

    if (label === 'Shipping Info') {
      link.setAttribute('href', 'contact.html?intent=shipping');
      return;
    }

    if (label === 'Terms of Service') {
      link.setAttribute('href', 'contact.html?intent=terms');
      return;
    }
  });

  document.querySelectorAll('footer button').forEach((button) => {
    const icon = button.querySelector('.material-symbols-outlined')?.textContent.trim();
    if (icon !== 'send') {
      return;
    }

    button.type = 'button';
    button.addEventListener('click', () => {
      const wrapper = button.parentElement;
      const emailInput = wrapper?.querySelector('input[type="email"]');
      const email = emailInput?.value.trim() || '';
      const query = email ? '&email=' + encodeURIComponent(email) : '';
      window.location.href = 'contact.html?intent=newsletter' + query;
    });
  });
});
