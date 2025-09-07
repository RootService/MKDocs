CI+A11Y Patch — 2025-09-07

Enthält:
- ci_steps/serve_site.yml, ci_steps/run_lhci.yml
- .lighthouserc.relaxed.json (optional)
- snippets/aria-dialog.html, snippets/aria-progressbar.html, snippets/alt-examples.md, snippets/heading-guidelines.md
- tools/a11y-audit.sh

Anwendung:
1) In `.github/workflows/ci.yml` die beiden Steps ersetzen (Serve + Run Lighthouse CI).
2) Optional `.lighthouserc.relaxed.json` vorübergehend als `.lighthouserc.json` nutzen.
3) A11Y: Snippets übernehmen, ALT/Headings korrigieren, `tools/a11y-audit.sh` ausführen.



Combined Patch — 2025-09-07

Includes:
- .lighthouserc.json (uses .desktopConfig.json)
- .desktopConfig.json
- overrides/assets/styles/extra.css (WCAG AA contrast adjustments)
- .markdownlint.json (enforce heading order)
- snippets/nginx-cache.conf
- tools/fix-tabs.sh
- tools/a11y-scan.sh
- tools/a11y-audit.sh
- .github/workflows/ci.yml (corrected, with Lighthouse, audit, security, summary)

How to apply:
1) Copy these files into your repo at the same paths.
2) Run:  sh tools/fix-tabs.sh .
3) Optionally run:  ./tools/a11y-audit.sh docs a11y-findings
4) Push. CI will build MkDocs, run Lighthouse, upload artifacts, and post summaries.
