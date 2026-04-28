#!/usr/bin/env bash
# Dataiku AI Context Installer
# Installs Dataiku Claude Code agents and/or doc bundles for your AI coding tool
#
# Usage:
#   Interactive:  ./install.sh
#   One-liner:    curl -sL https://raw.githubusercontent.com/raphaelbleier/dataiku-ai-context/main/install.sh | bash

set -euo pipefail

# ---------------------------------------------------------------------------
# Colors & symbols
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
ARROW="${CYAN}→${NC}"

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
REPO_OWNER="raphaelbleier"
REPO_NAME="dataiku-ai-context"
GITHUB_RAW="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main"
GITHUB_API="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/contents"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"
LOCAL_AGENTS_DIR="${SCRIPT_DIR}/agents"
LOCAL_DOCS_DIR="${SCRIPT_DIR}/docs"

GLOBAL_CLAUDE_DIR="${HOME}/.claude/agents"
LOCAL_CLAUDE_DIR=".claude/agents"

# State
INSTALL_MODE=""       # global | local
SOURCE_MODE=""        # local | remote
SELECTED_WHAT=""      # agents | docs | both

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
has_local_repo() { [[ -d "${LOCAL_AGENTS_DIR}" ]]; }
has_local_claude() { [[ -d ".claude" ]]; }
check_cmd() { command -v "$1" &>/dev/null; }

require_curl() {
    if ! check_cmd curl; then
        echo -e "${RED}Error: curl is required. Install it and retry.${NC}"
        exit 1
    fi
}

require_python() {
    if check_cmd python3; then echo "python3"
    elif check_cmd python; then echo "python"
    else echo ""; fi
}

show_header() {
    clear
    echo -e "${BOLD}${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════╗"
    echo "║        Dataiku AI Context Installer                               ║"
    echo "║        Claude agents + doc bundles for every AI coding tool       ║"
    echo "╚═══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    if [[ -n "${INSTALL_MODE}" || -n "${SELECTED_WHAT}" ]]; then
        [[ -n "${SELECTED_WHAT}" ]]  && echo -e "  ${DIM}Installing:${NC}  ${BOLD}${SELECTED_WHAT}${NC}"
        [[ -n "${INSTALL_MODE}" ]]   && echo -e "  ${DIM}Agent mode:${NC}  ${BOLD}${INSTALL_MODE}${NC}"
        [[ -n "${SOURCE_MODE}" ]]    && echo -e "  ${DIM}Source:${NC}      ${BOLD}${SOURCE_MODE}${NC}"
        echo ""
    fi
}

press_enter() { read -rp "$(echo -e "${DIM}Press Enter to continue...${NC}")" _; }

# ---------------------------------------------------------------------------
# What to install
# ---------------------------------------------------------------------------
select_what() {
    show_header
    echo -e "${BOLD}What would you like to install?${NC}\n"
    echo -e "  ${YELLOW}1)${NC} ${BOLD}Claude Code agents${NC}     ${DIM}— 6 Dataiku domain agents for ~/.claude/agents/${NC}"
    echo -e "  ${YELLOW}2)${NC} ${BOLD}AI tool doc bundles${NC}    ${DIM}— 87 topic bundles for Cursor, Copilot, Windsurf, Aider, etc.${NC}"
    echo -e "  ${YELLOW}3)${NC} ${BOLD}Both${NC}"
    echo ""
    echo -e "  ${YELLOW}q)${NC} Quit"
    echo ""
    read -rp "$(echo -e "${CYAN}Choice:${NC} ")" choice
    case "$choice" in
        1) SELECTED_WHAT="agents" ;;
        2) SELECTED_WHAT="docs" ;;
        3) SELECTED_WHAT="both" ;;
        q|Q) echo -e "\n${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice.${NC}"; sleep 1; select_what ;;
    esac
}

# ---------------------------------------------------------------------------
# Source mode (local clone vs remote GitHub)
# ---------------------------------------------------------------------------
select_source_mode() {
    if ! has_local_repo; then
        SOURCE_MODE="remote"
        require_curl
        return
    fi
    show_header
    echo -e "${BOLD}Source:${NC}\n"
    echo -e "  ${YELLOW}1)${NC} ${BOLD}Local${NC}   ${DIM}(use this cloned repository — faster, offline)${NC}"
    echo -e "  ${YELLOW}2)${NC} ${BOLD}Remote${NC}  ${DIM}(download latest from GitHub)${NC}"
    echo ""
    echo -e "  ${YELLOW}q)${NC} Quit"
    echo ""
    read -rp "$(echo -e "${CYAN}Choice:${NC} ")" choice
    case "$choice" in
        1) SOURCE_MODE="local" ;;
        2) SOURCE_MODE="remote"; require_curl ;;
        q|Q) echo -e "\n${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice.${NC}"; sleep 1; select_source_mode ;;
    esac
}

# ---------------------------------------------------------------------------
# Claude agents installation
# ---------------------------------------------------------------------------
select_agent_install_mode() {
    show_header
    echo -e "${BOLD}Agent installation scope:${NC}\n"
    echo -e "  ${YELLOW}1)${NC} ${BOLD}Global${NC}  ${DIM}(${HOME}/.claude/agents/ — available in all projects)${NC}"
    if has_local_claude; then
        echo -e "  ${YELLOW}2)${NC} ${BOLD}Local${NC}   ${DIM}(.claude/agents/ — current project only)${NC}"
    else
        echo -e "  ${BLUE}2)${NC} ${DIM}Local   (unavailable — no .claude/ directory here)${NC}"
    fi
    echo ""
    echo -e "  ${YELLOW}q)${NC} Quit"
    echo ""
    read -rp "$(echo -e "${CYAN}Choice:${NC} ")" choice
    case "$choice" in
        1) INSTALL_MODE="global"; mkdir -p "${GLOBAL_CLAUDE_DIR}" ;;
        2)
            if has_local_claude; then
                INSTALL_MODE="local"; mkdir -p "${LOCAL_CLAUDE_DIR}"
            else
                echo -e "${RED}No .claude/ directory found.${NC}"; sleep 2; select_agent_install_mode
            fi ;;
        q|Q) echo -e "\n${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice.${NC}"; sleep 1; select_agent_install_mode ;;
    esac
}

get_agents_dest() {
    if [[ "${INSTALL_MODE}" == "global" ]]; then echo "${GLOBAL_CLAUDE_DIR}"
    else echo "${LOCAL_CLAUDE_DIR}"; fi
}

is_agent_installed() {
    local name="$1"
    [[ -f "$(get_agents_dest)/${name}" ]]
}

fetch_remote_agent_list() {
    local resp
    resp=$(curl -sf "${GITHUB_API}/agents" 2>/dev/null || echo "")
    if [[ -z "$resp" ]] || echo "$resp" | grep -q '"message"'; then
        echo -e "${RED}Failed to fetch agent list from GitHub.${NC}" >&2
        return 1
    fi
    echo "$resp" | grep -o '"name": "[^"]*\.md"' | sed 's/"name": "//;s/"$//' | sort
}

download_agent() {
    local filename="$1"
    local dest="$2"
    curl -sfL "${GITHUB_RAW}/agents/${filename}" -o "${dest}" 2>/dev/null
}

get_agent_description() {
    local file="$1"
    grep "^description:" "$file" 2>/dev/null | head -1 | sed 's/^description:[[:space:]]*//' | cut -c1-65
}

install_agents_menu() {
    select_agent_install_mode
    local dest; dest="$(get_agents_dest)"

    # Build agent list
    local agents=()
    local descriptions=()

    if [[ "${SOURCE_MODE}" == "remote" ]]; then
        show_header
        echo -e "${CYAN}Fetching agent list from GitHub...${NC}"
        while IFS= read -r line; do
            [[ -n "$line" ]] && agents+=("$line") && descriptions+=("")
        done < <(fetch_remote_agent_list)
        if [[ ${#agents[@]} -eq 0 ]]; then
            echo -e "${RED}No agents found.${NC}"; press_enter; return
        fi
    else
        for f in "${LOCAL_AGENTS_DIR}"/*.md; do
            [[ -f "$f" ]] || continue
            local bn; bn="$(basename "$f")"
            agents+=("$bn")
            descriptions+=("$(get_agent_description "$f")")
        done
    fi

    # Default all selected
    local states=()
    for _ in "${agents[@]}"; do states+=(1); done

    while true; do
        show_header
        echo -e "${BOLD}Select agents to install:${NC}  ${DIM}(toggle with number, ${GREEN}[✓]${NC}${DIM} = install)${NC}\n"

        local i=1
        for agent_file in "${agents[@]}"; do
            local name="${agent_file%.md}"
            local installed_mark=""
            is_agent_installed "${agent_file}" && installed_mark=" ${BLUE}[installed]${NC}"
            local idx=$((i-1))
            if [[ ${states[$idx]} -eq 1 ]]; then
                icon="${GREEN}[✓]${NC}"
            else
                icon="${RED}[ ]${NC}"
            fi
            local desc="${descriptions[$idx]}"
            printf "  ${YELLOW}%2d)${NC} %b %-35s ${DIM}%s${NC}%b\n" "$i" "$icon" "$name" "$desc" "$installed_mark"
            ((i++))
        done

        echo ""
        echo -e "  ${YELLOW}a)${NC} Select all    ${YELLOW}n)${NC} Deselect all    ${YELLOW}c)${NC} Confirm    ${YELLOW}b)${NC} Back    ${YELLOW}q)${NC} Quit"
        echo ""
        read -rp "$(echo -e "${CYAN}Choice:${NC} ")" choice

        case "$choice" in
            [0-9]*)
                if (( choice >= 1 && choice <= ${#agents[@]} )); then
                    local idx=$((choice-1))
                    [[ ${states[$idx]} -eq 1 ]] && states[$idx]=0 || states[$idx]=1
                fi ;;
            a|A) for i in "${!states[@]}"; do states[$i]=1; done ;;
            n|N) for i in "${!states[@]}"; do states[$i]=0; done ;;
            c|C) confirm_install_agents "${agents[@]}" "---STATES---" "${states[@]}"; return ;;
            b|B) return 1 ;;
            q|Q) echo -e "\n${GREEN}Goodbye!${NC}"; exit 0 ;;
        esac
    done
}

confirm_install_agents() {
    # Parse args: agents, then "---STATES---", then states
    local agents=()
    local states=()
    local parsing_states=false
    for arg in "$@"; do
        if [[ "$arg" == "---STATES---" ]]; then parsing_states=true; continue; fi
        if $parsing_states; then states+=("$arg"); else agents+=("$arg"); fi
    done

    local dest; dest="$(get_agents_dest)"
    local to_install=()
    for i in "${!agents[@]}"; do
        [[ ${states[$i]} -eq 1 ]] && to_install+=("${agents[$i]}")
    done

    show_header
    echo -e "${BOLD}Confirm installation${NC}\n"

    if [[ ${#to_install[@]} -eq 0 ]]; then
        echo -e "${YELLOW}Nothing selected.${NC}\n"; press_enter; return
    fi

    echo -e "${GREEN}Agents to install (${#to_install[@]}):${NC}"
    for a in "${to_install[@]}"; do echo -e "  ${CHECK} ${a%.md}"; done
    echo -e "\n${BOLD}Destination:${NC} ${dest}\n"

    read -rp "$(echo -e "${CYAN}Apply? (y/N):${NC} ")" confirm
    [[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo -e "${YELLOW}Cancelled.${NC}" && press_enter && return

    echo ""
    local ok=0 fail=0
    for agent_file in "${to_install[@]}"; do
        if [[ "${SOURCE_MODE}" == "remote" ]]; then
            if download_agent "${agent_file}" "${dest}/${agent_file}"; then
                echo -e "  ${CHECK} ${agent_file%.md}"
                ok=$((ok+1))
            else
                echo -e "  ${CROSS} ${agent_file%.md} (download failed)"
                fail=$((fail+1))
            fi
        else
            if cp "${LOCAL_AGENTS_DIR}/${agent_file}" "${dest}/${agent_file}"; then
                echo -e "  ${CHECK} ${agent_file%.md}"
                ok=$((ok+1))
            else
                echo -e "  ${CROSS} ${agent_file%.md}"
                fail=$((fail+1))
            fi
        fi
    done

    echo ""
    echo -e "${GREEN}${BOLD}Done: ${ok} installed${NC}$([[ $fail -gt 0 ]] && echo -e ", ${RED}${fail} failed${NC}" || echo "")"
    echo -e "\nAgents are ready. In Claude Code, they appear automatically as subagents."
    press_enter
}

# ---------------------------------------------------------------------------
# Docs installation
# ---------------------------------------------------------------------------
install_docs_menu() {
    show_header
    echo -e "${BOLD}Select AI coding tool:${NC}\n"
    echo -e "  ${YELLOW}1)${NC}  ${BOLD}Claude Code${NC}      ${DIM}→ .claude/dataiku/ + CLAUDE.md${NC}"
    echo -e "  ${YELLOW}2)${NC}  ${BOLD}Cursor${NC}           ${DIM}→ .cursor/dataiku/ + .cursor/rules/dataiku.mdc${NC}"
    echo -e "  ${YELLOW}3)${NC}  ${BOLD}GitHub Copilot${NC}   ${DIM}→ .github/dataiku/ + .github/copilot-instructions.md${NC}"
    echo -e "  ${YELLOW}4)${NC}  ${BOLD}Windsurf${NC}         ${DIM}→ .windsurf/dataiku/ + .windsurfrules${NC}"
    echo -e "  ${YELLOW}5)${NC}  ${BOLD}Aider${NC}            ${DIM}→ dataiku-docs/ + DATAIKU_DOCS.md${NC}"
    echo -e "  ${YELLOW}6)${NC}  ${BOLD}Continue.dev${NC}     ${DIM}→ .continue/dataiku/ + .continue/config.json${NC}"
    echo -e "  ${YELLOW}7)${NC}  ${BOLD}Cline${NC}            ${DIM}→ .cline/dataiku/ + .clinerules${NC}"
    echo -e "  ${YELLOW}8)${NC}  ${BOLD}All tools${NC}"
    echo ""
    echo -e "  ${YELLOW}b)${NC} Back    ${YELLOW}q)${NC} Quit"
    echo ""

    read -rp "$(echo -e "${CYAN}Choice:${NC} ")" choice

    local tool=""
    case "$choice" in
        1) tool="claude" ;;
        2) tool="cursor" ;;
        3) tool="copilot" ;;
        4) tool="windsurf" ;;
        5) tool="aider" ;;
        6) tool="continue" ;;
        7) tool="cline" ;;
        8) tool="all" ;;
        b|B) return 1 ;;
        q|Q) echo -e "\n${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid choice.${NC}"; sleep 1; install_docs_menu; return ;;
    esac

    # Ask for target directory
    show_header
    echo -e "${BOLD}Target project directory:${NC}\n"
    echo -e "  ${DIM}Enter the path to your project (where config files will be created).${NC}"
    echo -e "  ${DIM}Leave blank for current directory: ${CYAN}$(pwd)${NC}\n"
    read -rp "$(echo -e "${CYAN}Path [.]:${NC} ")" target_dir
    target_dir="${target_dir:-.}"
    target_dir="${target_dir/#\~/$HOME}"

    if [[ ! -d "$target_dir" ]]; then
        echo -e "${RED}Directory not found: ${target_dir}${NC}"; sleep 2; install_docs_menu; return
    fi

    run_docs_installer "$tool" "$target_dir"
}

run_docs_installer() {
    local tool="$1"
    local target="$2"

    show_header
    echo -e "${BOLD}Installing docs for ${CYAN}${tool}${NC}${BOLD} into ${CYAN}${target}${NC}\n"

    # Prefer Python installer if available
    local py; py="$(require_python)"

    if [[ -n "$py" ]]; then
        # Find the Python script
        local script=""
        if [[ -f "${SCRIPT_DIR}/tools/dataiku-docs.py" ]]; then
            script="${SCRIPT_DIR}/tools/dataiku-docs.py"
        elif [[ -f "${SCRIPT_DIR}/dataiku-docs.py" ]]; then
            script="${SCRIPT_DIR}/dataiku-docs.py"
        fi

        if [[ -n "$script" ]]; then
            # Find docs dir
            local docs_dir="${SCRIPT_DIR}/docs"
            [[ ! -d "$docs_dir" ]] && docs_dir="${SCRIPT_DIR}/dataiku_docs"

            if [[ -d "$docs_dir" ]]; then
                "$py" "$script" install "$tool" --docs-dir "$docs_dir" --target "$target"
                echo ""
                press_enter
                return
            fi
        fi
    fi

    # Fallback: pure bash copy for remote/no-python scenarios
    echo -e "${YELLOW}Python not available or docs not found locally — using remote bundles.${NC}"
    require_curl
    bash_install_docs "$tool" "$target"
    press_enter
}

bash_install_docs() {
    local tool="$1"
    local target="$2"

    # Download INDEX.md to get bundle list
    echo -e "${CYAN}Fetching bundle index...${NC}"
    local index; index=$(curl -sfL "${GITHUB_RAW}/docs/INDEX.md" 2>/dev/null || echo "")
    if [[ -z "$index" ]]; then
        echo -e "${RED}Failed to fetch bundle index from GitHub.${NC}"; return 1
    fi

    # Extract bundle filenames from index
    local bundles=()
    while IFS= read -r line; do
        local fname; fname=$(echo "$line" | grep -o '\[.*\]' | tr -d '[]')
        [[ -n "$fname" && "$fname" != "INDEX.md" ]] && bundles+=("$fname")
    done <<< "$index"

    echo -e "  Found ${#bundles[@]} bundles."

    # Create dest dir based on tool
    local docs_dest=""
    case "$tool" in
        claude)   docs_dest="${target}/.claude/dataiku" ;;
        cursor)   docs_dest="${target}/.cursor/dataiku" ;;
        copilot)  docs_dest="${target}/.github/dataiku" ;;
        windsurf) docs_dest="${target}/.windsurf/dataiku" ;;
        aider)    docs_dest="${target}/dataiku-docs" ;;
        continue) docs_dest="${target}/.continue/dataiku" ;;
        cline)    docs_dest="${target}/.cline/dataiku" ;;
        all)
            for t in claude cursor copilot windsurf aider continue cline; do
                bash_install_docs "$t" "$target"
            done
            return ;;
    esac

    mkdir -p "$docs_dest"
    local ok=0
    for bundle in "${bundles[@]}"; do
        if curl -sfL "${GITHUB_RAW}/docs/${bundle}" -o "${docs_dest}/${bundle}" 2>/dev/null; then
            ok=$((ok+1))
            [[ $((ok % 10)) -eq 0 ]] && echo -e "  ${CHECK} ${ok}/${#bundles[@]} downloaded..."
        fi
    done

    # Write INDEX.md + graph files
    curl -sfL "${GITHUB_RAW}/docs/INDEX.md" -o "${docs_dest}/INDEX.md" 2>/dev/null
    curl -sfL "${GITHUB_RAW}/docs/graph.json" -o "${docs_dest}/graph.json" 2>/dev/null \
        && echo -e "  ${CHECK} graph.json"
    curl -sfL "${GITHUB_RAW}/docs/graph_query.py" -o "${docs_dest}/graph_query.py" 2>/dev/null \
        && echo -e "  ${CHECK} graph_query.py"

    # Create tool config
    write_tool_config "$tool" "$target" "$docs_dest"
    echo -e "\n${CHECK} ${ok} bundles + graph → ${docs_dest}"
}

write_tool_config() {
    local tool="$1"
    local target="$2"
    local docs_dest="$3"
    local marker="DATAIKU DOCS"

    case "$tool" in
        claude)
            local f="${target}/CLAUDE.md"
            grep -q "$marker" "$f" 2>/dev/null && return
            cat >> "$f" <<EOF

<!-- ${marker} -->
## Dataiku Documentation
Bundles in \`.claude/dataiku/\`. Load with \`@.claude/dataiku/INDEX.md\` then open relevant bundle.
<!-- END ${marker} -->
EOF
            echo -e "  ${CHECK} ${f}" ;;

        cursor)
            mkdir -p "${target}/.cursor/rules"
            cat > "${target}/.cursor/rules/dataiku.mdc" <<'EOF'
---
description: Dataiku DSS documentation reference
globs: ['**/*.py', '**/*.ipynb']
alwaysApply: false
---
# Dataiku Documentation
Load `.cursor/dataiku/INDEX.md` to find the right bundle, then open it.
EOF
            echo -e "  ${CHECK} ${target}/.cursor/rules/dataiku.mdc" ;;

        copilot)
            local f="${target}/.github/copilot-instructions.md"
            mkdir -p "${target}/.github"
            grep -q "$marker" "$f" 2>/dev/null && return
            cat >> "$f" <<EOF

<!-- ${marker} -->
## Dataiku DSS Documentation
Bundles in \`.github/dataiku/\`. Reference when answering Dataiku questions.
<!-- END ${marker} -->
EOF
            echo -e "  ${CHECK} ${f}" ;;

        windsurf)
            local f="${target}/.windsurfrules"
            grep -q "$marker" "$f" 2>/dev/null && return
            cat >> "$f" <<EOF

# ${marker}
Dataiku docs in \`.windsurf/dataiku/\`. Load INDEX.md to navigate.
# END ${marker}
EOF
            echo -e "  ${CHECK} ${f}" ;;

        aider)
            cat > "${target}/DATAIKU_DOCS.md" <<EOF
# Dataiku Documentation for Aider

\`\`\`
aider --read DATAIKU_DOCS.md --read dataiku-docs/python-api.md
\`\`\`
EOF
            echo -e "  ${CHECK} ${target}/DATAIKU_DOCS.md" ;;

        continue)
            local f="${target}/.continue/config.json"
            mkdir -p "${target}/.continue"
            [[ ! -f "$f" ]] && echo '{"docs":[]}' > "$f"
            echo -e "  ${CHECK} ${f} (add docs entries manually or use Python installer)" ;;

        cline)
            local f="${target}/.clinerules"
            grep -q "$marker" "$f" 2>/dev/null && return
            cat >> "$f" <<EOF

# ${marker}
Dataiku docs in \`.cline/dataiku/\`. Load INDEX.md to navigate.
# END ${marker}
EOF
            echo -e "  ${CHECK} ${f}" ;;
    esac
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
    # Check if piped (curl | bash) — can't use interactive menus
    if [[ ! -t 0 ]]; then
        echo -e "${BOLD}${CYAN}Dataiku AI Context Installer${NC}"
        echo -e "${DIM}Running non-interactively (piped mode).${NC}\n"
        echo -e "To run interactively, clone the repo first:\n"
        echo -e "  ${CYAN}git clone https://github.com/${REPO_OWNER}/${REPO_NAME}.git${NC}"
        echo -e "  ${CYAN}cd ${REPO_NAME}${NC}"
        echo -e "  ${CYAN}./install.sh${NC}\n"
        echo -e "Or install Claude agents with one line:\n"
        echo -e "  ${CYAN}curl -sL ${GITHUB_RAW}/install.sh -o install.sh && chmod +x install.sh && ./install.sh${NC}"
        exit 0
    fi

    select_what
    select_source_mode

    case "${SELECTED_WHAT}" in
        agents)
            install_agents_menu ;;
        docs)
            install_docs_menu ;;
        both)
            install_agents_menu
            install_docs_menu ;;
    esac

    show_header
    echo -e "${GREEN}${BOLD}Installation complete!${NC}\n"
    echo -e "  ${ARROW} ${BOLD}Claude agents:${NC}  restart Claude Code to load new agents"
    echo -e "  ${ARROW} ${BOLD}Doc bundles:${NC}    reference INDEX.md in your AI tool to navigate topics"
    echo ""
    echo -e "${DIM}Docs: https://github.com/${REPO_OWNER}/${REPO_NAME}${NC}\n"
}

main "$@"
