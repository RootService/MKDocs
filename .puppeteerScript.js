module.exports = async (page, context) => {
  console.log("Hello, this is AnupamAS01!");
  try {
    await page.type('#input-email', 'test@example.com').catch(() => {});
    await page.type('#input-password', 'secret').catch(() => {});
    await page.click('#login-button').catch(() => {});
  } catch (err) {
    console.error("⚠️ Puppeteer interaction failed:", err);
  }
  await page.screenshot({ path: 'lighthouse-screenshot.png', fullPage: true });
};
