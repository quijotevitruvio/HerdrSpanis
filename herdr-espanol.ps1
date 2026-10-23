#!/usr/bin/env pwsh
<#
.SYNOPSIS
    HerdrSpanis - Localización y tematización de agentes para Herdr.
.DESCRIPTION
    Cumple con la especificación oficial de https://herdr.dev/docs/plugins/:
    - Usa $env:HERDR_BIN_PATH dinámicamente para máxima portabilidad.
    - Soporta invocación por [[startup]], [[events]] (HERDR_PLUGIN_EVENT_JSON) y [[actions]].
    - Aplica etiquetas de estado en español y asigna iconos visuales a cada IA/Agente.
#>

[CmdletBinding()]
param(
    [switch]$Watch,
    [int]$IntervalSeconds = 3
)

$ErrorActionPreference = "SilentlyContinue"

# 1. Resolver el binario de Herdr según https://herdr.dev/docs/plugins/ (HERDR_BIN_PATH primero)
$herdrCmd = if ($env:HERDR_BIN_PATH -and (Test-Path $env:HERDR_BIN_PATH)) {
    $env:HERDR_BIN_PATH
} elseif (Get-Command "herdr" -ErrorAction SilentlyContinue) {
    (Get-Command "herdr").Source
} else {
    $currentWin = Join-Path $HOME ".herdr\packages\standalone\current\herdr.exe"
    $currentUnix = Join-Path $HOME ".herdr/packages/standalone/current/herdr"
    if (Test-Path $currentWin) {
        $currentWin
    } elseif (Test-Path $currentUnix) {
        $currentUnix
    } else {
        $latestRelease = Get-ChildItem -Path (Join-Path $HOME ".herdr\packages\standalone\releases") -Directory -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestRelease) {
            Join-Path $latestRelease.FullName "herdr.exe"
        } else {
            "herdr"
        }
    }
}

# 2. Catálogo de iconos por agente reconocido en Herdr
$agentIcons = @{
    "agy"             = "✨ Antigravity"
    "antigravity-cli" = "✨ Antigravity"
    "gemini"          = "✨ Gemini"
    "hermes"          = "⚡ Hermes"
    "opencode"        = "🤖 OpenCode"
    "claude"          = "🧠 Claude"
    "codex"           = "💻 Codex"
    "copilot"         = "🐙 Copilot"
    "devin"           = "🎯 Devin"
    "cursor"          = "⚡ Cursor"
    "grok"            = "🌌 Grok"
    "kimi"            = "🌙 Kimi"
    "qwen"            = "🐉 Qwen"
    "qwen-code"       = "🐉 Qwen"
    "qoder"           = "🛠️ Qoder"
    "qodercli"        = "🛠️ Qoder"
    "droid"           = "🤖 Droid"
    "kilo"            = "⚖️ Kilo"
    "letta"           = "🧬 Letta"
    "mastracode"      = "🎭 Mastra"
    "pi"              = "🥧 Pi"
    "omp"             = "⚡ OhMyPosh"
}

function Update-PaneSpanishMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PaneId,
        [string]$AgentKey,
        [string]$CurrentDisplayAgent,
        $CurrentLabels
    )

    $displayAgent = if ($AgentKey -and $agentIcons.ContainsKey($AgentKey)) {
        $agentIcons[$AgentKey]
    } elseif ($AgentKey) {
        "🤖 $AgentKey"
    } else {
        "🐚 Terminal"
    }

    $needsUpdate = $false
    if (-not $CurrentLabels -or
        $CurrentLabels.idle -ne "Listo" -or
        $CurrentLabels.working -ne "Trabajando..." -or
        $CurrentLabels.blocked -ne "Esperando tu respuesta" -or
        $CurrentLabels.done -ne "Completado" -or
        $CurrentDisplayAgent -ne $displayAgent) {
        $needsUpdate = $true
    }

    if ($needsUpdate) {
        & $herdrCmd pane report-metadata $PaneId `
            --source "herdr-spanis" `
            --display-agent "$displayAgent" `
            --state-label "idle=Listo" `
            --state-label "working=Trabajando..." `
            --state-label "blocked=Esperando tu respuesta" `
            --state-label "done=Completado" `
            --state-label "unknown=Desconocido" | Out-Null
    }
}

function Apply-HerdrSpanis {
    try {
        $panesJson = & $herdrCmd pane list
        if (-not $panesJson) { return }

        $data = $panesJson | ConvertFrom-Json
        if (-not $data.result.panes) { return }

        foreach ($pane in $data.result.panes) {
            Update-PaneSpanishMetadata `
                -PaneId $pane.pane_id `
                -AgentKey $pane.agent `
                -CurrentDisplayAgent $pane.display_agent `
                -CurrentLabels $pane.state_labels
        }
    } catch {
        # Silencioso para evitar interrumpir flujos de terminal o hooks
    }
}

Apply-HerdrSpanis

if ($Watch) {
    Write-Host "Iniciando HerdrSpanis en modo continuo (cada $IntervalSeconds s)..." -ForegroundColor Cyan
    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds
        Apply-HerdrSpanis
    }
}
