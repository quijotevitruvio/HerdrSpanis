# ==============================================================================
# HerdrSpanis - Instalador Automático de Herdr en Español (Para Dummies)
# ==============================================================================

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Write-Host @"

  ██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ ███╗   ██╗██╗███████╗
  ██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗  ██║██║██╔════╝
  ███████║█████╗  ██████╔╝██║  ██║███████╗██████╔╝███████║██╔██╗ ██║██║███████╗
  ██╔══██║██╔══╝  ██╔══██╗██║  ██║╚════██║██╔═══╝ ██╔══██║██║╚██╗██║██║╚════██║
  ██║  ██║███████╗██║  ██║██████╔╝███████║██║     ██║  ██║██║ ╚████║██║███████║
  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝
                     Localización al Español para Herdr
"@ -ForegroundColor Cyan

Write-Host "`n[1/4] Verificando instalación de Herdr..." -ForegroundColor Yellow

$standaloneDir = "$env:USERPROFILE\.herdr\packages\standalone"
$releasesDir = "$standaloneDir\releases"
$currentLink = "$standaloneDir\current"
$scriptsDir = "$env:USERPROFILE\.herdr\scripts"

if (-not (Test-Path $releasesDir)) {
    Write-Host "[!] No se detectó Herdr instalado en tu equipo." -ForegroundColor Yellow
    Write-Host "    Instalando Herdr oficial primero..." -ForegroundColor Cyan
    Invoke-Expression (Invoke-RestMethod -Uri "https://herdr.dev/install.ps1")
}

$dirOficial = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -notmatch '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1

if (-not $dirOficial) {
    Write-Error "No se pudo localizar el directorio oficial de Herdr. Instala Herdr desde https://herdr.dev primero."
    return
}

$versionMatch = [regex]::Match($dirOficial.Name, '^([0-9]+\.[0-9]+(\.[0-9]+)?)')
$version = if ($versionMatch.Success) { $versionMatch.Groups[1].Value } else { "0.9.5" }

Write-Host "[OK] Herdr oficial detectado: versión $version" -ForegroundColor Green

# 2. Respaldar oficial
Write-Host "`n[2/4] Respaldando ejecutable oficial de fábrica..." -ForegroundColor Yellow
$binOficial = Join-Path $dirOficial.FullName "herdr.exe"
$binBackup = Join-Path $dirOficial.FullName "herdr-original.exe"
if ((Test-Path $binOficial) -and (-not (Test-Path $binBackup))) {
    Copy-Item $binOficial $binBackup -Force
    Write-Host "[OK] Copia de seguridad guardada en: herdr-original.exe" -ForegroundColor Green
} else {
    Write-Host "[OK] Copia de seguridad ya existe." -ForegroundColor DarkGray
}

# 3. Descargar e instalar versión en español
Write-Host "`n[3/4] Descargando e instalando Herdr en Español..." -ForegroundColor Yellow
$nombreEspanol = "$version-espanol-x86_64-pc-windows-msvc"
$dirEspanol = Join-Path $releasesDir $nombreEspanol

if (-not (Test-Path $dirEspanol)) {
    New-Item -ItemType Directory -Path $dirEspanol -Force | Out-Null
}

# Copiar dependencias de terminal (conpty)
if (Test-Path (Join-Path $dirOficial.FullName "conpty")) {
    Copy-Item (Join-Path $dirOficial.FullName "conpty") (Join-Path $dirEspanol "conpty") -Recurse -Force
}
if (Test-Path (Join-Path $dirOficial.FullName "THIRD-PARTY-NOTICES")) {
    Copy-Item (Join-Path $dirOficial.FullName "THIRD-PARTY-NOTICES") (Join-Path $dirEspanol "THIRD-PARTY-NOTICES") -Recurse -Force
}

$binEspanolDestino = Join-Path $dirEspanol "herdr.exe"
$tempFile = Join-Path $env:TEMP "herdr-es-installer.exe"
Write-Host "    Descargando binario traducido..." -ForegroundColor Gray

$urlsDescarga = @(
    "https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v$version-espanol/herdr-es.exe",
    "https://github.com/quijotevitruvio/HerdrSpanis/releases/latest/download/herdr-es.exe"
)

$descargaExitosa = $false
foreach ($url in $urlsDescarga) {
    try {
        Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing -TimeoutSec 60
        if ((Test-Path $tempFile) -and ((Get-Item $tempFile).Length -gt 10000000)) {
            Copy-Item $tempFile $binEspanolDestino -Force
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            $descargaExitosa = $true
            Write-Host "[OK] Binario en español instalado con éxito." -ForegroundColor Green
            break
        }
    } catch {
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    }
}

if (-not $descargaExitosa) {
    Write-Warning "No se pudo descargar el binario precompilado de GitHub. Podrás compilarlo o usar el plugin directamente."
}

# Crear scripts auxiliares
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
}

# Descargar scripts de gestión y automatización
$baseUrl = "https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/scripts"
$scripts = @("herdr-idioma.ps1", "herdr-actualizar-es.ps1", "lanzar-agente.ps1", "check-actualizacion.ps1")

foreach ($s in $scripts) {
    try {
        Invoke-WebRequest -Uri "$baseUrl/$s" -OutFile "$scriptsDir\$s" -UseBasicParsing -ErrorAction SilentlyContinue
    } catch {}
}

# Instalar comandos globales en cargo bin o herdr bin
$binFolder = if (Test-Path "$env:USERPROFILE\.cargo\bin") { "$env:USERPROFILE\.cargo\bin" } else { "$env:USERPROFILE\.herdr\bin" }
if (-not (Test-Path $binFolder)) { New-Item -ItemType Directory -Path $binFolder -Force | Out-Null }

Set-Content -Path "$binFolder\herdr-idioma.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-idioma.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-idioma.ps1`" %*"
Set-Content -Path "$binFolder\herdr-actualizar-es.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-actualizar-es.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-actualizar-es.ps1`" %*"
Set-Content -Path "$binFolder\herdr-agente.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\lanzar-agente.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\lanzar-agente.ps1`" %*"
Set-Content -Path "$binFolder\herdr-escuadron.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\lanzar-agente.ps1`" -Escuadron %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\lanzar-agente.ps1`" -Escuadron %*"
Set-Content -Path "$binFolder\herdr-check-actualizacion.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\check-actualizacion.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\check-actualizacion.ps1`" %*"

# 4. Configurar enlace activo y PATH
Write-Host "`n[4/4] Configurando enlace 'current' y variables de entorno..." -ForegroundColor Yellow

if (Test-Path $currentLink) {
    cmd /c rmdir "$currentLink" 2>$null
}
New-Item -ItemType Junction -Path $currentLink -Target $dirEspanol | Out-Null

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$rutasAAgregar = @($currentLink, $binFolder)

foreach ($r in $rutasAAgregar) {
    if ($userPath -notmatch [regex]::Escape($r)) {
        $userPath = "$r;$userPath"
    }
}
[Environment]::SetEnvironmentVariable('Path', $userPath, 'User')
Write-Host "[OK] Variable PATH de usuario configurada para comandos rápidos." -ForegroundColor Green

# 5. Activar plugin oficial de estados e iconos
try {
    Write-Host "    Activando plugin oficial para iconos y estados de agentes..." -ForegroundColor Gray
    & "$dirEspanol\herdr.exe" plugin install quijotevitruvio/HerdrSpanis 2>$null
} catch {}

# Comprobar actualizaciones y preparar caché inicial
try {
    & "$scriptsDir\check-actualizacion.ps1" -Silent
} catch {}

# ==============================================================================
# MENSAJE DE ÉXITO Y DONACIONES / APOYO
# ==============================================================================
Write-Host @"

  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                 🎉  ¡HERDR EN ESPAÑOL ESTÁ LISTO PARA USAR!               ║
  ╚════════════════════════════════════════════════════════════════════════════╝

  Comandos rápidos disponibles en cualquier terminal:
    herdr                      -> Inicia Herdr 100% en Español
    herdr-escuadron            -> Lanza Escuadrón (Antigravity + Hermes Auditor)
    herdr-agente [nombre]      -> Lanza cualquiera de las 24 IAs en Español
    herdr-idioma es            -> Activar versión en Español
    herdr-idioma en            -> Volver al Inglés oficial original
    herdr-actualizar-es        -> Sincronizar automáticamente con nuevas versiones
    herdr-check-actualizacion  -> Comprobar si hay actualizaciones disponibles

  ────────────────────────────────────────────────────────────────────────────
  ⭐  ¿TE HA SERVIDO ESTE PROYECTO?
      Regálanos una estrella en GitHub para llegar a más desarrolladores:
      👉 https://github.com/quijotevitruvio/HerdrSpanis

  ☕  ¿QUIERES APOYAR EL DESARROLLO CONTINUO?
      Cómprame un café o dona a través de PayPal:
      👉 https://paypal.me/bibliotecologo

  👨‍💻  CREADO POR ANDRÉS VALENCIA TOBÓN
      X (Twitter): https://x.com/quijotevitruvio
      LinkedIn:    https://www.linkedin.com/in/andrés-valencia-tobón/
      TikTok:      https://www.tiktok.com/@quijotevitruvio
  ────────────────────────────────────────────────────────────────────────────

  Para comenzar, abre una nueva terminal y escribe: herdr
"@ -ForegroundColor Magenta
