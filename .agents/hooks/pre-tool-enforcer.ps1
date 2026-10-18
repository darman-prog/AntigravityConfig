# Enforcer de permisos para hooks PreToolUse de Antigravity (fuente ASCII, sin BOM)
$utf8 = [Text.UTF8Encoding]::new($false)

function Emit($obj) {
    $json = $obj | ConvertTo-Json -Compress
    $json = [regex]::Replace($json, '[^\x00-\x7F]', [Text.RegularExpressions.MatchEvaluator]{
        param($m) '\u{0:x4}' -f [int][char]$m.Value
    })
    $bytes = [Text.Encoding]::ASCII.GetBytes($json)
    $out = [Console]::OpenStandardOutput()
    $out.Write($bytes, 0, $bytes.Length)
    $out.Flush()
}

$reader = [IO.StreamReader]::new([Console]::OpenStandardInput(), $utf8)
$rawInput = $reader.ReadToEnd()
if (-not $rawInput) { Emit @{ decision = "allow" }; exit 0 }

try { $payload = $rawInput | ConvertFrom-Json }
catch { Emit @{ decision = "allow" }; exit 0 }

$toolCall = $payload.toolCall
$toolName = if ($toolCall) { $toolCall.name } else { "" }
$toolArgs = if ($toolCall) { $toolCall.args } else { $null }

if ($toolName -eq "run_command" -and $null -ne $toolArgs) {
    $cmd = [string]$toolArgs.CommandLine

    if ($cmd -match '(?i)--output') {
        Emit @{ decision = "deny"; reason = "Denegado por politica de seguridad del harness: prohibido --output en comandos de consola." }
        exit 0
    }
    if ($cmd -match '(?i)git\s+(apply|checkout|restore|stash)\b') {
        Emit @{ decision = "ask"; reason = "Comando potencialmente destructivo sobre el arbol de trabajo ($cmd). Requiere confirmacion." }
        exit 0
    }
    if ($cmd -match '^(git\s+(diff|status|log)|dir|Get-ChildItem|ls)\b' -and $cmd -notmatch '[;&|`]') {
        Emit @{ decision = "allow" }
        exit 0
    }
    Emit @{ decision = "ask"; reason = "Ejecucion de comando en consola: $cmd" }
    exit 0
}

Emit @{ decision = "allow" }
exit 0