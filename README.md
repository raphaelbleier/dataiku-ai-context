# Dataiku AI Context

> Full Dataiku DSS documentation + Claude Code subagents — installable into every major AI coding tool in one command.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agents](https://img.shields.io/badge/agents-6-blue)](#claude-code-agents)
[![Doc bundles](https://img.shields.io/badge/doc%20bundles-87-green)](#documentation-bundles)
[![Tools supported](https://img.shields.io/badge/tools-7-purple)](#supported-ai-tools)

## What's included

| | |
|---|---|
| **6 Claude Code agents** | Domain-specialized subagents for Dataiku development |
| **87 doc bundles** | Full DSS + Developer docs as markdown, topic-organized |
| **7 tool installers** | Claude Code, Cursor, Copilot, Windsurf, Aider, Continue, Cline |

Docs scraped from [doc.dataiku.com](https://doc.dataiku.com/dss/latest/) and [developer.dataiku.com](https://developer.dataiku.com/latest/) — 1755 pages bundled into ~400 KB topic files.

---

## Quick install

**Linux / macOS**
```bash
git clone https://github.com/raphaelbleier/dataiku-ai-context.git
cd dataiku-ai-context
./install.sh
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/raphaelbleier/dataiku-ai-context.git
cd dataiku-ai-context
.\install.ps1
```

**One-liners (no clone required)**
```bash
# Linux / macOS
curl -sL https://raw.githubusercontent.com/raphaelbleier/dataiku-ai-context/main/install.sh | bash
```
```powershell
# Windows
iex (irm https://raw.githubusercontent.com/raphaelbleier/dataiku-ai-context/main/install.ps1)
```

The interactive installer lets you choose:
- **Claude Code agents** (global or project-local)
- **Doc bundles** for your AI coding tool
- **Both**

---

## Claude Code agents

Six specialized subagents, auto-loaded by Claude Code from `~/.claude/agents/`:

| Agent | When to use |
|-------|------------|
| `dataiku-developer` | General DSS tasks: Flow, datasets, recipes, project structure |
| `dataiku-data-engineer` | Pipelines, Spark/SQL, scenarios, automation, metrics |
| `dataiku-ml-engineer` | Visual ML, AutoML, MLflow, model deployment, monitoring |
| `dataiku-genai-engineer` | LLM Mesh, AI agents, RAG, Knowledge Banks, GenAI recipes |
| `dataiku-api-developer` | Python API, REST API, API Node, Project Deployer |
| `dataiku-admin` | Installation, users, connections, code envs, security, ops |

### Install agents only

```bash
# Linux / macOS — interactive
./install.sh
# → choose "Claude Code agents" → "Global"

# Linux / macOS — manual
cp agents/*.md ~/.claude/agents/

# Linux / macOS — project-local
mkdir -p .claude/agents && cp agents/*.md .claude/agents/
```

```powershell
# Windows — interactive
.\install.ps1

# Windows — manual (global)
Copy-Item agents\*.md "$HOME\.claude\agents\"

# Windows — project-local
New-Item -ItemType Directory -Force .claude\agents | Out-Null
Copy-Item agents\*.md .claude\agents\
```

---

## Documentation bundles

87 markdown files covering every DSS topic, ready to load as context in any AI tool.

```
docs/
├── INDEX.md                    ← start here
├── concepts.md
├── python-api.md
├── dev-concepts-examples.md    ← Python API cookbook
├── machine-learning.md
├── generative-ai-llm.md
├── ai-agents.md
├── code-recipes.md
├── flow.md
├── data-preparation.md
├── automation-scenarios.md
├── mlops.md
├── deployment.md
└── ... (87 total)
```

---

## Supported AI tools

| Tool | Doc bundles | Agent rules |
|------|-------------|-------------|
| **Claude Code** | `.claude/dataiku/` | `~/.claude/agents/*.md` |
| **Cursor** | `.cursor/dataiku/` | `.cursor/rules/dataiku-*.mdc` |
| **GitHub Copilot** | `.github/dataiku/` | `.github/instructions/dataiku-*.instructions.md` |
| **Windsurf** | `.windsurf/dataiku/` | `.windsurf/rules/dataiku-*.md` |
| **Aider** | `dataiku-docs/` | `dataiku-docs/dataiku-*.md` |
| **Continue.dev** | `.continue/dataiku/` | `.continue/rules/dataiku-*.md` |
| **Cline** | `.cline/dataiku/` | `.clinerules/dataiku-*.md` |

Each tool gets **6 domain-specific rule files** matching the Claude Code agents:

| Rule | Covers |
|------|--------|
| `dataiku-developer` | Flow, datasets, recipes, project structure |
| `dataiku-data-engineer` | Pipelines, Spark/SQL, scenarios, automation |
| `dataiku-ml-engineer` | Visual ML, AutoML, MLflow, model deployment |
| `dataiku-genai-engineer` | LLM Mesh, AI agents, RAG, Knowledge Banks |
| `dataiku-api-developer` | Python API, REST API, API Node, Project Deployer |
| `dataiku-admin` | Installation, users, connections, code envs, security |

The installer copies both doc bundles and rule files in one step.

### Install docs for a specific tool

```bash
# Interactive
./install.sh
# → choose "AI tool doc bundles" → pick your tool

# Python CLI (more control)
python tools/dataiku-docs.py install cursor --target /path/to/your/project
python tools/dataiku-docs.py install all    --target /path/to/your/project
python tools/dataiku-docs.py list
```

---

## Usage in Claude Code

Once agents are installed, Claude Code automatically delegates Dataiku tasks to the right agent:

```
# These automatically invoke the matching subagent:
"Help me write a Python recipe to join two datasets"     → dataiku-developer
"Set up MLflow tracking for my model"                    → dataiku-ml-engineer
"Build a RAG pipeline with Dataiku Knowledge Banks"      → dataiku-genai-engineer
"Automate this pipeline with a scenario"                 → dataiku-data-engineer
"Create an API endpoint for my model"                    → dataiku-api-developer
"Add a new user and configure LDAP"                      → dataiku-admin
```

Reference doc bundles directly:

```
@.claude/dataiku/python-api.md
@.claude/dataiku/generative-ai-llm.md
@.claude/dataiku/INDEX.md
```

---

## Keeping docs up to date

Re-scrape and re-bundle when Dataiku releases a new DSS version:

```bash
python tools/scrape_docs.py     # re-scrapes ~1755 pages
python tools/dataiku-docs.py bundle  # rebuilds bundles
```

---

## Repository structure

```
dataiku-ai-context/
├── agents/                 # Claude Code subagent definitions (6 files)
│   └── dataiku-*.md
├── rules/                  # Agent rules for other AI coding tools
│   ├── cursor/             # .mdc files for Cursor
│   ├── copilot/            # .instructions.md for GitHub Copilot
│   ├── windsurf/           # .md files for Windsurf
│   ├── aider/              # .md files for Aider
│   ├── continue/           # .md files for Continue.dev
│   └── cline/              # .md files for Cline
├── docs/                   # 87 bundled documentation files
│   ├── INDEX.md
│   └── *.md
├── tools/                  # Maintainer scripts
│   ├── scrape_docs.py      # Re-scrapes Dataiku docs
│   └── dataiku-docs.py     # Bundle + install CLI
├── install.sh              # Interactive installer (Linux/macOS)
├── install.ps1             # Interactive installer (Windows)
├── LICENSE
└── README.md
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

PRs welcome for:
- New/improved agent prompts
- Bug fixes in the installer
- Support for additional AI tools

---

## License

MIT — see [LICENSE](LICENSE).

---

*Docs sourced from [doc.dataiku.com](https://doc.dataiku.com/dss/latest/) and [developer.dataiku.com](https://developer.dataiku.com/latest/) under Dataiku's documentation terms.*
