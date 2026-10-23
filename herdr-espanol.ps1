#!/usr/bin/env pwsh
<#
.SYNOPSIS
    HerdrSpanis - Localización y tematización de agentes para Herdr.
.DESCRIPTION
    Aplica etiquetas de estado en español (Listo, Trabajando..., Esperando tu respuesta, etc.)
    y añade iconos reconocibles (Nerd Fonts / Unicode) a cada agente en Herdr.
#>

[CmdletBinding()]
param(
    [switch]$Watch,
    [int]$IntervalSeconds = 3
)

$ErrorActionPreference = "SilentlyContinue"

# Ruta al ejecutable de herdr
$herdrCmd = "herdr"
if (-not (Get-Command $herdrCmd -ErrorAction SilentlyContinue)) {
    $herdrFallback = "C:\Users\Rocka\.herdr\packages\standalone\releases\0.9.5-x86_64-pc-windows-msvc\herdr.exe"
    if (Test-Path $herdrFallback) {
        $herdrCmd = $herdrFallback
    }
}

# Iconos y nombres estilizados para cada IA/Agente
$agentIcons = @{
    "agy"        = "✨ Antigravity"
    "hermes"     = "⚡ Hermes"
    "opencode"   = "🤖 OpenCode"
    "claude"     = "🧠 Claude"
    "codex"      = "💻 Codex"
    "copilot"    = "🐙 Copilot"
    "devin"      = "🎯 Devin"
    "cursor"     = "⚡ Cursor"
    "grok"       = "🌌 Grok"
    "kimi"       = "🌙 Kimi"
    "qwen"       = "🐉 Qwen"
}

function Apply-HerdrSpanis {
    try {
        $panesJson = & $herdrCmd pane list
        if (-not $panesJson) { return }

        $data = $panesJson | ConvertFrom-Json
        if (-not $data.result.panes) { return }

        foreach ($pane in $data.result.panes) {
            $paneId = $pane.pane_id
            $agentKey = $pane.agent
            
            $displayAgent = if ($agentKey -and $agentIcons.ContainsKey($agentKey)) { 
                $agentIcons[$agentKey] 
            } elseif ($agentKey) { 
                "🤖 $agentKey" 
            } else { 
                "🐚 Terminal" 
            }

            $currentLabels = $pane.state_labels
            $needsUpdate = $false

            if (-not $currentLabels -or $currentLabels.idle -ne "Listo" -or $currentLabels.working -ne "Trabajando..." -or $pane.display_agent -ne $displayAgent) {
                $needsUpdate = $true
            }

            if ($needsUpdate) {
                & $herdrCmd pane report-metadata $paneId `
                    --source "herdr-spanis" `
                    --display-agent "$displayAgent" `
                    --state-label "idle=Listo" `
                    --state-label "working=Trabajando..." `
                    --state-label "blocked=Esperando tu respuesta" `
                    --state-label "done=Completado" `
                    --state-label "unknown=Desconocido"
            }
        }
    } catch {
        # Silencioso para evitar interrumpir flujos de terminal
    }
}

Write-Host "Iniciando HerdrSpanis..." -ForegroundColor Cyan
Apply-HerdrSpanis
Write-Host "Herdr configurado con iconos de agentes y estados en español." -ForegroundColor Green

if ($Watch) {
    Write-Host "Modo continuo activo (vigilando paneles cada $IntervalSeconds s). Presiona Ctrl+C para salir." -ForegroundColor Yellow
    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds
        Apply-HerdrSpanis
    }
}
