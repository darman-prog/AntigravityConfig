---
name: infra-despliegue
description: Infraestructura y despliegue: Dockerfile, compose, IaC, red, TLS, DNS, cache, CDN, ambientes (dev/staging/prod), CI/CD, healthchecks y rollback. Usar al tocar Docker, infraestructura, pipelines o despliegues.
---

# Infraestructura y Despliegue

Gobierna la infraestructura como código, entornos locales reproducibles, orquestación, pipelines de CI/CD y despliegue seguro a producción.

## 1. Infraestructura como código y local reproducible

- **Versionado absoluto**: Dockerfile, `docker-compose.yml`, manifiestos (k8s, terraform, helm) en el repositorio; jamás configuración manual en el servidor.
- **Dockerfile multi-stage**: Imagen final mínima, usuario no-root, sin secretos ni caché de build innecesario; pinned por digest o tag exacto (no `latest`).
- **Compose local**: `docker-compose` como único comando para levantar el stack local (app, base de datos, colas) con volúmenes para persistencia.
- **Variables de entorno**: `.env.example` versionado sin secretos; `.env` estrictamente ignorado en `.gitignore`. Secretos de producción en secret manager del proveedor.

## 2. Red, TLS y Seguridad de Infraestructura

- **TLS en el borde**: Terminado en ingress, balanceador o reverse proxy con certificado administrado, renovación automática y alerta a 30+ días.
- **DNS y correo**: Registros A/AAAA, CNAME, MX, TXT en IaC. Correo saliente con SPF, DKIM y DMARC configurados antes del primer envío.
- **Exposición mínima**: DB y colas privadas; puertos expuestos solo los indispensables.
- **Ingress / Reverse Proxy**: Único punto de entrada para TLS, headers de seguridad, rate limiting y ruteo.

## 3. Pipeline de CI/CD y Ambientes

- **Validación previa**: Todo pipeline corre lint, typecheck y suites de tests antes del empaquetado (skill `workflow`).
- **Build reproducible**: Lockfile commiteado y dependencias congeladas.
- **Migraciones de base de datos**: Corren en paso independiente previo al arranque del servicio, con estrategia backward-compatible (expand/contract, skill `base-datos`).

## 4. Producción, Monitoreo y Rollback

- **Healthchecks**: Endpoint `/health` o `/ready` sin autenticación que sondee dependencias vitales (DB, colas).
- **Rollback obligatorio**: Plan de rollback documentado antes de cada despliegue (versión anterior disponible y migraciones reversibles).
- **Logs y continuidad**: Logs estructurados a stdout con `traceId` (skill `observabilidad`); backups automáticos de DB con retención y prueba de restauración periódica.
- **Fallas de despliegue**: Ante anomalías críticas post-deploy, rollback primero y debugging después.
