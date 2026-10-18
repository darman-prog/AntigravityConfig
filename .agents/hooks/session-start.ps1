# Inyecta el banner de bienvenida del harness al iniciar una sesion en Antigravity CLI (fuente ASCII, sin BOM)
$ErrorActionPreference = "Stop"

# Emite el payload JSON en stdout codificando cualquier caracter no ASCII en secuencias de escape unicode
function Emit($obj) {
    # Se especifica Depth 5 para serializar correctamente estructuras anidadas de injectSteps
    $json = $obj | ConvertTo-Json -Depth 5 -Compress
    $json = [regex]::Replace($json, '[^\x00-\x7F]', [Text.RegularExpressions.MatchEvaluator]{
        param($m) '\u{0:x4}' -f [int][char]$m.Value
    })
    $bytes = [Text.Encoding]::ASCII.GetBytes($json)
    $out = [Console]::OpenStandardOutput()
    $out.Write($bytes, 0, $bytes.Length)
    $out.Flush()
}

# Texto del banner de inicio con las convenciones y comandos basicos del harness
$banner = "Plantilla Antigravity CLI - Harness Activo`nAtajos clave: /plan (planificar) | /goal (modo exhaustivo) | /schedule (temporizadores) | /help"

# Construye el objeto segun el contrato protojson de SessionStart esperado por agy
Emit @{
    injectSteps = @(
        @{
            systemMessage = @{
                systemMessage = $banner
            }
        }
    )
}
exit 0
