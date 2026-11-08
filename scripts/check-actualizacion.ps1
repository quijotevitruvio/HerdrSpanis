<#
.SYNOPSIS
    Comprobador de actualizaciones para Herdr en Español (HerdrSpanis).
.DESCRIPTION
    Consulta periódicamente la API pública de GitHub para detectar nuevas versiones.
    Utiliza un caché local con TTL de 24 horas para no ralentizar el inicio de Herdr
    ni agotar la cuota de peticiones.
.PARAMETER Silent
    Suprime cualquier salida por consola. Devuelve código de salida 1 si hay actualización o 0 si está al día.
.PARAMETER CheckOnly
    Fuerza comprobación explícita e informa tanto si hay actualización como si está al día.
.PARAMETER ForceCheck
    Ignora el caché local de 24 horas y consulta directamente a GitHub.
.EXAMPLE
    check-actualizacion.ps1
    check-actualizacion.ps1 -CheckOnly
    check-actualizacion.ps1 -Silent
#>

[CmdletBinding()]
param(
    [switch]$Silent,
    [switch]$CheckOnly,
    [switch]$ForceCheck
)

$ErrorActionPreference = 'SilentlyContinue'

# Versión local del plugin
$VersionPlugin = "0.3.0"
$RepoOwner = "quijotevitruvio"
$RepoName = "HerdrSpanis"
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"

$cacheDir = Join-Path $env:USERPROFILE ".herdr\cache"
$cacheFile = Join-Path $cacheDir "last-update-check.json"
$cacheTtlSeconds = 86400 # 24 horas

# Detectar versión del binario de Herdr instalado
$localHerdrVersion = $null
$releasesDir = Join-Path $env:USERPROFILE ".herdr\packages\standalone\releases"
if (Test-Path $releasesDir) {
    $dirEspanol = Get-ChildItem -Directory $releasesDir | Where-Object { $_.Name -match '-espanol' } | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $dirEspanol) {
        $dirEspanol = Get-ChildItem -Directory $releasesDir | Sort-Object Name -Descending | Select-Object -First 1
    }
    if ($dirEspanol -and ($dirEspanol.Name -match '^([0-9]+\.[0-9]+(\.[0-9]+)?)')) {
        $localHerdrVersion = $matches[1]
    }
}

function Compare-SemVer ($vLocal, $vRemote) {
    if (-not $vLocal -or -not $vRemote) { return $false }
    $cleanLocal = (($vLocal -replace '^[vV]', '') -split '-')[0]
    $cleanRemote = (($vRemote -replace '^[vV]', '') -split '-')[0]
    try {
        $parsedLocal = [version]$cleanLocal
        $parsedRemote = [version]$cleanRemote
        return $parsedRemote -gt $parsedLocal
    } catch {
        $partsL = $cleanLocal.Split('.') | ForEach-Object { [int]($_ -replace '\D', '0') }
        $partsR = $cleanRemote.Split('.') | ForEach-Object { [int]($_ -replace '\D', '0') }
        for ($i = 0; $i -lt [Math]::Max($partsL.Count, $partsR.Count); $i++) {
            $l = if ($i -lt $partsL.Count) { $partsL[$i] } else { 0 }
            $r = if ($i -lt $partsR.Count) { $partsR[$i] } else { 0 }
            if ($r -gt $l) { return $true }
            if ($r -lt $l) { return $false }
        }
        return $false
    }
}

function Show-UpdateBanner ($vNueva) {
    $tagMostrar = if ($vNueva.StartsWith("v")) { $vNueva } else { "v$vNueva" }
    $txt1 = "📢 NUEVA ACTUALIZACIÓN DE HERDR EN ESPAÑOL DISPONIBLE ($tagMostrar)"
    $txt2 = "Ejecuta 'herdr-actualizar-es' para actualizar al instante"
    
    # Ajustar caja a 61 caracteres internos
    $len1 = [Math]::Max(0, 59 - $txt1.Length)
    $pad1 = ' ' * $len1
    $len2 = [Math]::Max(0, 59 - $txt2.Length)
    $pad2 = ' ' * $len2

    Write-Host ""
    Write-Host "╭─────────────────────────────────────────────────────────────╮" -ForegroundColor Yellow
    Write-Host "│ $txt1$pad1 │" -ForegroundColor Yellow
    Write-Host "│ $txt2$pad2 │" -ForegroundColor Cyan
    Write-Host "╰─────────────────────────────────────────────────────────────╯" -ForegroundColor Yellow
    Write-Host ""
}

$debeConsultar = $true
$cachedData = $null

if (-not $ForceCheck -and (Test-Path $cacheFile)) {
    try {
        $cachedJson = Get-Content $cacheFile -Raw | ConvertFrom-Json
        $tiempoTranscurrido = (Get-Date) - (Get-Date $cachedJson.last_check)
        if ($tiempoTranscurrido.TotalSeconds -lt $cacheTtlSeconds) {
            $debeConsultar = $false
            $cachedData = $cachedJson
        }
    } catch {
        $debeConsultar = $true
    }
}

$latestTag = $null
$htmlUrl = ""

if ($debeConsultar) {
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13
        $headers = @{
            "User-Agent" = "HerdrSpanis-CheckActualizacion/$VersionPlugin"
            "Accept"     = "application/vnd.github.v3+json"
        }
        $response = Invoke-RestMethod -Uri $ApiUrl -Headers $headers -TimeoutSec 4 -ErrorAction Stop
        if ($response -and $response.tag_name) {
            $latestTag = $response.tag_name
            $htmlUrl = $response.html_url

            if (-not (Test-Path $cacheDir)) {
                New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
            }

            $cacheObj = @{
                last_check     = (Get-Date).ToString("o")
                latest_tag     = $latestTag
                html_url       = $htmlUrl
                published_at   = $response.published_at
            }
            $cacheObj | ConvertTo-Json | Set-Content -Path $cacheFile -Force
        }
    } catch {
        if ($cachedData -and $cachedData.latest_tag) {
            $latestTag = $cachedData.latest_tag
            $htmlUrl = $cachedData.html_url
        }
    }
} elseif ($cachedData) {
    $latestTag = $cachedData.latest_tag
    $htmlUrl = $cachedData.html_url
}

$hayActualizacion = $false
if ($latestTag) {
    if ($latestTag -match '-espanol' -and $localHerdrVersion) {
        # Si la release remota es de binario Herdr (ej: v0.9.5-espanol), comparar con binario instalado
        $hayActualizacion = Compare-SemVer -vLocal $localHerdrVersion -vRemote $latestTag
    } else {
        # Si la release es del plugin o no tiene binario específico, comparar con versión de plugin
        $hayActualizacion = Compare-SemVer -vLocal $VersionPlugin -vRemote $latestTag
    }
}

if ($Silent) {
    if ($hayActualizacion) { exit 1 } else { exit 0 }
}

if ($hayActualizacion) {
    Show-UpdateBanner -vNueva $latestTag
} elseif ($CheckOnly) {
    Write-Host "`n[HerdrSpanis] Versión local del plugin: v$VersionPlugin" -ForegroundColor Green
    if ($localHerdrVersion) {
        Write-Host "[HerdrSpanis] Versión de Herdr instalada: v$localHerdrVersion" -ForegroundColor Gray
    }
    if ($latestTag) {
        Write-Host "[HerdrSpanis] Última versión en GitHub: $latestTag" -ForegroundColor Gray
    }
    Write-Host "[HerdrSpanis] ¡Tu instalación de Herdr en Español está al día!`n" -ForegroundColor Green
}
