# Presupuestos del harness — Antigravity CLI

> **Para quién:** dev junior — cifras y su porqué; lectura en 1 min.
> **Fuente única:** estos topes viven aquí. `scripts/harness-budget.ps1` los implementa como constantes y falla (`exit 1`) si se exceden, nombrando archivo y valor infractor.

| Constante | Valor | Qué mide |
| :--- | :--- | :--- |
| `MAX_AGENTS_MD_TOTAL` | 75 líneas | `AGENTS.md`: se inyecta en **cada** sesión de `agy` |
| `MAX_AGENTS_TOTAL` | 350 líneas | Los 6 subagentes de `.agents/agents/` en total (actual: 237) |
| `MAX_AGENT` | 45 líneas | Un subagente individual (tope estricto de prompt) |
| `MAX_SKILL` | 65 líneas | Una skill que se auto-activa bajo demanda |
| `MAX_SKILL_EXENTA` | 180 líneas | Exentas: vendor o manuales (se cargan bajo demanda) |
| `MAX_DESC` | 45 palabras | `description` de una skill (es su gatillo de ruteo) |
| `MAX_DESC_MANUAL` | 25 palabras | `description` de las 2 skills manuales |

**Exentas del tope de líneas** (`MAX_SKILL_EXENTA`): `ofimatica` (manual). `impeccable` y `ui-ux` cumplen el tope estándar de ≤65 líneas con sus playbooks y guías en `references/`.
**Con description de 25 palabras** (`MAX_DESC_MANUAL`): `ofimatica`.

---

## Por qué

- `AGENTS.md` y `GEMINI.md` se evalúan en cada sesión → 1 línea de más se paga en cada turno. Los subagentes y las skills solo se cargan cuando se invocan, por eso tienen límites modulares.
- Las manuales y las vendor se cargan bajo demanda → toleran más cuerpo; su `description`, que se expone en el catálogo de herramientas del sistema, va corta.
- Los conteos se derivan por glob (`Get-ChildItem`), no hay cifras fijadas en el script: agregar o quitar un archivo no requiere tocar el presupuesto manualmente.
- `MAX_AGENTS_TOTAL` está fijado en **350 líneas** para los 6 subagentes especializados (`auditor`, `backend-expert`, `debugger`, `quality`, `tester`, `ui-ux`), promediando ~39 líneas por subagente.
- `docs/specs/*` es archivo histórico de especificaciones previas; las nuevas especificaciones siguen el ciclo DDR en `docs/features/`.

---

## Verificar

```powershell
powershell -NoProfile -File .\scripts\harness-budget.ps1
```

- **Exit 0** = todo dentro de presupuesto.
- **Exit 1** = lista cada violación con archivo, línea y valor detectado.
- Además de líneas, el script valida contratos:
  - Frontmatter fail-closed (`name`, `mode`, `subagent`).
  - Integridad de codificación: UTF-8 puro sin BOM, cero mojibake ni caracteres de control invisibles.
  - Grafo acíclico de delegación.
  - Subagentes de solo lectura sin vectores de escritura en bash.
  - Validez de Lifecycle Hooks en `.agents/hooks.json`.
  - Cero binarios ni residuos externos en archivos activos.

---

## Telemetría y Medición de Tokens en Antigravity CLI

- **Telemetría continua nativa**: El panel `Context Usage` de `agy` CLI muestra en tiempo real el desglose de tokens del context window de 1.0M (`System tools`, `System prompt`, `Skills`, `Subagents`, `User messages`, `Agent responses`, `Tool calls`).
- **Registro en `transcript.jsonl`**: En cada sesión, `transcript.jsonl` almacena los valores exactos de `input_tokens`, `output_tokens` y `cache_read_tokens` por cada turno ejecutado.
- **Prompt Caching de Google Gemini**: Los bloques estáticos del prompt del sistema (~24.8k tokens de infraestructura base) quedan automáticamente en caché del servidor, por lo que los turnos subsiguientes se atienden con coste de cuota cercano a cero y mínima latencia.
- **Auditoría de sesión**: `scripts/audit-session-skills.ps1` fiscaliza el cumplimiento estricto del Skill Gate y el protocolo de badges TUI directamente sobre el archivo de log de la sesión activa.
