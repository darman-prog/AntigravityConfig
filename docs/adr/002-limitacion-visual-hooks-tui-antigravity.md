# ADR 002: Inviabilidad de Renderizado Visual Directo en TUI mediante Lifecycle Hooks de Antigravity CLI

## Estado
Aceptado / Descartado intento visual

## Fecha
2026-10-17

## Contexto
Se evaluó la posibilidad de personalizar la interfaz de terminal (TUI) de Antigravity CLI (`agy`) para incorporar una cabecera persistente y un panel de telemetría de cuota orbital con glifos (`◔ ◑ ◕ ●`) y colores ergonómicos directamente en la consola interactiva, utilizando los lifecycle hooks oficiales (`SessionStart` y `PreInvocation`).

Durante la prueba de concepto y la inspección forense del binario `agy.EXE` y los registros de ejecución en `%USERPROFILE%\.gemini\antigravity-cli\cli.log`, se evidenció la arquitectura interna del ejecutable oficial de Google:

1. **Captura y supresión de I/O en hooks**:
   - `agy.EXE` ejecuta los hooks configurados en `hooks.json` mediante subprocesos aislados (`cmd /c`).
   - El ejecutor interno (`command_hook_executor.go:75`) redirige tanto `stdout` (para parsear el JSON de respuesta) como `stderr` hacia el archivo de diagnóstico `cli.log`:
     ```text
     command_hook_executor.go:75] JSON hook command stderr: +------------------------------------------------------------------------+
     ```
   - Toda salida generada por scripts en stderr o stdout es suprimida de la pantalla de la terminal del usuario.

2. **Propiedad exclusiva del lienzo TUI**:
   - El motor de terminal de `agy.EXE` (escrito en Go y C++) gestiona directamente el búfer de pantalla alterno (*alternate screen buffer*) y el posicionamiento del cursor.
   - Cualquier intento de impresión directa a la consola es sobreescrito o ignorado por el bucle de eventos del TUI.

3. **Ciclo de vida de `SessionStart`**:
   - El evento `SessionStart` no se ejecuta al iniciar el proceso `agy` en la terminal, sino recién cuando el usuario envía su primer mensaje en la conversación.
   - Su contrato (`injectSteps`) únicamente permite pasar instrucciones al modelo de lenguaje (`systemMessage`) o pasos de chat (`ephemeralMessage`), no renderizar componentes gráficos o paneles fijos.

## Decisión
1. **Descartar la personalización visual de la TUI mediante hooks nativos**: No se intentará inyectar cabeceras, recuadros, barras laterales ni widgets visuales a través de `hooks.json`.
2. **Preservar los hooks exclusivamente para lógica de control y contexto**:
   - `PreToolUse`: Guardarraíl de seguridad y permisos (`pre-tool-enforcer.ps1`).
   - `PreToolUse` / `Stop`: Notificaciones nativas del sistema operativo (`notify-windows.ps1`).
   - `SessionStart`: Inyección silenciosa de contexto y bienvenida para el agente (`session-start.ps1`).
3. **Canal oficial para personalización visual completa**:
   - Si en el futuro se requiere una interfaz visualmente enriquecida (pantalla dividida, barra lateral, glifos orbitales en tiempo real), la única vía viable y soportada es un **TUI Wrapper desacoplado** (por ejemplo, en Python `Textual` o Go `Bubbletea`) que consuma la CLI mediante el protocolo de streaming headless:
     ```bash
     agy --input-format stream-json --output-format stream-json
     ```

## Consecuencias
- **Positivas**:
  - Se mantiene la integridad y estabilidad absoluta del entorno de desarrollo.
  - Cero dependencias frágiles o hackeos contra el ejecutable oficial de Google.
  - El harness cumple al 100% con los contratos esperados por `agy update`.
- **Negativas**:
  - La terminal interactiva de `agy` mantendrá su diseño y flujo nativo estándar sin cabeceras custom ni paneles divididos en la vista por defecto.

## Alternativas descartadas
- **Escritura directa en `[Console]::Error` (stderr)**: Descartada porque `command_hook_executor.go` intercepta stderr y lo desvía a `cli.log`.
- **Modificación o parcheo binario de `agy.EXE`**: Terminantemente descartada; rompe firmas Authenticode, infringe los términos de uso y se sobreescribe en cada actualización automática.
