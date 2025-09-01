(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var title = document.querySelector('h1')?.textContent?.trim() || document.title;
    var desc = document.querySelector('meta[name="description"]')?.content || '';
    var json = {
      '@context': 'https://schema.org',
      '@type': 'TechArticle',
      'headline': title,
      'author': {'@type': 'Organization', 'name': 'RootService Team'},
      'publisher': {'@type': 'Organization', 'name': 'RootService'},
      'datePublished': document.querySelector('meta[name="date"]')?.content || undefined,
      'dateModified': document.querySelector('meta[name="updated"]')?.content || undefined,
      'inLanguage': 'de'
    };
    var script = document.createElement('script');
    script.type = 'application/ld+json';
    script.textContent = JSON.stringify(json, null, 2);
    document.head.appendChild(script);
  });
})();
