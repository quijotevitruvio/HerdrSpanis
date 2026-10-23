<#
.SYNOPSIS
    Actualiza Herdr y aplica/sincroniza automáticamente la traducción al Español.
.DESCRIPTION
    1. Ejecuta 'herdr update' o verifica la última versión oficial de Herdr instalada.
    2. Asegura que el binario oficial quede respaldado como 'herdr-original.exe'.
    3. Descarga o compila automáticamente la versión en español correspondiente.
    4. Copia las dependencias de ConPTY y actualiza el enlace 'current' sin romper la instalación oficial.
.EXAMPLE
    herdr-actualizar-es
#>

[CmdletBinding()]
param(
    [switch]$ForceRebuild,
    [switch]$CheckOnly
)

$ErrorActionPreference = 'Stop'
$standaloneDir = "$env:USERPROFILE\.herdr\packages\standalone"
$releasesDir = "$standaloneDir\releases"
$currentLink = "$standaloneDir\current"
$srcDir = "F:\666999\0.Programador\herdr-src"
$zigExe = "$env:USERPROFILE\.zig-0.16.0\zig.exe"

Write-Host "`n=== ACTUALIZADOR DE HERDR EN ESPAÑOL ===" -ForegroundColor Cyan

# 1. Detectar versión oficial instalada
$dirOficial = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -notmatch '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1

if (-not $dirOficial) {
    Write-Error "No se encontró ningún paquete oficial de Herdr en '$releasesDir'."
    return
}

$nombreOficial = $dirOficial.Name # Ej: 0.9.5-x86_64-pc-windows-msvc
$versionMatch = [regex]::Match($nombreOficial, '^([0-9]+\.[0-9]+\.[0-9]+)')
if (-not $versionMatch.Success) {
    Write-Error "No se pudo determinar el número de versión desde '$nombreOficial'."
    return
}
$version = $versionMatch.Groups[1].Value
Write-Host "Versión oficial detectada: " -NoNewline
Write-Host "$version ($nombreOficial)" -ForegroundColor Green

# Carpeta destino para la versión en español
$nombreEspanol = "$version-espanol-x86_64-pc-windows-msvc"
$dirEspanol = Join-Path $releasesDir $nombreEspanol

# 2. Respaldar binario oficial si aún no se hizo
$binOficial = Join-Path $dirOficial.FullName "herdr.exe"
$binBackup = Join-Path $dirOficial.FullName "herdr-original.exe"
if ((Test-Path $binOficial) -and (-not (Test-Path $binBackup))) {
    Copy-Item $binOficial $binBackup -Force
    Write-Host "[Backup] Binario original respaldado en: herdr-original.exe" -ForegroundColor DarkGray
}

if ($CheckOnly) {
    Write-Host "Comprobación finalizada." -ForegroundColor Cyan
    return
}

# 3. Asegurar carpeta en español
if (-not (Test-Path $dirEspanol)) {
    New-Item -ItemType Directory -Path $dirEspanol -Force | Out-Null
}

# Copiar dependencias críticas de terminal (conpty, etc.)
if (Test-Path (Join-Path $dirOficial.FullName "conpty")) {
    Copy-Item (Join-Path $dirOficial.FullName "conpty") (Join-Path $dirEspanol "conpty") -Recurse -Force
}
if (Test-Path (Join-Path $dirOficial.FullName "THIRD-PARTY-NOTICES")) {
    Copy-Item (Join-Path $dirOficial.FullName "THIRD-PARTY-NOTICES") (Join-Path $dirEspanol "THIRD-PARTY-NOTICES") -Recurse -Force
}

$binEspanolDestino = Join-Path $dirEspanol "herdr.exe"
$descargadoConExito = $false

# 4. Intentar descarga rápida desde Releases de GitHub si no se pide ForceRebuild
if (-not $ForceRebuild) {
    $urlRelease = "https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v$version-espanol/herdr-es.exe"
    Write-Host "Buscando binario en español precompilado en GitHub ($urlRelease)..." -ForegroundColor Gray
    try {
        $tempFile = Join-Path $env:TEMP "herdr-es-$version.exe"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        Invoke-WebRequest -Uri $urlRelease -OutFile $tempFile -UseBasicParsing -TimeoutSec 30
        if ((Test-Path $tempFile) -and ((Get-Item $tempFile).Length -gt 10000000)) {
            Copy-Item $tempFile $binEspanolDestino -Force
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            $descargadoConExito = $true
            Write-Host "[OK] Binario en español descargado e instalado correctamente." -ForegroundColor Green
        }
    } catch {
        Write-Host "No se encontró release remoto para v$version-espanol. Procediendo con compilación local..." -ForegroundColor Yellow
    }
}

# 5. Compilación local si no se pudo descargar
if (-not $descargadoConExito) {
    if (-not (Test-Path $srcDir)) {
        Write-Error "No se encontró el directorio de código fuente en '$srcDir'."
        return
    }
    if (-not (Test-Path $zigExe)) {
        Write-Error "No se encontró el compilador Zig 0.16.0 en '$zigExe'."
        return
    }

    Write-Host "Compilando localmente con Zig 0.16.0 y Cargo (esto toma aprox. 1-2 min)..." -ForegroundColor Cyan
    $env:PATH = "C:\Users\Rocka\.zig-0.16.0;$env:PATH"

    # Recompilar en modo release
    $buildCmd = "cargo build --release --bin herdr"
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c cd /d `"$srcDir`" && $buildCmd" -NoNewWindow -Wait -PassThru

    if ($process.ExitCode -ne 0) {
        Write-Error "La compilación de Herdr en español falló con código $($process.ExitCode)."
        return
    }

    $binCompilado = Join-Path $srcDir "target\release\herdr.exe"
    if (Test-Path $binCompilado) {
        Copy-Item $binCompilado $binEspanolDestino -Force
        Write-Host "[OK] Compilación exitosa e instalada en: $binEspanolDestino" -ForegroundColor Green
    } else {
        Write-Error "No se encontró el archivo compilado en '$binCompilado'."
        return
    }
}

# 6. Actualizar enlace 'current' a la versión en español
if (Test-Path $currentLink) {
    cmd /c rmdir "$currentLink" 2>$null
}
New-Item -ItemType Junction -Path $currentLink -Target $dirEspanol | Out-Null

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host " ¡Herdr v$version está 100% actualizado y en Español!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host "Comando activo: herdr (apunta a $nombreEspanol)" -ForegroundColor DarkGray
Write-Host "Para volver al inglés en cualquier momento: herdr-idioma en`n" -ForegroundColor Cyan

Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "⭐ ¿Te gusta este proyecto? Danos una estrella en GitHub:" -ForegroundColor Yellow
Write-Host "   https://github.com/quijotevitruvio/HerdrSpanis" -ForegroundColor White
Write-Host "☕ ¿Quieres apoyar el desarrollo y mantenimiento?" -ForegroundColor Yellow
Write-Host "   Dona en PayPal: https://paypal.me/bibliotecologo" -ForegroundColor Cyan
Write-Host "────────────────────────────────────────────────────────────`n" -ForegroundColor DarkGray
