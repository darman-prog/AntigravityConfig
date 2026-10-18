# Test de Carga del Harness — Antigravity CLI

**Fecha:** 2026-10-17  
**Contexto:** Verificación de publicación y carga del plugin global en `~/.gemini/config/plugins/antigravity-harness`.

## Qué se prueba

| # | Prueba | Comando | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| 1 | Guardarraíl de presupuesto | `powershell -NoProfile -File scripts\harness-budget.ps1` | **PASS** — exit 0 |
| 2 | Sincronización global | `powershell -NoProfile -File scripts\publish-global-agy.ps1` | **PASS** — exit 0, plugin publicado |
| 3 | Registro en Antigravity CLI | `agy plugin list` | **PASS** — plugin `antigravity-harness` habilitado con 38 skills, 6 agents, 2 rules, 3 hooks |
| 4 | Auditoría de skills en sesión | `powershell -NoProfile -File scripts\audit-session-skills.ps1` | **PASS** — verificación de lectura física de skills y badges |

## Detalle del guardarraíl

```text
Guardarrail de presupuesto OK: AGENTS.md=71 lineas | GEMINI.md=33 lineas (tope 75) | skills=38 archivos SKILL.md | agentes=6 archivos, 237 lineas en total (tope 350) | hooks=OK
```

## Detalle de la publicación global

```text
Publicado OK en: ~/.gemini/config/plugins/antigravity-harness | subagentes=6 | reglas=AGENTS.md+GEMINI.md | archivos de skills=104 | hooks sincronizados
```

## Salida de `agy plugin list`

```text
- antigravity-harness (enabled, 1.0.0)
    Components: 38 skills, 6 agents, 2 rules, 3 hooks
```
