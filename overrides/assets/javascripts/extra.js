// Lazy-load images and iframes
document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('img:not([loading]), iframe:not([loading])').forEach((el) => {
    el.setAttribute('loading', 'lazy');
    el.setAttribute('decoding', 'async');
  });
});
