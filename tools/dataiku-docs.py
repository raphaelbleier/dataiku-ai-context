#!/usr/bin/env python3
"""
dataiku-docs — bundle scraped Dataiku docs and install them for AI coding tools.

Commands:
  bundle   [--docs-dir PATH]                  Merge raw pages into topic bundles
  install  <tool> [--docs-dir PATH]           Install bundles for an AI coding tool
           [--target PATH]
  list                                         List supported tools

Supported tools: claude, cursor, copilot, windsurf, aider, continue, cline, all
"""

import argparse
import json
import os
import re
import shutil
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DOCS_DIR_DEFAULT = Path(__file__).parent / "dataiku_docs"
BUNDLE_DIR_NAME = "bundles"
MAX_BUNDLE_BYTES = 400_000  # ~400 KB per bundle file

# Map top-level folder names → human-readable bundle names
TOPIC_LABELS = {
    # doc.dataiku.com
    "concepts": "concepts",
    "connecting": "connecting-to-data",
    "explore": "data-exploration",
    "flow": "flow",
    "preparation": "data-preparation",
    "other_recipes": "visual-recipes",
    "code_recipes": "code-recipes",
    "generative-ai": "generative-ai-llm",
    "agents": "ai-agents",
    "semantic-models": "semantic-models",
    "ai-assistants": "ai-assistants",
    "visualization": "charts-visualization",
    "machine-learning": "machine-learning",
    "mlops": "mlops",
    "notebooks": "notebooks",
    "code-studios": "code-studios",
    "webapps": "webapps",
    "dashboards": "dashboards",
    "data-catalog": "data-catalog",
    "data-lineage": "data-lineage",
    "time-series": "time-series",
    "geographic": "geographic-data",
    "graph": "graph-data",
    "nlp": "nlp-text",
    "unstructured-data": "unstructured-data",
    "metrics-check-data-quality": "metrics-data-quality",
    "scenarios": "automation-scenarios",
    "deployment": "deployment",
    "apinode": "api-node-deployer",
    "governance": "ai-governance",
    "installation": "installation",
    "containers": "elastic-ai-containers",
    "cloud": "dss-cloud",
    "hadoop": "hadoop",
    "operations": "operations",
    "security": "security",
    "user-isolation": "user-isolation",
    "python-api": "python-api",
    "R-api": "r-api",
    "publicapi": "public-rest-api",
    "api": "additional-apis",
    "plugins": "plugins",
    "streaming": "streaming",
    "release_notes": "release-notes",
    "troubleshooting": "troubleshooting",
    # developer.dataiku.com
    "getting-started": "dev-getting-started",
    "concepts-and-examples": "dev-concepts-examples",
    "tutorials": "dev-tutorials",
    "api-reference": "dev-api-reference",
}


# ---------------------------------------------------------------------------
# Bundle
# ---------------------------------------------------------------------------

def bundle(docs_dir: Path) -> Path:
    bundle_dir = docs_dir / BUNDLE_DIR_NAME
    bundle_dir.mkdir(exist_ok=True)

    # Collect all source .md files grouped by topic
    groups: dict[str, list[Path]] = {}

    for root_dir in [docs_dir / "doc_dataiku_com" / "dss" / "latest",
                     docs_dir / "developer_dataiku_com" / "latest"]:
        if not root_dir.exists():
            print(f"  WARNING: {root_dir} not found, skipping")
            continue

        for child in sorted(root_dir.iterdir()):
            if child.is_dir():
                key = TOPIC_LABELS.get(child.name, child.name)
                files = sorted(child.rglob("*.md"))
                if files:
                    groups.setdefault(key, []).extend(files)
            elif child.suffix == ".md" and child.stem not in ("genindex",):
                groups.setdefault("_root", []).append(child)

    # Write bundles
    index_entries: list[str] = []
    total_files = 0

    for topic, files in sorted(groups.items()):
        if topic == "_root":
            continue
        part = 0
        buf: list[str] = []
        buf_size = 0
        written_parts: list[Path] = []

        def flush(buf, part, topic, bundle_dir):
            if not buf:
                return None
            stem = topic if part == 0 else f"{topic}-part{part}"
            out = bundle_dir / f"{stem}.md"
            header = f"# Dataiku Docs — {topic}\n\n"
            out.write_text(header + "\n\n---\n\n".join(buf), encoding="utf-8")
            return out

        for f in files:
            try:
                text = f.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            # Strip HTML comment source line
            text = re.sub(r"<!-- source:.*?-->\n\n?", "", text, count=1)
            text = text.strip()
            if not text:
                continue

            # Relative label from file path
            rel = str(f).split("latest/", 1)[-1].replace(".md", "")
            section = f"## [{rel}]\n\n{text}"

            if buf_size + len(section) > MAX_BUNDLE_BYTES and buf:
                out = flush(buf, part, topic, bundle_dir)
                if out:
                    written_parts.append(out)
                buf, buf_size, part = [], 0, part + 1

            buf.append(section)
            buf_size += len(section)
            total_files += 1

        out = flush(buf, part, topic, bundle_dir)
        if out:
            written_parts.append(out)

        for p in written_parts:
            size_kb = p.stat().st_size // 1024
            index_entries.append(f"- [{p.stem}]({p.name}) ({size_kb} KB, {len(files)} pages)")

    # Write master index
    index_path = bundle_dir / "INDEX.md"
    index_path.write_text(
        "# Dataiku Documentation — Bundle Index\n\n"
        "Generated from doc.dataiku.com and developer.dataiku.com\n\n"
        "## Bundles\n\n" + "\n".join(index_entries) + "\n\n"
        "## How to use\n\n"
        "Load a specific bundle file when working on a related task. "
        "Each bundle contains the full documentation for one topic area.\n",
        encoding="utf-8",
    )

    print(f"  Bundled {total_files} pages → {len(index_entries)} bundle files")
    print(f"  Index: {index_path}")
    print(f"  Bundles dir: {bundle_dir}")
    return bundle_dir


# ---------------------------------------------------------------------------
# Installer helpers
# ---------------------------------------------------------------------------

def resolve_docs_dir(docs_dir: Path) -> Path:
    if not docs_dir.exists():
        sys.exit(f"ERROR: docs dir not found: {docs_dir}\nRun 'bundle' first.")
    bundle_dir = docs_dir / BUNDLE_DIR_NAME
    if not bundle_dir.exists():
        sys.exit(f"ERROR: bundles not found in {docs_dir}\nRun 'bundle' first.")
    return bundle_dir


def copy_bundles(bundle_dir: Path, dest: Path):
    if dest.exists():
        shutil.rmtree(dest)
    dest.mkdir(parents=True, exist_ok=True)
    count = 0
    # use os.scandir — more reliable than Path.glob on WSL/Windows filesystems
    for entry in os.scandir(bundle_dir):
        if entry.is_file() and entry.name.endswith(".md"):
            try:
                shutil.copy2(entry.path, dest / entry.name)
                count += 1
            except OSError as e:
                print(f"  WARNING: skipped {entry.name}: {e}")
    print(f"  Copied {count} bundle files → {dest}")


def read_existing(path: Path) -> str:
    return path.read_text(encoding="utf-8") if path.exists() else ""


def append_unique(path: Path, marker: str, content: str):
    existing = read_existing(path)
    if marker in existing:
        print(f"  {path} already contains dataiku block, skipping")
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write("\n" + content)
    print(f"  Updated: {path}")


# ---------------------------------------------------------------------------
# Per-tool installers
# ---------------------------------------------------------------------------

def install_claude(bundle_dir: Path, target: Path):
    """Claude Code: copy bundles to .claude/dataiku/, add CLAUDE.md snippet."""
    dest = target / ".claude" / "dataiku"
    copy_bundles(bundle_dir, dest)

    snippet = (
        "<!-- DATAIKU DOCS -->\n"
        "## Dataiku Documentation\n\n"
        "Full Dataiku DSS and Developer docs are available as markdown bundles in `.claude/dataiku/`.\n"
        "Use `@.claude/dataiku/INDEX.md` to find the right bundle, then load it with `@<bundle-file>`.\n"
        "Key bundles: `concepts.md`, `python-api.md`, `dev-concepts-examples.md`, `machine-learning.md`\n"
        "<!-- END DATAIKU DOCS -->\n"
    )
    append_unique(target / "CLAUDE.md", "DATAIKU DOCS", snippet)


def install_cursor(bundle_dir: Path, target: Path):
    """Cursor: create .cursor/rules/dataiku.mdc"""
    rules_dir = target / ".cursor" / "rules"
    rules_dir.mkdir(parents=True, exist_ok=True)

    # Copy bundles alongside rules
    dest = target / ".cursor" / "dataiku"
    copy_bundles(bundle_dir, dest)

    bundles = sorted(dest.glob("*.md"))
    bundle_list = "\n".join(f"- `{b.name}`" for b in bundles if b.name != "INDEX.md")

    rule = (
        "---\n"
        "description: Dataiku DSS documentation reference\n"
        "globs: ['**/*.py', '**/*.ipynb', '**/*.json']\n"
        "alwaysApply: false\n"
        "---\n\n"
        "# Dataiku Documentation\n\n"
        "When working on Dataiku DSS tasks, reference the documentation bundles in `.cursor/dataiku/`.\n\n"
        "## Finding the right bundle\n\n"
        "Load `.cursor/dataiku/INDEX.md` to see all topics, then open the relevant bundle.\n\n"
        "## Available bundles\n\n"
        f"{bundle_list}\n\n"
        "## Key patterns\n\n"
        "- Python API: see `python-api.md` and `dev-concepts-examples.md`\n"
        "- ML workflows: see `machine-learning.md` and `mlops.md`\n"
        "- LLM/GenAI: see `generative-ai-llm.md` and `ai-agents.md`\n"
        "- Data prep: see `data-preparation.md` and `code-recipes.md`\n"
    )
    out = rules_dir / "dataiku.mdc"
    out.write_text(rule, encoding="utf-8")
    print(f"  Created: {out}")


def install_copilot(bundle_dir: Path, target: Path):
    """GitHub Copilot: .github/copilot-instructions.md"""
    dest = target / ".github" / "dataiku"
    copy_bundles(bundle_dir, dest)

    bundles = sorted(dest.glob("*.md"))
    bundle_list = "\n".join(f"- `{b.name}`" for b in bundles if b.name != "INDEX.md")

    snippet = (
        "\n<!-- DATAIKU DOCS -->\n"
        "## Dataiku DSS Documentation\n\n"
        "Dataiku documentation bundles are in `.github/dataiku/`. "
        "Reference them when answering Dataiku-related questions.\n\n"
        "### Available topic bundles\n\n"
        f"{bundle_list}\n"
        "<!-- END DATAIKU DOCS -->\n"
    )
    append_unique(target / ".github" / "copilot-instructions.md", "DATAIKU DOCS", snippet)


def install_windsurf(bundle_dir: Path, target: Path):
    """Windsurf: .windsurfrules"""
    dest = target / ".windsurf" / "dataiku"
    copy_bundles(bundle_dir, dest)

    bundles = sorted(dest.glob("*.md"))
    bundle_list = "\n".join(f"- `{b.name}`" for b in bundles if b.name != "INDEX.md")

    snippet = (
        "\n# DATAIKU DOCS\n"
        "## Dataiku Documentation Reference\n\n"
        "Dataiku DSS documentation is in `.windsurf/dataiku/`.\n"
        "When working on Dataiku tasks, load the relevant bundle from:\n\n"
        f"{bundle_list}\n"
        "Start with `INDEX.md` to find the right bundle.\n"
        "# END DATAIKU DOCS\n"
    )
    append_unique(target / ".windsurfrules", "DATAIKU DOCS", snippet)


def install_aider(bundle_dir: Path, target: Path):
    """Aider: create dataiku-docs/ and a .aider-dataiku.md conventions file."""
    dest = target / "dataiku-docs"
    copy_bundles(bundle_dir, dest)

    bundles = sorted(dest.glob("*.md"))
    bundle_list = "\n".join(f"  --read dataiku-docs/{b.name}" for b in bundles if b.name != "INDEX.md")

    conventions = (
        "# Dataiku Documentation Conventions\n\n"
        "This project uses Dataiku DSS. Documentation bundles are in `dataiku-docs/`.\n\n"
        "## Usage with aider\n\n"
        "Load the full documentation:\n"
        "```\n"
        "aider --read dataiku-docs/INDEX.md \\\n"
        f"{bundle_list}\n"
        "```\n\n"
        "Or load only the relevant bundle for your task:\n"
        "```\n"
        "aider --read dataiku-docs/python-api.md\n"
        "aider --read dataiku-docs/machine-learning.md\n"
        "aider --read dataiku-docs/generative-ai-llm.md\n"
        "```\n\n"
        "## Key bundles\n\n"
        "- `python-api.md` — Python API reference\n"
        "- `dev-concepts-examples.md` — Developer cookbook\n"
        "- `machine-learning.md` — ML workflows\n"
        "- `generative-ai-llm.md` — LLM Mesh / GenAI\n"
        "- `code-recipes.md` — Python/R/SQL recipes\n"
        "- `flow.md` — Flow and datasets\n"
    )
    out = target / "DATAIKU_DOCS.md"
    out.write_text(conventions, encoding="utf-8")
    print(f"  Created: {out}")
    print(f"  Bundles: {dest}")
    print("  TIP: Run with: aider --read DATAIKU_DOCS.md --read dataiku-docs/<bundle>.md")


def install_continue(bundle_dir: Path, target: Path):
    """Continue.dev: .continue/config.json docs entries"""
    dest = target / ".continue" / "dataiku"
    copy_bundles(bundle_dir, dest)

    config_path = target / ".continue" / "config.json"
    config_path.parent.mkdir(parents=True, exist_ok=True)

    config = {}
    if config_path.exists():
        try:
            config = json.loads(config_path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            print(f"  WARNING: could not parse {config_path}, creating fresh")

    config.setdefault("docs", [])

    marker_title = "Dataiku DSS Docs"
    if any(d.get("title") == marker_title for d in config["docs"]):
        print(f"  {config_path} already has Dataiku docs entry, skipping")
    else:
        bundles = sorted(dest.glob("*.md"))
        for b in bundles:
            if b.name == "INDEX.md":
                continue
            config["docs"].append({
                "title": f"Dataiku — {b.stem}",
                "startUrl": f"file://{b.resolve()}",
            })
        config_path.write_text(json.dumps(config, indent=2), encoding="utf-8")
        print(f"  Updated: {config_path} (+{len(bundles)} entries)")


def install_cline(bundle_dir: Path, target: Path):
    """Cline (VS Code): .clinerules"""
    dest = target / ".cline" / "dataiku"
    copy_bundles(bundle_dir, dest)

    bundles = sorted(dest.glob("*.md"))
    bundle_list = "\n".join(f"- `.cline/dataiku/{b.name}`" for b in bundles if b.name != "INDEX.md")

    snippet = (
        "\n# DATAIKU DOCS\n"
        "## Dataiku DSS Documentation\n\n"
        "Full documentation bundles are in `.cline/dataiku/`.\n"
        "Load the relevant bundle when answering Dataiku questions.\n\n"
        "### Bundles\n\n"
        f"{bundle_list}\n"
        "# END DATAIKU DOCS\n"
    )
    append_unique(target / ".clinerules", "DATAIKU DOCS", snippet)


TOOLS = {
    "claude":    (install_claude,   "Claude Code (.claude/dataiku/ + CLAUDE.md)"),
    "cursor":    (install_cursor,   "Cursor (.cursor/rules/dataiku.mdc + .cursor/dataiku/)"),
    "copilot":   (install_copilot,  "GitHub Copilot (.github/copilot-instructions.md)"),
    "windsurf":  (install_windsurf, "Windsurf (.windsurfrules)"),
    "aider":     (install_aider,    "Aider (dataiku-docs/ + DATAIKU_DOCS.md)"),
    "continue":  (install_continue, "Continue.dev (.continue/config.json)"),
    "cline":     (install_cline,    "Cline (.clinerules)"),
}


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        prog="dataiku-docs",
        description="Bundle Dataiku docs and install them for AI coding tools.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    sub = parser.add_subparsers(dest="command", required=True)

    # bundle
    p_bundle = sub.add_parser("bundle", help="Merge raw pages into topic bundles")
    p_bundle.add_argument("--docs-dir", type=Path, default=DOCS_DIR_DEFAULT,
                          help=f"Path to scraped docs (default: {DOCS_DIR_DEFAULT})")

    # install
    p_install = sub.add_parser("install", help="Install bundles for an AI coding tool")
    p_install.add_argument("tool", choices=[*TOOLS.keys(), "all"],
                           help="Tool to install for (or 'all')")
    p_install.add_argument("--docs-dir", type=Path, default=DOCS_DIR_DEFAULT,
                           help=f"Path to scraped docs (default: {DOCS_DIR_DEFAULT})")
    p_install.add_argument("--target", type=Path, default=Path("."),
                           help="Project directory to install into (default: .)")

    # list
    sub.add_parser("list", help="List supported tools")

    args = parser.parse_args()

    if args.command == "list":
        print("\nSupported tools:\n")
        for name, (_, desc) in TOOLS.items():
            print(f"  {name:<12} {desc}")
        print()
        return

    if args.command == "bundle":
        print(f"Bundling docs from {args.docs_dir} ...")
        bundle(args.docs_dir)
        return

    if args.command == "install":
        bundle_dir = resolve_docs_dir(args.docs_dir)
        target = args.target.resolve()

        tools_to_install = list(TOOLS.items()) if args.tool == "all" else [(args.tool, TOOLS[args.tool])]

        for name, (fn, desc) in tools_to_install:
            print(f"\nInstalling for {name} ({desc}) ...")
            fn(bundle_dir, target)

        print("\nDone.")


if __name__ == "__main__":
    main()
