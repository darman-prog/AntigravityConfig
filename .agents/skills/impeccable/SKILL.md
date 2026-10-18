---
name: impeccable
description: Guía de diseño en texto para construir, rediseñar, criticar o pulir interfaces frontend (sitios, dashboards, componentes, formularios, onboarding): UX, jerarquía visual, accesibilidad, motion y theming. Usar en cualquier UI visible. No usar en backend.
---

# Impeccable: guía de diseño UI/UX

Guía propia del harness, solo texto: no ejecuta binarios ni scripts. Aplícala como un director de diseño con criterio de producción. El flujo del proyecto vive en `impeccable-doctrina`.

## Principios
- Sin medias tintas: entrega completo, con dirección clara y oficio, salvo los assets que debe poner el usuario.
- El brief manda: respeta estéticas, fuentes y paletas fijadas aunque choquen con tus gustos.
- Refinar preserva identidad, copy y alcance; rediseñar reemplaza el mundo visual. Nunca pulir lo descartado.
- Verifica en pasadas acotadas: construye completo, revisa una vez (desktop y móvil juntos), corrige todo en un lote y para.

## Setup (sin binario)
1. Contexto: lee `PRODUCT.md` y `DESIGN.md` del proyecto si existen. Sin ellos, usa `references/init.md` (nueva superficie) u `references/new-work.md` (mundo visual nuevo o reemplazo).
2. Carga el playbook del pedido (tabla de abajo) o `references/routing.md` si no hay comando claro.
3. Justo antes de editar UI carga `references/craft-floor.md` (piso de calidad, prohibiciones y reflejos que ningún detector atrapa). No lo cargues para trabajo solo de planificación.

## Modos (se elige por superficie, no por producto)
- **Persuade:** landing, marketing, pricing. Ganar atención y acción.
- **Operate:** apps, dashboards, editores, admin. Escaneabilidad y consistencia sobre expresión (`references/operate.md`).
- **Read:** docs, artículos, guías. Estructura para comprender.
- **Experience:** portfolios, galerías. El artefacto lidera; la interfaz se retira.

## Playbooks (se piden en lenguaje natural: "aplica critique a X")
Cada comando es `references/<comando>.md` (variante nativa: `<comando>.native.md`).

| Grupo | Comandos |
|---|---|
| Construir | `shape`, `init`, `document`, `extract` |
| Evaluar | `critique` (heurístico), `audit` (técnico: a11y, perf, responsive) |
| Refinar | `polish`, `bolder`, `quieter`, `distill`, `harden`, `onboard` |
| Mejorar | `animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive` |
| Corregir | `clarify`, `adapt`, `optimize` |

Pares: `audit` → `harden`/`polish`/`optimize`; `critique` → `polish`/`distill`; `bolder` ↔ `quieter`. `polish` solo sobre features terminadas.
Sin comando claro: lee `references/routing.md`; nunca ejecutes uno sin pedirlo. Falta `PRODUCT.md` para una superficie nueva: `init`, luego `new-work`.