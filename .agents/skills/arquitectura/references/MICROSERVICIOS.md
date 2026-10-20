# Microservicios y Sistemas Distribuidos

Guía para diseño, comunicación y consistencia en arquitecturas distribuidas.

## Cuándo NO dividir

- **Monolito modular primero**: Diseña con capas limpias (Clean Architecture) y límites internos firmes antes de extraer servicios.
- **Causas válidas para dividir**: Equipos independientes desacoplados, requerimientos divergentes de escalado o ciclo de despliegue independiente. "Se ve más moderno" no es justificación.
- **Base de datos compartida**: Si dos servicios comparten el mismo esquema de base de datos, conceptualmente siguen siendo un monolito pero distribuido y frágil.

## Límites y Bounded Contexts

- Los límites de servicio se definen por **bounded contexts** del dominio del negocio, no por capas técnicas.
- Cada servicio es dueño exclusivo de sus datos; el acceso cruzado se realiza vía APIs versionadas o eventos asíncronos.
- Versionado de contratos hacia atrás (backward compatibility) obligatorio (skill `api-backend`).

## Comunicación entre servicios

- **Sincrónica (REST / gRPC)**: Para lecturas directas o flujos donde el usuario requiere respuesta inmediata. Requiere timeouts explícitos, política de reintentos con backoff y **circuit breaker**.
- **Asincrónica (Eventos / Colas)**: Para desacoplar efectos secundarios. Consumidores estrictamente **idempotentes** (tolerancia a entrega at-least-once).
- **Patrón Transactional Outbox**: Los eventos de negocio se guardan en la misma transacción que los datos de la DB (tabla `outbox` + relay); jamás hacer commit y luego intentar publicar a la red.

## Consistencia y Transacciones

- **Transacciones distribuidas (2PC)**: Evitarlas; generan acoplamiento temporal y bloqueos.
- **Patrón Saga**: Coreografía para flujos de 2–3 pasos; orquestación para flujos de más de 3 pasos o con compensaciones complejas.
- **Consistencia eventual**: Default entre servicios; el diseño visual y el frontend deben tolerar estados intermedios.
- **Idempotencia**: Claves de idempotencia obligatorias en endpoints y mensajes de escritura.

## CQRS y Event Sourcing

- **CQRS**: Separar modelos de lectura y escritura solo cuando las proyecciones o consultas pesadas lo requieran; no por defecto.
- **Event Sourcing**: Reservado únicamente para dominios donde la auditoría inmutable, histórico o replay sean requisitos de negocio (ej. contabilidad, finanzas).

## Operación y Trazabilidad

- **Propagación de `traceId`**: Obligatorio propagar headers de correlación en toda llamada RPC o mensaje de cola (skill `api-backend`, `observabilidad`).
- **Resiliencia ante fallos de red**: Las caídas de red son la norma; toda integración externa debe definir fallback y comportamiento degradado.
