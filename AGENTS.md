# AGENTS.md

Plantilla base Antigravity CLI.

## Stack
Ver `.agents/` para skills y config. Si esta seccion sigue vacia al iniciar un proyecto, el agente debe preguntar el stack al usuario (flujo en skill `uso-eficiente`, seccion "Onboarding de stack") o aplicar `inicio-proyecto`.

## Comandos
- `agy` (CLI) · `.\scripts\harness-budget.ps1` (guardarrail) · `.\scripts\new-feature.ps1` (DDR) · `.\scripts\audit-session-skills.ps1` (auditar skills en sesion)

## Skill Gate (obligatorio antes de leer, buscar o editar)

Antes de la primera accion (y tras cada compactacion `CONTEXT_SUMMARY`): identifica skills con la tabla, lee cada `SKILL.md` con `view_file` usando `toolAction: "[SKILL] Cargando <nombre>"` (este archivo NO sustituye a la skill) y declara en tu primer mensaje `Skills: <cargadas (regla aplicada)>`; si omites una candidata, `omitida <nombre>: <motivo>`. Si coinciden varias señales, combina sus skills; carga solo las obligatorias al inicio y las opcionales cuando apliquen. Toda escritura o modificación de código carga `code-clue`, sin que el usuario tenga que pedir comentarios.

| Tipo de tarea | Obligatoria | Opcional (solo si aplica) |
| --- | --- | --- |
| Toda tarea (buscar, leer, planificar, responder) | `uso-eficiente`, `comunicacion-asertiva` | — |
| Escribir o modificar código (cualquier lenguaje o proyecto) | `code-clue` | — |
| Definir producto, alcance, MVP, roadmap o prioridades | `criterio-proyecto` | `ingenieria-software` |
| Plan técnico, dependencias, spike/POC | `ingenieria-software` | `arquitectura` |
| Feature multi-sesión: feature-spec en docs/features | `documentacion`, `ingenieria-software` | `criterio-proyecto`, `contexto-proyecto` |
| Feature backend, dominio, API o jobs en background | `arquitectura`, `api-backend` | `base-datos` |
| Código frontend sin cambio visual | `ui-ux` | `accesibilidad` |
| Diseñar, crear, pulir o revisar UI visible/interactiva | `ui-ux`, `impeccable` | `accesibilidad` |
| Medir UX con métricas (SUS, UMUX-Lite), factores de calidad ISO/IEC 25010/SQuaRE o informe de evaluación de experiencia | `evaluacion-experiencia` | `analisis-datos`, `seguridad`, `ui-ux` |
| Bug no trivial o intermitente | `debugging` | `testing`, `calidad-refactor` |
| Refactor, deuda técnica, code smells o calidad de código | `calidad-refactor` | `testing` |
| Escribir, revisar o correr tests | `testing` | — |
| Esquema, migraciones o seeds | `base-datos` | `seguridad` |
| Auth, inputs, secretos, validación o CORS | `seguridad` | `api-backend` |
| Datos personales, retención o cumplimiento | `seguridad` | — |
| Investigación de hechos externos o actuales | `investigacion-web` | — |
| Analizar datasets, CSV/JSON o métricas | `analisis-datos` | — |
| Automatizar tareas repetitivas con scripts | `automatizacion` | — |
| Usar Notion, Playwright u otra herramienta MCP | `activacion-mcp` | — |
| README, ADR, guía, tutorial o taller | `documentacion` | `contexto-proyecto` |
| Onboarding de proyecto o cambio en `docs/project-brain/` | `inicio-proyecto`, `contexto-proyecto` | — |
| Deploy, pipeline, Docker o IaC | `infra-despliegue` | — |
| Red, TLS, DNS o certificados | `infra-despliegue` | `seguridad` |
| Medir u optimizar rendimiento | `performance` | `observabilidad`, `calidad-refactor` |
| Instrumentar logs, métricas o trazas | `observabilidad` | `debugging` |
| Editar `.agents/` (agentes, skills, config) | `agy-customizations` | — |
| Auditar el harness (skills, agentes, scripts, permisos); pre-flight con `auditor` | `agy-customizations` | `testing` |
| Cierre de implementación o cambio | `calidad-cierre` | `testing`, `seguridad` |
| Commits, ramas o PRs | `workflow` | — |
| Manuales, solo por petición explícita | `habilidades-ofimaticas`, `informe-docx` | — |

Regla anti-omision: si la `description` de una skill menciona un verbo o dominio presente en la tarea, cargala aunque creas conocerla o este resumida aqui.

## Estilo de respuesta (obligatorio para todos los agentes)
Formato por defecto (perfil del usuario: directo, sin rodeos):
1. **Primera linea = veredicto**: `Hecho:` / `Pendiente:` / `Bloqueado:` + resumen en una frase.
2. **Maximo 5 bullets** con lo esencial: que se hizo, que falta, que decision tuya falta.
3. Termina si hace falta con `¿Detallo algo?`; nunca expandas sin que te lo pidan.
Excepciones (detalle COMPLETO aunque rompa el limite): preguntas de clarificacion, planes, ADRs y docs; hallazgos BLOCKER, riesgos de seguridad/perdida de datos o decisiones irreversibles. Prohibido: preambulos, repetir el plan, re-explicar lo ya dicho. Doctrina de redaccion, densidad y diagramas: skill `comunicacion-asertiva` (en preguntas puras responde sin etiquetas; respeta "modo detallado" como override del usuario).

## Definition of Done
Canonica en la skill `workflow` (lint/typecheck/tests, diff, secretos, cambios enfocados con tests, docs, contratos API, UI+impeccable). No la dupliques.

## Tokens y contexto
Reglas en la skill `uso-eficiente`; detalle en `.agents/skills/uso-eficiente/references/TOKEN-SAVING.md` (leerlo en exploracion amplia). `grep`/`glob` antes que `read`; no re-leas archivos ya vistos: este archivo es cache. **Ante la duda:** lee este archivo y `docs/project-brain/INDEX.md` (si existe) antes de preguntar o asumir. **Fuera del repo:** no explores rutas externas salvo que la tarea nombre la ruta o el repo no responda.

## Manejo de `.gitignore`
Puedes crear `.gitignore` (raiz o subdirectorios) y agregar entradas. **Nunca elimines ni sobrescribas las existentes**: si hay conflicto, consulta al usuario.

## Agentes
- Primarios (Sesión): `build`, `plan`.
- Subagentes (invoke_subagent): `ui-ux` (frontend, edita), `backend-expert` (solo analiza y planifica), `auditor`, `tester`, `quality`, `debugger`, `explore`. No invocan a nadie: reportan y quien los delego decide.
- `calidad-cierre` es el gate de cierre (delegable); no sustituye `testing`, `seguridad`, `auditor` ni las skills de diseño.
- Modelos se asignan manualmente por agente.
