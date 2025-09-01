#!/usr/bin/env python3
"""
Generate screenshots of MkDocs site in light and dark mode using Playwright.
"""

import asyncio
from pathlib import Path
from playwright.async_api import async_playwright

OUT_DIR = Path("docs/assets/img")
OUT_DIR.mkdir(parents=True, exist_ok=True)

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context()
        page = await context.new_page()

        # Light mode
        await page.emulate_media(color_scheme="light")
        await page.goto("http://127.0.0.1:8000/")
        await page.screenshot(path=OUT_DIR / "preview-light.png", full_page=True)

        # Dark mode
        await page.emulate_media(color_scheme="dark")
        await page.goto("http://127.0.0.1:8000/")
        await page.screenshot(path=OUT_DIR / "preview-dark.png", full_page=True)

        await browser.close()

if __name__ == "__main__":
    asyncio.run(main())
