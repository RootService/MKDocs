
[![CI](https://github.com/${{ github.repository }}/actions/workflows/ci.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/ci.yml)
[![Pages Deploy](https://github.com/${{ github.repository }}/actions/workflows/pages.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/pages.yml)
[![Release](https://github.com/${{ github.repository }}/actions/workflows/release.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/release.yml)
[![Lighthouse CI](https://github.com/${{ github.repository }}/actions/workflows/lighthouse.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/lighthouse.yml)



## Inhalt

## Projektstatus

| Workflow        | Status | Beschreibung |
|-----------------|--------|--------------|
| CI              | [![CI](https://github.com/${{ github.repository }}/actions/workflows/ci.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/ci.yml) | Lint, Tests und Build für mehrere OS/Versionen |
| Pages Deploy    | [![Pages Deploy](https://github.com/${{ github.repository }}/actions/workflows/pages.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/pages.yml) | Deployment nach GitHub Pages |
| Release         | [![Release](https://github.com/${{ github.repository }}/actions/workflows/release.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/release.yml) | Automatisierte Releases bei neuen Tags |
| Lighthouse Audit| [![Lighthouse CI](https://github.com/${{ github.repository }}/actions/workflows/lighthouse.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/lighthouse.yml) | Accessibility- und Performance-Audit (WCAG AA+) |




## ⚙️ Automation Workflows

This project uses **GitHub Actions** for CI/CD, release, and maintenance.
All workflows are in [`.github/workflows/`](.github/workflows/).

### 🔄 CI Pipeline (`ci.yml`)
Runs on every push/PR to `main`:
- Install dependencies with cached **pip**, **npm**, and **MkDocs** (3-day cache).
- Lint Markdown (`markdownlint`).
- Run tests (`pytest`).
- Build documentation site (`mkdocs build --strict`).
- Uploads build artifacts:
  - `site-${commit}` (7 days) and `site-latest` (3 days).
  - `lighthouse-${commit}` (7 days) and `lighthouse-latest` (3 days).
  - `screenshots-${commit}` (7 days) and `screenshots-latest` (3 days).
- Deploys site to **GitHub Pages** (main branch only).
- Runs **Lighthouse CI** for performance, accessibility, best practices, and SEO.
- Updates `README.md` table of contents automatically.
- Applies PR labels using `.github/labeler.yml`.

### 🚀 Release (`release.yml`)
Triggered on tag push `v*.*.*`:
- Reuses **site, Lighthouse, and screenshots artifacts** from CI if available.
- Falls back to rebuilding site if artifacts are missing.
- Generates **release notes**:
  - Includes Lighthouse scores.
  - Embeds screenshots inline.
- Release name embeds Lighthouse scores, e.g.:
- Publishes site, Lighthouse reports, and screenshots as release assets.

### 🛠️ Maintenance (`maintenance.yml`)
Runs on schedule:
- **Stale issues**: marks after 60d inactivity, closes after 14d more.
- **Badge auto-update**: updates README badges weekly (Mon 05:00 UTC).
- **GitHub Pages status check**: daily at 06:00 UTC.

### 💾 Retention & Caching
- **pip cache**: 3 days (per-commit, per-OS).
- **npm cache**: 3 days.
- **MkDocs build cache**: 3 days.
- **Artifacts**: 7 days (commit-specific) and 3 days (rolling latest).

This ensures fast rebuilds for active branches while keeping storage usage low.








Here’s a **migration checklist** to safely replace your old workflows with the new setup.

---

## ✅ Migration Checklist for GitHub Workflows

### 1. Backup & Cleanup

* [ ] Copy your existing `.github/workflows/` directory to a safe branch or folder.
* [ ] Remove old workflow files (`CI`, `Deploy Pages`, `Lighthouse CI`, `README TOC`, `Release`, `GitHub Pages Status`, `Close stale issues`, `Auto Label`, `Badge Auto-Update`).

### 2. Add New Workflows

* [ ] Create three new workflow files:

  * `.github/workflows/ci.yml`
  * `.github/workflows/release.yml`
  * `.github/workflows/maintenance.yml`
* [ ] Paste in the **final versions** provided.

### 3. Repo Configuration

* [ ] Ensure **GitHub Pages** is enabled in repository settings (`main` branch, `/docs` or `/site` as needed).
* [ ] Ensure **Actions permissions** allow read/write for contents and Pages.

### 4. Repository Files

* [ ] Verify a valid `VERSION` file exists at repo root (used for releases).
* [ ] Ensure `requirements.txt` and optionally `requirements-dev.txt` exist.
* [ ] Ensure `mkdocs.yml` is valid.
* [ ] Ensure `tools/update-badges.sh` and `tools/generate-screenshots.js` scripts exist and are executable.
* [ ] Ensure `.lighthouserc.json` is present for Lighthouse CI config.

### 5. Secrets & Permissions

* [ ] Confirm `secrets.GITHUB_TOKEN` is available (default).
* [ ] If extra tokens are used in `update-badges.sh`, configure them in **Settings > Secrets**.

### 6. Test CI

* [ ] Push a feature branch → confirm **CI** runs build, tests, MkDocs, Lighthouse.
* [ ] Confirm artifacts are uploaded (`site`, `lighthouse`, `screenshots`).
* [ ] Confirm TOC updates if README.md is changed.
* [ ] Confirm PR labeler works (based on `.github/labeler.yml`).

### 7. Test Release

* [ ] Create a tag `v0.1.0` and push it.
* [ ] Confirm **Release** workflow reuses artifacts (if CI ran).
* [ ] Confirm fallback rebuild works if artifacts missing.
* [ ] Check GitHub Release:

  * Title includes Lighthouse scores.
  * Notes include scores + screenshots.
  * Assets include site, Lighthouse reports, screenshots.

### 8. Test Maintenance

* [ ] Trigger **Maintenance** workflow manually (`workflow_dispatch`).
* [ ] Confirm it updates badges (commits new badge).
* [ ] Confirm stale issue logic works (configure a test repo if needed).
* [ ] Confirm Pages status check logs a result.

### 9. Optimize

* [ ] Monitor run times for CI and Release.
* [ ] Adjust cache retention (`retention-days`) if storage runs tight.
* [ ] Verify Lighthouse assertions thresholds in `.lighthouserc.json`.

---

✅ Following this ensures a **smooth transition** from fragmented workflows → unified, lean, and free-tier-safe setup.

Do you want me to also prepare a **rollback plan** (so you can restore old workflows if something fails)?

