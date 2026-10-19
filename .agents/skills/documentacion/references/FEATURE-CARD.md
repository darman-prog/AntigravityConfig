# Tarjeta de feature (single-session DDR)

Registra una feature terminada en una sesión por un solo agente. Mantén la tarjeta en 25 líneas o menos.

```markdown
---
id: NNN
status: cerrada
date: YYYY-MM-DD
tipo: creación | modificación
---
# Feature NNN — <slug>

> Una frase: qué cambió y por qué.

## Cambio
Descripción directa del cambio funcional entregado.

## Por qué
Motivo o necesidad que originó el cambio.

## Dónde mirar
- `ruta/al/archivo/principal:línea`
- `ruta/al/test/o/script`

## Verificación
Comando, prueba ejecutada o criterio observable que valida el cambio.

## Evidencia
- Commits atómicos vinculados.
- Salida relevante o comprobación en verde.
```

## Reglas

- Registra por unidad funcional de una sesión; los micro-fixes quedan en el changelog sin archivo.
- Usa `tipo: creación` para artefactos nuevos y `tipo: modificación` para cambios en artefactos existentes.
- `docs/features/INDEX.md` enlaza la tarjeta bajo `## Cerradas`.