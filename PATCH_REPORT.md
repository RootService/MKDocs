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

## Änderungen am 2025-09-02

- Dark-Mode als Default: Palette neu gesetzt (slate->dark, default->light) mit Magenta/Pink.
- Pygments: `material` aktiviert. Code-Highlighting per CSS-Variablen auf Magenta/Pink abgestimmt.
- WCAG/WAI-ARIA: Skip-Link ergänzt, `role="banner"` und `role="navigation"` gesetzt, Fokus sichtbar.
- JSON‑LD bleibt in `overrides/main.html`. Doppelter Client‑Injection via `schema.js` entfernt.
- CI: `mkdocs build --strict` forciert.
