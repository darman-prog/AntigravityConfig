# Convenciones de Arquitectura y Código Frontend

Guía de estructura de proyectos frontend, convenciones de capas y estado.

## Estructura de carpetas

- Organiza la aplicación por `features/`, con carga diferida (lazy loading) cuando aplique.
- Reserva `core/` para servicios singleton, configuración transversal e interceptores.
- Usa `shared/` para componentes visuales puros y utilidades reutilizables sin lógica de negocio.
- Mantén la lógica de cada feature cerca de sus componentes, servicios, modelos y tests.

## Estado, red y llamadas

- Usa los interceptores existentes para autenticación, manejo centralizado de errores, loading y `traceId`; no dupliques manejo transversal en cada componente.
- Usa el mecanismo de estado adoptado por el proyecto; evita estado global para datos de alcance estrictamente local.
- Nombres de archivo en `kebab-case` y conserva los patrones de imports y tests existentes.

## Layout, responsive y tokens

- Mobile-first y responsive en los flujos principales.
- Define estados: `loading`, `error`, `empty`, `disabled` y `success` en todo componente interactivo o de datos.
- Usa tokens consistentes de spacing (grilla 4/8), tipografía, color y radius; prioriza el sistema visual existente en `docs/DESIGN.md`.
- Accesibilidad: cumple el canon de `accesibilidad` (WCAG 2.2 AA).
