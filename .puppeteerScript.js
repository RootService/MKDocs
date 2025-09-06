module.exports = async (page, context) => {
  console.log("PuppeTeer is ready.");
  // LHCI gibt hier nur ein minimales Objekt, kein echtes Puppeteer-Page.
  // Deshalb keine page.type(), page.click() oder page.evaluate() möglich.
  return;
};
