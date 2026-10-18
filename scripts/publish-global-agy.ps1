# Publica el harness de PlantillaAntiGravity como plugin global de Antigravity CLI en ~/.gemini/config/plugins/antigravity-harness
param(
    [switch]$DryRun,
    [string]$TargetPluginDir = "$env:USERPROFILE\.gemini\config\plugins\antigravity-harness"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

# Ejecuta primero el guardarrail de presupuesto en modo fail-closed antes de publicar al entorno global
Write-Host "1. Verificando guardarrail de presupuesto..."
& (Join-Path $PSScriptRoot "harness-budget.ps1") -Root $Root
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: El guardarrail fallo. Se aborta la publicacion global."
    exit 1
}

$srcAgents = Join-Path $Root ".agents\agents"
$srcSkills = Join-Path $Root ".agents\skills"
$srcHooksJson = Join-Path $Root ".agents\hooks.json"
$srcAgentsMd = Join-Path $Root "AGENTS.md"
$srcGeminiMd = Join-Path $Root "GEMINI.md"

$agentFiles = @(Get-ChildItem -LiteralPath $srcAgents -File -Filter *.md)
$skillFiles = @(Get-ChildItem -LiteralPath $srcSkills -Recurse -File)

if ($DryRun) {
    Write-Host "[DRY-RUN] Publicaria en: $TargetPluginDir"
    Write-Host ("[DRY-RUN] Subagentes: " + $agentFiles.Count + " archivos .md")
    Write-Host ("[DRY-RUN] Skills: " + $skillFiles.Count + " archivos en total")
    Write-Host "[DRY-RUN] Reglas: rules/AGENTS.md + rules/GEMINI.md + hooks.json + plugin.json"
    exit 0
}

# Recrea los subdirectorios de agentes, skills, reglas y hooks para evitar archivos huerfanos
foreach ($sub in @("agents", "skills", "rules", "hooks")) {
    $subPath = Join-Path $TargetPluginDir $sub
    if (Test-Path -LiteralPath $subPath) {
        Remove-Item -LiteralPath $subPath -Recurse -Force
    }
    [void](New-Item -ItemType Directory -Path $subPath -Force)
}

# Escribe el manifiesto plugin.json siguiendo el esquema estricto de Antigravity CLI (sin claves no soportadas)
$manifest = @"
{
  "name": "antigravity-harness",
  "displayName": "Antigravity Harness",
  "description": "Harness de ingenieria con 6 subagentes especializados, GEMINI.md de orquestacion, 38 skills bajo demanda y Lifecycle Hooks.",
  "version": "1.0.0"
}
"@ -replace "`r`n", "`n"
[System.IO.File]::WriteAllText((Join-Path $TargetPluginDir "plugin.json"), $manifest, $utf8NoBom)

# Copia los 6 subagentes preservando saltos de linea LF y codificacion UTF-8 sin BOM
foreach ($af in $agentFiles) {
    $dest = Join-Path $TargetPluginDir ("agents\" + $af.Name)
    $content = [System.IO.File]::ReadAllText($af.FullName, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($dest, $content, $utf8NoBom)
}

# Copia las 38 skills y sus subdirectorios references/ preservando LF y UTF-8 sin BOM
foreach ($sf in $skillFiles) {
    $rel = $sf.FullName.Substring($srcSkills.Length).TrimStart('\')
    $dest = Join-Path $TargetPluginDir ("skills\" + $rel)
    $destParent = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $destParent)) {
        [void](New-Item -ItemType Directory -Path $destParent -Force)
    }
    $content = [System.IO.File]::ReadAllText($sf.FullName, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($dest, $content, $utf8NoBom)
}

# Copia AGENTS.md y GEMINI.md a rules/ y hooks.json a la raiz del plugin
$rulesContent = [System.IO.File]::ReadAllText($srcAgentsMd, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
[System.IO.File]::WriteAllText((Join-Path $TargetPluginDir "rules\AGENTS.md"), $rulesContent, $utf8NoBom)

$geminiContent = [System.IO.File]::ReadAllText($srcGeminiMd, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
[System.IO.File]::WriteAllText((Join-Path $TargetPluginDir "rules\GEMINI.md"), $geminiContent, $utf8NoBom)

$hooksContent = [System.IO.File]::ReadAllText($srcHooksJson, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
[System.IO.File]::WriteAllText((Join-Path $TargetPluginDir "hooks.json"), $hooksContent, $utf8NoBom)

# Copia los scripts de hooks/*.ps1 al subdirectorio hooks/ del plugin preservando LF y UTF-8 sin BOM
$srcHooksDir = Join-Path $Root ".agents\hooks"
if (Test-Path -LiteralPath $srcHooksDir) {
    Get-ChildItem -LiteralPath $srcHooksDir -File | ForEach-Object {
        $destHook = Join-Path $TargetPluginDir ("hooks\" + $_.Name)
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.Encoding]::UTF8) -replace "`r`n", "`n"
        [System.IO.File]::WriteAllText($destHook, $content, $utf8NoBom)
    }
}

Write-Host ("Publicado OK en: " + $TargetPluginDir + " | subagentes=" + $agentFiles.Count + " | reglas=AGENTS.md+GEMINI.md | archivos de skills=" + $skillFiles.Count + " | hooks sincronizados")
exit 0
