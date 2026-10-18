---
name: inicio-proyecto
description: Inicia o reaprovecha un proyecto con las skills, agentes y config del harness Antigravity: preguntas de stack, BD, UI y producto, y genera PRODUCT.md, DESIGN.md y AGENTS.md mergeado. Usar al empezar un proyecto nuevo o existente que adopte el harness.
---

# Inicio de proyecto con harness Antigravity

Adopta o inicia un proyecto con las directivas de Antigravity CLI. Genera la tríada de contexto (`PRODUCT.md`, `DESIGN.md`, `AGENTS.md`) y siembra el cerebro documental en `docs/project-brain/`.

## Flujo

0. **Escaneo previo del destino** (si el proyecto ya existe): listar `.agents/` local y contrastar con la configuración existente. Si existen configuraciones obsoletas, pregunta al usuario antes de sobrescribir.
1. **Preguntas progresivas** (5-7 por turno, no un monólogo):
   - Bloque A: nombre del proyecto, descripción breve, tipo (web/app/api/cli), público objetivo.
   - Bloque B: stack frontend (Angular/React/Vue/Svelte/ninguno), stack backend (Django/Spring/Laravel/NestJS/.NET/ninguno), lenguaje principal.
   - Bloque C: base de datos (PostgreSQL/MySQL/MongoDB/SQLite/otra), ORM si aplica, testing framework preferido.
   - Bloque D: estilo visual (minimalista/colorido/corporativo/gaming), componentes UI preferidos, accesibilidad, animaciones.
   - Bloque E: alcance inicial (MVP/hackathon/producción), prioridades (velocidad/calidad/ambas), Figma/wireframes, API externa.
2. **Copiar config del proyecto**:
   - Copiar las directivas necesarias del harness en `.agents/` y los hooks en `.agents/hooks.json`.
   - Servidores MCP opt-in: si el usuario requiere QA (Playwright) o Notion, configura `.agents/mcp_config.json`.
3. **Generar docs**:
   - `PRODUCT.md` y `DESIGN.md` desde templates en `references/` con las respuestas.
   - `AGENTS.md`: merge por secciones (Stack/Comandos se actualizan con lo descubierto; el resto se preserva).
   - `docs/project-brain/`: siembra `INDEX.md` + 2-4 documentos (`PRODUCT.md` de detalle, `ARCHITECTURE.md` inicial).
4. **Cierre**: resume qué se creó y qué archivos quedaron pendientes de ajustar.

## Reglas

- Pregunta en bloques chicos; no des 20 preguntas seguidas.
- No crees subagentes nuevos; usa los del roster en `.agents/agents/`.
- `impeccable` es guía propia del harness en texto: edítala solo con `agy-customizations`.
- No corras `/init`; el merge de AGENTS.md lo reemplaza.
- No copies `node_modules` ni `.git` del template.
- El contenido del cerebro sigue las reglas de la skill `contexto-proyecto`.
