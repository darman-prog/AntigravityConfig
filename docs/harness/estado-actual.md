# Estado actual del harness — Antigravity CLI

> **Para quién:** dev junior — tablas y diagramas; lectura en 5 min.
> **Para qué:** saber qué existe hoy y cómo se mueve una tarea. Complementa al [pipeline](pipeline.md); el historial por cambio vive en [changelog.md](changelog.md).
> **Fecha:** 2026-10-17 · **Estado:** vigente. Las cifras salen de la salida del guardarraíl (`scripts/harness-budget.ps1`), nunca de memoria.

<a id="sec-1"></a>
## 1. Números (verificados por el guardarraíl)

| Métrica | Valor | Tope | Nota |
| --- | --- | --- | --- |
| `AGENTS.md` | 71 líneas | 75 | Se inyecta en cada sesión de Antigravity CLI |
| `GEMINI.md` | 33 líneas | 75 | Orquestación del agente `default` y modo `/plan` en `agy` |
| Subagentes | 6 archivos · 237 líneas | 350 | Montados en `invoke_subagent` del agente `default` (`ui-ux`, `backend-expert`, `auditor`, `debugger`, `quality`, `tester`) |
| Skills | 38 `SKILL.md` en 38 carpetas | 65 líneas c/u | 180 las exentas (manuales y frontend-design-review) |
| Lifecycle Hooks | 3 hooks activos | — | `permission-gate` (PreToolUse), `windows-notify` (PreToolUse/Stop), `tui-welcome` (SessionStart) |
| Features | Registro funcional en `docs/features/` | — | Ciclo DDR: feature-specs multi-sesión y tarjetas |
| Fin de línea | LF en índice y carpeta | — | Fijado en `.gitattributes` |

<a id="sec-2"></a>
## 2. Índice de agentes y delegación

En Antigravity CLI (`agy`), el agente `default` actúa como único agente principal de sesión (con el comando `/plan` integrado y su orquestación en `GEMINI.md`). Los 6 subagentes especializados se montan en `invoke_subagent` y cada uno posee su rol visual y frontera estricta:

| Agente | Modo | Color TUI | Puede lanzar (Task) | Edita | Líneas | Cuándo |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `default` (`/plan`) | built-in (`GEMINI.md`) | — | los 6 subagentes + `research`/`self` | código (nada en `/plan`) | 33 | Planificar con `/plan`, implementar features/bugs y orquestar |
| `ui-ux` | subagent | `accent` (Verde) | nadie | solo frontend | 43 | UI visible: implementar, pulir, revisar |
| `backend-expert` | subagent | `primary` (Azul) | nadie | nada | 35 | Dominio, invariantes y contratos (no da el plan) |
| `auditor` | subagent | `warning` (Ámbar) | nadie | solo `*.md` | 34 | Revisión pre-merge y pre-flight de seguridad |
| `debugger` | subagent | `danger` (Rojo) | nadie | código | 39 | Bugs no triviales con test de regresión |
| `quality` | subagent | `secondary` (Púrpura) | nadie | código | 42 | Deuda, refactors, hotspots medidos |
| `tester` | subagent | `neutral` (Gris) | nadie | nada | 44 | E2E y pruebas funcionales del proyecto |
| `research` / `explore` | built-in | — | — | nada | Búsquedas amplias y relevamiento de repositorio |

<a id="sec-3"></a>
## 3. Índice de skills

Fuente única: la tabla del Skill Gate en `AGENTS.md` (no se copia aquí, por diseño).

| Modo | Cuántas | Cuáles | Dónde se decide |
| :--- | :--- | :--- | :--- |
| Siempre | 2 | `uso-eficiente`, `comunicacion-asertiva` | §Skill Gate, fila "Toda tarea" |
| Por tarea/señal | 34 | Incluye `code-clue` al escribir código | §Skill Gate, por tipo de tarea |
| Manuales | 2 | `habilidades-ofimaticas`, `informe-docx` | §Skill Gate, fila "Manuales" |
| **Total** | **38** | | Lo cuenta `harness-budget.ps1` |

Reglas: la tabla es la única fuente de ruteo · `references/` se lee bajo demanda · las descripciones comprueban el ruteo literal del 100% de las skills locales; `code-clue` se carga obligatoriamente al modificar código.

El guardarraíl (`scripts/harness-budget.ps1`) agrupa sus checks en bloques numerados:
- Frontmatter fail-closed (`name`, `mode`, `subagent`).
- Validación de `AGENTS.md` y `GEMINI.md` dentro de presupuesto (≤75 líneas c/u).
- Tamaño total de subagentes ≤350 líneas (actual: 237).
- Ausencia de BOM en todos los archivos de configuración y scripts.
- Cobertura 100% de probes de gatillo de skills.
- Protocolo de Lifecycle Hooks en `.agents/hooks.json`.
- Integridad de codificación y cero binarios o residuos externos en archivos activos.

<a id="sec-4"></a>
## 4. Índice de archivos

| Qué | Dónde | Nota |
| --- | --- | --- |
| Reglas de la sesión | `AGENTS.md` | Tabla del Skill Gate + estilo + roster de agentes (tope 75 líneas) |
| Orquestación Antigravity | `GEMINI.md` | Reglas del agente `default` y modo `/plan` en `agy` (tope 75 líneas) |
| Subagentes | `.agents/agents/*.md` | 6 subagentes especializados montados en `invoke_subagent` |
| Skills bajo demanda | `.agents/skills/<nombre>/` | 38 skills con `SKILL.md` (tope ≤65 líneas) y referencias |
| Lifecycle Hooks | `.agents/hooks.json` | 3 hooks configurados: `permission-gate`, `windows-notify`, `tui-welcome` |
| Guardarraíl | `scripts/harness-budget.ps1` | Verifica topes, codificación y contratos (exit 0 = verde) |
| Ciclo DDR | `scripts/new-feature.ps1` | Generador de especificaciones funcionales en `docs/features/` |
| Auditor de sesión | `scripts/audit-session-skills.ps1` | Auditoría de skills cargadas en `transcript.jsonl` y badges TUI |
| Publicador global | `scripts/publish-global-agy.ps1` | Sincroniza al plugin global `~/.gemini/config/plugins/antigravity-harness` |

<a id="sec-5"></a>
## 5. Estado de Verificación y Smokes

| Componente | Verificación | Evidencia |
| :--- | :--- | :--- |
| **Plugin Global Antigravity** | `agy plugin list` | Registrado y habilitado con: `38 skills, 6 agents, 2 rules, 3 hooks`. |
| **Guardarraíl Presupuesto** | `scripts/harness-budget.ps1` | **PASS (exit 0)**: AGENTS.md=71L, GEMINI.md=33L, subagentes=237L, skills=38. |
| **Guardarraíl de Seguridad** | MD5 de `pre-tool-enforcer.ps1` | `93F4BBD789AAD058B247D5A51B73719F` (inviolable, verificado). |
| **Notificaciones Windows** | WinRT PowerShell | Toast notifications funcionales en PreToolUse y Stop. |
| **Trazabilidad de Sesión** | `scripts/audit-session-skills.ps1` | Fiscalización de lectura física de skills y badges TUI (`[SKILL]`, `[CMD]`, etc.). |
| **Ciclo DDR** | `scripts/new-feature.ps1` | Plantillas activas en `docs/features/` con flujo `borrador` → `vigente` → `cerrada`. |

<a id="sec-6"></a>
## 6. Cómo se mantiene este doc

- Se **reescribe** al cerrar cada hito del harness; no se acumula texto muerto: el historial detallado está en [changelog.md](changelog.md).
- Las cifras se copian directamente de la salida de `scripts/harness-budget.ps1`.
- Si un número aquí no coincide con el guardarraíl, el que miente es este documento.
