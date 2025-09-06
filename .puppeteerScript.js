module.exports = async (page, context) => {
  console.log("Hello, this is AnupamAS01!");

  // Try to fill email field if it exists
  const emailField = await page.$('#input-email');
  if (emailField) {
    await emailField.type('test@example.com');
  } else {
    console.log('⚠️ No #input-email field found, skipping typing.');
  }

  // Try to fill password field if it exists
  const passwordField = await page.$('#input-password');
  if (passwordField) {
    await passwordField.type('secret');
  } else {
    console.log('⚠️ No #input-password field found, skipping typing.');
  }

  // Optionally click login button if present
  const loginButton = await page.$('#login-button');
  if (loginButton) {
    await loginButton.click();
  } else {
    console.log('⚠️ No #login-button found, skipping click.');
  }

  // Take screenshot of the page
  try {
    await page.screenshot({ path: 'lighthouse-screenshot.png', fullPage: true });
    console.log('📸 Screenshot saved: lighthouse-screenshot.png');
  } catch (err) {
    console.error('❌ Failed to take screenshot', err);
  }
};
