---
name: impeccable
description: Guía de diseño, doctrina y playbooks UI/UX (sitios, dashboards, componentes, formularios): dirección estética, accesibilidad, motion, anti-slop visual y verificación de calidad. Usar en cualquier UI visible. No usar en backend puro.
---

# Impeccable: guía y doctrina de diseño UI/UX

Combina la doctrina de diseño del proyecto, los playbooks especializados y la disciplina de ejecución anti-slop. Guía 100% en texto, sin binarios.

## Principios y reglas no negociables

1. **Verificación visual obligatoria**: Antes de terminar cualquier cambio de UI, haz una pasada de verificación visual contra [references/craft-floor.md](references/craft-floor.md) (piso de calidad anti-slop). Resuelve o justifica cualquier hallazgo; bloquea el cierre ante defectos graves.
2. **Contexto primero**: Si el proyecto no tiene `PRODUCT.md` y `DESIGN.md`, propón el playbook `init` (captura contexto) antes de cambios de diseño profundos para no caer en patrones genéricos de SaaS.
3. **El brief manda**: Respeta estéticas, fuentes y paletas fijadas en `docs/DESIGN.md`. Sin medias tintas: entrega completo, con dirección clara y oficio.
4. **polish solo sobre features terminadas** (sin TODOs). Si el pase reestructura layout, el playbook correcto era `critique` o `layout`.
5. **Verificación acotada**: Construye completo, revisa una vez (desktop y móvil juntos contra `craft-floor.md`), corrige en un lote y para.

## Modos (se elige por superficie, no por producto)

- **Persuade:** Landing, marketing, pricing. Ganar atención y acción con ganchos claros.
- **Operate:** Dashboards, editores, herramientas de ingeniería, admin. Densidad, escaneabilidad y consistencia sobre ornamentos ([references/operate.md](references/operate.md)).
- **Read:** Docs, artículos, contenido. Tipografía balanceada, medida de línea a 65–75ch y wayfinding claro.
- **Experience:** Portfolios, piezas interactivas. El artefacto lidera; la interfaz acompaña.

## Enrutamiento y Playbooks

Carga el playbook específico en `references/<comando>.md` según la necesidad:

| Categoría | Playbooks disponibles |
|---|---|
| **Construir** | `shape` (brief antes de construir), `init` (captura producto en PRODUCT.md), `new-work` (crea/reemplaza mundo visual), `document`, `extract` |
| **Evaluar** | `critique` (heurístico perceptual), `audit` (técnico: a11y, perf, responsive) |
| **Refinar** | `polish` (acabado fino), `bolder` / `quieter` (eje de volumen visual), `distill`, `harden`, `onboard` |
| **Mejorar** | `animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive` |
| **Corregir** | `clarify`, `adapt`, `optimize` |

- **Pares obligatorios**: `audit` → `harden`/`polish`/`optimize`; `critique` → `polish`/`distill`; `bolder` ↔ `quieter`.
- **Anti-slop**: Justo antes de editar o auditar UI carga siempre [references/craft-floor.md](references/craft-floor.md).
