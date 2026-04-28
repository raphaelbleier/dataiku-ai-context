#!/usr/bin/env python3
"""
Scrape Dataiku docs to markdown files.
Targets:
  - https://doc.dataiku.com/dss/latest/
  - https://developer.dataiku.com/latest/
"""

import os
import re
import time
import hashlib
from pathlib import Path
from urllib.parse import urljoin, urlparse, urldefrag
from collections import deque

import requests
from bs4 import BeautifulSoup
import html2text

TARGETS = [
    "https://doc.dataiku.com/dss/latest/",
    "https://developer.dataiku.com/latest/",
]

OUT_DIR = Path("dataiku_docs")
DELAY = 0.3  # seconds between requests
TIMEOUT = 30
MAX_RETRIES = 3

SESSION = requests.Session()
SESSION.headers.update({
    "User-Agent": "Mozilla/5.0 (compatible; DocScraper/1.0)"
})

H2T = html2text.HTML2Text()
H2T.ignore_links = False
H2T.ignore_images = True
H2T.body_width = 0
H2T.protect_links = True
H2T.unicode_snob = True


def normalize_url(url: str) -> str:
    url, _ = urldefrag(url)
    if url.endswith("/index.html") or url.endswith("/index"):
        pass
    return url.rstrip("/") if not url.endswith(".html") else url


def url_to_path(url: str, base_url: str) -> Path:
    parsed = urlparse(url)
    base_parsed = urlparse(base_url)

    # Use domain as top-level folder
    domain = parsed.netloc.replace(".", "_")
    path = parsed.path.lstrip("/")

    if not path or path.endswith("/"):
        path = path + "index"

    if path.endswith(".html"):
        path = path[:-5]

    # Sanitize
    path = re.sub(r"[^\w/\-.]", "_", path)
    return OUT_DIR / domain / (path + ".md")


def is_in_scope(url: str, base_url: str) -> bool:
    parsed = urlparse(url)
    base_parsed = urlparse(base_url)
    # Same host, path starts with base path
    if parsed.netloc != base_parsed.netloc:
        return False
    base_path = base_parsed.path.rstrip("/")
    return parsed.path.startswith(base_path)


def fetch(url: str) -> str | None:
    for attempt in range(MAX_RETRIES):
        try:
            resp = SESSION.get(url, timeout=TIMEOUT)
            if resp.status_code == 200:
                return resp.text
            elif resp.status_code == 404:
                return None
            else:
                print(f"  HTTP {resp.status_code}: {url}")
                return None
        except Exception as e:
            if attempt < MAX_RETRIES - 1:
                time.sleep(2 ** attempt)
            else:
                print(f"  FAILED after {MAX_RETRIES} attempts: {url} — {e}")
    return None


def extract_content(html: str, url: str) -> tuple[str, list[str]]:
    soup = BeautifulSoup(html, "html.parser")

    # Extract links before stripping
    links = []
    for a in soup.find_all("a", href=True):
        href = a["href"]
        if href.startswith(("mailto:", "javascript:", "#")):
            continue
        abs_url = urljoin(url, href)
        abs_url, _ = urldefrag(abs_url)
        links.append(abs_url)

    # Try to isolate main content (Sphinx docs)
    main = (
        soup.find("div", {"class": "document"})
        or soup.find("div", {"role": "main"})
        or soup.find("article")
        or soup.find("main")
        or soup.find("div", {"class": "body"})
        or soup.find("div", {"id": "content"})
        or soup.body
    )

    if main is None:
        return "", links

    # Remove nav/sidebar noise
    for tag in main.find_all(["nav", "footer", "script", "style"]):
        tag.decompose()
    for tag in main.find_all(class_=re.compile(r"sidebar|toctree|navigation|breadcrumb|headerlink|prev|next")):
        tag.decompose()

    md = H2T.handle(str(main))
    return md.strip(), links


def scrape(base_url: str):
    queue = deque([base_url])
    visited = set()
    saved = 0
    skipped = 0

    print(f"\n=== Scraping {base_url} ===")

    while queue:
        url = queue.popleft()
        norm = normalize_url(url)

        if norm in visited:
            continue
        visited.add(norm)

        if not is_in_scope(norm, base_url):
            continue

        # Only process HTML pages
        if any(norm.endswith(ext) for ext in [".pdf", ".zip", ".png", ".jpg", ".gif", ".svg", ".js", ".css"]):
            continue

        out_path = url_to_path(norm, base_url)

        # Skip if already scraped (resume support)
        if out_path.exists():
            skipped += 1
            # Still extract links to keep crawling
            html = None
        else:
            time.sleep(DELAY)
            html = fetch(norm)

        if html is not None:
            md, links = extract_content(html, norm)

            if md:
                out_path.parent.mkdir(parents=True, exist_ok=True)
                # Add source URL header
                full_md = f"<!-- source: {norm} -->\n\n{md}"
                out_path.write_text(full_md, encoding="utf-8")
                saved += 1
                if saved % 50 == 0:
                    print(f"  Saved {saved} pages, queue={len(queue)}, visited={len(visited)}")
        elif out_path.exists():
            # Read existing file to extract links for continued crawl
            existing = out_path.read_text(encoding="utf-8")
            links = []
        else:
            links = []

        if html is not None:
            for link in links:
                link_norm = normalize_url(link)
                if link_norm not in visited and is_in_scope(link_norm, base_url):
                    queue.append(link)

    print(f"  Done: {saved} new pages saved, {skipped} skipped (already exist), {len(visited)} total visited")
    return saved


def main():
    OUT_DIR.mkdir(exist_ok=True)
    total = 0
    for url in TARGETS:
        total += scrape(url)
    print(f"\nTotal new pages saved: {total}")
    print(f"Output directory: {OUT_DIR.resolve()}")


if __name__ == "__main__":
    main()
