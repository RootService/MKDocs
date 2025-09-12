#!/usr/bin/env node
// .github/scripts/format-lighthouse.cjs
'use strict'; // CJS unter Node 20

const fs = require('fs');
const path = require('path');

const DIR = process.env.LHCI_DIR || '.lighthouseci';
const PATTERN = /-lhr\.json$/i;
const PICK = (process.env.LH_PICK || 'latest').toLowerCase(); // 'latest' | 'best'

function listReports(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((f) => PATTERN.test(f))
    .map((f) => {
      const fp = path.join(dir, f);
      const st = fs.statSync(fp);
      return { file: fp, mtime: +st.mtime };
    })
    .sort((a, b) => b.mtime - a.mtime);
}

function readJson(fp) {
  try {
    return JSON.parse(fs.readFileSync(fp, 'utf8'));
  } catch {
    return null;
  }
}

function pickReport(files) {
  if (files.length === 0) return null;
  if (PICK === 'best') {
    let best = null,
      bestScore = -1;
    for (const f of files) {
      const j = readJson(f.file);
      if (!j || !j.categories || !j.categories.performance) continue;
      const s = Number(j.categories.performance.score || 0);
      if (s > bestScore) {
        bestScore = s;
        best = { meta: f, json: j };
      }
    }
    if (best) return best;
  }
  const j = readJson(files[0].file);
  return j ? { meta: files[0], json: j } : null;
}

function pct(x) {
  if (x == null || isNaN(x)) return '–';
  return Math.round(Number(x) * 100);
}

function fmtMs(ms) {
  if (ms == null || isNaN(ms)) return '–';
  ms = Number(ms);
  if (ms < 1000) return `${Math.round(ms)} ms`;
  return `${(ms / 1000).toFixed(2)} s`;
}

function fmtNumber(x, digits = 2) {
  if (x == null || isNaN(x)) return '–';
  return Number(x).toFixed(digits);
}

function findSiblingHtml(jsonFile) {
  const base = jsonFile.replace(/-lhr-.*\.json$/i, '');
  const dir = path.dirname(jsonFile);
  const candidates = fs.readdirSync(dir).filter((f) => f.startsWith(path.basename(base)) && f.endsWith('.html'));
  if (candidates.length > 0) return path.join(dir, candidates[0]);
  return null;
}

const reports = listReports(DIR);
const picked = pickReport(reports);

if (!picked) {
  console.log('### Lighthouse\n\nKein Report gefunden.');
  process.exit(0);
}

const r = picked.json;
const filePath = picked.meta.file;
const htmlPath = findSiblingHtml(filePath);

const cats = r.categories || {};
const audits = r.audits || {};
const url = r.finalUrl || '–';
const ua = r.userAgent || (r.configSettings && r.configSettings.formFactor) || '–';
const when = r.fetchTime || '–';

const perf = pct(cats.performance && cats.performance.score);
const a11y = pct(cats.accessibility && cats.accessibility.score);
const bp = pct(cats['best-practices'] && cats['best-practices'].score);
const seo = pct(cats.seo && cats.seo.score);

const FCP = fmtMs(audits['first-contentful-paint'] && audits['first-contentful-paint'].numericValue);
const SI = fmtMs(audits['speed-index'] && audits['speed-index'].numericValue);
const LCP = fmtMs(audits['largest-contentful-paint'] && audits['largest-contentful-paint'].numericValue);
const TBT = fmtMs(audits['total-blocking-time'] && audits['total-blocking-time'].numericValue);
const CLS = fmtNumber(audits['cumulative-layout-shift'] && audits['cumulative-layout-shift'].numericValue, 3);
const TTFB = fmtMs((audits['server-response-time'] || audits['time-to-first-byte']) && (audits['server-response-time']?.numericValue ?? audits['time-to-first-byte']?.numericValue));

let lines = [];
lines.push('### Lighthouse');
lines.push('');
lines.push(`**URL:** ${url}`);
lines.push(`**Zeit:** ${when}`);
lines.push(`**User-Agent/Formfactor:** ${ua}`);
lines.push(`**Quelle:** \`${path.relative(process.cwd(), filePath)}\`${htmlPath ? `  |  **HTML:** \`${path.relative(process.cwd(), htmlPath)}\`` : ''}`);
lines.push('');
lines.push('| Kategorie | Score |');
lines.push('|---|---:|');
lines.push(`| Performance | ${perf} |`);
lines.push(`| Accessibility | ${a11y} |`);
lines.push(`| Best Practices | ${bp} |`);
lines.push(`| SEO | ${seo} |`);
lines.push('');
lines.push('#### Kernmetriken');
lines.push('');
lines.push('| Metrik | Wert |');
lines.push('|---|---:|');
lines.push(`| First Contentful Paint | ${FCP} |`);
lines.push(`| Speed Index | ${SI} |`);
lines.push(`| Largest Contentful Paint | ${LCP} |`);
lines.push(`| Total Blocking Time | ${TBT} |`);
lines.push(`| Cumulative Layout Shift | ${CLS} |`);
lines.push(`| Time to First Byte | ${TTFB} |`);

console.log(lines.join('\n'));
