---
id: GRAPHIFY-ARCHITECTURE
title: "Grafo de Conocimiento Arquitectónico (AST): Upstream Rust vs Artefactos HerdrEspañol"
date: 2026-11-08
status: active
author: "Andrés Valencia Tobón (@quijotevitruvio) & Equipo HerdrEspañol"
tags:
  - graphify
  - ast
  - architecture
  - knowledge-graph
  - rust
  - obsidian
  - herdr
  - patches
  - scripts
related:
  - "[[ADR-001-localizacion-y-favicons-rust]]"
  - "[[ADR-002-sistema-notificacion-actualizaciones]]"
  - "[[ADR-003-orquestacion-multi-agente-hermes]]"
  - "[[README]]"
---

# Grafo de Conocimiento Arquitectónico (AST): Upstream Rust vs Artefactos HerdrEspañol

Este documento constituye el **mapa topológico y de dependencias AST (Abstract Syntax Tree)** que vincula los componentes del motor original en Rust (`herdr-src/`) con los artefactos de localización, parches, scripts de automatización y plugins de `HerdrEspañol`.

> [!NOTE]
> Siguiendo el flujo simbiótico de **Graphify + Obsidian**, este grafo preserva la memoria persistente de la arquitectura del proyecto, optimiza el consumo de tokens en prompts de agentes IA y permite auditar en segundos el impacto de cualquier cambio upstream.

---

## 1. Visualización del Grafo de Conocimiento AST

```mermaid
graph TD
    subgraph Upstream_Rust["Motor Núcleo Upstream (herdr-src)"]
        A1["src/detect/mod.rs<br/><i>enum Agent (24 variantes)<br/>enum AgentState</i>"]
        A2["src/ui/sidebar/tokens.rs<br/><i>sidebar_agent_rows()<br/>sidebar_space_rows()<br/>ResolvedTokenKind</i>"]
        A3["src/client/shell/agent_sidebar.rs<br/><i>render_agent_panel_header()<br/>render_agent_list()<br/>render_agent_row()</i>"]
        A4["src/client/shell/sidebar.rs<br/><i>render_sidebar()<br/>workspace_rows()<br/>render_workspace_rows()</i>"]
        A5["src/client/shell/context_menu.rs<br/><i>ClientContextMenuOverlay<br/>ClientContextMenuTarget</i>"]
        A6["src/client/shell/state.rs<br/><i>ClientShellSnapshot<br/>ClientShellState</i>"]
        A7["src/input/keybind_help.rs<br/><i>Atajos de Teclado y Modales</i>"]
    end

    subgraph Patches["Capa de Parches y Compilación (Rust/Zig)"]
        P1["patches/v0.9.5-espanol.patch<br/><i>Diff unificado de localización</i>"]
        P2["scripts/herdr-actualizar-es.ps1<br/><i>Orquestador de compilación (Zig/Cargo) y Releases</i>"]
    end

    subgraph Runtime_Localizacion["Capa de Extensión y Runtime (HerdrEspañol)"]
        E1["herdr-plugin.toml<br/><i>Manifiesto de Eventos y Acciones</i>"]
        E2["herdr-espanol.ps1<br/><i>Inyector dinámico de metadatos e iconos</i>"]
        E3["scripts/herdr-idioma.ps1<br/><i>Conmutador en caliente ES ↔ EN</i>"]
        E4["scripts/lanzar-agente.ps1<br/><i>Lanzador Multi-Agente con LANG=es_ES</i>"]
        E5["ayuda-menu.ps1<br/><i>Panel popup TUI en español</i>"]
    end

    subgraph Obsidian_Docs["Memoria Persistente Obsidian PKM"]
        O1["[[ADR-001-localizacion-y-favicons-rust]]"]
        O2["[[ADR-002-sistema-notificacion-actualizaciones]]"]
        O3["[[ADR-003-orquestacion-multi-agente-hermes]]"]
        O4["[[README]]"]
    end

    %% Relaciones AST y de Flujo
    A1 -->|Define tipos de agente| A2
    A2 -->|Alimenta tokens a| A3
    A2 -->|Alimenta tokens a| A4
    A6 -->|Suministra snapshot de estado a| A3
    A6 -->|Suministra snapshot de estado a| A4
    A5 -->|Inyecta menús en| A4

    P1 -.->|Modifica en caliente| A3
    P1 -.->|Modifica en caliente| A4
    P1 -.->|Modifica en caliente| A5
    P1 -.->|Modifica en caliente| A7

    P2 ==>|Aplica P1 y compila con Zig/Cargo| Upstream_Rust

    E1 -->|Dispara en pane.created / status_changed| E2
    E2 -->|Ejecuta herdr pane report-metadata| A6
    E3 -->|Alterna junctions en .herdr/current| P2
    E4 -->|herdr pane split con agentes| A1

    O1 -.->|Documenta diseño de| A3
    O1 -.->|Documenta diseño de| A4
    O2 -.->|Documenta diseño de| P2
    O3 -.->|Documenta orquestación de| E4
    O4 -.->|Índice central de| Obsidian_Docs
```

---

## 2. Matriz de Nodos AST y Trazabilidad

| Nodo Fuente Upstream | Entidad AST Principal | Archivo de HerdrEspañol Vinculado | ADR Vinculado | Responsabilidad Arquitectónica |
| :--- | :--- | :--- | :--- | :--- |
| `src/detect/mod.rs` | `enum Agent`, `Agent::ALL: [Self; 24]`, `enum AgentState` | `herdr-espanol.ps1`, `patches/v0.9.5-espanol.patch` | `[[ADR-001-localizacion-y-favicons-rust]]` | Define el catálogo completo de 24 agentes IA detectables y sus estados (`Idle`, `Working`, `Blocked`, `Unknown`). |
| `src/ui/sidebar/tokens.rs` | `sidebar_agent_rows()`, `sidebar_space_rows()`, `ResolvedTokenKind` | `patches/v0.9.5-espanol.patch` | `[[ADR-001-localizacion-y-favicons-rust]]` | Resuelve los tokens de visualización y asocia etiquetas a cada fila de agente o espacio. |
| `src/client/shell/agent_sidebar.rs` | `render_agent_panel_header()`, `render_agent_list()`, `render_agent_row()`, `sidebar_status_text()` | `patches/v0.9.5-espanol.patch`, `herdr-espanol.ps1` | `[[ADR-001-localizacion-y-favicons-rust]]` | Renderizado visual del panel lateral de agentes, cabeceras en español (`agentes`, `agrupados`, `prioridad`), favicons y colores RGB. |
| `src/client/shell/sidebar.rs` | `render_sidebar()`, `workspace_rows()`, `render_workspace_rows()` | `patches/v0.9.5-espanol.patch` | `[[ADR-001-localizacion-y-favicons-rust]]`, `[[ADR-002-sistema-notificacion-actualizaciones]]` | Renderizado del panel de espacios (`espacios`, `nuevo`, `menú`), iconos de carpetas (`󰝰 `, `󰉋 `), worktrees (`󰙅 `), ramas Git (` `) y footer de actualizaciones. |
| `src/client/shell/context_menu.rs` | `ClientContextMenuOverlay::items()`, `ClientContextMenuTarget` | `patches/v0.9.5-espanol.patch` | `[[ADR-001-localizacion-y-favicons-rust]]` | Opciones de menú contextual del botón derecho traducidas (`Renombrar`, `Cerrar`, `Nuevo worktree`, `Expandir`, `Contraer`). |
| `src/client/shell/state.rs` | `ClientShellSnapshot`, `ClientShellWorkspace`, `ClientShellAgent` | `herdr-espanol.ps1` | `[[ADR-003-orquestacion-multi-agente-hermes]]` | Estructuras de datos del estado de la terminal; recibe metadatos inyectados desde `herdr pane report-metadata`. |
| `src/input/keybind_help.rs` | `keybind_help_text()` | `patches/v0.9.5-espanol.patch`, `ayuda-menu.ps1` | `[[ADR-001-localizacion-y-favicons-rust]]` | Textos del diálogo modal de ayuda de atajos de teclado (`Ctrl+b`, particiones, navegación). |
| Build Toolchain (`Cargo.toml`) | `herdr binary target` | `scripts/herdr-actualizar-es.ps1` | `[[ADR-002-sistema-notificacion-actualizaciones]]` | Proceso de compilación con `zig.exe 0.16.0` y `cargo build --release --bin herdr`. |
| Plugin Runtime (`~/.herdr/plugins`) | `herdr-plugin.toml` | `herdr-plugin.toml`, `herdr-espanol.ps1` | `[[ADR-001-localizacion-y-favicons-rust]]`, `[[ADR-003-orquestacion-multi-agente-hermes]]` | Suscripción reactiva a eventos del shell de Herdr para inyección sin recompilación obligatoria. |

---

## 3. Protocolo de Extracción y Actualización Continua (Graphify)

Para mantener este grafo sincronizado automáticamente con los cambios en el código fuente de upstream o de los parches:

```bash
# 1. Extraer o actualizar el grafo AST completo hacia la bóveda Obsidian
graphify . --obsidian

# 2. Actualización incremental tras aplicar parches o modificar scripts
graphify . --update

# 3. Instalación del hook de Git para regeneración automática en cada commit
graphify hook install
```

> [!TIP]
> Al realizar code reviews o refactorizaciones con **Google Antigravity** o **Nous Hermes** (según `[[ADR-003-orquestacion-multi-agente-hermes]]`), este documento actúa como mapa mental de contexto ultraligero que evita releer miles de líneas de Rust innecesariamente.
