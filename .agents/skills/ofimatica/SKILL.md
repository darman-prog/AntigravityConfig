---
name: ofimatica
description: Word (.docx con portada e indice), PowerPoint (.pptx), PDF y HTML a PDF: calidad editorial y templates. Solo por petición explícita.
---

# Habilidades Ofimáticas y Calidad Editorial

Generación de documentos profesionales en Word (.docx), PowerPoint (.pptx) y PDF con diseño editorial de alto nivel.

> [!IMPORTANT]
> **Activación manual exclusiva:** Esta skill NO se carga automáticamente. Solo se activa cuando el usuario la solicita explícitamente (`ofimatica`, `word`, `docx`, `pdf`, `powerpoint` o `pptx`).

---

## 1. Stack y Enrutamiento DOCX (Elige UNA ruta)

| Tipo de Documento | Ruta Recomendada | Herramienta / Plantilla |
|---|---|---|
| **Documento corto, nota, acta, resumen rápido** | Ruta Python (rápida) | `python-docx` vía `templates/generar-docx.py` |
| **Informe técnico / académico complejo** (portada, índice, tablas, figuras, código) | Ruta Node.js (editorial) | Kit `scripts/kit.js` con `references/ejemplo.js` (`docx-js`) |
| **Presentación de diapositivas** | Ruta PowerPoint | `python-pptx` vía `templates/generar-pptx.py` |
| **Documento imprimible desde web** | Ruta HTML a PDF | `WeasyPrint` o Puppeteer vía `templates/reporte-print.html` |

- No mezcles ambas rutas de Word en un mismo documento.
- Para HTML a PDF copia `templates/reporte-print.html` y reemplaza el contenido en `<main>`; no escribas CSS print desde cero.

---

## 2. Paletas Contextuales y Tokens

Antes de generar el documento, identifica el contexto y propón una paleta con justificación en 1 línea para confirmación del usuario:

- **Corporativo / Formal**: `#1A56DB` + `#374151` (confianza, sobriedad)
- **Financiero / Datos**: `#0F2A44` + `#0E9F6E` (solidez, tablas claras)
- **Educativo / Académico**: `#0E7490` + `#D97706` (claridad y énfasis)
- **Creativo / Marketing**: `#7C3AED` + `#DB2777` (energía y contraste)
- **Salud / Minimal**: `#047857` + `#57534E` (limpieza, calma)

**Tipografía**: `Inter, Helvetica, Arial, sans-serif`. Cuerpo: 11pt/14pt, H1: 18-22pt negrita, H2: 14-16pt semibold. Márgenes: A4 vertical 20mm; presentación 16:9.

---

## 3. Protocolo de Maquetación Editorial (Ruta kit.js)

1. **Auditoría previa**: Revisa el contenido antes de maquetar (referencias cruzadas, numeración de tablas y figuras).
2. **Estructura limpia**: Portada independiente, índice dinámico, secciones numeradas, conclusiones y anexos al final.
3. **Generación aislada**: Crea el script `build.js` en una carpeta temporal fuera del árbol del kit (`scripts/`).
4. **Validación visual**: Si LibreOffice está disponible, previsualiza la conversión a PDF (`soffice --headless --convert-to pdf salida.docx`) antes de entregar.
5. **Entrega clara**: Enumera al usuario las decisiones de diseño tomadas y cualquier confirmación pendiente de contenido.
