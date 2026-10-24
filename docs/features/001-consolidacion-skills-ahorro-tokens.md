---
id: 001
status: cerrada
area: harness
tarea: -
created: 2026-10-19
updated: 2026-10-19
---
# Feature 001 — Consolidación de skills a núcleo de 29 y ahorro de tokens

> Reducir el catálogo de skills de 38 a 29 para ahorrar tokens fijos por turno y eliminar parálisis de decisión, preservando el 100% del conocimiento técnico e integrando el estándar visual High-Craft / Linear y la auditoría Anti-Slop en la DoD.

## Objetivo
Un catálogo de skills denso, libre de duplicidades y con menos de 3,600 tokens de metadata base, con el guardarraíl de presupuesto en exit 0, arquetipo de diseño High-Craft / Linear estructurado en tokens y regla de entrega Anti-Slop.

## Contexto
El análisis de tokens demostró que 38 skills cargan ~5.0k tokens en cada mensaje. La duplicidad entre skills similares (ej. testing vs tdd, code-quality vs refactoring) divide el contexto innecesariamente.

## Alcance
| Incluye | Excluye |
|---|---|
| Fusión de las 9 duplicidades en 29 skills canónicas; actualización de `scripts/trigger-probes.json`; actualización de tablas en `AGENTS.md` y `GEMINI.md`; actualización de agentes `quality.md` y `ui-ux.md`; creación de `docs/DESIGN.md` con tokens de arquetipo High-Craft / Linear; regla Anti-Slop en la Definition of Done (`workflow/SKILL.md`) y gate en `calidad-cierre`. | Modificar las skills del núcleo esencial (`uso-eficiente`, `comunicacion-asertiva`, `code-clue`, `workflow`, etc.). |

## Criterios de aceptación (Given-When-Then)
| N.º | Escenario / Condición | Resultado Esperado | Evidencia |
|---|---|---|---|
| 1 | Dado el repositorio con 38 skills, Cuando se ejecuta la consolidación | Quedan exactamente 29 carpetas en `.agents/skills/` | `Get-ChildItem .agents/skills` retorna 29 directorios |
| 2 | Dado el catálogo de 29 skills, Cuando se corre `scripts/harness-budget.ps1` | Finaliza con `exit 0` y 0 violaciones de probes | `harness-budget.ps1` exit 0 |
| 3 | Dado el enforcer de seguridad, Cuando se valida el hook `pre-tool-enforcer.ps1` | Su hash MD5 sigue siendo `93F4BBD789AAD058B247D5A51B73719F` | `Get-FileHash` retorna `93F4BBD789AAD058B247D5A51B73719F` |
| 4 | Dado el nuevo catálogo, Cuando se sincroniza el plugin global | `publish-global-agy.ps1` finaliza con éxito publicando 29 skills | Ejecución exitosa de `publish-global-agy.ps1` |
| 5 | Dado el estándar UI del harness, Cuando se audita la entrega visual | Existe `docs/DESIGN.md` (arquetipo High-Craft / Linear estructurado por tokens) y la DoD incluye la regla Anti-Slop AI bloqueante | `docs/DESIGN.md` vigente y punto 7 en `workflow/SKILL.md` |

## Matriz de Edge Cases
| Caso Límite | Comportamiento Esperado | Manejo de Error / Fallback |
|---|---|---|
| Un subagente pide una skill renombrada (ej. `refactoring`) | Se actualizan las instrucciones de los subagentes para invocar `calidad-refactor` | Sweep previo en `.agents/agents/*.md` |
| Falso positivo en probes de trigger | `scripts/trigger-probes.json` mapea las keywords a las 24 skills | Validación incremental por commit |

## Pasos
1. Inicializar la feature-spec con `new-feature.ps1` y actualizar `docs/features/INDEX.md`.
2. Consolidar Testing y Calidad de Código (`testing` y `calidad-refactor`).
3. Consolidar UI y Frontend (`impeccable` y `ui-ux`), crear `docs/DESIGN.md` (arquetipo High-Craft / Linear) y blindar la regla Anti-Slop en la Definition of Done.
4. Consolidar Infraestructura, Arquitectura y Seguridad (`infra-despliegue`, `arquitectura`, `seguridad`).
5. Consolidar Ofimática (`ofimatica`).
6. Actualizar Skill Gate en `AGENTS.md` / `GEMINI.md`, probes en `trigger-probes.json`, validar guardarraíl y resincronizar plugin global.

## Cierre
- Fila resumen en `docs/harness/changelog.md`.
- Decisión de arquitectura: no aplica (refactor interno de organización).
