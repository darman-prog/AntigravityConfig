# Auditoría de Subagentes — Antigravity CLI

> **Para qué:** delimitar fronteras, eliminar solapes de roles, restringir permisos y mantener el presupuesto de contexto.
> **Cuándo leerla:** antes de tocar `.agents/agents/`, al delegar con `invoke_subagent` o al revisar el presupuesto.
> **Fecha:** 2026-10-17 · **Estado:** vigente · **Plataforma:** Antigravity CLI (`agy`).

## 1. Resumen de Consolidación

El harness se adaptó a la arquitectura nativa de Antigravity CLI consolidando los roles primarios (`build` y `plan`) dentro del agente de sesión `default` mediante `GEMINI.md`, dejando en `.agents/agents/` estrictamente los **6 subagentes especializados**.

- **0 agentes con solape grave** tras el refactor.
- **1 bypass de escritura corregido**: `auditor` restringe `git diff --output` mediante denegación explícita.
- **6 subagentes especializados**: `ui-ux`, `backend-expert`, `auditor`, `debugger`, `quality`, `tester`.
- **Presupuesto consolidado**: **237 líneas** en total (tope 350 líneas, promedio ≤45 líneas c/u).

## 2. Hallazgos y Estado de Mitigación

| Severidad | Hallazgo | Mitigación |
| :--- | :--- | :--- |
| **BLOCKER** | `auditor` es de solo lectura pero `git diff*` permitía `git diff --output=<archivo>`, que escribe en disco. | **Corregido**: Bloqueado explícitamente `*--output*`, `git apply*`, `git checkout*`, `git restore*`, `git stash*`. |
| **WARNING** | El agente prescribía capas `domain/application/adapters/infrastructure` y `traceId` en stacks donde no existen. | **Corregido**: No se imponen capas ajenas a la arquitectura preexistente del proyecto. |
| **WARNING** | `debugger` derivaba huecos de seguridad a `auditor`, que no tiene permisos de edición de código. | **Corregido**: La remediación de seguridad se ejecuta directamente o se reporta con test de regresión. |
| **WARNING** | `ui-ux` pedía animaciones complejas por defecto, inflando diffs innecesariamente. | **Corregido**: Principio anti-slop y minimalismo de la doctrina Impeccable. |
| **WARNING** | `quality` forzaba métricas de rendimiento en refactoring simple sin hotspot medido. | **Corregido**: Medición previa obligatoria antes de optimizar. |
| **WARNING** | `backend-expert` duplicaba el plan paso a paso en lugar de analizar invariantes. | **Corregido**: Su rol es consultoría de arquitectura y dominio; no redacta el plan de ejecución. |

## 3. Fronteras y Roles en Antigravity CLI

| Agente | Ámbito | Lo que NO hace |
| :--- | :--- | :--- |
| **`default`** (`/plan`) | Planificación sin edición en `/plan`; implementación en modo normal | No mezcla refactors ajenos a la tarea |
| **`backend-expert`** | Dominio, invariantes, contratos de API | No da planes de implementación ni toca código |
| **`ui-ux`** | UI visible, jerarquía visual, maquetación, WCAG | No toca lógica de backend ni E2E complejo |
| **`debugger`** | Diagnóstico hasta causa raíz + fix mínimo y regresión | No diseña features nuevas ni refactoriza |
| **`quality`** | Refactoring seguro y optimización medida | No aplica optimizaciones sin benchmark previo |
| **`tester`** | Pruebas funcionales E2E con browser | No edita código ni resuelve bugs |
| **`auditor`** | Revisión pre-merge de seguridad, estilo y convención | Solo edita `*.md`; nunca escribe código |

## 4. Permisos de Solo Lectura (`auditor`)

`auditor` conserva lectura de Git (`git status/log/diff`) y bloquea los vectores de escritura:

```yaml
bash:
  "*": ask
  "git diff*": allow
  "git log*": allow
  "git status*": allow
  "*--output*": deny
  "git apply*": deny
  "git checkout*": deny
  "git restore*": deny
  "git stash*": deny
```

## 5. Verificación de Invariantes

- Ningún subagente invoca a otros subagentes: la delegación es estrictamente centralizada desde el agente principal `default`.
- El guardarraíl `scripts/harness-budget.ps1` valida el presupuesto (237 líneas ≤ 350) y que los 6 subagentes posean frontmatter fail-closed.
