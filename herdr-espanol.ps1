#!/usr/bin/env pwsh
<#
.SYNOPSIS
    HerdrSpanis - Localización nativa y tematización de agentes para Herdr.
.DESCRIPTION
    Cumple con la especificación oficial de https://herdr.dev/docs/plugins/:
    - Utiliza $env:HERDR_BIN_PATH dinámicamente para máxima portabilidad.
    - Soporta invocación por [[startup]], [[events]] y [[actions]].
    - Aplica etiquetas de estado en español.
    - Asigna nombres limpios e iconos tipográficos/Nerd Fonts originales para el catálogo de las 24 IAs.
#>

[CmdletBinding()]
param(
    [switch]$Watch,
    [int]$IntervalSeconds = 3
)

$ErrorActionPreference = "SilentlyContinue"

# 1. Resolver el binario de Herdr según https://herdr.dev/docs/plugins/
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

# 2. Catálogo estilizado con iconos canónicos para las 24 IAs y Agentes
$agentIcons = @{
    # 1. Antigravity
    "agy"             = "󰚩 Antigravity"
    "antigravity"     = "󰚩 Antigravity"
    "antigravity-cli" = "󰚩 Antigravity"
    # 2. Claude
    "claude"          = "󰭻 Claude"
    # 3. Hermes
    "hermes"          = "⚚ Hermes"
    # 4. OpenCode
    "opencode"        = " OpenCode"
    # 5. Codex
    "codex"           = "󰘦 Codex"
    # 6. Gemini
    "gemini"          = "󰊠 Gemini"
    # 7. Cursor
    "cursor"          = "󰨞 Cursor"
    # 8. Devin
    "devin"           = "󰆍 Devin"
    # 9. Grok
    "grok"            = "󰛡 Grok"
    # 10. Kimi
    "kimi"            = "󰽤 Kimi"
    # 11. Qwen
    "qwen"            = "󰈸 Qwen"
    "qwen-code"       = "󰈸 Qwen"
    # 12. Cline
    "cline"           = "󰞋 Cline"
    # 13. Kiro
    "kiro"            = "󰘧 Kiro"
    # 14. Droid
    "droid"           = "󰄛 Droid"
    # 15. Amp
    "amp"             = "󰘦 Amp"
    # 16. Kilo
    "kilo"            = "󰄯 Kilo"
    # 17. Qoder / QoderCLI
    "qoder"           = "󰘧 Qoder"
    "qodercli"        = "󰘧 Qoder"
    # 18. Letta
    "letta"           = "󰐚 Letta"
    # 19. Maki
    "maki"            = "󰒍 Maki"
    # 20. Muse
    "muse"            = "󰝚 Muse"
    # 21. OhMyPosh
    "omp"             = "󰊠 OhMyPosh"
    # 22. Mastra / Mastracode
    "mastra"          = "󰒍 Mastra"
    "mastracode"      = "󰒍 Mastra"
    # 23. Pi
    "pi"              = "󰄛 Pi"
    # 24. Terminal / Shell
    "terminal"        = " Terminal"
    "pwsh"            = " Terminal"
    "powershell"      = " Terminal"
    "cmd"             = " Terminal"
    "bash"            = " Terminal"
    "zsh"             = " Terminal"
    # Agente adicional
    "copilot"         = " Copilot"
}

function Update-PaneSpanishMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PaneId,
        [string]$AgentKey,
        [string]$CurrentDisplayAgent,
        $CurrentLabels
    )

    $displayAgent = if ($AgentKey -and $agentIcons.ContainsKey($AgentKey.ToLower())) {
        $agentIcons[$AgentKey.ToLower()]
    } elseif ($AgentKey) {
        "$AgentKey"
    } else {
        " Terminal"
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

# 3. Comprobar actualizaciones de fondo de forma no intrusiva
try {
    $checkScript = Join-Path $PSScriptRoot "scripts\check-actualizacion.ps1"
    if (Test-Path $checkScript) {
        & $checkScript
    }
} catch {}

Apply-HerdrSpanis

if ($Watch) {
    Write-Host "Iniciando HerdrSpanis en modo continuo (cada $IntervalSeconds s)..." -ForegroundColor Cyan
    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds
        Apply-HerdrSpanis
    }
}
