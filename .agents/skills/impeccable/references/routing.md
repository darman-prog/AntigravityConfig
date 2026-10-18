# Playbook Routing Guidance

## Workflow questions

Give advice on which playbook to apply based on the current project state. Consult the relevant playbook references under `references/` as needed for prerequisites and scope. If the user requests execution, load and follow the chosen playbook.

## Context-aware routing

When deciding which playbook to apply next, inspect `PRODUCT.md`, `DESIGN.md`, and the target frontend files:

- **No `PRODUCT.md` yet** (and the surface is not a disposable demo/spike): start with [init.md](init.md) to capture durable product truth before inventing a visual system.
- **Code exists without `DESIGN.md`**: use [document.md](document.md) to extract and record the existing visual system.
- **New surface or replacement identity**: use [new-work.md](new-work.md) (or [shape.md](shape.md) if the user wants a design brief without code).
- **Existing surface never critiqued**: use [critique.md](critique.md) for holistic UX/design review or [audit.md](audit.md) ([audit.native.md](audit.native.md) on `ios`/`android`/`adaptive`) for technical checks.
- **Known defects or post-critique refinement**: use [polish.md](polish.md) to bring the complete user path to shipping quality, or targeted playbooks ([layout.md](layout.md), [typeset.md](typeset.md), [colorize.md](colorize.md), [animate.md](animate.md), [harden.md](harden.md), [distill.md](distill.md), [bolder.md](bolder.md), [quieter.md](quieter.md)).
- **Craft floor verification**: before closing any visual change on web surfaces, verify manually against [craft-floor.md](craft-floor.md).

Keep recommendations to 2-3 pointed picks tailored to the current surface and platform.
