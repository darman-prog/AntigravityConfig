<#
.SYNOPSIS
    Captura automática de vistas en viewport escritorio y móvil para auditoría visual Anti-Slop.
.DESCRIPTION
    Utiliza Playwright headless para generar capturas estandarizadas en modo oscuro (High-Craft)
    tanto para desktop (1440x900) como para mobile (390x844), facilitando la verificación visual.
.PARAMETER Target
    URL HTTP/HTTPS o ruta absoluta/relativa a un archivo HTML local.
.PARAMETER Name
    Nombre base para identificar las capturas generadas.
.PARAMETER OutputDir
    Directorio destino donde se almacenarán las imágenes (ignorado en git).
.PARAMETER FullPage
    Indica si debe capturarse el scroll completo de la página.
.PARAMETER CopyArtifact
    Copia las capturas al directorio de artefactos de la sesión activa para su previsualización.
.PARAMETER WhatIf
    Muestra la simulación de las capturas sin ejecutar Playwright.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Target,

    [Parameter(Position = 1)]
    [string]$Name = "view",

    [string]$OutputDir = ".visual-audit",

    [switch]$FullPage,

    [switch]$CopyArtifact,

    [string]$ArtifactDir = "",

    [string]$Channel = "msedge"
)

$ErrorActionPreference = "Stop"

# Aseguramos que la salida en consola use codificación UTF-8 pura sin BOM
try {
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = $utf8
    $OutputEncoding = $utf8
} catch { }

# Si se pasa una ruta local, verificamos su existencia y convertimos a formato URI de archivo
if (-not ($Target -match "^https?://")) {
    if (-not (Test-Path -LiteralPath $Target)) {
        Write-Error "El archivo o ruta local especificada no existe: $Target"
        exit 1
    }
    $resolvedPath = (Resolve-Path -LiteralPath $Target).Path.Replace('\', '/')
    $Target = "file:///$resolvedPath"
}

# Resolvemos la ruta absoluta del directorio de salida para almacenar las imágenes
$fullOutputDir = Join-Path (Get-Location).Path $OutputDir
if (-not (Test-Path -LiteralPath $fullOutputDir)) {
    # Creamos el directorio si no existe previamente
    New-Item -ItemType Directory -Path $fullOutputDir -Force | Out-Null
}

$desktopFile = Join-Path $fullOutputDir "desktop-$Name.png"
$mobileFile  = Join-Path $fullOutputDir "mobile-$Name.png"

# Argumentos base para ejecutar capturas en modo oscuro según el estándar High-Craft
$baseArgs = @(
    "playwright", "screenshot",
    "--color-scheme", "dark",
    "--wait-for-timeout", "1000"
)

if ($Channel) {
    # Usamos el canal especificado (msedge por defecto en Windows) para evitar descargas
    $baseArgs += @("--channel", $Channel)
}

if ($FullPage) {
    # Añadimos bandera de captura de página completa si se solicitó
    $baseArgs += "--full-page"
}

# Comando de simulación en caso de ejecutar con WhatIf
if ($PSCmdlet.ShouldProcess($Target, "Capturar vistas desktop (1440x900) y mobile (390x844)")) {
    Write-Host "Iniciando captura visual de: $Target"
    
    # 1. Captura en resolución Desktop (1440x900)
    Write-Host "  -> Capturando Desktop (1440x900)..."
    $desktopArgs = $baseArgs + @("--viewport-size", "1440, 900", $Target, $desktopFile)
    & npx $desktopArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error ejecutando captura de escritorio con Playwright."
        exit $LASTEXITCODE
    }

    # 2. Captura en resolución Mobile (390x844 - iPhone 13/14 estándar)
    Write-Host "  -> Capturando Mobile (390x844)..."
    $mobileArgs = $baseArgs + @("--viewport-size", "390, 844", $Target, $mobileFile)
    & npx $mobileArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Error ejecutando captura móvil con Playwright."
        exit $LASTEXITCODE
    }

    # Verificamos los archivos creados y mostramos resumen de tamaños
    $dInfo = Get-Item -LiteralPath $desktopFile
    $mInfo = Get-Item -LiteralPath $mobileFile

    Write-Host "`nCapturas generadas con exito:"
    Write-Host "  [Desktop] $($dInfo.FullName) ($([math]::Round($dInfo.Length / 1KB, 1)) KB)"
    Write-Host "  [Mobile]  $($mInfo.FullName) ($([math]::Round($mInfo.Length / 1KB, 1)) KB)"

    # Copiamos al directorio de artefactos si se requirió para el chat o reporte
    if ($CopyArtifact) {
        if (-not $ArtifactDir) {
            # Intentamos detectar la conversación más reciente en el almacenamiento local de Antigravity
            $brainRoot = Join-Path $env:USERPROFILE ".gemini\antigravity-cli\brain"
            if (Test-Path -LiteralPath $brainRoot) {
                $latest = Get-ChildItem -LiteralPath $brainRoot -Directory | 
                    Sort-Object LastWriteTime -Descending | 
                    Select-Object -First 1
                if ($latest) { $ArtifactDir = $latest.FullName }
            }
        }

        if ($ArtifactDir -and (Test-Path -LiteralPath $ArtifactDir)) {
            Copy-Item -LiteralPath $desktopFile -Destination (Join-Path $ArtifactDir "desktop-$Name.png") -Force
            Copy-Item -LiteralPath $mobileFile -Destination (Join-Path $ArtifactDir "mobile-$Name.png") -Force
            Write-Host "  [Artifacts] Copiadas al directorio de artefactos: $ArtifactDir"
        }
    }
}
