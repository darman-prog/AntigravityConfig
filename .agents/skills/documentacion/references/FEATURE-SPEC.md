# Feature-spec (DDR): una por feature multi-sesión

Fuente de verdad para cambios que duran >1 sesión o tocan ≥2 agentes: se planea, se ejecuta y se cierra desde aquí.
Se persiste en `docs/features/NNN-<slug>.md`. Cambios de una sesión: usar tarjeta (≤25 líneas).

```markdown
---
id: NNN
status: borrador          # borrador | aprobada | en-curso | cerrada
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Feature NNN — nombre funcional claro

> Resumen ejecutivo: qué cambia y por qué importa, en dos líneas.

## Objetivo
Resultado observable en lenguaje de usuario o consumidor.

## Contexto
Antecedente mínimo necesario para entender el problema.

## Alcance
| Incluye | Excluye |
|---|---|
| Cambio principal | Lo que no se toca |

## Criterios de aceptación (Given-When-Then)
| N.º | Escenario / Condición | Resultado Esperado | Evidencia |
|---|---|---|---|
| 1 | Dado X, Cuando Y | Entonces Z | `file:línea`, test o commit |

## Matriz de Edge Cases
| Caso Límite | Comportamiento Esperado | Manejo de Error / Fallback |
|---|---|---|
| Input vacío o error de red | Validación temprana y feedback claro | Código de error tipado |

## Pasos
Un paso por commit, con su validación incluida.

## Cierre
- Fila resumen en `docs/harness/changelog.md`.
- Decisión de arquitectura: `ADR NNN` | no aplica.
```

## Ciclo de vida

- `plan` la redacta en su entrega (no edita); el ejecutor persiste el archivo con `status: en-curso` al arrancar el paso 1.
- La spec manda mientras `status` != `cerrada`: tras compactar contexto, se reanuda leyendo solo este archivo.
- Al cerrar: `calidad-cierre` verifica criterio a criterio contra la sección Evidencia; el changelog queda como registro histórico.
- Spec `cerrada` no se reescribe: una decisión nueva abre otra feature o un ADR.