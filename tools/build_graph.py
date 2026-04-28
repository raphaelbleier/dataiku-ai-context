#!/usr/bin/env python3
"""
build_graph.py — build docs/graph.json from the 87 Dataiku doc bundles.

Produces:
  docs/graph.json      — knowledge graph (bundle nodes + section nodes + edges)
  docs/graph_query.py  — standalone query utility (installed alongside bundles)

Usage:
  python tools/build_graph.py [--docs-dir PATH]
"""

import json
import os
import re
import sys
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
DOCS_DIR_DEFAULT = REPO_ROOT / "docs"
AGENTS_DIR = REPO_ROOT / "agents"

# Folder name → bundle stem (mirrors TOPIC_LABELS in dataiku-docs.py)
FOLDER_TO_BUNDLE = {
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
    "getting-started": "dev-getting-started",
    "concepts-and-examples": "dev-concepts-examples",
    "tutorials": "dev-tutorials",
    "api-reference": "dev-api-reference",
    # section-namespace aliases (from ## [namespace/...] headers)
    "code-recipes": "code-recipes",
    "code_recipes": "code-recipes",
    "other-recipes": "visual-recipes",
    "other_recipes": "visual-recipes",
    "release-notes": "release-notes",
    "release_notes": "release-notes",
    "metrics-check": "metrics-data-quality",
    "unstructured": "unstructured-data",
    "R": "r-api",
    "thirdparty": "thirdparty",
}

# Extra aliases for section namespace → bundle stem
NAMESPACE_ALIASES = {
    "code_recipes": "code-recipes",
    "other_recipes": "visual-recipes",
    "release_notes": "release-notes",
    "metrics-check-data-quality": "metrics-data-quality",
    "unstructured-data": "unstructured-data",
    "python-api": "python-api",
    "R-api": "r-api",
    "api-reference": "dev-api-reference",
    "concepts-and-examples": "dev-concepts-examples",
    "getting-started": "dev-getting-started",
}


def read_file(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""


def bundle_stem(filename: str) -> str:
    """'machine-learning-part1.md' → 'machine-learning'"""
    stem = filename.removesuffix(".md")
    stem = re.sub(r"-part\d+$", "", stem)
    return stem


def resolve_link_to_bundle(raw_href: str, all_bundle_stems: set[str]) -> str | None:
    """
    Resolve an HTML cross-reference like `../../machine-learning/index.html`
    to a bundle stem like `machine-learning`.
    """
    # Strip anchors, query strings
    href = re.split(r"[#?]", raw_href)[0].strip()
    # Extract meaningful path segments (skip .., ., empty)
    parts = [p for p in href.replace("\\", "/").split("/")
             if p and p != ".." and p != "."]
    if not parts:
        return None

    # Try each part as a folder/namespace key
    for part in parts:
        part_clean = part.replace(".html", "").replace(".md", "")
        # Direct match
        if part_clean in all_bundle_stems:
            return part_clean
        # Via FOLDER_TO_BUNDLE
        mapped = FOLDER_TO_BUNDLE.get(part_clean)
        if mapped and mapped in all_bundle_stems:
            return mapped
        # Via NAMESPACE_ALIASES
        mapped = NAMESPACE_ALIASES.get(part_clean)
        if mapped and mapped in all_bundle_stems:
            return mapped

    return None


def extract_sections(text: str, bundle_id: str) -> list[str]:
    """Extract ## [namespace/path] section IDs from bundle text."""
    sections = []
    for m in re.finditer(r"^## \[([^\]]+)\]", text, re.MULTILINE):
        raw = m.group(1).strip()
        sections.append(raw)
    return sections


def extract_outbound_links(text: str, all_bundle_stems: set[str]) -> set[str]:
    """Extract cross-bundle references from markdown HTML links."""
    refs = set()
    # Pattern: [text](<href>) or [text](href)
    for m in re.finditer(r"\[([^\]]*)\]\(<([^>]+)>\)", text):
        href = m.group(2)
        target = resolve_link_to_bundle(href, all_bundle_stems)
        if target:
            refs.add(target)
    for m in re.finditer(r"\[([^\]]*)\]\((?!<)([^\)]+)\)", text):
        href = m.group(2)
        target = resolve_link_to_bundle(href, all_bundle_stems)
        if target:
            refs.add(target)
    return refs


def extract_agent_bundles(agent_file: Path, all_bundle_stems: set[str]) -> list[str]:
    """Parse agent .md and extract bundle stems it references."""
    text = read_file(agent_file)
    found = []
    # Look for backtick-wrapped bundle references like `docs/machine-learning.md`
    for m in re.finditer(r"`(?:docs/)?([a-z0-9_\-]+(?:-part\d+)?)\.md`", text):
        stem = bundle_stem(m.group(1))
        if stem in all_bundle_stems:
            found.append(stem)
    return list(dict.fromkeys(found))  # deduplicate, preserve order


# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------

def build(docs_dir: Path) -> dict:
    all_files = []
    for entry in os.scandir(docs_dir):
        if entry.is_file() and entry.name.endswith(".md") and entry.name != "INDEX.md":
            all_files.append(entry)

    # Build set of all bundle stems
    all_bundle_stems: set[str] = set()
    for entry in all_files:
        all_bundle_stems.add(bundle_stem(entry.name))

    print(f"  Found {len(all_files)} bundle files, {len(all_bundle_stems)} unique stems")

    # --- Bundle nodes ---
    bundles: dict[str, dict] = {}

    # First pass: create bundle stubs
    for stem in sorted(all_bundle_stems):
        bundles[stem] = {
            "file": f"{stem}.md",
            "size_kb": 0,
            "parts": [],
            "agents": [],
            "section_count": 0,
            "outbound_bundle_refs": [],
        }

    # Attach part files + sizes
    for entry in all_files:
        stem = bundle_stem(entry.name)
        base = stem
        size_kb = entry.stat().st_size // 1024
        if entry.name == f"{stem}.md":
            bundles[stem]["size_kb"] = size_kb
        else:
            # It's a part file
            if entry.name not in bundles[base]["parts"]:
                bundles[base]["parts"].append(entry.name)

    # --- Section nodes + edges from content ---
    sections: dict[str, dict] = {}
    bundle_outbound: dict[str, set[str]] = defaultdict(set)

    total_sections = 0
    for entry in all_files:
        text = read_file(Path(entry.path))
        if not text:
            continue
        stem = bundle_stem(entry.name)

        # Sections
        sec_ids = extract_sections(text, stem)
        for sec_id in sec_ids:
            if sec_id not in sections:
                sections[sec_id] = {"bundle": stem, "outbound_refs": []}
        bundles[stem]["section_count"] += len(sec_ids)
        total_sections += len(sec_ids)

        # Outbound cross-bundle refs
        refs = extract_outbound_links(text, all_bundle_stems)
        refs.discard(stem)  # no self-loops
        bundle_outbound[stem].update(refs)

    # Attach outbound refs to bundles
    for stem, refs in bundle_outbound.items():
        bundles[stem]["outbound_bundle_refs"] = sorted(refs)

    # Section-level cross-refs (within same bundle for now — intra-bundle)
    # Full section-to-section edges would be huge; skip for query perf
    print(f"  Extracted {total_sections} section nodes, {sum(len(v) for v in bundle_outbound.values())} cross-bundle edges")

    # --- Agent → bundle affinities ---
    agent_bundles: dict[str, list[str]] = {}
    if AGENTS_DIR.exists():
        for agent_file in sorted(AGENTS_DIR.glob("*.md")):
            agent_name = agent_file.stem
            ab = extract_agent_bundles(agent_file, all_bundle_stems)
            agent_bundles[agent_name] = ab
            for b in ab:
                if b in bundles and agent_name not in bundles[b]["agents"]:
                    bundles[b]["agents"].append(agent_name)
        print(f"  Linked {len(agent_bundles)} agents to bundles")

    graph = {
        "meta": {
            "generated_at": datetime.now(timezone.utc).isoformat(),
            "total_bundles": len(all_bundle_stems),
            "total_sections": total_sections,
            "total_cross_bundle_edges": sum(len(v) for v in bundle_outbound.values()),
        },
        "bundles": bundles,
        "sections": sections,
        "agent_bundles": agent_bundles,
    }
    return graph


# ---------------------------------------------------------------------------
# graph_query.py content
# ---------------------------------------------------------------------------

GRAPH_QUERY_SRC = '''#!/usr/bin/env python3
"""
graph_query.py — find the most relevant Dataiku doc bundles for any topic.
Uses the knowledge graph in graph.json (same directory).

Usage:
  python graph_query.py "machine learning model deployment"
  python graph_query.py "LLM mesh knowledge bank"
  python graph_query.py "spark recipe partitioning"

Or import:
  from graph_query import find_bundles
  results = find_bundles("python API dataset read")
"""

import json
import re
import sys
from collections import deque, defaultdict
from pathlib import Path

_GRAPH_PATH = Path(__file__).parent / "graph.json"
_GRAPH: dict | None = None


def _load() -> dict:
    global _GRAPH
    if _GRAPH is None:
        _GRAPH = json.loads(_GRAPH_PATH.read_text(encoding="utf-8"))
    return _GRAPH


def find_bundles(query: str, max_hops: int = 2, top_n: int = 10) -> list[dict]:
    """
    Return top N bundles relevant to the query.
    Uses keyword scoring + BFS traversal of cross-bundle edges.
    """
    g = _load()
    bundles = g["bundles"]
    agent_bundles = g.get("agent_bundles", {})

    query_terms = set(re.findall(r"\\w+", query.lower()))
    scores: dict[str, float] = defaultdict(float)

    # 1. Keyword match against bundle IDs and section namespaces
    for bundle_id, bundle in bundles.items():
        bundle_terms = set(re.findall(r"\\w+", bundle_id))
        # Also match against section namespaces
        sec_terms: set[str] = set()
        for sec_id in list(g.get("sections", {}).keys())[:500]:
            if g["sections"][sec_id]["bundle"] == bundle_id:
                sec_terms.update(re.findall(r"\\w+", sec_id))

        overlap = len(query_terms & (bundle_terms | sec_terms))
        if overlap > 0:
            scores[bundle_id] += float(overlap) * 2.0

    # 2. BFS expansion: traverse outbound_bundle_refs
    seeds = [b for b, s in scores.items() if s > 0]
    visited: set[str] = set(seeds)
    queue: deque[tuple[str, int]] = deque((b, 0) for b in seeds)

    while queue:
        node, depth = queue.popleft()
        if depth >= max_hops:
            continue
        for ref in bundles.get(node, {}).get("outbound_bundle_refs", []):
            if ref not in visited:
                visited.add(ref)
                scores[ref] += 0.5 / (depth + 1)
                queue.append((ref, depth + 1))

    # 3. Agent boost: if query matches an agent name, boost its bundles
    for agent_name, ab in agent_bundles.items():
        agent_terms = set(re.findall(r"\\w+", agent_name))
        if query_terms & agent_terms:
            for b in ab:
                scores[b] += 0.5

    if not scores:
        # Fallback: return top bundles by section count (most comprehensive)
        ranked_all = sorted(
            bundles.items(),
            key=lambda x: x[1].get("section_count", 0),
            reverse=True,
        )[:top_n]
        return [
            {"bundle": b, "file": bundles[b]["file"], "score": 0.0, "agents": bundles[b].get("agents", [])}
            for b, _ in ranked_all
        ]

    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)[:top_n]
    return [
        {
            "bundle": bundle_id,
            "file": bundles[bundle_id]["file"],
            "score": round(score, 2),
            "agents": bundles[bundle_id].get("agents", []),
            "size_kb": bundles[bundle_id].get("size_kb", 0),
        }
        for bundle_id, score in ranked
        if bundle_id in bundles
    ]


def find_sections(query: str, top_n: int = 20) -> list[dict]:
    """Return top N section IDs relevant to the query."""
    g = _load()
    query_terms = set(re.findall(r"\\w+", query.lower()))
    scores: dict[str, float] = defaultdict(float)

    for sec_id, sec in g.get("sections", {}).items():
        terms = set(re.findall(r"\\w+", sec_id.lower()))
        overlap = len(query_terms & terms)
        if overlap:
            scores[sec_id] += float(overlap)

    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)[:top_n]
    sections = g.get("sections", {})
    return [
        {"section": sec_id, "bundle": sections[sec_id]["bundle"], "score": round(score, 2)}
        for sec_id, score in ranked
        if sec_id in sections
    ]


if __name__ == "__main__":
    query = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "python API dataset"
    print(f"\\nTop bundles for: \\'{query}\\'\\n")
    results = find_bundles(query)
    if not results:
        print("  No results found.")
    else:
        for i, r in enumerate(results, 1):
            agents = f"  [agents: {', '.join(r['agents'])}]" if r["agents"] else ""
            print(f"  {i:2d}. {r['file']:<45}  score={r['score']:5.2f}  {r['size_kb']}KB{agents}")

    print(f"\\nTop sections for: \\'{query}\\'\\n")
    secs = find_sections(query, top_n=8)
    for s in secs:
        print(f"  {s['section']:<60}  (bundle: {s['bundle']})")
    print()
'''


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    import argparse
    parser = argparse.ArgumentParser(description="Build docs/graph.json from Dataiku doc bundles.")
    parser.add_argument("--docs-dir", type=Path, default=DOCS_DIR_DEFAULT,
                        help=f"Path to docs/ directory (default: {DOCS_DIR_DEFAULT})")
    args = parser.parse_args()

    docs_dir = args.docs_dir
    if not docs_dir.exists():
        sys.exit(f"ERROR: docs dir not found: {docs_dir}")

    print(f"Building graph from {docs_dir} ...")
    graph = build(docs_dir)

    # Write graph.json
    graph_path = docs_dir / "graph.json"
    graph_path.write_text(json.dumps(graph, indent=2, ensure_ascii=False), encoding="utf-8")
    size_kb = graph_path.stat().st_size // 1024
    print(f"  Wrote {graph_path} ({size_kb} KB)")
    print(f"  Bundles: {graph['meta']['total_bundles']}")
    print(f"  Sections: {graph['meta']['total_sections']}")
    print(f"  Cross-bundle edges: {graph['meta']['total_cross_bundle_edges']}")

    # Write graph_query.py
    query_path = docs_dir / "graph_query.py"
    query_path.write_text(GRAPH_QUERY_SRC, encoding="utf-8")
    print(f"  Wrote {query_path}")

    print("\nDone. Run: python docs/graph_query.py \"your topic\"")


if __name__ == "__main__":
    main()
