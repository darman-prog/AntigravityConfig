# Documentacion del repositorio

> **Para quién:** dev junior con TDAH — índice corto; leer en 1 min.
> **Para qué:** saber dónde está cada cosa sin bucear el repo.
> **Qué es:** un harness de ingeniería para Antigravity CLI (skills, 6 subagentes, presupuesto y verificación) que se instala en tus proyectos para trabajar con contexto pequeño y cambios verificables.

| Carpeta | Qué hay | Cuándo la necesitas |
| --- | --- | --- |
| [harness/](harness/) | [estado-actual.md](harness/estado-actual.md) (inventario) · [pipeline.md](harness/pipeline.md) (flujo operativo) · [notion.md](harness/notion.md) (integración Notion) · [changelog.md](harness/changelog.md) (historial) · [presupuestos.md](harness/presupuestos.md) (topes) · [auditoria-subagentes.md](harness/auditoria-subagentes.md) (roles) · [auditoria-complementacion.md](harness/auditoria-complementacion.md) (cobertura) | Cambiaste agentes, skills, permisos o el presupuesto del harness |
| [project-brain/](project-brain/) | Cerebro documental: [INDEX.md](project-brain/INDEX.md) (el índice que se carga siempre) · [ARCHITECTURE.md](project-brain/ARCHITECTURE.md) (capas e invariantes) | Estás con dudas de "qué hay, dónde vive o qué no se rompe" |
| [guias/](guias/) | Procedimientos y runbooks paso a paso: setup, instalación de dependencias, scripts de recuperación | Necesitas ejecutar un procedimiento operativo o rehacer una configuración |
| [features/](features/) | Registro DDR: índice en [INDEX.md](features/INDEX.md); una **tarjeta** por feature de una sesión (`NNN-<slug>.md`, ≤25 líneas) y una **spec** si es multi-sesión (≤45 líneas). Plantillas en [FEATURE-SPEC.md](../.agents/skills/documentacion/references/FEATURE-SPEC.md) y [FEATURE-CARD.md](../.agents/skills/documentacion/references/FEATURE-CARD.md) | Definir, reanudar o cerrar una feature; ver qué se construyó |
| [adr/](adr/) | Decisiones irreversibles o globales: [001](adr/001-rtk-dependencia-de-maquina.md) (RTK), [002](adr/002-limitacion-visual-hooks-tui-antigravity.md) (Hooks TUI), [003](adr/003-desglose-overhead-tokens-primer-turno.md) (Tokens primer turno). No se editan: una decisión nueva crea otro ADR | Saber por qué el harness es como es |
| [specs/](specs/) | Archivo histórico: `001` (ahorro de tokens), `002` (review de UI) y `003` (retirada de sdd-lite); `004` es un runbook one-off de instalación de la skill `evaluacion-experiencia`. La documentación activa vive en `docs/features/`. | Consultar decisiones o runbooks históricos |

**Glosario (6 palabras):** feature = unidad de trabajo; tarjeta = su registro en una sesión; spec = su registro si dura más; ADR = decisión irreversible; guía = procedimiento; changelog = historial.

**Verde** = el guardarraíl pasa (`scripts/harness-budget.ps1`) y los contratos/invariantes están íntegros; no dice si tu producto es correcto.
**Tras cambiar skills o config:** `.\scripts\publish-global-agy.ps1` para sincronizar al plugin global de Antigravity; `.\scripts\harness-budget.ps1` comprueba los presupuestos.

**Regla:** la documentación del harness vive en `docs/harness/`, nunca dentro de `.agents/`
(que es la carpeta de runtime: agentes, skills y hooks). El guardarraíl lo verifica.
