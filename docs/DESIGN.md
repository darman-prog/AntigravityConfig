---
status: vigente
last_reviewed: 2026-10-19
archetype: high-craft-linear
---

# Design System & Estándar Visual

> Estándar visual y sistema de diseño del proyecto. Fija el arquetipo visual activo estructurado estrictamente por tokens para erradicar el AI-slop y garantizar una experiencia de ingeniería de alta precisión.

---

## 1. Arquetipo Activo: High-Craft / Linear

Inspirado en herramientas técnicas de alto rendimiento (Linear, Raycast, Vercel). Diseñado para operadores e ingenieros: máxima densidad de información sin saturar, respuesta instantánea, atajos de teclado y elevación por bordes de 1px.

> [!NOTE]
> **Adaptabilidad de Dominio**: Si el proyecto construido sobre este arnés requiere otro arquetipo (ej. Editorial, E-commerce, Salud), se modifican únicamente los **Tokens** de este documento sin alterar la arquitectura de skills ni el motor de auditoría Anti-Slop.

---

## 2. Tokens del Sistema

### A. Paleta de Color (Zinc Técnico & Acento Cobalto)

- **Modo Predeterminado**: Oscuro sobrio (`dark`) con alto contraste.
- **Superficies**:
  - `bg-canvas`: `#09090b` (zinc-950 puro — fondo base de pantalla)
  - `bg-surface`: `#121215` (zinc-900 ajustado — contenedores principales)
  - `bg-overlay`: `#18181b` (zinc-900 — modales, dropdowns, popovers)
  - `bg-muted`: `#27272a` (zinc-800 — hover en filas, chips, estados secundarios)
- **Bordes y Delimitadores**:
  - `border-subtle`: `rgba(255, 255, 255, 0.08)` (1px — separación estándar entre tarjetas/bloques)
  - `border-strong`: `rgba(255, 255, 255, 0.16)` (1px — estados activos, foco o división estructural)
- **Acento Primario Único**:
  - `accent-brand`: `#5e6ad2` / `#6366f1` (Cobalto/Indigo eléctrico — un único acento primario para botones principales y selección)
  - `accent-hover`: `#4f59b6`
  - `accent-highlight`: `rgba(99, 102, 241, 0.15)` (fondos sutiles de selección)
- **Estados Semánticos**:
  - Éxito: `#10b981` (esmeralda sobrio)
  - Alerta: `#f59e0b` (ámbar técnico)
  - Error: `#ef4444` (carmesí)

### B. Tipografía y Escala

- **Fuente UI Principal**: `Geist Sans`, `Inter`, o `system-ui` (sans-serif neutra, legible, sin ornamentos).
  - Tracking ajustado en encabezados: `-0.02em` a `-0.04em`.
- **Fuente Monospace Técnica**: `Geist Mono`, `JetBrains Mono` o `ui-monospace`.
  - **Uso estricto**: Reservada exclusivamente para código, hashes, métricas numéricas tabulares, atajos `<kbd>` e IDs técnicos.
- **Escala de Texto**:
  - `text-xs`: 12px (etiquetas secundarias, badges de estado, atajos)
  - `text-sm`: 14px (texto base de lectura, inputs, botones, tablas)
  - `text-base`: 16px (subtítulos de sección, cards destacadas)
  - `text-lg`: 18px (encabezados de nivel 3)
  - `text-xl`: 20px (encabezados de nivel 2)
  - `text-2xl`: 24px (título principal de pantalla/vista)

### C. Superficie y Elevación (Anti-Slop Elevation)

- **Regla de oro**: Elevación mediante contraste de fondo y **bordes de 1px sutiles**, NUNCA sombras difusas pesadas ni halos de colores.
- **Sombras**:
  - `shadow-sm`: `0 1px 2px 0 rgba(0, 0, 0, 0.4)` (solo en elementos interactivos flotantes pequeños).
  - Prohibido el uso de `box-shadow` difuso de color o halos fosforescentes sin justificación.

### D. Densidad, Layout y Grilla

- **Grilla modular**: Incrementos de 4px / 8px (`4, 8, 12, 16, 24, 32, 48px`).
- **Composición asimétrica**: Agrupar la información por flujo de tarea y jerarquía de lectura.
- **Prohibición de "Sopa de Tarjetas"**: Prohibido estructurar vistas completas repitiendo cuadrículas 3x3 de tarjetas idénticas con icono + título + texto genérico.

### E. Microinteracciones y Teclado

- **Velocidad**: Transiciones de 100ms a 150ms con curvas exponenciales de salida (`ease-out`). Sin rebotes ni animaciones lentas.
- **Soporte de teclado**: Toda acción principal cuenta con atajo visible (`<kbd>`) y anillo de foco visible (`focus-visible:ring-2 focus-visible:ring-indigo-500/50`).
- **Iconografía**: Iconos vectoriales limpios (Lucide o Radix) con grosor de trazo consistente de 1.5px. Cero emojis como iconos.

---

## 3. Checklist de Auditoría Anti-Slop (Norma de Calidad)

Antes de dar por entregado cualquier cambio de UI, la interfaz DEBE cumplir este filtro:

- [ ] **Sin sopa de tarjetas**: El layout responde al contenido real, no a plantillas de tarjetas repetitivas.
- [ ] **Sin gradientes en texto**: El énfasis se expresa con tamaño o peso tipográfico, nunca con texto arcoíris.
- [ ] **Sin emojis por iconos**: Se emplean iconos vectoriales consistentes en una sola librería.
- [ ] **Sin glassmorphism gratuito**: Efecto blur reservado únicamente para superficies flotantes translúcidas reales (ej. navbar con scroll).
- [ ] **Sin métricas falsas tipo SaaS**: Sin números gigantes desprovistos de contexto o unidad de negocio.
- [ ] **Estados completos presentes**: Implementados y verificados `loading`, `error`, `empty`, `success` y `disabled`.
- [ ] **Accesibilidad WCAG 2.2 AA**: Contraste ≥ 4.5:1 en texto normal, ≥ 3:1 en componentes y navegación completa por teclado.
