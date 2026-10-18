---
status: vigente
last_reviewed: 2026-10-03
confidence: confirmado
source: verificado contra el repo el 2026-10-03
---

# Arquitectura del harness

> **Para qué:** saber dónde vive cada responsibility y qué invariantes se rompen si tocas algo.
> **Cifras:** salen de [presupuestos.md](../harness/presupuestos.md) y las implementa `scripts/harness-budget.ps1`.

## Capas

| Capa | Dónde vive | Qué contiene | Quién la lee |
| --- | --- | --- | --- |
| Bootstrap | `AGENTS.md` (tope 75 líneas en `presupuestos.md`) | tabla del Skill Gate por tipo de tarea, estilo y contexto | todos los agentes, en cada sesión |
| Doctrina | `.agents/skills/` (38) | skills por tarea/dominio; referencias bajo demanda | el agente que la carga |
| Contratos | `.agents/agents/` (8, 317 líneas) | rol, modo y directivas de comportamiento | el runtime de Antigravity CLI |
| Permisos | `.agents/hooks/` (`hooks.json`, `pre-tool-enforcer.ps1`) | enforcer de seguridad y control de acceso | el motor de hooks |
| Verificación | `scripts/harness-budget.ps1` | guardarraíl de presupuestos, higiene y codificación | el ejecutor y CI/pre-commit |
| Documentación | `docs/` | `harness/` (vigente), `features/` (specs), `specs/` (historia) y este cerebro | personas y agentes |

## Invariantes

Si uno cae, el harness se pudre en silencio. Los verifica `harness-budget.ps1` (exit 1).

1. **Presupuesto**: todo lo de arriba dentro de los topes de `presupuestos.md`; manda el guardarraíl, no el criterio.
2. **Higiene Antigravity**: cero binarios (`.exe`, `.bin`), codificación estricta UTF-8 sin BOM, fin de línea LF, sin mojibake.
3. **Permisos**: `plan`, `backend-expert` y `tester` nunca editan; `auditor` solo `*.md`; los subagents no se invocan entre sí; enforcer MD5 inmutable.
4. **Fail-closed**: sin `name`/`description` en el frontmatter la skill no se anuncia; guardarraíl en rojo bloquea el flujo.
5. **Un dato, un lugar**: los topes en `presupuestos.md`, el ruteo en `AGENTS.md`, las features multi-sesión en `docs/features/`.

## Flujo de una tarea

`usuario` → primario (`build` | `plan`) → subagents (`invoke_subagent`) → `calidad-cierre` → commit con tu "sí".

El detalle por actor está en [pipeline.md](../harness/pipeline.md).

## Dónde no va nada

- **Checklists sin spec**: el plan vive en la entrega de `plan`; los cambios multi-sesión usan `docs/features/NNN-*.md` y registro en el changelog.
- **Decisiones de arquitectura**: van a `docs/adr/` el día que haya una (`documentacion` §Qué se documenta).
- **Lógica del harness duplicada**: se enlaza, no se copia (regla de la propia [pipeline.md](../harness/pipeline.md)).
