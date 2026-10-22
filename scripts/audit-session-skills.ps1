# Audita que las skills declaradas en el chat hayan sido realmente leidas con view_file en el transcript de la sesion
# y valida que el protocolo de badges [SKILL] se use de forma correcta y exclusiva
param(
    [string]$ConversationId = "",
    [string]$BrainRoot = "$env:USERPROFILE\.gemini\antigravity-cli\brain"
)

$ErrorActionPreference = "Stop"

try {
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = $utf8
    $OutputEncoding = $utf8
} catch { }

if (-not (Test-Path -LiteralPath $BrainRoot)) {
    Write-Host "ERROR: No existe el directorio de sesiones en $BrainRoot"
    exit 1
}

# Selecciona la conversacion indicada o busca automaticamente la sesion con el transcript mas reciente
$transcriptFile = $null
if ($ConversationId) {
    $cand = Join-Path $BrainRoot "$ConversationId\.system_generated\logs\transcript.jsonl"
    if (Test-Path -LiteralPath $cand) { $transcriptFile = Get-Item -LiteralPath $cand }
} else {
    $transcriptFile = Get-ChildItem -LiteralPath $BrainRoot -Directory -ErrorAction SilentlyContinue |
        ForEach-Object {
            $p = Join-Path $_.FullName ".system_generated\logs\transcript.jsonl"
            if (Test-Path -LiteralPath $p) { Get-Item -LiteralPath $p }
        } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

if ($null -eq $transcriptFile) {
    Write-Host "ERROR: No se encontro ningun archivo transcript.jsonl para auditar."
    exit 1
}

$convDir = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $transcriptFile.FullName))
$convId = Split-Path -Leaf $convDir

$readSkills = @{}
$declaredSkills = @{}
$badgeAlerts = @()
$badgeMisuse = @()

# Recorre cada evento JSONL para cruzar lecturas fisicas (view_file / slash command) contra declaraciones en texto
foreach ($line in [System.IO.File]::ReadLines($transcriptFile.FullName, [System.Text.Encoding]::UTF8)) {
    if (-not $line.Trim()) { continue }
    $step = $null
    try { $step = $line | ConvertFrom-Json } catch { continue }
    if ($null -eq $step) { continue }

    $idx = $step.step_index

    # Detecta skills inyectadas por comando slash explicito del usuario
    if ($step.type -eq "USER_INPUT" -and $step.content) {
        foreach ($m in [regex]::Matches([string]$step.content, '<SKILL>The user has explicitly invoked the \(([^)]+)\) skill')) {
            $sName = ($m.Groups[1].Value.Trim() -replace '_', '-')
            if (-not $readSkills.ContainsKey($sName)) {
                $readSkills[$sName] = [pscustomobject]@{ Count = 0; Steps = @(); LastAction = "slash_command"; BadgeOk = $true }
            }
            $readSkills[$sName].Count++
            $readSkills[$sName].Steps += $idx
        }
    }

    if ($step.type -eq "PLANNER_RESPONSE") {
        # Extrae y valida llamadas de herramientas para auditar lectura de SKILL.md y cumplimiento de badges
        if ($step.tool_calls) {
            foreach ($tc in $step.tool_calls) {
                $act = if ($tc.args.toolAction) { ([string]$tc.args.toolAction).Trim('"') } else { "" }
                
                # Valida si la herramienta es view_file sobre un archivo de skill
                if ($tc.name -eq "view_file" -and $tc.args -and $tc.args.AbsolutePath) {
                    $rawPath = [string]$tc.args.AbsolutePath
                    if ($rawPath -match '[\\/]+skills[\\/]+([^\\/"]+)[\\/]+SKILL\.md') {
                        # Normaliza guion bajo a guion medio para builtin skills como antigravity_guide -> antigravity-guide
                        $sName = ($Matches[1] -replace '_', '-')
                        $hasBadge = ($act -match '^\[SKILL\]')
                        if (-not $readSkills.ContainsKey($sName)) {
                            $readSkills[$sName] = [pscustomobject]@{ Count = 0; Steps = @(); LastAction = $act; BadgeOk = $hasBadge }
                        }
                        $readSkills[$sName].Count++
                        $readSkills[$sName].Steps += $idx
                        if ($act) { 
                            $readSkills[$sName].LastAction = $act 
                            if (-not $hasBadge) { $readSkills[$sName].BadgeOk = $false }
                        }
                        if (-not $hasBadge) {
                            $badgeAlerts += "Step $($idx): lectura de skill '$sName' sin badge [SKILL] (toolAction: '$act')"
                        }
                    } else {
                        # Advierte si se usa el badge [SKILL] en un view_file que no apunta a SKILL.md
                        if ($act -match '^\[SKILL\]') {
                            $badgeMisuse += "Step $($idx): badge [SKILL] usado en archivo no-skill: '$rawPath'"
                        }
                    }
                } else {
                    # Advierte si una herramienta distinta a view_file utiliza indebidamente el badge [SKILL]
                    if ($act -match '^\[SKILL\]') {
                        $badgeMisuse += "Step $($idx): badge [SKILL] usado indebidamente en tool '$($tc.name)'"
                    }
                }
            }
        }

        # Extrae las declaraciones "Skills: ..." emitidas por el agente al inicio de su respuesta
        if ($step.content) {
            $rootRepo = Split-Path -Parent $PSScriptRoot
            $knownSkills = @(Get-ChildItem -Path (Join-Path $rootRepo ".agents\skills") -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.Name }) + @('antigravity-guide', 'agy-customizations', 'android-cli', 'plugin', 'run-workflow', 'modern-web-guidance')
            foreach ($m in [regex]::Matches([string]$step.content, '(?m)^Skills:\s*(.+)$')) {
                $declLine = $m.Groups[1].Value
                foreach ($sm in [regex]::Matches($declLine, '`([a-z0-9][a-z0-9-]*)`')) {
                    $dName = $sm.Groups[1].Value
                    if ($knownSkills -notcontains $dName) { continue }
                    if (-not $declaredSkills.ContainsKey($dName)) {
                        $declaredSkills[$dName] = [pscustomobject]@{ Count = 0; Steps = @() }
                    }
                    $declaredSkills[$dName].Count++
                    $declaredSkills[$dName].Steps += $idx
                }
            }
        }
    }
}

$allNames = @(($readSkills.Keys + $declaredSkills.Keys) | Sort-Object -Unique)
Write-Host "=== Auditoria de Skills y Badges en Sesion ($convId) ==="
Write-Host ("Transcript: " + $transcriptFile.FullName)
Write-Host ""

$fakeLoads = @()
$rows = foreach ($name in $allNames) {
    $r = if ($readSkills.ContainsKey($name)) { $readSkills[$name] } else { $null }
    $d = if ($declaredSkills.ContainsKey($name)) { $declaredSkills[$name] } else { $null }
    $rCount = if ($r) { $r.Count } else { 0 }
    $dCount = if ($d) { $d.Count } else { 0 }
    $rSteps = if ($r) { ($r.Steps | Select-Object -Last 4) -join "," } else { "-" }
    $badgeStatus = if ($r) { if ($r.BadgeOk) { "OK" } else { "FALTA" } } else { "-" }
    $status = if ($rCount -gt 0 -and $dCount -gt 0) {
        "OK (leida y declarada)"
    } elseif ($rCount -gt 0 -and $dCount -eq 0) {
        "OK (leida en sesion)"
    } else {
        $fakeLoads += $name
        "ALERTA: declarada sin view_file"
    }
    [pscustomobject]@{
        Skill       = $name
        ViewFile    = $rCount
        Declarada   = $dCount
        Badge       = $badgeStatus
        UltimosStep = $rSteps
        Estado      = $status
    }
}

$rows | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host $_.TrimEnd() }
Write-Host ""

if ($badgeMisuse.Count -gt 0) {
    Write-Host "AVISOS DE BADGES MAL USADOS (Protocolo TUI):"
    $badgeMisuse | Select-Object -First 5 | ForEach-Object { Write-Host " - $_" }
    Write-Host ""
}

if ($fakeLoads.Count -gt 0) {
    Write-Host ("RESULTADO: ALERTA - " + $fakeLoads.Count + " skill(s) declarada(s) sin lectura fisica: " + ($fakeLoads -join ", "))
    exit 1
}

Write-Host ("RESULTADO: OK - " + $readSkills.Count + " skill(s) verificada(s) con lectura real en transcript.jsonl (0 cargas fingidas).")
exit 0
