<#
.SYNOPSIS
    Lanzador de agentes de IA y Orquestador de Escuadrones Multi-Agente en Español para Herdr.
.DESCRIPTION
    Abre paneles, pestañas o divisiones configurando el entorno para que las IAs respondan en español.
    Incluye el catálogo completo de las 24 IAs reconocidas por Herdr.
    Soporta el modo '-Escuadron' / '-HermesAuditor' para desplegar a Antigravity (u otro agente principal)
    a la izquierda y Hermes Agent a la derecha como copiloto auditor en tiempo real.
.PARAMETER Agente
    El agente principal a lanzar.
.PARAMETER Direccion
    Dirección de la división ('right', 'down', 'tab').
.PARAMETER Escuadron
    Activa el escuadrón multi-agente: Agente principal a la izquierda y Hermes Auditor a la derecha.
.PARAMETER HermesAuditor
    Alias para activar el copiloto auditor Hermes en paralelo.
.EXAMPLE
    lanzar-agente -Agente antigravity
    lanzar-agente -Agente antigravity -HermesAuditor
    lanzar-agente -Escuadron
    lanzar-agente -Agente claude -Direccion down
#>

[CmdletBinding()]
param(
    [ValidateSet(
        'antigravity', 'claude', 'hermes', 'opencode', 'codex', 'gemini', 
        'cursor', 'devin', 'grok', 'kimi', 'qwen', 'cline', 
        'kiro', 'droid', 'amp', 'kilo', 'qodercli', 'letta', 
        'maki', 'muse', 'omp', 'mastracode', 'pi', 'terminal'
    )]
    [string]$Agente = 'antigravity',

    [ValidateSet('right', 'down', 'tab')]
    [string]$Direccion = 'right',

    [switch]$Escuadron,
    [switch]$HermesAuditor
)

$ErrorActionPreference = 'SilentlyContinue'

# 1. Configurar variables de entorno globales en español
$env:LANG = "es_ES.UTF-8"
$env:LC_ALL = "es_ES.UTF-8"
$env:HERMES_LANG = "es"

# 2. Localizar binario de Herdr
$herdrCmd = if ($env:HERDR_BIN_PATH -and (Test-Path $env:HERDR_BIN_PATH)) {
    $env:HERDR_BIN_PATH
} elseif (Get-Command "herdr" -ErrorAction SilentlyContinue) {
    (Get-Command "herdr").Source
} else {
    $currentWin = Join-Path $HOME ".herdr\packages\standalone\current\herdr.exe"
    $currentUnix = Join-Path $HOME ".herdr/packages/standalone/current/herdr"
    if (Test-Path $currentWin) { $currentWin }
    elseif (Test-Path $currentUnix) { $currentUnix }
    else { "herdr" }
}

# 3. Mapeo de comandos ejecutables para las 24 IAs
function Get-AgentCommand ($agentName) {
    switch ($agentName) {
        'antigravity' { return 'agy' }
        'claude'      { return 'claude --prompt "Por favor comunícate y responde siempre en español."' }
        'hermes'      { return 'hermes' }
        'opencode'    { return 'opencode' }
        'codex'       { return 'codex' }
        'gemini'      { return 'gemini' }
        'cursor'      { return 'cursor' }
        'devin'       { return 'devin' }
        'grok'        { return 'grok' }
        'kimi'        { return 'kimi' }
        'qwen'        { return 'qwen' }
        'cline'       { return 'cline' }
        'kiro'        { return 'kiro' }
        'droid'       { return 'droid' }
        'amp'         { return 'amp' }
        'kilo'        { return 'kilo' }
        'qodercli'    {
            if (Get-Command "qodercli" -ErrorAction SilentlyContinue) { return 'qodercli' }
            elseif (Get-Command "qoder" -ErrorAction SilentlyContinue) { return 'qoder' }
            else { return 'qodercli' }
        }
        'letta'       { return 'letta' }
        'maki'        { return 'maki' }
        'muse'        { return 'muse' }
        'omp'         { return 'omp' }
        'mastracode'  { return 'mastracode' }
        'pi'          { return 'pi' }
        'terminal'    {
            if ($IsWindows -or ($env:OS -match 'Windows')) { return 'pwsh' }
            else { return 'bash' }
        }
        default       { return 'pwsh' }
    }
}

function Invoke-HerdrPaneLaunch {
    param(
        [string]$TargetDir, # 'right', 'down', 'tab'
        [string]$CmdToRun
    )
    try {
        $paneId = $null
        if ($TargetDir -eq 'tab') {
            $res = & $herdrCmd tab create 2>$null
            if ($res) {
                $obj = $res | ConvertFrom-Json
                $paneId = $obj.result.pane.pane_id
            }
        } elseif ($TargetDir -in @('right', 'down')) {
            $res = & $herdrCmd pane split --direction $TargetDir 2>$null
            if ($res) {
                $obj = $res | ConvertFrom-Json
                $paneId = $obj.result.pane.pane_id
            }
        }

        if ($paneId -and $CmdToRun) {
            Start-Sleep -Milliseconds 250
            & $herdrCmd pane run $paneId "$CmdToRun" | Out-Null
        }
    } catch {
        # Si no hay sesión Herdr activa en este contexto
    }
}

$esModoEscuadron = $Escuadron -or $HermesAuditor
$cmdPrincipal = Get-AgentCommand $Agente
$cmdHermes = 'hermes'

if ($esModoEscuadron) {
    Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║       🚀 DESPLEGANDO ESCUADRÓN MULTI-AGENTE HERDR             ║" -ForegroundColor Yellow
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host " Agente Principal : $Agente (Panel Izquierdo)" -ForegroundColor Cyan
    Write-Host " Copiloto Auditor : ⚚ Hermes Agent (Panel Derecho)" -ForegroundColor Green
    Write-Host " Modo             : Revisión, auditoría y background jobs simultáneos`n" -ForegroundColor DarkGray

    # Iniciar agente principal
    Invoke-HerdrPaneLaunch -TargetDir $Direccion -CmdToRun $cmdPrincipal

    Start-Sleep -Milliseconds 400

    # Dividir a la derecha con Hermes Auditor
    Invoke-HerdrPaneLaunch -TargetDir 'right' -CmdToRun $cmdHermes
    Write-Host "[OK] Escuadrón multi-agente configurado en Herdr.`n" -ForegroundColor Green
} else {
    Write-Host "`n=== LANZADOR DE AGENTES IA EN HERDR (ESPAÑOL) ===" -ForegroundColor Cyan
    Write-Host "Iniciando $Agente..." -ForegroundColor Green
    
    Invoke-HerdrPaneLaunch -TargetDir $Direccion -CmdToRun $cmdPrincipal
}
