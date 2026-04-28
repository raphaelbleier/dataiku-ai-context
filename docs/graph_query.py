#!/usr/bin/env python3
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

    query_terms = set(re.findall(r"\w+", query.lower()))
    scores: dict[str, float] = defaultdict(float)

    # 1. Keyword match against bundle IDs and section namespaces
    for bundle_id, bundle in bundles.items():
        bundle_terms = set(re.findall(r"\w+", bundle_id))
        # Also match against section namespaces
        sec_terms: set[str] = set()
        for sec_id in list(g.get("sections", {}).keys())[:500]:
            if g["sections"][sec_id]["bundle"] == bundle_id:
                sec_terms.update(re.findall(r"\w+", sec_id))

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
        agent_terms = set(re.findall(r"\w+", agent_name))
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
    query_terms = set(re.findall(r"\w+", query.lower()))
    scores: dict[str, float] = defaultdict(float)

    for sec_id, sec in g.get("sections", {}).items():
        terms = set(re.findall(r"\w+", sec_id.lower()))
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
    print(f"\nTop bundles for: \'{query}\'\n")
    results = find_bundles(query)
    if not results:
        print("  No results found.")
    else:
        for i, r in enumerate(results, 1):
            agents = f"  [agents: {', '.join(r['agents'])}]" if r["agents"] else ""
            print(f"  {i:2d}. {r['file']:<45}  score={r['score']:5.2f}  {r['size_kb']}KB{agents}")

    print(f"\nTop sections for: \'{query}\'\n")
    secs = find_sections(query, top_n=8)
    for s in secs:
        print(f"  {s['section']:<60}  (bundle: {s['bundle']})")
    print()
