# AGENTS-MERGE y comandos de configuración

## Contexto

Las directivas de Antigravity residen en `.agents/` y en `AGENTS.md`. El onboarding no satura el proyecto con duplicaciones: solo asegura la configuración de proyecto, `AGENTS.md` y la documentación inicial.

## Comandos (Windows)

```powershell
# 1. Config de proyecto y hooks en Antigravity
Copy-Item "C:\Users\damez\Downloads\Estudio\PlantillaAntiGravity\.agents\hooks.json" ".agents\hooks.json" -Force

# 2. Servidores MCP opt-in (SOLO si el usuario los pide)
Copy-Item "C:\Users\damez\Downloads\Estudio\PlantillaAntiGravity\.agents\mcp_config.json" ".agents\mcp_config.json" -Force

# 3. AGENTS.md si el proyecto no tiene uno
Copy-Item "C:\Users\damez\Downloads\Estudio\PlantillaAntiGravity\AGENTS.md" ".\AGENTS.md" -Force
```

## Lógica de merge para AGENTS.md

Si el proyecto destino **ya tiene AGENTS.md**:

1. Lee el archivo existente.
2. Identifica secciones por encabezado `## `.
3. Actualiza SOLO estas secciones con lo descubierto en las preguntas:
   - `## Stack` → lenguaje, frameworks, gestor de paquetes detectado.
   - `## Comandos` → comandos clave del stack (dev server, test, build, lint).
4. **Preserva sin tocar**:
   - `## Skill Gate (obligatorio antes de leer, buscar o editar)`
   - `## Estilo de respuesta`
   - `## Definition of Done`
   - `## Tokens y contexto`
   - `## Manejo de .gitignore`
   - `## Agentes`
   - Cualquier sección custom que el proyecto ya tenga.
5. El `AGENTS.md` resultante debe respetar el presupuesto (≤75 líneas).
