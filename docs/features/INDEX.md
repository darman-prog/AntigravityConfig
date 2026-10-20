---
status: vigente
last_reviewed: 2026-10-19
---

# Registro de features implementadas

Lectura rápida por unidad funcional implementada. Cada fila enlaza su evidencia;
el detalle vive en la spec o tarjeta correspondiente, no en este índice.

## Activas

| Fecha | Cambio | Estado | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|

## Cerradas

| Fecha | Cambio | Estado | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|
| 2026-10-19 | Consolidación de skills a núcleo de 29 y ahorro de tokens | cerrada | Consolidación a 29 skills, estándar High-Craft en DESIGN.md y regla anti-slop en DoD | [001-consolidacion-skills-ahorro-tokens.md](001-consolidacion-skills-ahorro-tokens.md) | `harness-budget.ps1` exit 0, commits `e18c836`..`626c2be` |

## Decisiones (ADR)

| Fecha | Decisión | Estado | Ámbito | Registro |
|---|---|---|---|---|
| 2026-09-28 | RTK como dependencia de máquina | vigente | Rendimiento/costes del harness | [ADR-001](../adr/001-rtk-dependencia-de-maquina.md) |
| 2026-10-17 | Limitación visual de hooks en TUI de Antigravity | vigente | TUI y ciclo de vida de hooks | [ADR-002](../adr/002-limitacion-visual-hooks-tui-antigravity.md) |
| 2026-10-17 | Desglose y contención de overhead de tokens en primer turno | vigente | Presupuesto y Prompt Caching | [ADR-003](../adr/003-desglose-overhead-tokens-primer-turno.md) |

## Reglas

- Una fila por unidad funcional implementada; los micro-fixes quedan en el changelog.
- Toda feature de una sesión se registra con una **tarjeta** (25 líneas o menos); una feature multi-sesión, con una **spec** (45 líneas o menos).
- Una decisión irreversible o global se registra como **ADR**; un procedimiento, como guía en `docs/guias/`.
- Si las secciones activas y cerradas superan 40 filas, mueve las cerradas antiguas a `ARCHIVE.md` y conserva aquí solo el resumen.

## Archivado

Vacío por ahora. `ARCHIVE.md` aún no existe; se creará append-only cuando el índice necesite poda.