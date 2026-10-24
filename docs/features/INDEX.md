---
status: vigente
last_reviewed: 2026-10-23
---

# Registro de features implementadas

Lectura rápida por unidad funcional implementada. Cada fila enlaza su evidencia;
el detalle vive en la spec o tarjeta correspondiente, no en este índice.
El trabajo abierto vive en `BACKLOG.md`; al cerrar, su fila se borra y queda este registro.

## Activas

| Fecha | Cambio | Estado | Área | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|---|

## Cerradas

| Fecha | Cambio | Estado | Área | Alcance | Registro | Evidencia |
|---|---|---|---|---|---|---|
| 2026-10-19 | Consolidación de skills a núcleo de 29 y ahorro de tokens | cerrada | harness | Consolidación a 29 skills, estándar High-Craft en DESIGN.md y regla anti-slop en DoD | [001-consolidacion-skills-ahorro-tokens.md](001-consolidacion-skills-ahorro-tokens.md) | `harness-budget.ps1` exit 0, commits `e18c836`..`626c2be` |

## Decisiones (ADR)

| Fecha | Decisión | Estado | Ámbito | Registro |
|---|---|---|---|---|
| 2026-09-28 | RTK como dependencia de máquina | vigente | Rendimiento/costes del harness | [ADR-001](../adr/001-rtk-dependencia-de-maquina.md) |
| 2026-10-17 | Limitación visual de hooks en TUI de Antigravity | vigente | TUI y ciclo de vida de hooks | [ADR-002](../adr/002-limitacion-visual-hooks-tui-antigravity.md) |
| 2026-10-17 | Desglose y contención de overhead de tokens en primer turno | vigente | Presupuesto y Prompt Caching | [ADR-003](../adr/003-desglose-overhead-tokens-primer-turno.md) |
| 2026-10-23 | Trazabilidad portable para todos los proyectos (3 capas + CLI) | vigente | Arquitectura y auditoría de cambios | [ADR-004](../adr/004-trazabilidad-portable.md) |

## Reglas

- Una fila por unidad funcional implementada; los micro-fixes quedan en el changelog.
- El trabajo abierto vive en `BACKLOG.md`; al cerrar, la fila se borra y el registro conserva `tarea: B-NNN`.
- Un cambio auditable usa **spec** (60 líneas o menos, con bitácora por criterio); uno pequeño, **tarjeta** (25 líneas o menos). El umbral canónico: `documentacion` §docs/features.
- Toda spec o tarjeta declara `area` y `tarea` (`-` si no vino del backlog).
- Una decisión irreversible o global se registra como **ADR**; un procedimiento, como guía en `docs/guias/`.
- Si las secciones activas y cerradas superan 40 filas, mueve las cerradas antiguas a `ARCHIVE.md` y conserva aquí solo el resumen.

## Archivado

Vacío por ahora. `ARCHIVE.md` aún no existe; se creará append-only cuando el índice necesite poda.
