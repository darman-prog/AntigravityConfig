# Metodología TDD: Red-Green-Refactor

Guía paso a paso para desarrollo guiado por pruebas (TDD) en lógica compleja y contratos.

## El ciclo

1. **Rojo**: Escribe el test más pequeño que falte y falle.
2. **Verde**: Implementación mínima para que pase. Mínima de verdad: nada "por si acaso" (YAGNI, skill `calidad-refactor`).
3. **Refactor**: Mejora nombres y estructura sin agregar comportamiento (skill `calidad-refactor`).
4. Repite con el siguiente test. Cada ciclo cierra con tests en verde.

## Driver/Navigator con IA (colaboración paso a paso)

- Tú (usuario) eres navigator: decides qué test viene, el agente es driver que lo escribe.
- Flujo por paso con confirmación:
  1. Agente propone el siguiente test (nombre + asserts) y ESPERA tu "sí".
  2. Agente escribe el test; muestra el resultado en rojo.
  3. Agente implementa lo mínimo; muestra el verde.
  4. Agente propone refactor si aplica; solo se ejecuta con tu aprobación.
  5. Commit del ciclo (skill `workflow`, commits por paso de plan): propone mensaje y espera tu "sí".
- El agente nunca salta pasos ni escribe test e implementación de un tirón sin tu aprobación.

## Cuándo sí y cuándo no

- **Sí**: Lógica de negocio compleja, reglas con bordes, contratos API, algoritmos con casos límite.
- **No**: UI visual (delega en el agente `ui-ux` + `impeccable`), spikes de exploración, config trivial, CRUD sin reglas.
- Duda de estrategia general (niveles, qué mockear): ver `SKILL.md`; duda de si refactorizar: skill `calidad-refactor`.

## Reglas

- El test se escribe antes que el código; implementar primero anula el ciclo.
- Nombres de test describen comportamiento del negocio, no del método.
- Si el ciclo lleva 3 intentos de verde sin lograrlo, el diseño está mal: para y reevalúa con `backend-expert` o propone al usuario cambiar a `plan`.
