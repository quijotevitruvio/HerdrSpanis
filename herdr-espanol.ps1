#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Herdr en Español - Daemon / Hook de localización automática para Herdr.
.DESCRIPTION
    Monitorea los paneles y agentes activos en Herdr y aplica metadatos de visualización
    con etiquetas de estado traducidas al español (Listo, Trabajando..., Esperando respuesta, etc.)
    y nombres amigables para cada agente (Hermes, OpenCode, Antigravity, Claude).
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

$agentNames = @{
    "agy"        = "Antigravity (Español)"
    "hermes"     = "Hermes Agent (Español)"
    "opencode"   = "OpenCode (Español)"
    "claude"     = "Claude Code (Español)"
    "codex"      = "Codex"
    "copilot"    = "GitHub Copilot"
    "devin"      = "Devin"
}

function Apply-HerdrSpanish {
    try {
        $panesJson = & $herdrCmd pane list
        if (-not $panesJson) { return }

        $data = $panesJson | ConvertFrom-Json
        if (-not $data.result.panes) { return }

        foreach ($pane in $data.result.panes) {
            $paneId = $pane.pane_id
            $agentKey = $pane.agent
            $displayAgent = if ($agentNames.ContainsKey($agentKey)) { $agentNames[$agentKey] } else { $agentKey }

            # Verificar si ya tiene las etiquetas en español
            $currentLabels = $pane.state_labels
            $needsUpdate = $false

            if (-not $currentLabels -or $currentLabels.idle -ne "Listo" -or $currentLabels.working -ne "Trabajando..." -or $pane.display_agent -ne $displayAgent) {
                $needsUpdate = $true
            }

            if ($needsUpdate) {
                & $herdrCmd pane report-metadata $paneId `
                    --source "herdr-espanol" `
                    --display-agent "$displayAgent" `
                    --state-label "idle=Listo" `
                    --state-label "working=Trabajando..." `
                    --state-label "blocked=Esperando tu respuesta" `
                    --state-label "done=Completado" `
                    --state-label "unknown=Desconocido"
            }
        }
    } catch {
        # Silencioso para evitar romper la sesión
    }
}

Write-Host "Iniciando Herdr en Español..." -ForegroundColor Cyan
Apply-HerdrSpanish
Write-Host "Etiquetas en español aplicadas a todos los paneles activos." -ForegroundColor Green

if ($Watch) {
    Write-Host "Modo continuo activo (verificando cada $IntervalSeconds segundos). Presiona Ctrl+C para detener." -ForegroundColor Yellow
    while ($true) {
        Start-Sleep -Seconds $IntervalSeconds
        Apply-HerdrSpanish
    }
}
