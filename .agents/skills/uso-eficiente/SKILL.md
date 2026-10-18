---
name: uso-eficiente
description: Estrategia transversal de bajo consumo de tokens: grep/glob antes que read, batch de tool calls, delegar a explore, cache de contexto, onboarding de stack. Usar en toda tarea — buscar, leer, planificar o responder.
---

# Uso Eficiente

Skill transversal. Se activa en toda tarea para evitar derroche de tokens.

## 1. AGENTS.md

- Si no existe: informa en una linea, crea `AGENTS.md` minimo (estructura, stack, comandos, esta skill).
- Si existe, leelo al inicio y no re-explores el repo.
- Si "Stack" sigue siendo el placeholder de la plantilla: pregunta con `ask_question` (frontend / backend / BD / gestor / testing), escribe las respuestas en "Stack" y "Comandos", confirma en una linea o aplica la skill `inicio-proyecto`.

## 2. Busqueda, lectura y skills

- `grep`/`glob` antes que `read`; `read` con `offset`/`limit` al bloque minimo.
- Batch: llamadas independientes en un turno; secuencial solo si B depende de A.
- Delega a `explore` con >3 archivos o dominio desconocido. 3+ pasos → `todowrite`.
- Skills: lee cada `SKILL.md` con `view_file` (`toolAction: "[SKILL] Cargando <nombre>"`); re-leelas si hubo `CONTEXT_SUMMARY` y declara `Skills: <nombre> (<regla aplicada>)`. Nunca precargar ni declarar sin haber leido.
- Al correr tests: carga `testing` primero y lidera con el runner directo del proyecto (ej. `npx vitest run`, `pytest`); `npm test` solo como último recurso.
- Nunca recorrer `node_modules/`, `.git/`, `dist/`, `build/`, `__pycache__/`; acota con filtros.

## 3. Delegacion por tipo

- Exploracion → `explore` · Feature fullstack → `build` · UI → `ui-ux` · Refactor/deuda/performance → `quality` · Bug complejo → `debugger` · Revision pre-merge → `auditor` · Tests E2E → `tester`.
- No ejecutes secuencialmente lo que un subagente puede hacer aislado.
- Retorno: ≤30 lineas, evidencia `file:linea`, sin pegar logs; resume.

## 4. Respuestas y anti-patrones

- Directo y sin rodeos: la doctrina de redaccion, densidad y diagramas vive en `comunicacion-asertiva` (obligatoria en toda tarea); aqui solo el criterio de tokens. Usa `file:linea`.
- Anti-patrones: releer archivos ya leidos; leer completos para buscar una funcion; crear documentacion no pedida; cargar skills "por si acaso"; afirmar conocer una skill sin cargarla.
- **Salida larga de comandos**: usa banderas que limiten salida o filtros nativos del comando (`--summary`, `-q`, `Select-Object -First`, `head`, etc.) para no saturar tokens de contexto con logs gigantes.

## 5. Cierre y contexto

- Autochequeo: skills obligatorias cargadas? mas de 3 archivos sin delegar? directorios ignorados? resumenes no pedidos? Si algo es "si" (salvo la primera), corrige o justifica en una linea.
- Confia en `compaction.auto`; si el usuario nota respuestas fuera de contexto, sugiere reiniciar sesion.
- Tacticas ampliadas: [TOKEN-SAVING.md](references/TOKEN-SAVING.md).

## 6. Protocolo de Badges en la TUI

Las acciones mostradas en la consola Antigravity (`toolAction`) DEBEN usar prefijos estandarizados:
- `[SKILL] Cargando <nombre>`: Exclusivo para lectura de archivos `SKILL.md`.
- `[CMD] <descripcion>`: Para ejecuciones de comandos con `run_command`.
- `[FILE] <accion> <archivo>`: Para lectura o edicion de codigo y docs (no skills).
- `[TEST] <suite>`: Para ejecucion y validacion de pruebas.
- `[SUBAGENT] <nombre>`: Para invocacion de subagentes con `invoke_subagent`.
