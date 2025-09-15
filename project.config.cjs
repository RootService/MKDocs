/**
 * Unified configuration for:
 * - Prettier
 * - ESLint (with TypeScript)
 * - Stylelint (CSS + HTML, no SCSS)
 * - linthtml (HTML linting)
 * - markdownlint-cli2 (Markdown linting)
 * - Commitlint (conventional commits)
 * - PostCSS (Autoprefixer + cssnano)
 *
 * Node.js 20 + MkDocs (Material theme) + Browserslist targets
 * Ignores: unified via .gitignore
 */

const { defineConfig } = require("eslint/config");
const tsEslint = require("@typescript-eslint");
const prettierConfig = require("eslint-config-prettier");

// Use .gitignore as single ignore source
const ignores = ["!**/.gitignore"];

module.exports = {
  prettier: {
    printWidth: 255,
    tabWidth: 2,
    useTabs: false,
    semi: true,
    singleQuote: true,
    quoteProps: "as-needed",
    jsxSingleQuote: false,
    trailingComma: "es5",
    bracketSpacing: true,
    bracketSameLine: false,
    arrowParens: "always",
    proseWrap: "preserve",
    htmlWhitespaceSensitivity: "css",
    vueIndentScriptAndStyle: false,
    endOfLine: "lf",
    embeddedLanguageFormatting: "auto",
    singleAttributePerLine: false,
    plugins: ["prettier-plugin-jinja-template"],
    overrides: [
      {
        files: ["*.html", "*.jinja", "*.j2"],
        options: { parser: "jinja-template" }
      }
    ],
    ignorePath: ".gitignore"
  },

  eslint: defineConfig([
    {
      files: ["**/*.{js,cjs,mjs,ts,tsx,json}"],
      ignores,
      ignorePatterns: ["!**/.gitignore"],
      languageOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        parser: tsEslint.parsers.typescript,
        parserOptions: {
          project: "./tsconfig.json",
          tsconfigRootDir: __dirname
        }
      },
      env: {
        browser: true,
        es2023: true,
        node: true
      },
      plugins: { "@typescript-eslint": tsEslint },
      rules: {
        "no-console": ["warn", { allow: ["warn", "error"] }],
        eqeqeq: ["error", "always"],
        curly: ["error", "multi-line"],
        "brace-style": ["error", "1tbs", { allowSingleLine: true }],
        "no-var": "error",
        "prefer-const": "error",
        "@typescript-eslint/no-unused-vars": [
          "warn",
          { argsIgnorePattern: "^_", varsIgnorePattern: "^_" }
        ],
        "@typescript-eslint/no-explicit-any": "warn",
        "@typescript-eslint/consistent-type-imports": "error",
        "@typescript-eslint/no-floating-promises": "error",
        ...prettierConfig.rules
      }
    },
    {
      files: ["docs/**/*.js"],
      rules: {
        "no-console": "off",
        "@typescript-eslint/no-explicit-any": "off"
      }
    },
    {
      files: ["**/*.{test,spec}.{js,ts}"],
      rules: {
        "no-unused-expressions": "off",
        "@typescript-eslint/no-explicit-any": "off"
      }
    }
  ]),

  stylelint: {
    extends: [
      "stylelint-config-standard",
      "stylelint-config-prettier",
      "stylelint-config-recommended",
      "stylelint-config-recess-order",
      "stylelint-config-html",
      "@stylistic/stylelint-config"
    ],
    plugins: ["@stylistic/stylelint-plugin", "stylelint-order"],
    overrides: [
      { files: ["**/*.{css,html,htm,j2,jinja,md,markdown}"], customSyntax: "postcss-html" }
    ],
    rules: {
      "alpha-value-notation": "number",
      "annotation-no-unknown": null,
      "at-rule-empty-line-before": [
        "always",
        {
          except: ["blockless-after-same-name-blockless", "first-nested"],
          ignore: ["after-comment"],
          ignoreAtRules: ["if", "each", "else", "elseif", "for", "import", "return"]
        }
      ],
      "at-rule-no-unknown": null,
      "color-function-notation": null,
      "color-hex-length": "long",
      "color-named": "never",
      "comment-empty-line-before": ["always", { ignore: ["stylelint-commands"] }],
      "custom-property-empty-line-before": null,
      "custom-property-pattern": null,
      "declaration-no-important": null,
      "declaration-block-single-line-max-declarations": 0,
      "font-family-name-quotes": "always-where-recommended",
      "font-weight-notation": "numeric",
      "function-calc-no-unspaced-operator": null,
      "function-no-unknown": null,
      "function-url-no-scheme-relative": true,
      "function-url-quotes": "always",
      "hue-degree-notation": "number",
      "length-zero-no-unit": [true, { ignore: ["custom-properties"] }],
      "media-feature-name-no-unknown": null,
      "media-feature-range-notation": null,
      "media-query-no-invalid": null,
      "no-descending-specificity": null,
      "no-empty-source": null,
      "no-unknown-animations": true,
      "order/properties-alphabetical-order": true,
      "property-no-unknown": null,
      "property-no-vendor-prefix": [true, { ignoreProperties: ["line-clamp", "box-orient"] }],
      "selector-class-pattern": null,
      "selector-id-pattern": null,
      "selector-max-id": 0,
      "selector-no-qualifying-type": null,
      "selector-pseudo-class-no-unknown": null,
      "selector-pseudo-element-no-unknown": null,
      "unit-allowed-list": [
        "%",
        "s",
        "ch",
        "dppx",
        "deg",
        "rem",
        "em",
        "fr",
        "mm",
        "ms",
        "px",
        "vh",
        "vw"
      ],
      "value-keyword-case": ["lower", { ignoreProperties: ["/^--/"] }],
      "value-no-vendor-prefix": [true, { ignoreValues: ["box"] }],
      "@stylistic/block-closing-brace-newline-after": ["always", { ignoreAtRules: ["if", "else", "elseif"] }],
      "@stylistic/declaration-colon-space-after": null,
      "@stylistic/no-empty-first-line": true,
      "@stylistic/linebreaks": "unix",
      "@stylistic/selector-combinator-space-before": null,
      "@stylistic/selector-descendant-combinator-no-non-space": null,
      "@stylistic/selector-max-empty-lines": 0,
      "@stylistic/string-quotes": "single",
      "@stylistic/unicode-bom": "never",
      "@stylistic/value-list-comma-newline-after": null
    },
    ignoreFiles: [
      "node_modules/**",
      "dist/**",
      "build/**",
      "site/**",
      "docs/_build/**",
      ".venv*/**",
      "venv/**"
    },
    ignorePath: ".gitignore"
  },

  linthtml: {
    rules: {
      "attr-bans": ["style", "align", "bgcolor", "border"],
      "attr-name-style": "dash",
      "attr-quote-style": "double",
      "attr-req-value": true,
      "attr-no-dup": true,
      "attr-name-lowercase": true,
      "attr-value-not-empty": true,
      "doctype-first": true,
      "doctype-html5": true,
      "head-req-title": true,
      "title-max-len": 120,
      "html-req-lang": true,
      "id-class-style": "dash",
      "img-req-alt": true,
      "img-req-src": true,
      "line-end-style": "lf",
      "line-max-len": 255,
      "line-no-trailing-whitespace": true,
      "indent-style": "spaces",
      "indent-width": 2,
      "spec-char-escape": true,
      "table-req-caption": false,
      "tag-bans": ["style", "font", "center", "blink"],
      "tag-name-lowercase": true,
      "tag-close": true,
      "tag-self-close": "always",
      "tag-req-attr": [
        { tag: "a", attr: ["href"] },
        { tag: "script", attr: ["src"], allowEmpty: true }
      ],
      "link-req-noopener": true,
      "raw-ignore-regex": "{[{%#][\\s\\S]*?[%#}]}"
    },
    ignoreFiles: [".gitignore"]
  },

  markdownlint: {
    "globs": ["docs/**/*.md"],
    "ignores": [
      "node_modules",
      "build",
      ".cache",
      "site",
      ".venv",
      "venv",
      ".vscode",
      ".github",
      ".lighthouseci",
      "overrides",
      "snippets",
      "tools"
    ]
    "gitignore": ".gitignore",
    "config": {
      "default": true,
      "MD001": true,
      "MD002": false,
      "MD003": {
        "style": "atx",
      },
      "MD004": {
        "style": "dash",
      },
      "MD007": {
        "indent": 2,
      },
      "MD009": true,
      "MD010": true,
      "MD012": { "maximum": 2 },
      "MD013": {
        "line_length": 255,
        "code_blocks": false,
        "tables": false,
        "headings": false,
      },
      "MD014": false,
      "MD018": true,
      "MD019": true,
      "MD022": true,
      "MD023": true,
      "MD025": { "front_matter_title": "" },
      "MD026": { "punctuation": ".,;:!?" },
      "MD026": {
        "punctuation": ".,;:",
      },
      "MD029": {
        "style": "ordered",
      },
      "MD030": {
        "ul_single": 1,
        "ol_single": 1,
        "ul_multi": 1,
        "ol_multi": 1,
      },
      "MD031": true,
      "MD032": true,
      "MD033": {
        "allowed_elements": ["br", "img", "details", "summary", "address", "kbd", "sup", "sub", "mark"],
      },
      "MD034": true,
      "MD035": {
        "style": "---",
      },
      "MD036": true,
      "MD037": true,
      "MD038": true,
      "MD039": true,
      "MD040": true,
      "MD041": false,
      "MD042": true,
      "MD043": false,
      "MD046": {
        "style": "fenced",
      },
      "MD048": {
        "style": "backtick",
      },
      "MD049": {
        "style": "asterisk",
      },
      "MD050": {
        "style": "asterisk",
      },
      "MD051": true,
      "MD053": true
    },
    ignorePath: ".gitignore"
  },

  commitlint: {
    extends: ["@commitlint/config-conventional"],
    rules: {
      "body-max-line-length": [2, "always", 100],
      "footer-max-line-length": [2, "always", 100],
      "subject-case": [2, "always", ["sentence-case", "start-case", "pascal-case"]],
      "type-enum": [
        2,
        "always",
        [
          "feat",
          "fix",
          "docs",
          "style",
          "refactor",
          "perf",
          "test",
          "build",
          "ci",
          "chore",
          "revert"
        ]
      ]
    }
  },

  postcss: {
    plugins: {
      "postcss-logical": {},
      "postcss-dir-pseudo-class": {},
      "postcss-pseudo-is": {},
      "postcss-inline-svg": {},
      autoprefixer: {},
      cssnano: { preset: "default" }
    }
  }
};
