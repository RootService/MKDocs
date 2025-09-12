// .github/scripts/format-lighthouse.js
const fs = require("fs");
const path = require("path");

function getLatestReport() {
  const dir = ".lighthouseci";
  if (!fs.existsSync(dir)) return null;
  const files = fs.readdirSync(dir).filter(f => f.endsWith("-lhr.json"));
  if (files.length === 0) return null;
  const sorted = files
    .map(f => path.join(dir, f))
    .sort((a, b) => fs.statSync(b).mtimeMs - fs.statSync(a).mtimeMs);
  return sorted[0];
}

const reportPath = getLatestReport();
if (!reportPath) {
  console.log("No Lighthouse report found");
  process.exit(0);
}

const report = JSON.parse(fs.readFileSync(reportPath, "utf8"));
let out = "### ⚡ Lighthouse Scores\\n\\n";
out += "| Kategorie | Score |\\n|-----------|-------|\\n";
for (const [k, v] of Object.entries(report.categories || {})) {
  out += `| ${k} | ${Math.round((v.score || 0) * 100)} |\\n`;
}
console.log(out);
