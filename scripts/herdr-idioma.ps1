<#
.SYNOPSIS
    Cambia instantáneamente el idioma de Herdr entre Español (Nativo) e Inglés (Oficial Upstream).
.DESCRIPTION
    Alterna el enlace 'current' del paquete standalone de Herdr para apuntar a la versión
    oficial original o a la versión optimizada en español.
.EXAMPLE
    herdr-idioma es
    herdr-idioma en
    herdr-idioma
#>

param(
    [ValidateSet('es', 'en', 'estado', 'status')]
    [string]$Idioma
)

$ErrorActionPreference = 'Stop'
$standaloneDir = "$env:USERPROFILE\.herdr\packages\standalone"
$currentLink = "$standaloneDir\current"
$releasesDir = "$standaloneDir\releases"

if (-not (Test-Path $releasesDir)) {
    Write-Error "No se encontró el directorio de versiones de Herdr en '$releasesDir'."
    return
}

# Obtener directorio oficial (sin -espanol) y directorio en español
$dirOficial = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -notmatch '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1
$dirEspanol = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -match '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1

# Detectar estado actual
$estadoActual = "Desconocido"
if (Test-Path $currentLink) {
    $currentTarget = (Get-Item $currentLink).Target
    if ($currentTarget -is [array]) { $currentTarget = $currentTarget[0] }
    if ($currentTarget -match '-espanol') {
        $estadoActual = "Español (Nativo traducido)"
    } else {
        $estadoActual = "Inglés (Oficial original)"
    }
}

if (-not $Idioma -or $Idioma -in @('estado', 'status')) {
    Write-Host "`n=== ESTADO DE IDIOMA EN HERDR ===" -ForegroundColor Cyan
    Write-Host "Idioma actual activo: " -NoNewline
    if ($estadoActual -match 'Español') {
        Write-Host "$estadoActual" -ForegroundColor Green
    } else {
        Write-Host "$estadoActual" -ForegroundColor Yellow
    }
    Write-Host "Destino de 'current': $currentTarget" -ForegroundColor DarkGray
    Write-Host "`nPara cambiar de idioma escribe:" -ForegroundColor Gray
    Write-Host "  herdr-idioma es   -> Cambiar a Español (100% traducido)" -ForegroundColor White
    Write-Host "  herdr-idioma en   -> Cambiar a Inglés (Oficial de fábrica)`n" -ForegroundColor White
    return
}

if ($Idioma -eq 'es') {
    if (-not $dirEspanol) {
        Write-Error "No se encontró ninguna versión en español instalada en '$releasesDir'. Ejecuta 'herdr-actualizar-es' para generarla."
        return
    }
    if (Test-Path $currentLink) {
        cmd /c rmdir "$currentLink" 2>$null
    }
    New-Item -ItemType Junction -Path $currentLink -Target $dirEspanol.FullName | Out-Null
    Write-Host "`n[OK] Herdr ha sido configurado en ESPAÑOL." -ForegroundColor Green
    Write-Host "Versión activa: $($dirEspanol.Name)" -ForegroundColor DarkGray
    Write-Host "Reinicia tu terminal de Herdr para ver los cambios.`n" -ForegroundColor Cyan
}
elseif ($Idioma -eq 'en') {
    if (-not $dirOficial) {
        Write-Error "No se encontró ninguna versión oficial instalada en '$releasesDir'."
        return
    }
    if (Test-Path $currentLink) {
        cmd /c rmdir "$currentLink" 2>$null
    }
    New-Item -ItemType Junction -Path $currentLink -Target $dirOficial.FullName | Out-Null
    Write-Host "`n[OK] Herdr ha sido restaurado al INGLÉS OFICIAL." -ForegroundColor Yellow
    Write-Host "Versión activa: $($dirOficial.Name)" -ForegroundColor DarkGray
    Write-Host "Reinicia tu terminal de Herdr para ver los cambios.`n" -ForegroundColor Cyan
}
