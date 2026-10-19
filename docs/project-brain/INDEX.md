---
status: vigente
last_reviewed: 2026-10-19
confidence: confirmado
source: harness verificado en el repo el 2026-10-19 (ver ../harness/changelog.md)
---

# Contexto del proyecto — HarnessConfig (plantilla de Antigravity)

Fuente de verdad organizada. **Carga solo lo relevante; nunca todo el directorio.**
Este repo no es una app: su conocimiento vive en `docs/harness/` y este índice lo enruta.

> **Para quién:** agentes y devs — un índice de 1 min antes de bucear el repo.

## Documentos

| Doc | Contenido | Cargar cuando | Estado |
| --- | --- | --- | --- |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Capas del harness, invariantes y flujo de una tarea | dónde va un cambio, qué no se rompe, permisos | vigente |
| [estado-actual.md](../harness/estado-actual.md) | Inventario vigente: agentes, skills, guardarraíl, sync, config global | "qué existe hoy", antes de tocar el harness | vigente |
| [pipeline.md](../harness/pipeline.md) | El paso a paso operativo por actor (fases 1-5) y permisos | cómo se ejecuta una tarea, quién delega a quién | vigente |
| [registro.md](../harness/registro.md) | Canon unificado: micro-fixes, tarjetas, specs, ADRs e índice | antes de registrar o iniciar una feature | vigente |
| [presupuestos.md](../harness/presupuestos.md) | Los topes del harness y su porqué | antes de añadir líneas, palabras o archivos | vigente |
| [features/](../features/INDEX.md) | Especificaciones de features multi-sesión y sus tarjetas | cambio multi-sesión o trazabilidad de features | vigente |
| [guias/](../guias/README.md) | Procedimientos y runbooks operativos paso a paso | ejecutar procedimientos o instalaciones | vigente |
| [changelog.md](../harness/changelog.md) | Registro append-only: un cambio por entrada, con criterios si es largo | "¿se hizo ya?", por qué algo cambió | vigente |
| [notion.md](../harness/notion.md) | Reglas de sincronización con Notion vía MCP | perfil Notion activo y tarea en Notion | vigente |
| [specs/](../specs/) | `001` tokens, `002` review de UI, `003` retirada sdd-lite, `004` runbook | trazar decisiones antiguas | obsoleto (histórico) |
| [ADR-001](../adr/001-rtk-dependencia-de-maquina.md) | RTK como dependencia de máquina | integración o cambio de RTK | vigente |
| [ADR-002](../adr/002-limitacion-visual-hooks-tui-antigravity.md) | Limitación visual de hooks en TUI | comportamiento de hooks en consola | vigente |
| [ADR-003](../adr/003-desglose-overhead-tokens-primer-turno.md) | Desglose y contención de overhead de tokens | optimización de tokens y Prompt Caching | vigente |

## Reglas del cerebro

- Actualización solo tras cambio verificado (`calidad-cierre`), nunca por edición.
- Solo se actualizan los documentos afectados por el cambio.
- Datos sin evidencia llevan `confidence: supuesto` y `status: pendiente`.
- Contradicción doc/código: reportar, no corregir automáticamente.
- Este índice se mantiene ≤ 60 líneas; si crece, resumir filas.
- La intención de un cambio multi-sesión vive en `docs/features/NNN-*.md` y su registro en el changelog; las decisiones de arquitectura, en `adr/`.
