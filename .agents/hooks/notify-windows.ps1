# Notificador nativo WinRT Toast y eventos sonoros para Lifecycle Hooks de Antigravity (fuente ASCII, sin BOM)
param(
    [ValidateSet("Stop", "PreToolUse")]
    [string]$Event = "Stop",
    [switch]$Force
)

$utf8 = [Text.UTF8Encoding]::new($false)

# Serializa la respuesta del hook en JSON ASCII puro (con escapes \uXXXX) para evitar problemas de encoding en stdout
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

# Detecta mediante Win32 user32.dll si la ventana activa en primer plano ya es una terminal o IDE conocido
function Test-TerminalFocused {
    if ($Force) { return $false }
    try {
        if (-not ('Win32Focus' -as [type])) {
            Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Win32Focus {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
}
"@ -ErrorAction Stop
        }
        $hwnd = [Win32Focus]::GetForegroundWindow()
        if ($hwnd -eq [IntPtr]::Zero) { return $false }
        $procId = [uint32]0
        [void][Win32Focus]::GetWindowThreadProcessId($hwnd, [ref]$procId)
        if ($procId -eq 0) { return $false }
        $procName = (Get-Process -Id $procId -ErrorAction Stop).ProcessName
        $terminals = @('WindowsTerminal', 'wezterm-gui', 'alacritty', 'ghostty', 'Code', 'Antigravity', 'powershell', 'pwsh', 'cmd')
        return ($terminals -contains $procName)
    } catch {
        # Ante cualquier error de P/Invoke o lectura de proceso, asumimos que no tiene foco para no silenciar alertas
        return $false
    }
}

# Reproduce el sonido acustico de evento configurado en Windows para alertar al usuario sin saturar la pantalla
function Play-WindowsSoundEvent([string]$EventName = "Notification.Default") {
    try {
        $regPath = "HKCU:\AppEvents\Schemes\Apps\.Default\$EventName\.Current"
        $wavPath = (Get-ItemProperty -Path $regPath -ErrorAction Stop).'(default)'
        if ($wavPath -and (Test-Path -LiteralPath $wavPath)) {
            $player = [System.Media.SoundPlayer]::new($wavPath)
            $player.PlaySync()
            return
        }
    } catch { }

    # Fallback si falla la lectura del registro o el archivo WAV no existe
    try {
        if ($EventName -match 'Reminder|Exclamation') {
            [System.Media.SystemSounds]::Exclamation.Play()
        } else {
            [System.Media.SystemSounds]::Asterisk.Play()
        }
    } catch { }
}

# Dispara notificacion visual Toast si la terminal no esta en foco, o reproduce sonido acustico si ya esta en foco
function Send-WindowsNotification([string]$Title, [string]$Body, [string]$SoundEvent = "Notification.Default") {
    # Si el usuario ya esta en una terminal (ej. en otra pestana de Windows Terminal), suprimimos el banner visual pero SI sonamos
    if (Test-TerminalFocused) {
        Play-WindowsSoundEvent -EventName $SoundEvent
        return
    }

    try {
        $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        [void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        [void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
        $template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
        $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template)
        $textNodes = $xml.GetElementsByTagName('text')
        [void]$textNodes.Item(0).AppendChild($xml.CreateTextNode($Title))
        [void]$textNodes.Item(1).AppendChild($xml.CreateTextNode($Body))

        $toastNode = $xml.SelectSingleNode('/toast')
        if ($null -ne $toastNode -and $SoundEvent) {
            $audio = $xml.CreateElement('audio')
            $audio.SetAttribute('src', "ms-winsoundevent:$SoundEvent")
            [void]$toastNode.AppendChild($audio)
        }

        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
    } catch {
        # Fallback acustico en caso de fallo del subsistema de UI/WinRT
        Play-WindowsSoundEvent -EventName $SoundEvent
    }
}

$reader = [IO.StreamReader]::new([Console]::OpenStandardInput(), $utf8)
$rawInput = $reader.ReadToEnd()
$payload = $null
if ($rawInput) {
    try { $payload = $rawInput | ConvertFrom-Json } catch { $payload = $null }
}

# Construye la vocal acentuada en runtime para mantener el archivo fuente 100% ASCII en PowerShell 5.1
$oAcute = [char]0x00F3
$title = "Antigravity"

if ($Event -eq "Stop") {
    $reason = if ($payload -and $payload.terminationReason) { [string]$payload.terminationReason } else { "NO_TOOL_CALL" }
    # Evita notificar cuando el propio usuario cancelo manualmente el turno
    if ($reason -ne "USER_CANCELED") {
        $body = "Sesi$($oAcute)n completada"
        Send-WindowsNotification -Title $title -Body $body -SoundEvent "Notification.Default"
    }
    Emit @{ decision = "stop" }
    exit 0
}

if ($Event -eq "PreToolUse") {
    $toolCall = if ($payload) { $payload.toolCall } else { $null }
    $toolName = if ($toolCall -and $toolCall.name) { [string]$toolCall.name } else { "" }
    $toolArgs = if ($toolCall) { $toolCall.args } else { $null }

    if ($toolName -eq "ask_question") {
        # Alerta para preguntas interactivas donde el agente espera respuesta del usuario
        $body = "Antigravity solicita respuesta interactiva"
        Send-WindowsNotification -Title $title -Body $body -SoundEvent "Notification.Reminder"
    } elseif ($toolName -eq "run_command" -and $null -ne $toolArgs) {
        $cmd = [string]$toolArgs.CommandLine
        # Espeja las condiciones de pre-tool-enforcer.ps1 para notificar solo cuando el comando realmente pedira confirmacion
        $isDenied = ($cmd -match '(?i)--output')
        $isAutoAllowed = ($cmd -match '^(git\s+(diff|status|log)|dir|Get-ChildItem|ls)\b' -and $cmd -notmatch '[;&|`]')
        if (-not $isDenied -and -not $isAutoAllowed) {
            # Notifica que se requiere acceso a consola sin volcar el comando crudo en la alerta
            $body = "Antigravity solicita acceso a consola"
            Send-WindowsNotification -Title $title -Body $body -SoundEvent "Notification.Reminder"
        }
    }

    # Devuelve allow para que permission-gate (pre-tool-enforcer.ps1) conserve la autoridad unica sobre ask/deny
    Emit @{ decision = "allow" }
    exit 0
}

Emit @{ decision = "allow" }
exit 0
