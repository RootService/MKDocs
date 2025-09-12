// .stylelintrc.cjs  (Beispiel, CSS-only)
module.exports = {
  extends: ['stylelint-config-standard'],
  rules: {
    // moderne Notation: rgb() ohne Kommas, Alpha als Prozent
    'color-function-notation': 'modern',
    'color-function-alias-notation': true,         // rgba()/hsla() -> rgb()/hsl()
    'alpha-value-notation': 'percentage',          // z.B. 12% statt 0.12
    'color-hex-length': 'short',                   // #f6c statt #ff66cc (optional)
    // BEM + MkDocs-Klassen erlauben: foo, foo__el, foo--mod
    'selector-class-pattern': [
      '^[a-z0-9]+(?:-[a-z0-9]+)*(?:__(?:[a-z0-9]+(?:-[a-z0-9]+)*))?(?:--[a-z0-9]+(?:-[a-z0-9]+)*)?$',
      { resolveNestedSelectors: true }
    ],
  },
};
