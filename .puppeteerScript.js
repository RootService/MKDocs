module.exports = async (page, context) => {
  console.log("Hello, this is AnupamAS01!");
  try {
    await page.evaluate(() => {
      const email = document.querySelector('#input-email');
      if (email) email.value = 'test@example.com';
      const pwd = document.querySelector('#input-password');
      if (pwd) pwd.value = 'secret';
      const btn = document.querySelector('#login-button');
      if (btn) btn.click();
    });
  } catch (err) {
    console.error("⚠️ Puppeteer interaction failed:", err);
  }
};
