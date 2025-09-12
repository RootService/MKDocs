# MKDocs Documentation

[![MkDocs CI](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg)](https://github.com/RootService/MKDocs/actions/workflows/ci.yml)
[![CodeQL](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg?event=codeql)](https://github.com/RootService/MKDocs/security/code-scanning)
[![Performance](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/RootService/MKDocs/gh-pages/lh-scores.json&label=Performance&query=$.performance&color=green)]()
[![Accessibility](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/RootService/MKDocs/gh-pages/lh-scores.json&label=Accessibility&query=$.accessibility&color=green)]()
[![Best Practices](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/RootService/MKDocs/gh-pages/lh-scores.json&label=Best%20Practices&query=$."best-practices"&color=green)]()
[![SEO](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/RootService/MKDocs/gh-pages/lh-scores.json&label=SEO&query=$.seo&color=green)]()
[![License](https://img.shields.io/github/license/RootService/MKDocs)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/RootService/MKDocs.svg)](https://github.com/RootService/MKDocs/commits/main)
[![GitHub release](https://img.shields.io/github/v/release/RootService/MKDocs)](https://github.com/RootService/MKDocs/releases)
[![Open Issues](https://img.shields.io/github/issues/RootService/MKDocs.svg)](https://github.com/RootService/MKDocs/issues)
[![Dependabot Status](https://img.shields.io/badge/dependabot-enabled-brightgreen?logo=dependabot)](https://docs.github.com/en/code-security/dependabot/dependabot-security-updates)

## Project Status

[![CI](https://github.com/RootService/MKDocs/actions/workflows/ci.yml/badge.svg)](https://github.com/RootService/MKDocs/actions/workflows/ci.yml)
[![CodeQL Analysis](https://github.com/RootService/MKDocs/actions/workflows/codeql.yml/badge.svg)](https://github.com/RootService/MKDocs/actions/workflows/codeql.yml)
[![Dependabot Updates](https://img.shields.io/badge/Dependabot-enabled-brightgreen?logo=dependabot)](https://github.com/RootService/MKDocs/network/updates)

[![Python Dependencies](https://img.shields.io/badge/pip-requirements-blue?logo=python)](requirements.txt)
[![npm Dependencies](https://img.shields.io/badge/npm-deps-blue?logo=npm)](package.json)

[![Lighthouse Scores](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/RootService/MKDocs/gh-pages/lh-scores.json)](https://RootService.github.io/MKDocs/lh-scores.json)

[![GitHub Pages](https://img.shields.io/github/deployments/RootService/MKDocs/github-pages?label=docs)](https://RootService.github.io/MKDocs/)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)


## 🔧 GitHub Workflows Overview

This repository uses a **failsafe CI/CD and automation suite** with self-documenting workflows.  
All workflows are in [`.github/workflows`](.github/workflows).

### 1. **Continuous Integration (ci.yml)**

- **When it runs**:  
  - On every push, pull request, and monthly schedule.  
- **What it does**:  
  - Sets up Node.js and Python environments.  
  - Installs dependencies.  
  - Builds MkDocs documentation.  
  - Deploys to GitHub Pages on `main` branch.  
- **Enforced rules**: Always builds from scratch to ensure reproducibility.

---

### 2. **Linting and Static Analysis (lint.yml)**

- **When it runs**: On PRs and pushes.  
- **What it does**:  
  - Runs ESLint, Prettier, and Stylelint for JS/TS/CSS.  
  - Runs Black, Flake8, and MyPy for Python.  
- **Enforced rules**: Code must meet style and type-checking standards.

---

### 3. **Automated Release (release.yml)**

- **When it runs**: On pushes to `main`.  
- **What it does**:  
  - Uses **semantic-release** to:  
    - Analyze commits (Conventional Commits).  
    - Bump version (major/minor/patch).  
    - Update `CHANGELOG.md`.  
    - Tag a release and publish GitHub Release.  
- **Enforced rules**: Commit messages control versioning.

---

### 4. **Security Scan (security.yml)**

- **When it runs**: Weekly and on manual trigger.  
- **What it does**:  
  - Scans Python dependencies with **Safety**.  
  - Runs `npm audit` for Node.js dependencies.  
- **Enforced rules**: Alerts on vulnerable packages.

---

### 5. **Dependabot Automation**

- **Dependabot (dependabot.yml)**:  
  - Groups updates by ecosystem (`pip`, `npm`, `github-actions`).  
  - Splits major vs minor/patch updates.  
- **Auto-Merge (dependabot-auto-merge.yml)**:  
  - Approves and auto-merges minor/patch PRs after CI passes.  
- **Labeling (dependabot-label.yml)**:  
  - Labels PRs by ecosystem (`pip`, `npm`, `actions`) and update type (`major`, `minor`, `patch`).  

---

### 6. **Label Management**

- **Label Sync (label-sync.yml + labels.yml)**:  
  - Ensures repo labels are consistent (dependencies, ci, lint, release, security, etc.).  
- **PR Labeler (pr-labeler.yml + labeler.yml)**:  
  - Auto-labels PRs based on touched files, branch names, or commit messages.  
- **Require Labels (require-label.yml)**:  
  - Blocks merging if a PR lacks at least one valid label (`feat`, `fix`, `docs`, `ci`, etc.).  

---

### 7. **Commit Message Linting (commitlint.yml)**

- **When it runs**: On PRs.  
- **What it does**:  
  - Installs **commitlint**.  
  - Ensures commits follow Conventional Commits (`feat:`, `fix:`, `docs:`, etc.).  
- **Enforced rules**: Prevents unstructured commit history.

---

## 🚀 Maintainer Notes

- **Labels**: Auto-applied, but can be adjusted manually.  
- **Releases**: Fully automated by semantic-release.  
- **Merging**: PRs without required labels or valid commit messages cannot be merged.  
- **Security**: Weekly audits; fix PRs are generated by Dependabot.  

