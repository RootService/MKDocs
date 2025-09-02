# Patch-Report

Datum: 2025-09-02 00:13:30Z (UTC)

## Änderungen

- **Dark-Mode als Standard**: `mkdocs.yml` Palette neu strukturiert. Nur noch zwei Schemata (slate=dark, default=light) mit Umschalter. Auto-Erkennung entfernt.
- **Ungültige Farbe `magenta` behoben**: `primary` und `accent` auf `pink` gesetzt, echte Magenta/Pink-Töne über CSS-Variablen definiert.
- **Glossy-Magenta-Theming**: `overrides/assets/stylesheets/extra.css` erweitert. Primär-/Akzentfarben pro Scheme via `--md-*` Variablen. Glossy-Hintergründe vereinheitlicht. Fokus- und Link-Farben angepasst.
- **README-TOC Workflow abgesichert**: ersetzt durch `technote-space/toc-generator@v4` und auf `README.md` begrenzt.
- **GitHub Pages Deployment**: neues `pages.yml` nach Best Practice (Build + Artifact + Deploy).
- **Kleinaufraumung**: Entferntes `nav_style` im Theme-Block, da nicht offiziell unterstützt.

## Hinweise

- Das CSS nutzt gut kontrastierende Pink/Fuchsia-Töne für Dark/Light. Feinjustage möglich in `extra.css`.
- CI bleibt unverändert: `ci.yml` baut strikt und führt Lint/Tests aus.
- Lokales Setup weiter über `tools/setup-mkdocs.sh`.

## WCAG/WAI-ARIA Ergänzungen (2025-09-02)

- Main-Landmark: <main id="main-content" role="main" tabindex="-1"> für korrekten Fokus nach Skip-Link.
- Footer-Landmark: Wrapper mit role="contentinfo" um partials/footer.html.
- Header-Interaktionen: Drawer- und Such-Trigger mit role="button", aria-label, aria-controls versehen.
- High-Contrast: @media (forced-colors: active) Styles hinzugefügt; Outline in Systemfarbe, keine Schatten.
- Focus Appearance: verstärkte visuelle Markierung nach WCAG 2.2 (2.4.11/2.4.13).

## Lighthouse CI (2025-09-02)
- Workflow `.github/workflows/lighthouse.yml` hinzugefügt.
- `.lighthouserc.json` mit Schwellwerten und Desktop-Preset.
- Artefakte werden als `lighthouse-report` gespeichert.
- Ergebnisse erscheinen im Job Summary.

## Screenshots (2025-09-02)
- Neues Script `tools/generate-screenshots.js` (Puppeteer).
- Workflow `lighthouse.yml` erweitert: erstellt `screenshot-dark.png` und `screenshot-light.png`.
- Ergebnisse werden als Artifact `screenshots` hochgeladen.

## Screenshots (2025-09-02)
- `tools/generate-screenshots.js` mit Puppeteer.
- CI erzeugt Dark/Light Screenshots und lädt sie als `screenshots`-Artifact hoch.

## FreeBSD portmaster (2025-09-02)
- `setup-mkdocs.sh root` unterstützt jetzt `--portmaster` und `--portsnap` sowie `-y/--yes`.
- Automatik: nutzt `portmaster`, wenn vorhanden, sonst `pkg`.

## Strict mode removed (2025-09-02)
- `--strict` build-mode entfernt aus setup-mkdocs.sh, Workflows, Makefile, INSTALL.md.
