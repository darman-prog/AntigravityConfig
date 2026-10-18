# Flujo de tareas con Notion — Antigravity CLI

> **Para qué:** sincronizar el plan y el avance de un proyecto con Notion sin convertirlo en la fuente de verdad.
> **Cuándo leerlo:** cuando el MCP de Notion está activo y el usuario pide registrar o consultar el flujo del proyecto.

Git es la fuente de verdad; Notion solo refleja el estado. Nunca reconstruyas estado desde Notion. Para activar herramientas MCP opt-in, sigue la skill [activacion-mcp](../../.agents/skills/activacion-mcp/SKILL.md).

## Requisitos

- Servidor MCP de Notion registrado y habilitado en Antigravity CLI (`agy mcp list` / `agy mcp enable notion`).
- Integración OAuth configurada en Notion con acceso limitado a las bases de datos del portafolio.
- API 2025-09-03 usa `data_source_id` (no `database_id`) en queries.

## Plantilla de bases de datos (crear una vez en Notion)

- **Proyectos**: nombre, estado (Activo/Pausado/Completado), ruta repo, stack.
- **Fases**: relación a Proyecto, orden, estado (Plan/En progreso/Hecho).
- **Tareas**: relación a Fase, estado (Todo/Doing/Done), tipo (feat/fix/refactor/test/docs/chore), link commit, evidencia.

Vistas recomendadas: Kanban por estado y tablero por proyecto. Página maestra "Portafolio" con template duplicable.

## Reglas de sincronización automática

1. **Al entregar plan numerado** (agente `default` en modo `/plan`):
   - Crear página Fase vinculada al Proyecto en Notion.
   - Por cada paso del plan, crear Tarea con estado Todo, tipo según la acción (`feat`/`fix`...).
   - Responder con IDs de las páginas creadas para trazabilidad.

2. **Al proponer commit de paso** (skill `workflow`, sección "Commits por paso de plan"):
   - Antes de commitear, mover la Tarea correspondiente a Doing.
   - Tras el commit aprobado por el usuario, mover a Done y registrar el link del commit.

3. **Al cerrar feature** (DoD completa, PR mergeado o feature terminada):
   - Actualizar estado del Proyecto a "Completado" si todas las Fases están en Hecho.
   - Dejar evidencia en la página del Proyecto (resumen, links a commits clave).

4. **Consultas manuales**: el usuario puede pedir "muéstrame tareas pendientes del proyecto X" o "resume avance de la Fase 2" — el agente consulta Notion vía MCP y responde.

## Comandos útiles (vía MCP Notion)

- `search` — buscar páginas o bases por nombre.
- `query-data-source` — listar tareas de una base con filtros.
- `create-page` — crear tarea/fase/proyecto.
- `update-page` — mover tarea a Done, actualizar estado.
- `retrieve-page` — leer detalles de una página.

## Restricciones

- Sigue este flujo solo cuando el MCP de Notion esté activado y responda correctamente.
- No escribe en Notion sin que el agente haya terminado la acción en git (commit, merge, etc.).
- Si el MCP falla o no está disponible, el agente continúa sin sincronizar y avisa en una sola línea.
