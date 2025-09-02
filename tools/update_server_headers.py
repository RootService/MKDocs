#!/usr/bin/env python3
import os, base64, hashlib, pathlib
from bs4 import BeautifulSoup  # pip install beautifulsoup4

SITE = pathlib.Path("site")
NGINX_CONF = SITE / ".nginx-csp.conf"
APACHE_HTA = SITE / ".htaccess"
CSP_ENV = os.getenv("CSP_ENV", "production").lower()

script_hashes, style_hashes = set(), set()

for htmlp in SITE.rglob("*.html"):
    soup = BeautifulSoup(htmlp.read_text(encoding="utf-8", errors="ignore"), "html.parser")
    for tag in soup.find_all("script"):
        if tag.has_attr("src"): continue
        content = (tag.string or "").encode("utf-8")
        if not content.strip(): continue
        h = base64.b64encode(hashlib.sha256(content).digest()).decode()
        script_hashes.add(f"'sha256-{h}'")
    for tag in soup.find_all("style"):
        content = (tag.string or "").encode("utf-8")
        if not content.strip(): continue
        h = base64.b64encode(hashlib.sha256(content).digest()).decode()
        style_hashes.add(f"'sha256-{h}'")

STYLE = " ".join(sorted(style_hashes))
SCRIPT = " ".join(sorted(script_hashes))

if CSP_ENV == "preview":
    csp = (
        "upgrade-insecure-requests; "
        "default-src 'self'; "
        "base-uri 'self'; "
        "child-src 'self'; "
        "connect-src 'self' https: ws: wss: http://127.0.0.1:* http://localhost:*; "
        "font-src 'self' data: https://fonts.gstatic.com; "
        "form-action 'self' "
        "frame-src 'self'; "
        "fenced-frame-src 'self'; "
        "img-src 'self' https: data:; "
        "manifest-src 'self'; "
        "media-src 'self' https: data:; "
        "object-src 'none'; "
        f"script-src 'self' {SCRIPT} 'report-sample'; "
        f"style-src 'self' https://fonts.googleapis.com {STYLE}; 'report-sample'; "
        "webrtc-src 'block'; "
        "worker-src 'self'; "
        "form-action 'self' https:; "
        "frame-ancestors 'self'; "
        "base-uri 'self'; "
        "sandbox allow-downloads allow-forms allow-modals allow-orientation-lock allow-pointer-lock allow-popups allow-popups-to-escape-sandbox allow-presentation allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation; "
        "report-uri https://www.rootservice.org/default-endpoint.php; "
        "report-to default-endpoint"
    )
else:
    csp = (
        "upgrade-insecure-requests; "
        "default-src 'self'; "
        "base-uri 'self'; "
        "child-src 'self'; "
        "connect-src 'self' https: ws: wss: http://127.0.0.1:* http://localhost:*; "
        "font-src 'self' data: https://fonts.gstatic.com;; "
        "form-action 'self' "
        "frame-src 'self'; "
        "fenced-frame-src 'self'; "
        "img-src 'self' https: data:; "
        "manifest-src 'self'; "
        "media-src 'self' https: data:; "
        "object-src 'none'; "
        f"script-src 'self' {SCRIPT} 'report-sample'; "
        f"style-src 'self' https://fonts.googleapis.com {STYLE}; 'report-sample'; "
        "webrtc-src 'block'; "
        "worker-src 'self'; "
        "form-action 'self' https:; "
        "frame-ancestors 'none'; "
        "base-uri 'self'; "
        "sandbox allow-downloads allow-forms allow-modals allow-orientation-lock allow-pointer-lock allow-popups allow-popups-to-escape-sandbox allow-presentation allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation; "
        "report-uri https://www.rootservice.org/default-endpoint.php; "
        "report-to default-endpoint"
    )

NGINX_CONF.write_text(
    f"add_header Content-Security-Policy \"{csp}\" always;\n",
    encoding="utf-8",
)
APACHE_HTA.write_text(
    "<IfModule mod_headers.c>\n"
    f'  Header always set Content-Security-Policy "{csp}"\n'
    "</IfModule>\n",
    encoding="utf-8",
)
