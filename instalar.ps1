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

$versionMatch = [regex]::Match($dirOficial.Name, '^([0-9]+\.[0-9]+\.[0-9]+)')
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

$urlRelease = "https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v$version-espanol/herdr-es.exe"
$binEspanolDestino = Join-Path $dirEspanol "herdr.exe"

$tempFile = Join-Path $env:TEMP "herdr-es-installer.exe"
Write-Host "    Descargando binario traducido..." -ForegroundColor Gray
Invoke-WebRequest -Uri $urlRelease -OutFile $tempFile -UseBasicParsing -TimeoutSec 60

if ((Test-Path $tempFile) -and ((Get-Item $tempFile).Length -gt 10000000)) {
    Copy-Item $tempFile $binEspanolDestino -Force
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] Binario en español instalado con éxito." -ForegroundColor Green
} else {
    Write-Error "No se pudo descargar el binario en español desde GitHub."
    return
}

# Crear scripts auxiliares
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
}

# Descargar scripts de gestión
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/scripts/herdr-idioma.ps1" -OutFile "$scriptsDir\herdr-idioma.ps1" -UseBasicParsing
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/scripts/herdr-actualizar-es.ps1" -OutFile "$scriptsDir\herdr-actualizar-es.ps1" -UseBasicParsing

# Instalar comandos globales en cargo bin o local bin
$binFolder = if (Test-Path "$env:USERPROFILE\.cargo\bin") { "$env:USERPROFILE\.cargo\bin" } else { "$env:USERPROFILE\.herdr\bin" }
if (-not (Test-Path $binFolder)) { New-Item -ItemType Directory -Path $binFolder -Force | Out-Null }

Set-Content -Path "$binFolder\herdr-idioma.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-idioma.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-idioma.ps1`" %*"
Set-Content -Path "$binFolder\herdr-actualizar-es.cmd" -Value "@echo off`r`npwsh.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-actualizar-es.ps1`" %*`r`nif %ERRORLEVEL% NEQ 0 powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"%USERPROFILE%\.herdr\scripts\herdr-actualizar-es.ps1`" %*"

# 4. Configurar enlace activo y PATH
Write-Host "`n[4/4] Configurando enlace 'current' y variables de entorno..." -ForegroundColor Yellow

if (Test-Path $currentLink) {
    cmd /c rmdir "$currentLink" 2>$null
}
New-Item -ItemType Junction -Path $currentLink -Target $dirEspanol | Out-Null

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath -notmatch [regex]::Escape($currentLink)) {
    $nuevoPath = "$currentLink;" + $userPath
    [Environment]::SetEnvironmentVariable('Path', $nuevoPath, 'User')
    Write-Host "[OK] Variable PATH de usuario actualizada para usar 'current'." -ForegroundColor Green
}

# ==============================================================================
# MENSAJE DE ÉXITO Y DONACIONES / APOYO
# ==============================================================================
Write-Host @"

  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                 🎉  ¡HERDR EN ESPAÑOL ESTÁ LISTO PARA USAR!               ║
  ╚════════════════════════════════════════════════════════════════════════════╝

  Comandos rápidos disponibles en cualquier terminal:
    herdr                -> Inicia Herdr 100% en Español
    herdr-idioma es      -> Activar versión en Español
    herdr-idioma en      -> Volver al Inglés oficial original
    herdr-actualizar-es  -> Sincronizar automáticamente con nuevas versiones

  ────────────────────────────────────────────────────────────────────────────
  ⭐  ¿TE HA SERVIDO ESTE PROYECTO?
      Regálanos una estrella en GitHub para llegar a más desarrolladores:
      👉 https://github.com/quijotevitruvio/HerdrSpanis

  ☕  ¿QUIERES APOYAR EL DESARROLLO CONTINUO?
      Cómprame un café o dona a través de PayPal:
      👉 https://paypal.me/bibliotecologo
  ────────────────────────────────────────────────────────────────────────────

  Para comenzar, abre una nueva terminal y escribe: herdr
"@ -ForegroundColor Magenta
