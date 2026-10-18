<#
.SYNOPSIS
  Guardarrail de presupuesto del harness Antigravity (AGENTS.md, agentes, skills, descriptions, hooks).

.DESCRIPTION
  Verifica los topes acordados en docs/harness/presupuestos.md adaptados para Antigravity CLI.
  Los conteos se derivan por glob (no hay cifras hardcodeadas).
  Exit 0 = todo en presupuesto; exit 1 = violaciones (listadas).

.EXAMPLE
  powershell -NoProfile -File .\scripts\harness-budget.ps1
#>



param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

try {
    $utf8 = [Text.UTF8Encoding]::new($false)
    [Console]::OutputEncoding = $utf8
    $OutputEncoding = $utf8
} catch { }


$ErrorActionPreference = "Stop"
$script:fail = @()
function Check($cond, $msg) { if (-not $cond) { $script:fail += $msg } }

# Topes (fuente unica: docs/harness/presupuestos.md)
$MAX_AGENTS_MD_TOTAL = 75
$MAX_AGENTS_TOTAL = 350
$MAX_AGENT        = 45
$MAX_SKILL        = 65
$MAX_SKILL_EXENTA = 180   # vendor o manuales (carga bajo demanda)
$MAX_DESC         = 45
$MAX_DESC_MANUAL  = 25
$MAX_RULE_BYTES   = 24000 # Tope de bytes por regla en Antigravity
$presupuestos = Join-Path $Root "docs\harness\presupuestos.md"
Check (Test-Path -LiteralPath $presupuestos) "falta docs\harness\presupuestos.md (fuente unica de los topes)"

$EXENTAS_LINEAS = @('frontend-design-review', 'habilidades-ofimaticas', 'informe-docx')
$MANUALES       = @('habilidades-ofimaticas', 'informe-docx')

$agentsMd  = Join-Path $Root "AGENTS.md"
$geminiMd  = Join-Path $Root "GEMINI.md"
$agentsDir = Join-Path $Root ".agents\agents"
$skillsDir = Join-Path $Root ".agents\skills"

# 1) AGENTS.md y GEMINI.md (se inyectan en cada sesion de Antigravity)
$agentsLines = (Get-Content -LiteralPath $agentsMd).Count
Check ($agentsLines -le $MAX_AGENTS_MD_TOTAL) "AGENTS.md tiene $agentsLines lineas (tope $MAX_AGENTS_MD_TOTAL)"
$agentsBytes = (Get-Item -LiteralPath $agentsMd).Length
Check ($agentsBytes -le $MAX_RULE_BYTES) "AGENTS.md tiene $agentsBytes bytes (tope Antigravity $MAX_RULE_BYTES bytes)"
Check (Test-Path -LiteralPath $geminiMd) "falta GEMINI.md (orquestacion del agente default y modo /plan en Antigravity)"
$geminiLines = if (Test-Path -LiteralPath $geminiMd) { (Get-Content -LiteralPath $geminiMd).Count } else { 0 }
Check ($geminiLines -le $MAX_AGENTS_MD_TOTAL) "GEMINI.md tiene $geminiLines lineas (tope $MAX_AGENTS_MD_TOTAL)"
if (Test-Path -LiteralPath $geminiMd) {
    $geminiBytes = (Get-Item -LiteralPath $geminiMd).Length
    Check ($geminiBytes -le $MAX_RULE_BYTES) "GEMINI.md tiene $geminiBytes bytes (tope Antigravity $MAX_RULE_BYTES bytes)"
}

# 2) Agentes: topes + contrato de roles y permisos
$BUILTIN_SUBAGENTS = @('explore', 'general', 'scout', 'title', 'summary', 'compaction', 'self', 'research', 'image-generator', 'build', 'plan', 'default')
$VALID_MODES      = @('primary', 'subagent', 'all')
$agentsTotal = 0
$agentCount  = 0
$agentMode   = @{}
$allowlists  = @()
Get-ChildItem -LiteralPath $agentsDir -Filter *.md | ForEach-Object {
    $lines = Get-Content -LiteralPath $_.FullName
    $n = $lines.Count
    $agentsTotal += $n
    $agentCount++
    Check ($n -le $MAX_AGENT) "agente $($_.Name) tiene $n lineas (tope $MAX_AGENT)"
    $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)

    # Frontmatter delimitado
    $fm = @()
    $closed = $false
    if ($lines.Count -gt 0 -and $lines[0] -match '^\s*---\s*$') {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*---\s*$') { $closed = $true; break }
            $fm += $lines[$i]
        }
    }
    Check $closed "agente $name sin cierre '---' del frontmatter"

    # Antigravity requiere name: en el frontmatter para registrar el agente/subagente
    $nameLine = $fm | Select-String -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
    $fmName = if ($null -ne $nameLine) { $nameLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    Check ($fmName -eq $name) "agente $name debe declarar 'name: $name' en el frontmatter para que agy lo descubra (actual: '$fmName')"

    $modeLine = $fm | Select-String -Pattern '^mode:\s*(.+?)\s*$' | Select-Object -First 1
    $mode = if ($null -ne $modeLine) { $modeLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    Check ($mode -in $VALID_MODES) "agente $name sin 'mode:' explicito y valido (primary|subagent|all; el default es all): '$mode'"
    $agentMode[$name] = $mode

    # Coherencia entre mode (harness) y mainAgent/subagent (Antigravity nativo)
    $mainLine = $fm | Select-String -Pattern '^mainAgent:\s*(.+?)\s*$' | Select-Object -First 1
    $mainVal = if ($null -ne $mainLine) { $mainLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    $subLine = $fm | Select-String -Pattern '^subagent:\s*(.+?)\s*$' | Select-Object -First 1
    $subVal = if ($null -ne $subLine) { $subLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    $expectedMain = if ($mode -eq 'primary') { 'true' } else { 'false' }
    $expectedSub = if ($mode -eq 'subagent') { 'true' } else { 'false' }
    Check ($mainVal -eq $expectedMain) "agente $name (mode: $mode) debe declarar 'mainAgent: $expectedMain' (actual: '$mainVal')"
    Check ($subVal -eq $expectedSub) "agente $name (mode: $mode) debe declarar 'subagent: $expectedSub' (actual: '$subVal')"
    # Antigravity soporta 9 colores semanticos nativos en la TUI
    $VALID_COLORS = @('primary', 'secondary', 'accent', 'success', 'warning', 'danger', 'info', 'neutral', 'muted')
    $colorLine = $fm | Select-String -Pattern '^color:\s*(.+?)\s*$' | Select-Object -First 1
    $fmColor = if ($null -ne $colorLine) { $colorLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    Check ($fmColor -in $VALID_COLORS) "agente $name debe declarar 'color:' valido ($($VALID_COLORS -join '|')) en el frontmatter (actual: '$fmColor')"

    $taskLine = $fm | Select-String -Pattern '^\s+task:\s*(.+?)\s*$' | Select-Object -First 1
    $taskVal = if ($null -ne $taskLine) { $taskLine.Matches[0].Groups[1].Value.Trim() } else { '' }
    Check ($taskVal -ne '') "agente $name sin 'task:' explicito en permission (el default es allow)"

    foreach ($tm in [regex]::Matches($taskVal, '"([^"]+)"\s*:')) {
        $target = $tm.Groups[1].Value
        if ($target -ne '*' -and $target -notmatch '[\*\?]') {
            $allowlists += [pscustomobject]@{ From = $name; To = $target }
        }
    }

    # Un subagent no puede delegar en un primary
    if ($mode -eq 'subagent') {
        $body = ($lines -join "`n")
        $bad = @([regex]::Matches($body, 'delega(?:ndo)?\s+(?:en\s+|a\s+)?`(build|plan|ui-ux|backend-expert)`') |
            ForEach-Object { $_.Groups[1].Value })
        Check ($bad.Count -eq 0) "el subagent $name dice que delega en $(($bad | Sort-Object -Unique) -join ', '), que no es invocable por subagent"
    }
}
Check ($agentsTotal -le $MAX_AGENTS_TOTAL) "agentes suman $agentsTotal lineas (tope $MAX_AGENTS_TOTAL)"

# 2a-bis) Si existen agentes con mainAgent: true, verificar que agy agents los liste
$expectedMainAgents = @($agentMode.Keys | Where-Object { $agentMode[$_] -eq 'primary' })
if ($expectedMainAgents.Count -gt 0 -and (Get-Command agy -ErrorAction SilentlyContinue)) {
    Push-Location $Root
    try {
        $discoveredAgents = @(& agy agents 2>$null | ForEach-Object { ([string]$_).Trim() } | Where-Object { $_ })
        foreach ($expectedAgent in $expectedMainAgents) {
            Check ($discoveredAgents -contains $expectedAgent) "el agente primario '$expectedAgent' no es descubierto por 'agy agents' (descubiertos: $($discoveredAgents -join ', '))"
        }
    } finally {
        Pop-Location
    }
}

# 2b) Allowlists de task: cada destino existe y es invocable
foreach ($a in $allowlists) {
    if ($BUILTIN_SUBAGENTS -contains $a.To) { continue }
    Check ($agentMode.ContainsKey($a.To)) "la allowlist task de $($a.From) nombra '$($a.To)', que no existe como agente"
    if ($agentMode.ContainsKey($a.To)) {
        Check ($agentMode[$a.To] -in @('subagent', 'all')) "la allowlist task de $($a.From) nombra a $($a.To) (mode: $($agentMode[$a.To])), que no es invocable"
    }
}

# 2c) Roster de AGENTS.md coherente con los mode reales
$rosterSrc = Get-Content -LiteralPath $agentsMd -Raw
$roster = @{}
($rosterSrc -split "`n") | Where-Object { $_ -match 'Primarios|Subagentes' } | ForEach-Object {
    $kind = if ($_ -match 'Primarios') { 'primary' } else { 'subagent' }
    foreach ($nm in [regex]::Matches($_, '`([^`]+)`')) { $roster[$nm.Groups[1].Value] = $kind }
}
foreach ($name in $agentMode.Keys) {
    Check ($roster.ContainsKey($name)) "el agente $name no figura en el roster de AGENTS.md (Primarios/Subagentes)"
    if ($roster.ContainsKey($name)) {
        Check ($roster[$name] -eq $agentMode[$name]) "el roster de AGENTS.md lista $name como $($roster[$name]) pero su mode es $($agentMode[$name])"
    }
}
foreach ($name in $roster.Keys) {
    Check ($agentMode.ContainsKey($name) -or ($BUILTIN_SUBAGENTS -contains $name)) "el roster de AGENTS.md nombra '$name', que no es agente del repo ni subagent built-in"
}

# 2d) Contrato de finales de linea declarado en el repo
$attrs = Join-Path $Root ".gitattributes"
if (Test-Path -LiteralPath $attrs) {
    Check ((Get-Content -LiteralPath $attrs -Raw) -match '(?m)^\*\.md\s+text\s+eol=lf') ".gitattributes debe fijar '*.md text eol=lf'"
} else {
    Check $false "falta .gitattributes con '*.md text eol=lf'"
}

# 2e) Las skills no pueden mandar a delegar en un primary
$skillMdScope = @(Get-ChildItem -LiteralPath $skillsDir -Recurse -File -Filter *.md)
$delPattern = '(?i)(delega\w*|lanza\w*|invoca\w*|consulta\w*|re-?evalua\w*|usa el agente)\s*(?:en\s+|a\s+|con\s+)?`(build|plan)`'
foreach ($hit in @($skillMdScope | Select-String -Pattern $delPattern)) {
    $rel = $hit.Path.Substring($skillsDir.Length).TrimStart('\')
    $verb = $hit.Matches[0].Groups[1].Value
    $target = $hit.Matches[0].Groups[2].Value
    Check $false "skill '$rel' manda a delegar en el primary '$target' ($verb): los primarios no son invocables como subagente"
}

# 2f) Grafo de delegacion aciclico
$graph = @{}
foreach ($a in $allowlists) {
    if (-not $graph.ContainsKey($a.From)) { $graph[$a.From] = @() }
    $graph[$a.From] += $a.To
}
function Reach($start, $node, $seen) {
    if ($node -eq $start) { return $true }
    if ($seen.Contains($node)) { return $false }
    $seen[$node] = $true
    foreach ($next in @($graph[$node])) {
        if ($null -ne $next -and (Reach $start $next $seen)) { return $true }
    }
    return $false
}
foreach ($src in $graph.Keys) {
    foreach ($nxt in @($graph[$src])) {
        Check (-not (Reach $src $nxt @{})) "ciclo de delegacion: $src puede alcanzarse a si mismo via $nxt"
    }
}

# 2g) Un agente de solo lectura no puede escribir por bash
foreach ($name in @($agentMode.Keys)) {
    $md = Join-Path $agentsDir "$name.md"
    if (-not (Test-Path -LiteralPath $md)) { continue }
    $fmLines = @()
    $closed = $false
    foreach ($l in (Get-Content -LiteralPath $md)) {
        if ($fmLines.Count -eq 0 -and $l -match '^\s*---\s*$') { continue }
        if ($l -match '^\s*---\s*$') { $closed = $true; break }
        $fmLines += $l
    }
    $fm = $fmLines -join "`n"
    if ($fm -notmatch 'solo lectura') { continue }
    Check ($fm -match '"\*--output\*":\s*deny') "$name se declara de solo lectura pero no bloquea '--output' en bash (podria escribir con git diff --output)"
}

# 2h) Sin BOM: el loader de Antigravity no procesa adecuadamente archivos con BOM
$bomScope = @(Get-ChildItem -LiteralPath $agentsDir -File -Filter *.md -ErrorAction SilentlyContinue)
$bomScope += Get-ChildItem -LiteralPath $skillsDir -Recurse -File -Filter SKILL.md -ErrorAction SilentlyContinue
if (Test-Path -LiteralPath $agentsMd) { $bomScope += Get-Item -LiteralPath $agentsMd }
if (Test-Path -LiteralPath $geminiMd) { $bomScope += Get-Item -LiteralPath $geminiMd }
$hooksDir = Join-Path $Root ".agents\hooks"
if (Test-Path -LiteralPath $hooksDir) { $bomScope += Get-ChildItem -LiteralPath $hooksDir -File -ErrorAction SilentlyContinue }
$bomFiles = @()
foreach ($f in $bomScope) {
    $b = [System.IO.File]::ReadAllBytes($f.FullName)
    if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) { $bomFiles += $f.FullName.Replace("$Root\", '') }
}
Check ($bomFiles.Count -eq 0) ("BOM (U+FEFF) en " + $bomFiles.Count + " archivo(s): " + (($bomFiles | Select-Object -First 5) -join ', '))

# 3) Skills: frontmatter fail-closed, name==carpeta, topes, descriptions y enlaces
$skillNames = @()
Get-ChildItem -LiteralPath $skillsDir -Recurse -Filter SKILL.md | ForEach-Object {
    $file   = $_
    $lines  = Get-Content -LiteralPath $file.FullName
    $folder = Split-Path -Leaf (Split-Path -Parent $file.FullName)
    $text   = $lines -join "`n"

    $fm = @()
    $closed = $false
    if ($lines.Count -gt 0 -and $lines[0] -match '^\s*---\s*$') {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*---\s*$') { $closed = $true; break }
            $fm += $lines[$i]
        }
    }
    Check $closed "SKILL.md sin cierre '---' del frontmatter ($folder)"
    if (-not $closed) { return }
    $nameLine = $fm | Select-String -Pattern '^name:\s*(.+?)\s*$' | Select-Object -First 1
    $descLine = $fm | Select-String -Pattern '^description:\s*(.+?)\s*$' | Select-Object -First 1
    Check ($null -ne $nameLine) "SKILL.md sin 'name:' en el frontmatter ($folder)"
    Check ($null -ne $descLine) "SKILL.md sin 'description:' en el frontmatter ($folder)"
    if ($null -eq $nameLine -or $null -eq $descLine) { return }

    $name = $nameLine.Matches[0].Groups[1].Value.Trim()
    $desc = $descLine.Matches[0].Groups[1].Value
    Check ($name -eq $folder) "el name '$name' no coincide con la carpeta '$folder'"
    $descWords = ($desc -split '\s+' | Where-Object { $_ }).Count

    $capLines = if ($EXENTAS_LINEAS -contains $name) { $MAX_SKILL_EXENTA } else { $MAX_SKILL }
    $capDesc  = if ($MANUALES -contains $name)       { $MAX_DESC_MANUAL  } else { $MAX_DESC }
    Check ($lines.Count -le $capLines) "skill $name tiene $($lines.Count) lineas (tope $capLines)"
    Check ($descWords -le $capDesc)    "description de $name tiene $descWords palabras (tope $capDesc)"

    foreach ($m in [regex]::Matches($text, '\]\((references?/[^)]+)\)')) {
        $refRel = ($m.Groups[1].Value -split '#')[0]
        $ref = Join-Path (Split-Path -Parent $file.FullName) $refRel
        Check (Test-Path -LiteralPath $ref) "enlace roto en ${name}: $refRel"
    }

    $skillNames += $name
}
Check (($skillNames | Sort-Object -Unique).Count -eq $skillNames.Count) "hay nombres de skill duplicados"

# 3b) Rutas en texto plano dentro de reference(s)/
Get-ChildItem -LiteralPath $skillsDir -Recurse -File -Filter *.md | ForEach-Object {
    $f = $_
    $fDir = Split-Path -Parent $f.FullName
    if ($fDir -match '[\\/]references?[\\/]') {
        $fText = Get-Content -LiteralPath $f.FullName -Raw
        foreach ($m in [regex]::Matches($fText, '`((?:reference|references)/[^`]+)`')) {
            $refRel = ($m.Groups[1].Value -split '#')[0]
            $ref = Join-Path $fDir $refRel
            Check (Test-Path -LiteralPath $ref) "ruta rota en $($f.Name): $refRel"
        }
    }
}

# 4) Routing bidireccional: cada skill del repo esta en la tabla; cada nombre de la tabla existe
$agentsContent = Get-Content -LiteralPath $agentsMd -Raw
foreach ($n in ($skillNames + 'agy-customizations')) {
    Check ($agentsContent -match ('`' + [regex]::Escape($n) + '`')) "skill $n no aparece en la tabla de AGENTS.md"
}
$known = @($skillNames) + @('agy-customizations')
$known += Get-ChildItem -LiteralPath $agentsDir -Filter *.md | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) }
$tableNames = @()
($agentsContent -split "`n") | Where-Object { $_ -match '^\|' } | ForEach-Object {
    foreach ($m in [regex]::Matches($_, '`([^`]+)`')) {
        $t = $m.Groups[1].Value
        if ($t -match '^[a-z0-9][a-z0-9-]*$') { $tableNames += $t }
    }
}
foreach ($t in ($tableNames | Sort-Object -Unique)) {
    Check ($known -contains $t) "la tabla de AGENTS.md menciona '$t' pero no existe como skill, agente ni agy-customizations"
}

# 4b) Las columnas Obligatoria/Opcional del Skill Gate solo admiten skills
$skillGateKnown = @($skillNames) + @('agy-customizations')
($agentsContent -split "`n") | Where-Object { $_ -match '^\|' } | ForEach-Object {
    $cols = $_ -split '\|'
    if ($cols.Count -ge 4) {
        foreach ($ci in 2, 3) {
            foreach ($m in [regex]::Matches($cols[$ci], '`([^`]+)`')) {
                $t = $m.Groups[1].Value
                if ($t -match '^[a-z0-9][a-z0-9-]*$') {
                    Check ($skillGateKnown -contains $t) "la columna Obligatoria/Opcional del Skill Gate menciona '$t', que no es skill ni agy-customizations"
                }
            }
        }
    }
}

# 4c) code-clue es obligatoria para cualquier escritura de código
$codeRows = @($agentsContent -split "`n" | Where-Object { $_ -match 'Escribir o modificar código' })
Check ($codeRows.Count -eq 1) "AGENTS.md debe tener una única fila para escribir/modificar código"
if ($codeRows.Count -eq 1) {
    $codeCols = $codeRows[0] -split '\|'
    Check ($codeCols.Count -ge 3 -and $codeCols[2] -match '`code-clue`') "code-clue debe estar en Obligatoria para toda escritura o modificación de código"
}

# 5) Fuente unica por regla
$scope = @()
$scope += Get-ChildItem -LiteralPath $skillsDir -Recurse -Filter *.md
$scope += Get-ChildItem -LiteralPath $agentsDir -Filter *.md
$scope += Get-Item -LiteralPath $agentsMd

$wcag = @($scope | Select-String -Pattern 'WCAG 2\.1')
Check ($wcag.Count -eq 0) "'WCAG 2.1' aparece en $($wcag.Count) archivo(s); el canonico es 2.2 AA"

$err = @($scope | Select-String -Pattern 'code, message, details')
Check (($err.Count -eq 1) -and ($err[0].Path -match 'api-backend')) "el contrato de errores debe estar solo en api-backend (encontrado $($err.Count))"

$dod = @(Get-ChildItem -LiteralPath $skillsDir -Recurse -Filter SKILL.md | Select-String -Pattern '^## Definition of Done')
Check ($dod.Count -eq 1) "la DoD canonica debe estar solo en workflow (encontradas $($dod.Count))"

# 6) Probes de trigger
$probesFile = Join-Path $Root "scripts\trigger-probes.json"
$probes = $null
if (Test-Path -LiteralPath $probesFile) {
    try { $probes = Get-Content -LiteralPath $probesFile -Raw | ConvertFrom-Json } catch { Check $false "trigger-probes.json no es JSON valido" }
} else {
    Check $false "falta scripts\trigger-probes.json (probes de trigger)"
}
if ($null -ne $probes) {
    $rows = @($agentsContent -split "`n" | Where-Object { $_ -match '^\|' })
    $descCache = @{}
    foreach ($p in $probes) {
        $s = [string]$p.skill
        if (-not $descCache.ContainsKey($s)) {
            $cand = (Join-Path $skillsDir $s)
            $descCache[$s] = if (Test-Path -LiteralPath (Join-Path $cand "SKILL.md")) {
                (Get-Content -LiteralPath (Join-Path $cand "SKILL.md") -TotalCount 8) -join ' '
            } else { '' }
        }
        $surfaces = @($rows | Where-Object { $_ -match ('`' + [regex]::Escape($s) + '`') })
        $haystack = ((($surfaces -join ' ') + ' ' + $descCache[$s]).ToLowerInvariant())
        $miss = @($p.keywords | Where-Object { $haystack -notmatch [regex]::Escape(([string]$_).ToLowerInvariant()) })
        if ($miss.Count -gt 0) { Check $false "probe '$(($p.prompt))' no tiene todas las keywords de '$s' en su description ni en su fila (faltan: $($miss -join ', '))" }
    }
    $probedSkills = @($probes | ForEach-Object { [string]$_.skill } | Select-Object -Unique)
    foreach ($reqSkill in ($skillNames + @('agy-customizations'))) {
        Check ($reqSkill -in $probedSkills) "la skill '$reqSkill' no tiene ningun probe en scripts\trigger-probes.json (cobertura 100% obligatoria)"
    }
}

# 7) Estilo de respuesta: fuente unica y precedencia
$styleSkill = 'comunicacion-asertiva'
Check ($agentsContent -match ('Doctrina de redaccion.*`' + $styleSkill + '`')) "AGENTS.md debe apuntar a la skill ``$styleSkill`` como doctrina del estilo"
$hardCapScope = @(Get-ChildItem -LiteralPath $skillsDir -Recurse -Filter SKILL.md) + @(Get-ChildItem -LiteralPath $agentsDir -Filter *.md) + @(Get-Item -LiteralPath $agentsMd)
$hardCap = @($hardCapScope | Select-String -Pattern '5 bullets')
Check (($hardCap.Count -eq 1) -and ($hardCap[0].Path -eq $agentsMd)) "el limite de bullets debe existir solo en AGENTS.md (encontrado $($hardCap.Count) fuera de el)"
$styleFile = Join-Path $skillsDir "$styleSkill\SKILL.md"
if (Test-Path -LiteralPath $styleFile) {
    $styleText = Get-Content -LiteralPath $styleFile -Raw
    Check ($styleText -match 'contradic[ae].*gana `AGENTS\.md`') "la skill $styleSkill debe declarar que gana AGENTS.md si contradice"
} else {
    Check $false "falta la skill $styleSkill (doctrina de estilo obligatoria)"
}

# 8) Convencion de documentacion
$estadoDoc = Join-Path $Root "docs\harness\estado-actual.md"
Check (Test-Path -LiteralPath $estadoDoc) "falta docs\harness\estado-actual.md (la documentacion del harness vive en docs\harness)"

# 9) Lifecycle Hooks de Antigravity
$hooksFile = Join-Path $Root ".agents\hooks.json"
Check (Test-Path -LiteralPath $hooksFile) "falta .agents\hooks.json (Lifecycle Hooks de Antigravity)"
if (Test-Path -LiteralPath $hooksFile) {
    try {
        $hJson = Get-Content -LiteralPath $hooksFile -Raw | ConvertFrom-Json
        Check ($null -ne $hJson.'permission-gate') "hooks.json debe declarar 'permission-gate'"
        Check ($null -ne $hJson.'windows-notify') "hooks.json debe declarar 'windows-notify'"
        Check ($null -ne $hJson.'tui-welcome') "hooks.json debe declarar 'tui-welcome'"

        # Valida que todos los comandos en hooks.json usen rutas relativas portables que comiencen por 'hooks/'
        $rawHooks = Get-Content -LiteralPath $hooksFile -Raw
        foreach ($m in [regex]::Matches($rawHooks, '-File\s+([^\s"]+)')) {
            $scriptTarget = $m.Groups[1].Value
            Check ($scriptTarget -match '^hooks[\\/]') "el hook debe usar ruta relativa portable comenzando por 'hooks/' (actual: '$scriptTarget')"
        }
    } catch {
        Check $false ".agents\hooks.json no es JSON valido"
    }
}
$enforcerFile = Join-Path $Root ".agents\hooks\pre-tool-enforcer.ps1"
Check (Test-Path -LiteralPath $enforcerFile) "falta .agents\hooks\pre-tool-enforcer.ps1 (enforcer de permisos)"
$notifyFile = Join-Path $Root ".agents\hooks\notify-windows.ps1"
Check (Test-Path -LiteralPath $notifyFile) "falta .agents\hooks\notify-windows.ps1 (notificador nativo de Windows)"
$welcomeFile = Join-Path $Root ".agents\hooks\session-start.ps1"
Check (Test-Path -LiteralPath $welcomeFile) "falta .agents\hooks\session-start.ps1 (banner de bienvenida de la TUI)"

# 10) Integridad de codificacion: sin mojibake
$mojibakeScope = @()
if (Test-Path -LiteralPath $agentsMd) { $mojibakeScope += Get-Item -LiteralPath $agentsMd }
if (Test-Path -LiteralPath $geminiMd) { $mojibakeScope += Get-Item -LiteralPath $geminiMd }
foreach ($raiz in @('.agents', 'docs', 'scripts')) {
    $ruta = Join-Path $Root $raiz
    if (Test-Path -LiteralPath $ruta) {
        $mojibakeScope += Get-ChildItem -LiteralPath $ruta -Recurse -File -Include *.md, *.json, *.ps1, *.js -ErrorAction SilentlyContinue
    }
}
$mojibakeScope = @($mojibakeScope | Where-Object { $_.Extension -in @('.md', '.json', '.ps1', '.js') })
$mojibake = @()
foreach ($f in $mojibakeScope) {
    if ($f.FullName -match '\\(node_modules|vendor|dist)\\{1}') { continue }
    try {
        $t = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
        if ($t -match '[\u00C3\u00C2\u00E2][\u0080-\u00BF\u2013\u2014\u2018\u2019\u201A\u201C\u201D\u201E\u2020\u2021\u2022\u2026\u2030\u2039\u203A\u0160\u0161\u017D\u017E\u0178\u0192\u02C6\u02DC\u0152\u0153\u20AC\u2122]') {
            $mojibake += $f.FullName.Replace("$Root\", '')
        }
    } catch { }
}
Check ($mojibake.Count -eq 0) ("mojibake (doble codificacion UTF-8) en " + $mojibake.Count + " archivo(s): " + (($mojibake | Select-Object -First 5) -join ', '))

# 10b) Caracteres de control invisibles
$ctrl = @()
foreach ($f in $mojibakeScope) {
    if ($f.FullName -match '\\(node_modules|vendor|dist)\\{1}') { continue }
    try {
        $t = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
        if ($t -match '[\u0000-\u0008\u000B\u000C\u000E-\u001F]') { $ctrl += $f.FullName.Replace("$Root\", '') }
    } catch { }
}
Check ($ctrl.Count -eq 0) ("caracteres de control invisibles en " + $ctrl.Count + " archivo(s): " + (($ctrl | Select-Object -First 5) -join ', '))

# 11) Higiene Antigravity: Cero binarios y cero residuos de OpenCode o CLI .impeccable
$binFiles = @(Get-ChildItem -Path $Root -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Extension -in @('.exe', '.dll', '.bin', '.so', '.dylib', '.cmd') -and $_.FullName -notmatch '\\(\.git|node_modules|scratch)\\'
})
Check ($binFiles.Count -eq 0) ("binarios o ejecutables prohibidos en el repo: " + (($binFiles | ForEach-Object { $_.FullName.Replace("$Root\", '') }) -join ', '))

$activeScope = @()
$activeScope += Get-ChildItem -Path (Join-Path $Root ".agents") -Recurse -File -ErrorAction SilentlyContinue
$activeScope += Get-ChildItem -Path (Join-Path $Root "scripts") -Recurse -File -ErrorAction SilentlyContinue
$activeScope += Get-Item -LiteralPath $agentsMd -ErrorAction SilentlyContinue
if (Test-Path -LiteralPath $geminiMd) { $activeScope += Get-Item -LiteralPath $geminiMd -ErrorAction SilentlyContinue }
$activeScope = @($activeScope | Where-Object { $_.Name -ne 'harness-budget.ps1' })
$residuos = @($activeScope | Select-String -Pattern '(\.opencode|customize-opencode|sync-global|\brtk\b|impeccable\.(exe|cmd)|\.impeccable/|serve-question|IMPECCABLE_CRITIQUE_META)' -ErrorAction SilentlyContinue)
Check ($residuos.Count -eq 0) ("residuos de OpenCode/RTK/.impeccable detectados en archivos activos (" + $residuos.Count + "): " + (($residuos | ForEach-Object { "$($_.Filename):$($_.LineNumber)" } | Select-Object -First 5) -join ', '))

# Resultado
if ($script:fail.Count -gt 0) {
    Write-Host "GUARDARRAIL DE PRESUPUESTO: $($script:fail.Count) violacion(es)"
    $script:fail | ForEach-Object { Write-Host " - $_" }
    exit 1
}
Write-Host "Guardarrail de presupuesto OK: AGENTS.md=$agentsLines lineas | GEMINI.md=$geminiLines lineas (tope $MAX_AGENTS_MD_TOTAL) | skills=$($skillNames.Count) archivos SKILL.md | agentes=$agentCount archivos, $agentsTotal lineas en total (tope $MAX_AGENTS_TOTAL) | hooks=OK"
exit 0
