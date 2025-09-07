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
