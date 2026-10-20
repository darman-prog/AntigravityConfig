# Protección de Datos y Privacidad

Guía para el tratamiento seguro de contraseñas, PII, retención y cumplimiento regulatorio.

## Contraseñas

- **Hashing seguro**: Hash siempre con **bcrypt o argon2id**; jamás MD5, SHA-1, SHA-256 plano ni cifrado reversible.
- **Coste de cómputo**: Calibra el factor de coste por entorno y documéntalo; no se deja en el valor mínimo por defecto.
- **Comparación constante**: Compara con función de tiempo constante (`timingSafeEqual`); nunca `==` sobre el hash.
- **Tratamiento confidencial**: Las contraseñas no se loguean, no se devuelven en respuestas ni se almacenan en texto plano en ninguna base de datos, log o backup.
- **Invalidación**: Al cambiar o resetear contraseñas, invalida inmediatamente las sesiones y tokens activos.

## Datos Personales (PII)

- **Clasificación previa**: PII directa (nombre, email, documento de identidad, teléfono, IP, geolocalización) y datos de categoría especial (salud, biométricos, menores) que exigen controles reforzados.
- **Minimización de datos**: Almacena únicamente los campos estrictamente necesarios para la funcionalidad actual.
- **Cifrado**: En tránsito siempre (TLS); en reposo para PII, credenciales, tokens y respaldos.
- **Aislamiento**: Separa identificadores de contenido sensible cuando sea viable para evitar filtraciones masivas.
- **Archivos y documentos**: Nombres no predecibles (UUIDs), almacenamiento privado y URLs firmadas de corta duración; jamás en carpetas públicas.

## Ciclo de vida y Retención

- **Política de retención**: Define ventanas de retención por tipo de dato y programa depuración automática mediante jobs en background (skill `api-backend`).
- **Derecho al olvido**: Proceso automatizado de eliminación o anonimización en cascada, incluidos backups y analíticas derivadas.
- **Anonimización / Pseudonimización**: Obligatoria para analítica, métricas y entornos de prueba/staging. Los seeds de desarrollo usan datos sintéticos, jamás volcados reales de producción.
- **Consentimiento**: Registra qué se aceptó, timestamp exacto y versión del aviso de privacidad.

## Bitácora de Auditoría

- **Registro de accesos**: Registra accesos a datos sensibles y cambios en roles/permisos (quién, cuándo y sobre qué recurso) en un log de auditoría independiente de los logs técnicos.
- **Sin datos sensibles en la bitácora**: La bitácora registra la referencia y el evento; jamás secretos, contraseñas ni payloads completos.
