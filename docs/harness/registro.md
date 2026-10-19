# Canon de Registro y Taxonomía de Trabajo

> **Para qué:** define el sistema unificado de registro de cambios, features, decisiones y guías para que cualquier agente o desarrollador trabaje con el mismo estándar.
> **Regla de oro:** una sola forma de registrar; no inventar sinónimos ni carpetas paralelas.

---

## 1. Taxonomía de Artefactos (Glosario de 6 Palabras)

| Tipo | Definición | Ubicación | Límite / Formato |
|---|---|---|---|
| **Micro-fix** | Arreglo menor sin cambio de arquitectura, contrato ni nuevo valor funcional | `docs/harness/changelog.md` | Solo una fila en el changelog. Sin archivo dedicado. |
| **Tarjeta** | Feature completada en 1 sola sesión por 1 solo agente | `docs/features/NNN-<slug>.md` | ≤ 25 líneas. Plantilla `FEATURE-CARD.md`. |
| **Feature-spec** | Feature que requiere >1 sesión o coordinación de ≥2 agentes | `docs/features/NNN-<slug>.md` | ≤ 45 líneas. Plantilla `FEATURE-SPEC.md` (SDD: Given-When-Then, edge-cases). |
| **ADR** | Decisión de arquitectura irreversible o global (stack, contratos, permisos, infra) | `docs/adr/NNN-<slug>.md` | Contexto, Decisión, Consecuencias, Alternativas descartadas. Inmutable. |
| **Guía / Runbook** | Procedimiento paso a paso (onboarding, setup, troubleshooting, recovery) | `docs/guias/` | Práctico y procedimental ("cómo hacerlo", no "por qué se decidió"). |
| **Changelog** | Historial cronológico del repositorio | `docs/harness/changelog.md` | Append-only. Fila más reciente arriba. |

---

## 2. Ciclo de Vida de una Feature

1. **Creación**: Se genera mediante `.\scripts\new-feature.ps1 -Slug <slug> -Title <titulo>`.
2. **Determinación del Formato**:
   - Si se resuelve en la sesión actual: Se redacta como **tarjeta** (≤ 25 líneas).
   - Si requiere múltiples sesiones o diseño profundo: Se redacta como **feature-spec** (≤ 45 líneas) con criterios Given-When-Then.
3. **Registro en el Índice**: Se añade la fila en `docs/features/INDEX.md` bajo `## Activas` (`borrador`, `aprobada` o `en-curso`).
4. **Implementación**: Cada paso del plan equivale a un commit atómico y enfocado.
5. **Cierre**:
   - La skill `calidad-cierre` verifica criterio a criterio con evidencia (`file:línea`, salida de test o commit).
   - El estado pasa a `cerrada`.
   - Se mueve la fila en `docs/features/INDEX.md` a `## Cerradas`.
   - Si hubo una decisión irreversible, se genera el correspondiente `ADR-NNN` y se referencia en la sección de cierre de la spec.
   - Se añade la fila resumen en `docs/harness/changelog.md`.

---

## 3. Decisiones de Arquitectura (ADR)

- Un ADR se reserva para decisiones difíciles de revertir: cambio de stack, contrato de API, modelo de datos, dependencias de máquina o políticas de seguridad.
- **Inmutabilidad**: Un ADR no se edita para cambiar la decisión; si cambia, se crea un nuevo ADR que reemplaza al anterior (con enlace explícito).
- Toda decisión registrada se indexa en la sección `## Decisiones (ADR)` de `docs/features/INDEX.md`.

---

## 4. Reglas del Índice (`docs/features/INDEX.md`)

- `## Activas`: Contiene únicamente features en estado `borrador`, `aprobada` o `en-curso`.
- `## Cerradas`: Contiene las features terminadas con evidencia observable.
- `## Decisiones (ADR)`: Índice centralizado de todos los ADRs vigentes o reemplazados.
- `## Archivado`: Cuando la suma de filas activas y cerradas supere ~40, las más antiguas se trasladan a `ARCHIVE.md` manteniendo limpio el contexto.
