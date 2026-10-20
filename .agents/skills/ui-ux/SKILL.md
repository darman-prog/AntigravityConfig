---
name: ui-ux
description: Diseño UI/UX, convenciones de código frontend (features/core/shared) y auditoría de diseño (pilares craft/frictionless/trustworthy, estados, responsive y accesibilidad). Usar al crear, estructurar o revisar interfaces.
---

# UI/UX y Convenciones Frontend

Gobierna el diseño de interfaces, la arquitectura de código frontend y la auditoría de calidad de diseño.

## 1. Principios de Interfaz

- **Jerarquía y flujo primero**: Diseña la estructura, el flujo de tareas y el modelo mental antes del pulido estético.
- **Estados completos**: Define siempre `loading`, `error`, `empty`, `success` y `disabled` en cualquier componente interactivo o de datos.
- **Microinteracciones y feedback**: Microinteracciones ágiles (100–150ms) con curvas `ease-out`; feedback comprensible que no dependa únicamente de color.
- **Accesibilidad**: Aplica el canon de `accesibilidad` (WCAG 2.2 AA: contraste, foco visible, navegación por teclado y aria).

## 2. Arquitectura de Código Frontend

- **Organización modular**: Arquitectura basada en `features/` con lazy loading; `core/` para servicios singleton y configuración transversal; `shared/` para utilidades y componentes visuales puros.
- **Detalle de arquitectura**: Guía completa de convenciones en [references/CONVENCIONES-FRONTEND.md](references/CONVENCIONES-FRONTEND.md).
- **Elección de librerías**: Protocolo para evaluar componentes y librerías externas en [references/COMPONENT-RESEARCH.md](references/COMPONENT-RESEARCH.md).

## 3. Auditoría de Calidad y Design Review

- **Evaluación por 3 pilares**:
  1. *Frictionless*: Navegación sin fricción, flujos claros, tiempos de respuesta rápidos.
  2. *Quality Craft*: Alineación a grilla (4/8px), espaciados coherentes, tokens respetados, microinteracciones pulidas.
  3. *Trustworthy*: Manejo visible de errores, datos consistentes y accesibilidad comprobada.
- **Checklists y formatos**: Protocolo detallado de scoring y revisión en [references/design-review/quick-checklist.md](references/design-review/quick-checklist.md).
- **Ejecución visual**: Para construir superficies nuevas o aplicar playbooks de refinamiento, usa la skill `impeccable`.
