# Contributing

## Improving agents

Agent files are in `agents/`. Each is a markdown file with YAML frontmatter.

The frontmatter schema:
```yaml
---
name: dataiku-<role>
description: One sentence — when Claude should delegate to this agent
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---
```

Guidelines:
- Keep system prompts focused — one domain per agent
- Include concrete code examples for the most common patterns
- Reference specific bundle files users can load
- Test with real Dataiku tasks before submitting

## Adding a new AI tool

1. Add an installer function to `tools/dataiku-docs.py` (Python):
   ```python
   def install_mytool(bundle_dir: Path, target: Path):
       ...
   ```
2. Add it to the `TOOLS` dict
3. Add the bash fallback to `install.sh` in `write_tool_config()`
4. Add it to the README table

## Re-scraping docs

When Dataiku ships a new DSS version:

```bash
python tools/scrape_docs.py      # ~30 min, ~1755 pages
python tools/dataiku-docs.py bundle
# commit docs/ to the repo
```

## Pull requests

- One concern per PR
- Test the installer on Linux/macOS
- Update README if adding new agents or tools
