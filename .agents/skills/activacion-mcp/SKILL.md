---
name: activacion-mcp
description: Guía la activación y uso de servidores MCP opt-in del proyecto, como Notion y Playwright. Usar cuando una tarea necesite una herramienta MCP.
---

# Activación de herramientas MCP

Los servidores MCP son opt-in por proyecto en Antigravity; no se activan sin que la tarea lo requiera.

| Integración | Herramienta | Configuración |
| --- | --- | --- |
| QA | Playwright | `.agents/mcp_config.json` |
| Notion | Notion | `.agents/mcp_config.json` |

- Comprueba que la herramienta MCP esté declarada en `.agents/mcp_config.json` y que la tarea realmente necesite ese MCP.
- En Antigravity CLI, los servidores MCP se configuran de forma declarativa en `.agents/mcp_config.json` (o a través de plugins en `.agents/plugins/`).
- Si la sesión actual no tiene disponibles las herramientas MCP esperadas, no finjas que lo están: indica al usuario qué configuración falta en `.agents/mcp_config.json` y que reinicie la sesión de `agy`.
- No habilites MCP globalmente sin necesidad y no cambies OAuth, credenciales o configuración sin autorización explícita.
- Para sincronizar tareas con Notion, carga las reglas operativas de [notion.md](../../../docs/harness/notion.md) después de confirmar que el MCP está activo.
- Playwright se usa solo para QA solicitado; sigue las restricciones y permisos del proyecto.
