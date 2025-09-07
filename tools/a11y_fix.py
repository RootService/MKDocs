#!/usr/bin/env python3
# Automatic a11y fixer for Markdown and HTML in docs/.
# - Ensures images have alt text.
# - Adds role="img" when aria-label present.
# - Adds alt="" and role="presentation" for bare <img>.
import argparse, re
from pathlib import Path

DOCS = Path("docs")

IMG_MD_RE = re.compile(r"!\[(?P<alt>[^\]]*)\]\((?P<src>[^\s)]+)(?:\s+\"(?P<title>[^\"]*)\")?\)")
IMG_HTML_RE = re.compile(r"<img\b([^>]*?)>", re.IGNORECASE)

def fix_markdown(md: str) -> str:
    def repl(m):
        alt = (m.group("alt") or "").strip()
        src = m.group("src")
        title = m.group("title") or ""
        if not alt:
            alt = title.strip() if title.strip() else "Bild"
        return f"![{alt}]({src}" + (f' "{title}"' if title else "") + ")"
    return IMG_MD_RE.sub(repl, md)

def fix_html(html: str) -> str:
    def repl(m):
        attrs = m.group(1)
        has_alt = re.search(r"\balt\s*=\s*([\"'])", attrs, re.IGNORECASE)
        new_attrs = attrs
        if not has_alt:
            new_attrs = f' alt="" role="presentation" ' + (attrs.strip() or "")
        elif re.search(r"\baria-label\s*=\s*([\"']).+?\1", attrs, re.IGNORECASE) and "role=" not in attrs.lower():
            new_attrs = attrs.strip() + ' role="img"'
        return "<img " + new_attrs.strip() + ">"
    return IMG_HTML_RE.sub(repl, html)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--fix", action="store_true")
    args = ap.parse_args()

    changed = 0
    for p in DOCS.rglob("*"):
        if not p.is_file():
            continue
        if p.suffix.lower() in [".md", ".markdown", ".html", ".htm"]:
            txt = p.read_text(encoding="utf-8", errors="ignore")
            new = txt
            if p.suffix.lower() in [".md", ".markdown"]:
                new = fix_markdown(txt)
            else:
                new = fix_html(txt)
            if new != txt:
                changed += 1
                if args.fix:
                    p.write_text(new, encoding="utf-8")
                else:
                    print(f"Would change: {p}")
    print(f"Files changed: {changed}")

if __name__ == "__main__":
    main()
