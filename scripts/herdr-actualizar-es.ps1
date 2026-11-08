<#
.SYNOPSIS
    Actualiza Herdr y aplica/sincroniza automáticamente la traducción al Español.
.DESCRIPTION
    1. Detecta la versión oficial de Herdr instalada en el sistema.
    2. Asegura que el binario oficial quede respaldado como 'herdr-original.exe'.
    3. Descarga o compila automáticamente la versión en español correspondiente (sin rutas fijas).
    4. Copia las dependencias de ConPTY y actualiza el enlace 'current' sin romper la instalación oficial.
.PARAMETER ForceRebuild
    Fuerza la compilación local desde código fuente en lugar de descargar el binario precompilado.
.PARAMETER CheckOnly
    Solo verifica el estado de las versiones sin aplicar cambios.
.EXAMPLE
    herdr-actualizar-es
    herdr-actualizar-es -CheckOnly
    herdr-actualizar-es -ForceRebuild
#>

[CmdletBinding()]
param(
    [switch]$ForceRebuild,
    [switch]$CheckOnly
)

$ErrorActionPreference = 'Stop'
$standaloneDir = Join-Path $env:USERPROFILE ".herdr\packages\standalone"
$releasesDir = Join-Path $standaloneDir "releases"
$currentLink = Join-Path $standaloneDir "current"

Write-Host "`n=== ACTUALIZADOR DE HERDR EN ESPAÑOL ===" -ForegroundColor Cyan

# 1. Detectar versión oficial instalada
if (-not (Test-Path $releasesDir)) {
    Write-Error "No se encontró el directorio de instalaciones de Herdr en '$releasesDir'. Asegúrate de tener Herdr instalado."
    return
}

$dirOficial = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -notmatch '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1

if (-not $dirOficial) {
    Write-Error "No se encontró ningún paquete oficial de Herdr en '$releasesDir'."
    return
}

$nombreOficial = $dirOficial.Name # Ej: 0.9.5-x86_64-pc-windows-msvc
$versionMatch = [regex]::Match($nombreOficial, '^([0-9]+\.[0-9]+(\.[0-9]+)?)')
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
    Write-Host "Comprobación finalizada. Estado actual: listo para actualizar." -ForegroundColor Cyan
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

# 4. Descarga rápida desde Releases de GitHub si no se fuerza rebuild
if (-not $ForceRebuild) {
    $urlsAProbar = @(
        "https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v$version-espanol/herdr-es.exe",
        "https://github.com/quijotevitruvio/HerdrSpanis/releases/latest/download/herdr-es.exe"
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
    $tempFile = Join-Path $env:TEMP "herdr-es-$version-$([System.Guid]::NewGuid().ToString('N').Substring(0,8)).exe"

    foreach ($urlRelease in $urlsAProbar) {
        Write-Host "Buscando binario en español en GitHub ($urlRelease)..." -ForegroundColor Gray
        try {
            Invoke-WebRequest -Uri $urlRelease -OutFile $tempFile -UseBasicParsing -TimeoutSec 45
            if ((Test-Path $tempFile) -and ((Get-Item $tempFile).Length -gt 10000000)) {
                Copy-Item $tempFile $binEspanolDestino -Force
                Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
                $descargadoConExito = $true
                Write-Host "[OK] Binario en español descargado e instalado correctamente." -ForegroundColor Green
                break
            }
        } catch {
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
        }
    }

    if (-not $descargadoConExito) {
        Write-Host "No se encontró release binario precompilado en GitHub. Procediendo con búsqueda/compilación local..." -ForegroundColor Yellow
    }
}

# 5. Compilación local dinámica si no se pudo descargar o se especificó -ForceRebuild
if (-not $descargadoConExito) {
    # 5.1 Resolver dinámicamente directorio de código fuente
    $srcDir = if ($env:HERDR_SRC_DIR -and (Test-Path $env:HERDR_SRC_DIR)) {
        $env:HERDR_SRC_DIR
    } elseif (Test-Path (Join-Path $PSScriptRoot "..\..\herdr-src")) {
        (Resolve-Path (Join-Path $PSScriptRoot "..\..\herdr-src")).Path
    } elseif (Test-Path (Join-Path $env:TEMP "herdr-src")) {
        Join-Path $env:TEMP "herdr-src"
    } else {
        $tempSrc = Join-Path $env:TEMP "herdr-src"
        Write-Host "Directorio fuente no encontrado. Clonando repositorio oficial de Herdr en $tempSrc..." -ForegroundColor Cyan
        git clone --depth 1 https://github.com/herdr-dev/herdr.git $tempSrc
        $tempSrc
    }

    # 5.2 Resolver dinámicamente el compilador Zig
    $zigExe = if (Get-Command "zig" -ErrorAction SilentlyContinue) {
        (Get-Command "zig").Source
    } else {
        $foundZig = $null
        $zigCandidates = @()
        $zigCandidates += Get-ChildItem -Path $env:USERPROFILE -Directory -Filter ".zig-*" -ErrorAction SilentlyContinue | ForEach-Object { Join-Path $_.FullName "zig.exe" }
        $zigCandidates += "$env:USERPROFILE\scoop\apps\zig\current\zig.exe"
        $zigCandidates += "C:\tools\zig\zig.exe"
        $zigCandidates += "C:\zig\zig.exe"

        foreach ($cand in $zigCandidates) {
            if (Test-Path $cand) {
                $foundZig = $cand
                break
            }
        }
        $foundZig
    }

    if (-not $zigExe -or (-not (Test-Path $zigExe))) {
        Write-Error "No se encontró el compilador Zig en el sistema ni en PATH. Instala Zig o agrega su ruta a PATH."
        return
    }

    $zigDir = Split-Path $zigExe -Parent
    $env:PATH = "$zigDir;$env:PATH"

    Write-Host "Compilando localmente con Zig ($zigExe) y Cargo..." -ForegroundColor Cyan
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
