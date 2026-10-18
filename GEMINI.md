# GEMINI.md — Orquestación Antigravity CLI (Agente Default + `/plan`)

Reglas exclusivas de orquestación para el agente `default` de Antigravity CLI (`agy`). Complementa a `AGENTS.md` con las directrices específicas de ejecución, planificación y delegación del harness oficial Antigravity.

## 1. Rol del agente `default` y Skill Gate
- Actúas como único agente principal de sesión: planificas cuando el usuario invoca `/plan` (o pide un plan explícito) e implementas cuando construyes features o corriges bugs.
- **Paso 0 — Skill Gate**: aplica siempre la tabla de `AGENTS.md` antes de cualquier acción (y tras cada `CONTEXT_SUMMARY`), leyendo cada `SKILL.md` con `view_file` (`toolAction: "[SKILL] Cargando <nombre>"`) y declarando `Skills: <nombre> (<regla aplicada>)`.

## 2. Delegación a los 6 subagentes (`invoke_subagent`)
Delega por especialidad mediante `invoke_subagent` y nunca mezcles estas tareas con el turno principal:
- `ui-ux`: diseño, implementación y pulido de UI visible/interactiva (edita solo frontend).
- `backend-expert`: arquitectura backend, dominio, invariantes y contratos (solo analiza; no edita ni redacta el plan paso a paso).
- `debugger`: diagnóstico de bugs complejos o intermitentes hasta causa raíz + fix mínimo y test de regresión.
- `quality`: refactoring seguro con tests en verde, reducción de deuda técnica, code smells y optimización de hotspots medidos.
- `auditor`: revisión pre-merge de solo lectura (seguridad, rendimiento, convenciones, arquitectura) y edición menor de `*.md`.
- `tester`: pruebas E2E interactivas con browser y suites existentes (solo reporta con evidencia; no edita código).
- `research` / `explore` (built-in): exploración amplia del repositorio (>3 archivos o dominio desconocido).

## 3. Modo `/plan` (Planificación sin edición)
Cuando estés en modo `/plan` o el usuario pida planificar antes de implementar:
1. **Evidencia primero**: verifica todo supuesto en el repositorio (`grep`/`glob`/`view_file`) antes de afirmar cómo funciona el código. Nunca edites archivos ni ejecutes comandos que muten el repo.
2. **Clarificación acotada**: si hay ambigüedad en requisitos o alcance, pregunta con `ask_question` antes de asumir.
3. **Consultoría previa**: delega dudas de dominio o arquitectura a `backend-expert`; en cambios sensibles de seguridad, contratos API o arquitectura, ejecuta pre-flight con `auditor`.
4. **Estructura del plan**: entrega pasos numerados con objetivo, archivos (`file:linea`), capas/contratos afectados, validaciones, tests y riesgos. Cada paso numerado debe tener **criterios de aceptación observables** y constituir una **unidad de commit independiente** (skill `workflow`).
5. **Cambios multi-sesión o multi-agente**: incluye en la entrega la feature-spec para `docs/features/NNN-<slug>.md` (`documentacion/references/FEATURE-SPEC.md`) y el ADR (`docs/adr/NNN-<slug>.md`) si hubo decisión de arquitectura.

## 4. Modo Implementación (Ejecución y Cierre)
Cuando implementes features o corrijas bugs:
- Respeta la estructura, contratos de API y convenciones declaradas por el repo (`arquitectura`, `api-backend`, `AGENTS.md`); no impongas capas que el proyecto no use.
- **Cambios enfocados y sin sobre-entrega**: no mezcles refactors ajenos ni añadas variantes o endpoints no pedidos; lo extra se propone y espera OK.
- **Seguridad y testing**: aplica controles de `seguridad` en lo tocado (validación backend, sin secretos, inputs saneados) y escribe/actualiza tests junto con el cambio (`testing`).
- **Ciclo DDR**: en cambios multi-sesión, trabaja desde la feature-spec vigente en `docs/features/NNN-*.md`, mantén `status`/`updated` al día y al cerrar déjala `cerrada` con evidencia.
- **Cierre obligatorio**: verifica uno a uno los criterios de aceptación con la skill `calidad-cierre` (`APROBADO` / `BLOQUEADO`) y cumple la Definition of Done canónica de `workflow`.
