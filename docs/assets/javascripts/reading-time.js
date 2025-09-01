(function() {
  function textContent(node) { return node ? node.innerText || node.textContent || '' : ''; }
  function countWords(text) { return (text.trim().match(/\S+/g) || []).length; }
  function format(mins) { return mins <= 1 ? '~1 Min.' : '~' + Math.round(mins) + ' Min.'; }
  document.addEventListener('DOMContentLoaded', function() {
    var article = document.querySelector('.md-content__inner');
    if (!article) return;
    var words = countWords(textContent(article));
    var minutes = words / 200; // 200 wpm
    var badge = document.createElement('div');
    badge.setAttribute('aria-label', 'Lesezeit');
    badge.style.fontSize = '.85rem';
    badge.style.opacity = .8;
    badge.textContent = 'Lesezeit: ' + format(minutes);
    var h1 = article.querySelector('h1');
    if (h1 && h1.parentNode) { h1.parentNode.insertBefore(badge, h1.nextSibling); }
  });
})();
