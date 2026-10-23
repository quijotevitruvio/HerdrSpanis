<#
.SYNOPSIS
    Lanzador de agentes de IA configurados en Español para Herdr.
.DESCRIPTION
    Abre o divide un panel con el agente solicitado configurando variables de entorno
    para asegurar que responda en español.
.PARAMETER Agente
    El agente a lanzar: 'antigravity', 'claude', 'hermes', 'opencode', 'codex', 'devin'.
.PARAMETER Direccion
    'right' para dividir a la derecha o 'down' para dividir abajo.
#>

param(
    [ValidateSet('antigravity', 'claude', 'hermes', 'opencode', 'codex', 'devin', 'terminal')]
    [string]$Agente = 'antigravity',

    [ValidateSet('right', 'down', 'tab')]
    [string]$Direccion = 'right'
)

$ErrorActionPreference = 'SilentlyContinue'

$env:LANG = "es_ES.UTF-8"
$env:LC_ALL = "es_ES.UTF-8"

Write-Host "`n=== LANZADOR DE AGENTES IA (EN ESPAÑOL) ===" -ForegroundColor Cyan
Write-Host "Iniciando $Agente en modo español..." -ForegroundColor Green

switch ($Agente) {
    'antigravity' {
        & herdr pane split --$Direccion -- agy
    }
    'claude' {
        & herdr pane split --$Direccion -- claude --prompt "Por favor comunícate y responde siempre en español."
    }
    'hermes' {
        & herdr pane split --$Direccion -- hermes
    }
    'opencode' {
        & herdr pane split --$Direccion -- opencode
    }
    'codex' {
        & herdr pane split --$Direccion -- codex
    }
    default {
        & herdr pane split --$Direccion -- pwsh
    }
}
