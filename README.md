# Plantilla Base Antigravity CLI — Harness de Ingeniería

Plantilla de desarrollo optimizada para **Google Antigravity CLI (`agy`)**, diseñada bajo los principios de bajo consumo de contexto (*token-saving*), progressive disclosure, delegación multi-agente y guardarraíles automatizados.

---

## Estructura del Repositorio

```text
├── AGENTS.md                  # Reglas de sesión y tabla del Skill Gate (≤75 líneas)
├── GEMINI.md                  # Orquestación del agente default y modo /plan (≤75 líneas)
├── .agents/
│   ├── agents/                # 6 subagentes especializados (backend, ui-ux, etc.)
│   ├── skills/                # 38 skills bajo demanda con guías y scripts
│   └── hooks.json             # Configuración de Lifecycle Hooks (seguridad y notificaciones)
├── scripts/
│   ├── harness-budget.ps1     # Guardarraíl de presupuesto y contratos (fail-closed)
│   ├── new-feature.ps1        # Generador de especificaciones DDR en docs/features/
│   ├── audit-session-skills.ps1 # Auditor de trazabilidad de skills y badges TUI
│   └── publish-global-agy.ps1 # Sincronizador al plugin global de agy
└── docs/
    ├── harness/               # Arquitectura, pipeline operativo y presupuestos
    ├── adr/                   # Architecture Decision Records
    ├── features/              # Feature-specs del ciclo DDR (multi-sesión)
    └── project-brain/         # Cerebro documental e invariantes de arquitectura
```

---

## Pipelines y Comandos Rápidos

```powershell
# 1. Verificar el guardarraíl de presupuesto y contratos
.\scripts\harness-budget.ps1

# 2. Iniciar una nueva feature multi-sesión (ciclo DDR)
.\scripts\new-feature.ps1 -Slug "mi-nueva-feature"

# 3. Auditar la sesión activa (Skill Gate y protocolo de badges TUI)
.\scripts\audit-session-skills.ps1

# 4. Publicar cambios al plugin global de Antigravity CLI
.\scripts\publish-global-agy.ps1
```

---

## Modelo de Agentes

1. **Agente Principal (`default`)**:
   - Modo normal: Implementación de features, resolución de bugs y refactors con Definition of Done.
   - Modo `/plan`: Planificación estricta sin mutar código, basada en evidencia real del repositorio.
2. **6 Subagentes Especializados (`invoke_subagent`)**:
   - `ui-ux`: Diseño, maquetación visual, WCAG 2.2 AA y doctrina Impeccable.
   - `backend-expert`: Análisis de dominio, invariantes y contratos de API (solo lectura).
   - `auditor`: Revisión pre-merge de seguridad, rendimiento y documentación (solo edita `*.md`).
   - `debugger`: Diagnóstico de bugs complejos con método científico y test de regresión.
   - `quality`: Refactoring seguro y optimización de hotspots medidos.
   - `tester`: Pruebas funcionales E2E con browser interactivo.

---

## Documentación Técnica

- [Pipeline de Ejecución](docs/harness/pipeline.md): Flujo detallado por actor, estados y ciclo de commit.
- [Estado Actual](docs/harness/estado-actual.md): Inventario de métricas y componentes vigentes.
- [Presupuestos](docs/harness/presupuestos.md): Límites estrictos de contexto y medición de tokens.
- [ADR 002](docs/adr/002-limitacion-visual-hooks-tui-antigravity.md): Evaluación arquitectónica de la TUI en Antigravity CLI.
