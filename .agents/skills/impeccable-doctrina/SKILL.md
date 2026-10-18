---
name: impeccable-doctrina
description: Doctrina del harness para la skill `impeccable`: flujo de trabajo, selección de playbooks, anti-slop visual y reglas de diseño UI del proyecto. Usar junto a `impeccable` en cualquier cambio de UI visible o interactivo. No usar en backend puro.
---

# Impeccable: flujo de diseño del proyecto

Define cuándo aplicar cada playbook de `impeccable` y en qué orden. Guía 100% en texto, sin binarios.

> **Relación con `impeccable`**: esta skill define el **flujo** del proyecto (cuándo ejecutar cada playbook y en qué orden). La skill `impeccable` (con sus playbooks en `references/`) define **cómo ejecutar** el diseño de cada técnica. En tareas de UI cárgalas juntas: `impeccable-doctrina` para el flujo, `impeccable` para la ejecución.

## Reglas no negociables

1. **Verificación manual obligatoria**: antes de dar por terminado cualquier cambio de UI, haz una pasada de verificación visual contra `impeccable/references/craft-floor.md` y el checklist anti-slop de `ui-ux`. Hallazgos: resolver o dejar justificados.
2. **Contexto primero**: si el proyecto no tiene `PRODUCT.md` y `DESIGN.md`, propón el playbook `init` antes de cualquier cambio de diseño profundo. Sin contexto, los diseños caen en patrones genéricos de SaaS.
3. **polish solo sobre features terminadas** (sin TODOs). Si el pase reestructura layout, el playbook correcto era `critique` o `layout`.

## Enrutamiento (usar el par correcto, nunca uno solo)

- `audit` -> `harden` / `polish` / `optimize` (según hallazgos de accesibilidad, performance o responsive).
- `critique` -> `polish` / `distill` (según veredicto visual y heurístico).
- `bolder` <-> `quieter` (par de "volumen": decidir rumbo visual, no quedar neutro).
- `init` -> `shape` (capturar producto, luego planear la superficie visual).

## Playbooks de diseño

- Crear: `shape` (brief antes de construir), `init` (captura contexto duradero).
- Evaluar: `audit` (técnico: a11y, perf, responsive), `critique` (heurístico perceptual).
- Refinar: `animate`, `bolder`, `colorize`, `delight`, `layout`, `overdrive`, `quieter`, `typeset`.
- Simplificar: `adapt`, `clarify`, `distill`.
- Endurecer: `harden`, `onboard`, `optimize`, `polish`.
- Sistema: `document` (genera DESIGN.md desde código existente), `extract` (extrae tokens y componentes).

## Integración con este repo

- Convive con `convenciones-frontend` (estructura/features/WCAG) y con el checklist anti-patrones de `ui-ux`: Impeccable cubre lo perceptual y los anti-patrones de AI-slop, no reemplaza esas reglas.
