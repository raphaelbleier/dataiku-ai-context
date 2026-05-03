#Requires -Version 5.1
# Dataiku AI Context Installer for Windows (PowerShell)
#
# Usage:
#   Interactive:  .\install.ps1
#   One-liner:    iex (irm https://raw.githubusercontent.com/raphaelbleier/dataiku-ai-context/main/install.ps1)

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
$REPO_OWNER   = "raphaelbleier"
$REPO_NAME    = "dataiku-ai-context"
$GITHUB_RAW   = "https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main"
$GITHUB_API   = "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents"

$SCRIPT_DIR        = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$LOCAL_AGENTS_DIR  = Join-Path $SCRIPT_DIR "agents"

$GLOBAL_CLAUDE_DIR = Join-Path $HOME ".claude\agents"
$LOCAL_CLAUDE_DIR  = ".claude\agents"

# State
$script:INSTALL_MODE   = ""
$script:SOURCE_MODE    = ""
$script:SELECTED_WHAT  = ""

# ---------------------------------------------------------------------------
# UI helpers
# ---------------------------------------------------------------------------
function Write-Col([string]$Text, [string]$Fg = "White", [switch]$NoNL) {
    if ($NoNL) { Write-Host $Text -ForegroundColor $Fg -NoNewline }
    else        { Write-Host $Text -ForegroundColor $Fg }
}

function Show-Header {
    Clear-Host
    Write-Col "╔═══════════════════════════════════════════════════════════════════╗" Cyan
    Write-Col "║        Dataiku AI Context Installer                               ║" Cyan
    Write-Col "║        Claude agents + doc bundles for every AI coding tool       ║" Cyan
    Write-Col "╚═══════════════════════════════════════════════════════════════════╝" Cyan
    Write-Host ""
    if ($script:SELECTED_WHAT -or $script:INSTALL_MODE) {
        if ($script:SELECTED_WHAT) { Write-Host "  Installing: " -NoNewline; Write-Col $script:SELECTED_WHAT White }
        if ($script:INSTALL_MODE)  { Write-Host "  Agent mode: " -NoNewline; Write-Col $script:INSTALL_MODE White }
        if ($script:SOURCE_MODE)   { Write-Host "  Source:     " -NoNewline; Write-Col $script:SOURCE_MODE White }
        Write-Host ""
    }
}

function Press-Enter { Read-Host "`nPress Enter to continue" | Out-Null }

# ---------------------------------------------------------------------------
# Network helpers
# ---------------------------------------------------------------------------
function Get-RemoteString([string]$Url) {
    try { return (Invoke-WebRequest -Uri $Url -UseBasicParsing -EA Stop).Content }
    catch { return "" }
}

function Save-RemoteFile([string]$Url, [string]$Dest) {
    try { Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing -EA Stop; return $true }
    catch { return $false }
}

# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------
function Has-LocalRepo  { Test-Path $LOCAL_AGENTS_DIR }
function Has-LocalClaude { Test-Path ".claude" }
function Get-AgentsDest {
    if ($script:INSTALL_MODE -eq "global") { $GLOBAL_CLAUDE_DIR } else { $LOCAL_CLAUDE_DIR }
}
function Is-AgentInstalled([string]$Filename) {
    Test-Path (Join-Path (Get-AgentsDest) $Filename)
}

# ---------------------------------------------------------------------------
# Step 1: What to install
# ---------------------------------------------------------------------------
function Select-What {
    Show-Header
    Write-Col "What would you like to install?" White
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "1)" Yellow -NoNL; Write-Host "  Claude Code agents    " -NoNewline
    Write-Col "— 6 Dataiku domain agents for ~/.claude/agents/" DarkGray
    Write-Host "  " -NoNewline; Write-Col "2)" Yellow -NoNL; Write-Host "  AI tool doc bundles   " -NoNewline
    Write-Col "— 87 topic bundles for Cursor, Copilot, Windsurf, Aider, etc." DarkGray
    Write-Host "  " -NoNewline; Write-Col "3)" Yellow -NoNL; Write-Host "  Both"
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "q)" Yellow -NoNL; Write-Host "  Quit"
    Write-Host ""
    $c = Read-Host "Choice"
    switch ($c.Trim()) {
        "1" { $script:SELECTED_WHAT = "agents" }
        "2" { $script:SELECTED_WHAT = "docs" }
        "3" { $script:SELECTED_WHAT = "both" }
        { $_ -in "q","Q" } { Write-Host "Goodbye!"; exit 0 }
        default { Write-Col "Invalid choice." Red; Start-Sleep 1; Select-What }
    }
}

# ---------------------------------------------------------------------------
# Step 2: Source mode
# ---------------------------------------------------------------------------
function Select-SourceMode {
    if (-not (Has-LocalRepo)) {
        $script:SOURCE_MODE = "remote"; return
    }
    Show-Header
    Write-Col "Source:" White
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "1)" Yellow -NoNL
    Write-Host "  Local  " -NoNewline; Write-Col "(use this cloned repository — faster, offline)" DarkGray
    Write-Host "  " -NoNewline; Write-Col "2)" Yellow -NoNL
    Write-Host "  Remote " -NoNewline; Write-Col "(download latest from GitHub)" DarkGray
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "q)" Yellow -NoNL; Write-Host "  Quit"
    Write-Host ""
    $c = Read-Host "Choice"
    switch ($c.Trim()) {
        "1" { $script:SOURCE_MODE = "local" }
        "2" { $script:SOURCE_MODE = "remote" }
        { $_ -in "q","Q" } { Write-Host "Goodbye!"; exit 0 }
        default { Write-Col "Invalid choice." Red; Start-Sleep 1; Select-SourceMode }
    }
}

# ---------------------------------------------------------------------------
# Agents: scope selection
# ---------------------------------------------------------------------------
function Select-AgentScope {
    Show-Header
    Write-Col "Agent installation scope:" White
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "1)" Yellow -NoNL
    Write-Host "  Global  " -NoNewline
    Write-Col "($HOME\.claude\agents\ — available in all projects)" DarkGray

    if (Has-LocalClaude) {
        Write-Host "  " -NoNewline; Write-Col "2)" Yellow -NoNL
        Write-Host "  Local   " -NoNewline
        Write-Col "(.claude\agents\ — current project only)" DarkGray
    } else {
        Write-Host "  " -NoNewline; Write-Col "2)" DarkGray -NoNL
        Write-Col "  Local   (unavailable — no .claude\ directory here)" DarkGray
    }
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "q)" Yellow -NoNL; Write-Host "  Quit"
    Write-Host ""
    $c = Read-Host "Choice"
    switch ($c.Trim()) {
        "1" {
            $script:INSTALL_MODE = "global"
            New-Item -ItemType Directory -Force -Path $GLOBAL_CLAUDE_DIR | Out-Null
        }
        "2" {
            if (Has-LocalClaude) {
                $script:INSTALL_MODE = "local"
                New-Item -ItemType Directory -Force -Path $LOCAL_CLAUDE_DIR | Out-Null
            } else {
                Write-Col "No .claude\ directory found." Red; Start-Sleep 2; Select-AgentScope
            }
        }
        { $_ -in "q","Q" } { Write-Host "Goodbye!"; exit 0 }
        default { Write-Col "Invalid choice." Red; Start-Sleep 1; Select-AgentScope }
    }
}

# ---------------------------------------------------------------------------
# Agents: fetch list from GitHub
# ---------------------------------------------------------------------------
function Get-RemoteAgentList {
    $resp = Get-RemoteString "$GITHUB_API/agents"
    if (-not $resp) { return @() }
    $json = $resp | ConvertFrom-Json
    return $json | Where-Object { $_.name -match '\.md$' } | Select-Object -ExpandProperty name | Sort-Object
}

# ---------------------------------------------------------------------------
# Agents: interactive selection + install
# ---------------------------------------------------------------------------
function Install-AgentsMenu {
    Select-AgentScope
    $dest = Get-AgentsDest

    $agents = @()
    $descriptions = @()

    if ($script:SOURCE_MODE -eq "remote") {
        Show-Header
        Write-Col "Fetching agent list from GitHub..." Cyan
        $agents = @(Get-RemoteAgentList)
        if ($agents.Count -eq 0) {
            Write-Col "No agents found." Red; Press-Enter; return
        }
        $descriptions = @($agents | ForEach-Object { "" })
    } else {
        $files = Get-ChildItem -Path $LOCAL_AGENTS_DIR -Filter "*.md" -File | Sort-Object Name
        foreach ($f in $files) {
            $agents += $f.Name
            $desc = (Select-String -Path $f.FullName -Pattern "^description:" | Select-Object -First 1).Line
            if ($desc) { $desc = $desc -replace "^description:\s*","" | ForEach-Object { if ($_.Length -gt 65) { $_.Substring(0,65) } else { $_ } } }
            $descriptions += ($desc -join "")
        }
    }

    # All selected by default
    $states = @(1) * $agents.Count

    while ($true) {
        Show-Header
        Write-Col "Select agents to install:" White
        Write-Col "  (toggle with number, [v] = install)" DarkGray
        Write-Host ""

        for ($i = 0; $i -lt $agents.Count; $i++) {
            $name = $agents[$i] -replace "\.md$",""
            $installed = if (Is-AgentInstalled $agents[$i]) { " [installed]" } else { "" }
            $icon = if ($states[$i] -eq 1) { "[v]" } else { "[ ]" }
            $iconColor = if ($states[$i] -eq 1) { "Green" } else { "Red" }
            $num = ($i + 1).ToString().PadLeft(2)
            Write-Host "  " -NoNewline
            Write-Col "$($num))" Yellow -NoNL
            Write-Host " " -NoNewline
            Write-Col $icon $iconColor -NoNL
            Write-Host " $($name.PadRight(35))" -NoNewline
            Write-Col $descriptions[$i] DarkGray -NoNL
            if ($installed) { Write-Col $installed Cyan -NoNL }
            Write-Host ""
        }

        Write-Host ""
        Write-Col "  a) Select all   n) Deselect all   c) Confirm   b) Back   q) Quit" DarkGray
        Write-Host ""
        $c = Read-Host "Choice"

        switch -Regex ($c.Trim()) {
            "^[0-9]+$" {
                $idx = [int]$c - 1
                if ($idx -ge 0 -and $idx -lt $agents.Count) {
                    $states[$idx] = if ($states[$idx] -eq 1) { 0 } else { 1 }
                }
            }
            "^[aA]$" { for ($i=0;$i -lt $states.Count;$i++) { $states[$i]=1 } }
            "^[nN]$" { for ($i=0;$i -lt $states.Count;$i++) { $states[$i]=0 } }
            "^[cC]$" { Confirm-InstallAgents $agents $states $dest; return }
            "^[bB]$" { return }
            "^[qQ]$" { Write-Host "Goodbye!"; exit 0 }
        }
    }
}

function Confirm-InstallAgents([string[]]$Agents, [int[]]$States, [string]$Dest) {
    $toInstall = @()
    for ($i = 0; $i -lt $Agents.Count; $i++) {
        if ($States[$i] -eq 1) { $toInstall += $Agents[$i] }
    }

    Show-Header
    Write-Col "Confirm installation" White
    Write-Host ""

    if ($toInstall.Count -eq 0) {
        Write-Col "Nothing selected." Yellow; Press-Enter; return
    }

    Write-Col "Agents to install ($($toInstall.Count)):" Green
    foreach ($a in $toInstall) { Write-Host "  [+] $($a -replace '\.md$','')" }
    Write-Host ""
    Write-Host "Destination: $Dest"
    Write-Host ""

    $confirm = Read-Host "Apply? (y/N)"
    if ($confirm -notmatch "^[yY]$") {
        Write-Col "Cancelled." Yellow; Press-Enter; return
    }

    Write-Host ""
    $ok = 0; $fail = 0
    foreach ($agentFile in $toInstall) {
        $destFile = Join-Path $Dest $agentFile
        $success = $false
        if ($script:SOURCE_MODE -eq "remote") {
            $success = Save-RemoteFile "$GITHUB_RAW/agents/$agentFile" $destFile
        } else {
            try {
                Copy-Item (Join-Path $LOCAL_AGENTS_DIR $agentFile) $destFile -Force
                $success = $true
            } catch { $success = $false }
        }
        if ($success) {
            Write-Col "  [+] $($agentFile -replace '\.md$','')" Green
            $ok++
        } else {
            Write-Col "  [x] $($agentFile -replace '\.md$','') (failed)" Red
            $fail++
        }
    }

    Write-Host ""
    Write-Col "Done: $ok installed$(if ($fail -gt 0) { ", $fail failed" })" Green
    Write-Host "`nAgents are ready. In Claude Code, they appear automatically as subagents."
    Press-Enter
}

# ---------------------------------------------------------------------------
# Docs installation
# ---------------------------------------------------------------------------
function Install-DocsMenu {
    Show-Header
    Write-Col "Select AI coding tool:" White
    Write-Host ""
    $tools = @(
        @{n="1"; label="Claude Code    "; hint="-> .claude\dataiku\ + CLAUDE.md"; key="claude"},
        @{n="2"; label="Cursor         "; hint="-> .cursor\dataiku\ + .cursor\rules\dataiku.mdc"; key="cursor"},
        @{n="3"; label="GitHub Copilot "; hint="-> .github\dataiku\ + .github\copilot-instructions.md"; key="copilot"},
        @{n="4"; label="Windsurf       "; hint="-> .windsurf\dataiku\ + .windsurfrules"; key="windsurf"},
        @{n="5"; label="Aider          "; hint="-> dataiku-docs\ + DATAIKU_DOCS.md"; key="aider"},
        @{n="6"; label="Continue.dev   "; hint="-> .continue\dataiku\ + .continue\config.json"; key="continue"},
        @{n="7"; label="Cline          "; hint="-> .cline\dataiku\ + .clinerules"; key="cline"},
        @{n="8"; label="All tools      "; hint=""; key="all"}
    )
    foreach ($t in $tools) {
        Write-Host "  " -NoNewline
        Write-Col "$($t.n))" Yellow -NoNL
        Write-Host "  $($t.label)" -NoNewline
        Write-Col $t.hint DarkGray
    }
    Write-Host ""
    Write-Host "  " -NoNewline; Write-Col "b)" Yellow -NoNL; Write-Host " Back  " -NoNewline
    Write-Col "q) Quit" Yellow
    Write-Host ""

    $c = Read-Host "Choice"
    $map = @{"1"="claude";"2"="cursor";"3"="copilot";"4"="windsurf";"5"="aider";"6"="continue";"7"="cline";"8"="all"}
    if ($c.Trim() -in @("b","B")) { return }
    if ($c.Trim() -in @("q","Q")) { Write-Host "Goodbye!"; exit 0 }
    if (-not $map.ContainsKey($c.Trim())) {
        Write-Col "Invalid choice." Red; Start-Sleep 1; Install-DocsMenu; return
    }
    $tool = $map[$c.Trim()]

    Show-Header
    Write-Col "Target project directory:" White
    Write-Host ""
    Write-Col "  Enter path to your project (where config files will be created)." DarkGray
    Write-Col "  Leave blank for current directory: $(Get-Location)" DarkGray
    Write-Host ""
    $targetDir = Read-Host "Path [.]"
    if (-not $targetDir) { $targetDir = "." }
    $targetDir = $targetDir.Trim('"')

    if (-not (Test-Path $targetDir)) {
        Write-Col "Directory not found: $targetDir" Red; Start-Sleep 2; Install-DocsMenu; return
    }

    Invoke-DocsInstaller $tool $targetDir
}

function Invoke-DocsInstaller([string]$Tool, [string]$Target) {
    Show-Header
    Write-Col "Installing docs for $Tool into $Target" White
    Write-Host ""

    # Try Python first
    $py = $null
    foreach ($cmd in @("python","python3")) {
        try { $null = & $cmd --version 2>&1; $py = $cmd; break } catch {}
    }

    if ($py) {
        $script = $null
        foreach ($p in @((Join-Path $SCRIPT_DIR "tools\dataiku-docs.py"),(Join-Path $SCRIPT_DIR "dataiku-docs.py"))) {
            if (Test-Path $p) { $script = $p; break }
        }
        $docsDir = $null
        foreach ($d in @((Join-Path $SCRIPT_DIR "docs"),(Join-Path $SCRIPT_DIR "dataiku_docs"))) {
            if (Test-Path $d) { $docsDir = $d; break }
        }
        if ($script -and $docsDir) {
            & $py $script install $Tool --docs-dir $docsDir --target $Target
            Install-RulesLocal $Tool $Target
            Write-Host ""
            Press-Enter
            return
        }
    }

    Write-Col "Python not available or docs not found locally — using remote bundles." Yellow
    Invoke-BashInstallDocs $Tool $Target
    Press-Enter
}

function Invoke-BashInstallDocs([string]$Tool, [string]$Target) {
    if ($Tool -eq "all") {
        foreach ($t in @("claude","cursor","copilot","windsurf","aider","continue","cline")) {
            Invoke-BashInstallDocs $t $Target
        }
        return
    }

    Write-Col "Fetching bundle index..." Cyan
    $index = Get-RemoteString "$GITHUB_RAW/docs/INDEX.md"
    if (-not $index) { Write-Col "Failed to fetch bundle index from GitHub." Red; return }

    $bundles = @()
    foreach ($line in ($index -split "`n")) {
        if ($line -match '\[([^\]]+\.md)\]') {
            $fname = $matches[1]
            if ($fname -ne "INDEX.md") { $bundles += $fname }
        }
    }
    Write-Host "  Found $($bundles.Count) bundles."

    $docsMap = @{
        "claude"   = ".claude\dataiku"
        "cursor"   = ".cursor\dataiku"
        "copilot"  = ".github\dataiku"
        "windsurf" = ".windsurf\dataiku"
        "aider"    = "dataiku-docs"
        "continue" = ".continue\dataiku"
        "cline"    = ".cline\dataiku"
    }
    $docsDest = Join-Path $Target $docsMap[$Tool]
    New-Item -ItemType Directory -Force -Path $docsDest | Out-Null

    $ok = 0
    foreach ($bundle in $bundles) {
        $success = Save-RemoteFile "$GITHUB_RAW/docs/$bundle" (Join-Path $docsDest $bundle)
        if ($success) {
            $ok++
            if ($ok % 10 -eq 0) { Write-Col "  [+] $ok/$($bundles.Count) downloaded..." Green }
        }
    }

    foreach ($f in @("INDEX.md","graph.json","graph_query.py")) {
        if (Save-RemoteFile "$GITHUB_RAW/docs/$f" (Join-Path $docsDest $f)) {
            Write-Col "  [+] $f" Green
        }
    }

    # Install rules
    Install-RulesRemote $Tool $Target

    Write-Tool-Config $Tool $Target $docsDest
    Write-Host ""
    Write-Col "[+] $ok bundles + graph -> $docsDest" Green
}

# ---------------------------------------------------------------------------
# Rules helpers
# ---------------------------------------------------------------------------
function Get-RulesDest([string]$Tool, [string]$Target) {
    switch ($Tool) {
        "cursor"   { return Join-Path $Target ".cursor\rules" }
        "copilot"  { return Join-Path $Target ".github\instructions" }
        "windsurf" { return Join-Path $Target ".windsurf\rules" }
        "aider"    { return Join-Path $Target "dataiku-docs" }
        "continue" { return Join-Path $Target ".continue\rules" }
        "cline"    { return Join-Path $Target ".clinerules" }
        default    { return "" }
    }
}

function Get-RulesExt([string]$Tool) {
    switch ($Tool) {
        "cursor"  { return ".mdc" }
        "copilot" { return ".instructions.md" }
        default   { return ".md" }
    }
}

function Install-RulesLocal([string]$Tool, [string]$Target) {
    if ($Tool -eq "claude") { return }
    $src = Join-Path $SCRIPT_DIR "rules\$Tool"
    if (-not (Test-Path $src)) { return }
    $dest = Get-RulesDest $Tool $Target
    if (-not $dest) { return }
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $count = 0
    foreach ($f in (Get-ChildItem $src -File)) {
        Copy-Item $f.FullName (Join-Path $dest $f.Name) -Force
        $count++
    }
    if ($count -gt 0) { Write-Col "  [+] $count rules -> $dest" Green }
}

function Install-RulesRemote([string]$Tool, [string]$Target) {
    if ($Tool -eq "claude") { return }
    $dest = Get-RulesDest $Tool $Target
    if (-not $dest) { return }
    $ext = Get-RulesExt $Tool
    $agentNames = @("dataiku-developer","dataiku-data-engineer","dataiku-ml-engineer",
                    "dataiku-genai-engineer","dataiku-api-developer","dataiku-admin")
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $ok = 0
    foreach ($agent in $agentNames) {
        $filename = "$agent$ext"
        if (Save-RemoteFile "$GITHUB_RAW/rules/$Tool/$filename" (Join-Path $dest $filename)) {
            $ok++
        }
    }
    if ($ok -gt 0) { Write-Col "  [+] $ok rules -> $dest" Green }
}

function Write-Tool-Config([string]$Tool, [string]$Target, [string]$DocsDest) {
    $marker = "DATAIKU DOCS"
    switch ($Tool) {
        "claude" {
            $f = Join-Path $Target "CLAUDE.md"
            if ((Test-Path $f) -and (Select-String -Path $f -Pattern $marker -Quiet)) { return }
            Add-Content $f @"

<!-- $marker -->
## Dataiku Documentation
Bundles in `.claude/dataiku/`. Load with `@.claude/dataiku/INDEX.md` then open relevant bundle.
<!-- END $marker -->
"@
            Write-Col "  [+] $f" Green
        }
        "cursor" {
            $rulesDir = Join-Path $Target ".cursor\rules"
            New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
            $f = Join-Path $rulesDir "dataiku.mdc"
            Set-Content $f @"
---
description: Dataiku DSS documentation reference
globs: ['**/*.py', '**/*.ipynb']
alwaysApply: false
---
# Dataiku Documentation
Load `.cursor/dataiku/INDEX.md` to find the right bundle, then open it.
"@
            Write-Col "  [+] $f" Green
        }
        "copilot" {
            $ghDir = Join-Path $Target ".github"
            New-Item -ItemType Directory -Force -Path $ghDir | Out-Null
            $f = Join-Path $ghDir "copilot-instructions.md"
            if ((Test-Path $f) -and (Select-String -Path $f -Pattern $marker -Quiet)) { return }
            Add-Content $f @"

<!-- $marker -->
## Dataiku DSS Documentation
Bundles in `.github/dataiku/`. Reference when answering Dataiku questions.
<!-- END $marker -->
"@
            Write-Col "  [+] $f" Green
        }
        "windsurf" {
            $f = Join-Path $Target ".windsurfrules"
            if ((Test-Path $f) -and (Select-String -Path $f -Pattern $marker -Quiet)) { return }
            Add-Content $f @"

# $marker
Dataiku docs in `.windsurf/dataiku/`. Load INDEX.md to navigate.
# END $marker
"@
            Write-Col "  [+] $f" Green
        }
        "aider" {
            $f = Join-Path $Target "DATAIKU_DOCS.md"
            Set-Content $f @"
# Dataiku Documentation for Aider

``````
aider --read DATAIKU_DOCS.md --read dataiku-docs/python-api.md
``````
"@
            Write-Col "  [+] $f" Green
        }
        "continue" {
            $contDir = Join-Path $Target ".continue"
            New-Item -ItemType Directory -Force -Path $contDir | Out-Null
            $f = Join-Path $contDir "config.json"
            if (-not (Test-Path $f)) { Set-Content $f '{"docs":[]}' }
            Write-Col "  [+] $f (add docs entries manually or use Python installer)" Green
        }
        "cline" {
            $f = Join-Path $Target ".clinerules"
            if ((Test-Path $f) -and (Select-String -Path $f -Pattern $marker -Quiet)) { return }
            Add-Content $f @"

# $marker
Dataiku docs in `.cline/dataiku/`. Load INDEX.md to navigate.
# END $marker
"@
            Write-Col "  [+] $f" Green
        }
    }
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
function Main {
    Select-What
    Select-SourceMode

    switch ($script:SELECTED_WHAT) {
        "agents" { Install-AgentsMenu }
        "docs"   { Install-DocsMenu }
        "both"   { Install-AgentsMenu; Install-DocsMenu }
    }

    Show-Header
    Write-Col "Installation complete!" Green
    Write-Host ""
    Write-Host "  -> Claude agents:  restart Claude Code to load new agents"
    Write-Host "  -> Doc bundles:    reference INDEX.md in your AI tool to navigate topics"
    Write-Host ""
    Write-Col "Docs: https://github.com/$REPO_OWNER/$REPO_NAME" DarkGray
    Write-Host ""
}

Main
