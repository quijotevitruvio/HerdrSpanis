---
id: DOCS-INDEX
title: "Bóveda de Arquitectura y Memoria Persistente de HerdrEspañol"
date: 2026-11-08
status: active
author: "Andrés Valencia Tobón (@quijotevitruvio) & Equipo HerdrEspañol"
tags:
  - index
  - architecture
  - obsidian
  - pkm
  - adr
  - graphify
  - herdr
related:
  - "[[ADR-001-localizacion-y-favicons-rust]]"
  - "[[ADR-002-sistema-notificacion-actualizaciones]]"
  - "[[ADR-003-orquestacion-multi-agente-hermes]]"
  - "[[GRAPHIFY-ARCHITECTURE]]"
---

# Bóveda de Arquitectura y Memoria Persistente de HerdrEspañol

Bienvenido al centro de documentación técnica y memoria persistente de **HerdrEspañol**. Esta bóveda está estructurada siguiendo el estándar PKM (Personal Knowledge Management) de **Obsidian** y el flujo simbiótico de **Graphify**, garantizando trazabilidad arquitectónica, optimización del contexto en agentes de IA y navegación bidireccional.

> [!NOTE]
> Esta carpeta `docs/` (junto con la configuración `.obsidian/`) puede abrirse directamente como una bóveda independiente en Obsidian o inspeccionarse desde la raíz del proyecto.

---

## 🏛️ Architecture Decision Records (ADRs)

Los registros de decisiones de arquitectura documentan los fundamentos, trade-offs y consecuencias técnicas de las modificaciones realizadas sobre el motor de Herdr:

| ID | Documento / Título | Estado | Fecha | Descripción Esencial |
| :---: | :--- | :---: | :---: | :--- |
| **001** | **[[ADR-001-localizacion-y-favicons-rust]]** | `accepted` | 2026-11-08 | Localización integral de interfaz TUI en Rust (`ratatui`) y tematización cromática de los **24 agentes IA** con favicons Nerd Fonts y colores RGB de marca (`ratatui::style::Color::Rgb`), más iconos de carpetas (`󰝰 `, `󰉋 `), worktrees (`󰙅 `) y rama Git (` `). |
| **002** | **[[ADR-002-sistema-notificacion-actualizaciones]]** | `accepted` | 2026-11-08 | Mecanismo asíncrono y no intrusivo de comprobación de nuevas versiones contra la API de GitHub Releases con **caché persistente TTL de 24 horas** (cero bloqueo en el arranque de la TUI y protección contra rate-limits). |
| **003** | **[[ADR-003-orquestacion-multi-agente-hermes]]** | `accepted` | 2026-11-08 | Patrón de **Escuadrón Multi-Agente** asíncrono asignando a **Nous Hermes** como auditor en segundo plano (testing, code review, validación de tipos) en paneles paralelos mientras el desarrollador opera con Google Antigravity o Claude Code. |

---

## 🗺️ Grafo de Conocimiento del Código Fuente (AST)

Para comprender la relación exacta entre los archivos de código upstream en Rust (`herdr-src/`) y los artefactos de personalización de `HerdrEspañol`:

* 🧭 **[[GRAPHIFY-ARCHITECTURE]]**: Grafo topológico completo de entidades sintácticas (AST), llamadas a funciones, parches de compilación y eventos del plugin.

---

## 🔍 Consultas Dinámicas para Obsidian (Dataview)

Si utilizas el plugin de Obsidian **Dataview**, las siguientes consultas se evaluarán automáticamente en tu bóveda:

### Tabla General de ADRs
```dataview
TABLE id, title AS "Título", status AS "Estado", date AS "Fecha", tags AS "Etiquetas"
FROM "docs/architecture"
WHERE contains(file.tags, "adr")
SORT id ASC
```

### Grafo de Documentos Relacionados
```dataview
LIST related
FROM "docs/architecture"
SORT file.name ASC
```

---

## ⚡ Flujo de Trabajo Recomendado para Agentes y Desarrolladores

1. **Consulta Rápida de Arquitectura**: Antes de proponer cambios en el renderizado de la terminal, consulta `[[ADR-001-localizacion-y-favicons-rust]]` para respetar las paletas de color y los glifos Unicode.
2. **Ciclo de Actualización Upstream**: Cuando se publique una nueva versión de Herdr, sigue las directrices descritas en `[[ADR-002-sistema-notificacion-actualizaciones]]` ejecutando `herdr-actualizar-es`.
3. **Desarrollo en Paralelo**: Aplica el patrón de escuadrón multi-agente de `[[ADR-003-orquestacion-multi-agente-hermes]]` delegando tareas secundarias a Nous Hermes mediante `.\scripts\lanzar-agente.ps1 -Agente hermes -Direccion right`.
4. **Sincronización de Memoria**: Tras modificar archivos del proyecto, ejecuta `graphify . --update` para regenerar los enlaces semánticos.

> [!TIP]
> Puedes regresar a la guía de usuario principal en cualquier momento abriendo el archivo raíz [README.md](../README.md).
