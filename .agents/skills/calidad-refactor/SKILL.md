---
name: calidad-refactor
description: Calidad de código y refactor seguro: principios DRY/KISS/YAGNI, SOLID aplicado, complejidad, code smells, preservando comportamiento y refactoring con tests en verde. Usar al escribir, revisar o refactorizar código.
---

# Calidad de Código y Refactor Seguro

Combina los estándares de calidad con el protocolo de refactorización paso a paso para mantener el código limpio y seguro.

## 1. Principios con criterio

- **DRY**: Extrae duplicación de **conocimiento**, no de coincidencia accidental; dos bloques iguales que evolucionan por razones distintas no se unen.
- **KISS**: La solución simple que funciona le gana a la elegante que no se entiende.
- **YAGNI**: Nada "por si acaso"; la abstracción entra con el segundo caso real, nunca con el primero imaginado.
- **SOLID aplicado**: Responsabilidad única en funciones/clases, inversión de dependencias en bordes (skill `arquitectura`).

## 2. Smells que bloquean

- **Función que hace y explica**: Nombre con "and"/"or" o más de un nivel de abstracción mezclado.
- **Complejidad ciclomática**: Mayor a 10 en una función se divide; nunca relajar el linter sin justificación técnica en el cambio.
- **Nombres mentirosos**: Variable llamada `list` que es mapa, método `get` que muta estado.
- **Parámetros booleanos**: Si bifurcan la función en dos flujos no relacionados, sepárala en dos funciones explícitas.
- **Feature envy y God object**: Lógica que pertenece a otro módulo o clases gigantescas (>500 líneas).
- **Manejo de errores ciego**: Prohibido silenciar con catch vacío o forzar casts (`as any`) sin validación previa.

## 3. Cuándo y cómo refactorizar

- **Regla del tres**: La tercera duplicación se extrae; la segunda se tolera.
- **Oportunismo controlado**: Al tocar código vecino para una feature, mejora lo que ya tocas; no abras refactors adyacentes "de paso".
- **Comportamiento idéntico**: Mismo contrato, mismos resultados; tests en verde antes y después (skill `testing`).
- **Un cambio a la vez**: Un smell a la vez, cambio pequeño, test, commit. Nada de "ya que estoy aquí, cambio esto otro" (skill `workflow`).
- **Separación estricta**: El refactor y la feature NUNCA viajan en el mismo commit.

## 4. Patrones frecuentes de refactor

- **Extract**: Extraer método, función, clase o variable para nombrar bloques opacos.
- **Rename**: Nombres que expresen el dominio del negocio, no la implementación técnica.
- **Move**: Mover lógica a su capa arquitectónica correcta (`domain`, `application`, `infrastructure`).
- **Replace conditional with polymorphism / lookup table**: Reducir branches anidados cuando SRP lo requiera.
- **Introduce parameter object**: Agrupar parámetros que siempre viajan juntos.

## 5. Deuda técnica y configuración

- **Deuda puntual**: Se registra conscientemente con un TODO explicativo (con contexto y severidad); nunca se oculta.
- **Deuda sistémica**: Patrones rotos en todo el repo no se arreglan inline: se planifican en `/plan` y se delegan al agente `quality`.
- **Presets de linter/typecheck**: Aplica la configuración base estricta de [LINTER-PRESETS.md](references/LINTER-PRESETS.md) para TypeScript, Python y C#.
