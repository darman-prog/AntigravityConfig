# ADR 003: Análisis del Overhead de Contexto en el Primer Turno y Estrategias de Optimización

## Estado
Pendiente / En Evaluación

## Fecha
2026-10-17

## Contexto
Al iniciar una nueva sesión en Antigravity CLI (`agy 1.4.1`) y enviar un mensaje inicial simple (ejemplo: `"hola"`), el panel nativo de telemetría `Context Usage` reporta un consumo inicial acumulado de **27.8k / 1.0M tokens (2.7%)**.

A primera vista, 27.8k tokens para un saludo parece una cifra desproporcionada. Se realizó una auditoría forense del desglose de tokens reportado por la TUI para determinar la causa raíz y evaluar si requiere intervención.

## Análisis Forense del Desglose de Tokens

De los 27.8k tokens registrados, el **89.2% (24.8k)** corresponde a infraestructura fija que el motor de Antigravity inyecta antes de que el usuario envíe su primera instrucción:

1. **System tools (11.7k tokens / 1.1%)**:
   - Esquemas JSON OpenAPI/JSON-Schema de todas las herramientas nativas disponibles (`view_file`, `replace_file_content`, `write_to_file`, `run_command`, `schedule`, `ask_question`, etc.).
   - Es una sobrecarga técnica ineludible para cualquier agente capaz de operar en la máquina del usuario.

2. **System prompt (7.0k tokens / 0.7%)**:
   - Instrucciones del sistema de Google Antigravity + reglas del proyecto cargadas globalmente (`rules/AGENTS.md` y `rules/GEMINI.md`).

3. **Skills Catalog (5.0k tokens / 0.5%)**:
   - Índice de nombres y descripciones breves de las 38 skills registradas en el harness global (`antigravity-harness`).
   - Sigue el principio de *progressive disclosure*: solo se inyecta la firma de cada skill, no el contenido completo.

4. **Subagents Catalog (1.1k tokens / 0.1%)**:
   - Definición de roles y capacidades de los 6 subagentes especializados (`auditor`, `backend-expert`, `debugger`, `quality`, `tester`, `ui-ux`).

5. **Tool calls dinámicas (2.3k tokens / 0.2%)**:
   - Provocadas por la ejecución estricta del **Skill Gate** en el primer turno (`view_file` de `uso-eficiente/SKILL.md` y `comunicacion-asertiva/SKILL.md`).

6. **Mensajes reales de usuario y asistente (0.6k tokens / 0.0%)**:
   - 147 tokens de entrada del usuario (`"hola"`) y 489 tokens de salida del agente.

## Mitigación Arquitectónica Existente: Prompt Caching

En la arquitectura de Google Gemini (Flash / Pro), los bloques estáticos del prompt del sistema (`System tools`, `System prompt`, `Skills`, `Subagents`) están sujetos a **Prompt Caching** del lado del servidor:
- En turnos subsiguientes, estos 24.8k tokens se leen desde la memoria caché (`cache_read_tokens`).
- Tienen un costo de cuota cercano a cero y no penalizan la latencia de generación.
- El contexto total de 1.0M deja 972k tokens (97.3%) completamente disponibles para el desarrollo de software.

## Opciones de Optimización Evaluadas (Pendientes de Implementación)

1. **Skill Gate perezoso (Lazy Loading en saludos puros)**:
   - Si la entrada del usuario no contiene intención de código ni órdenes accionables (ej. solo `"hola"`, `"buenos días"`), postergar la lectura física de `SKILL.md` hasta la primera tarea técnica real.
   - *Ahorro potencial*: -2.3k tokens en el primer turno.

2. **Modularización del catálogo de skills**:
   - En lugar de registrar 38 skills globales en todos los proyectos, permitir perfiles ligeros (ej. 10-15 skills base por proyecto).
   - *Ahorro potencial*: Reducción de `Skills` de 5.0k a ~1.5k tokens.

3. **Desactivación de plugins no utilizados**:
   - Deshabilitar extensiones de herramientas secundarias (`android-cli-plugin`, etc.) cuando no se requieran.
   - *Ahorro potencial*: Reducción proporcional en `System tools`.

## Decisión
- **Mantener el estado actual en observación**: No realizar cambios apresurados en el Skill Gate ni en la estructura de skills globales en este momento.
- Dejar este análisis y las 3 estrategias de optimización documentadas formalmente para ser ejecutadas cuando el usuario decida priorizar la reducción de overhead.

## Consecuencias
- **Positivas**:
  - Comprensión clara y documentada del consumo de memoria de contexto.
  - El usuario sabe que no está perdiendo cuota real gracias al Prompt Caching de Gemini.
  - Plan de optimización listo para implementarse a demanda.
- **Negativas**:
  - El primer turno continuará mostrando ~27.8k tokens en el panel `Context Usage`.
