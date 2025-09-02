const fs = require("fs");
const path = require("path");
const puppeteer = require("puppeteer");

(async () => {
  const baseUrl = process.env.BASE_URL || "http://localhost:8080/";
  const outDir = path.resolve(".screenshots");
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  const modes = [
    { name: "dark", value: "dark" },
    { name: "light", value: "light" }
  ];

  const browser = await puppeteer.launch({ headless: "new" });
  const page = await browser.newPage();
  await page.setViewport({ width: 1440, height: 900 });

  for (const m of modes) {
    await page.emulateMediaFeatures([{ name: "prefers-color-scheme", value: m.value }]);
    await page.goto(baseUrl, { waitUntil: "networkidle0" });
    const file = path.join(outDir, `screenshot-${m.name}.png`);
    await page.screenshot({ path: file, fullPage: true });
    console.log(`Saved ${file}`);
  }

  await browser.close();
})().catch(err => {
  console.error(err);
  process.exit(1);
});
