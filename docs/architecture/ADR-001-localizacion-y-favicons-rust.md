---
id: ADR-001
title: "Localización de Interfaz y Favicons Canónicos RGB de 24 Agentes IA en Ratatui/Rust"
date: 2026-11-08
status: accepted
author: "Andrés Valencia Tobón (@quijotevitruvio) & Equipo HerdrEspañol"
tags:
  - adr
  - architecture
  - rust
  - ratatui
  - tui
  - nerdfonts
  - localization
  - rgb-colors
related:
  - "[[ADR-002-sistema-notificacion-actualizaciones]]"
  - "[[ADR-003-orquestacion-multi-agente-hermes]]"
  - "[[GRAPHIFY-ARCHITECTURE]]"
  - "[[README]]"
---

# ADR-001: Localización de Interfaz y Favicons Canónicos RGB de 24 Agentes IA en Ratatui/Rust

## Contexto

Herdr es una estación de trabajo y orquestador TUI (Terminal User Interface) de alto rendimiento para desarrolladores que trabajan con agentes de inteligencia artificial y shells concurrentes, implementado en Rust sobre la biblioteca `ratatui` y el emulador de terminal `ghostty-vt`.

En su distribución oficial en inglés (`upstream`):
1. La totalidad de las etiquetas de navegación, encabezados de paneles, opciones de menú y estados de los procesos se presentan únicamente en inglés (`spaces`, `agents`, `idle`, `working`, `blocked`, `done`, `new`, `menu`).
2. La barra lateral de agentes identifica las instancias mediante texto plano o identificadores genéricos, lo que genera fatiga cognitiva y retraso en la identificación visual cuando el usuario opera simultáneamente múltiples CLI de IA (por ejemplo, Google Antigravity, Anthropic Claude Code, Nous Hermes y OpenCode).
3. Los espacios de trabajo (`spaces` / `workspaces`) carecían de diferenciación visual jerárquica instantánea entre directorios abiertos, carpetas colapsadas, ramas Git activas y árboles de trabajo vinculados (`git worktree`).

Al escalar el uso a flujos multi-agente intensivos, surge la necesidad de contar con una experiencia 100% localizada en español nativo y un sistema de diseño visual inmediato basado en glifos tipográficos canónicos (Nerd Fonts v3+) y colores RGB de marca fidedignos.

> [!NOTE]
> La suite de detección de Herdr define canónicamente 24 agentes IA reconocidos en tiempo de ejecución a través del enum `crate::detect::Agent` (`Agent::ALL: [Self; 24]`). Cada uno posee características visuales, comportamientos de prompt y modelos de inferencia distintos.

---

## Decisión

Se adopta una arquitectura de localización y tematización de dos niveles (Motor Rust nativo + Inyección dinámica de metadatos vía Plugin de Herdr):

### 1. Localización profunda en código fuente Rust (`ratatui`)

Se implementan parches modulares sobre los componentes de interfaz en `src/client/shell/`:
- **`src/client/shell/sidebar.rs`**: Traducción de encabezados (`spaces` ➔ `espacios`), pie de panel (`new` ➔ `nuevo`, `menu` ➔ `menú`), menús contextuales y renderizado de carpetas/worktrees.
- **`src/client/shell/agent_sidebar.rs`**: Traducción de cabeceras (`agents` ➔ `agentes`), modos de ordenación (`grouped` ➔ `agrupados`, `priority` ➔ `prioridad`) y estados de ejecución.
- **`src/client/shell/context_menu.rs`**: Acciones contextuales localizadas (`Renombrar`, `Cerrar`, `Nuevo worktree`, `Abrir worktree...`, `Eliminar worktree checkout...`, `Expandir`, `Contraer`).
- **`src/input/keybind_help.rs`**: Ayuda de atajos de teclado y modales en español.

### 2. Catálogo Oficial de Favicons y Colores RGB de Marca (24 Agentes IA)

Para cada una de las 24 variantes de `Agent::ALL`, se establece el renderizado con glifos Nerd Fonts dedicados y coloración TrueColor RGB exacta mediante `ratatui::style::Color::Rgb(r, g, b)`:

| # | Agente Enum (`Agent`) | Identificador CLI | Favicon / Glifo | Color RGB (`ratatui::style::Color::Rgb`) | Código Hex | Identidad de Marca / Justificación |
| :-: | :--- | :--- | :---: | :--- | :---: | :--- |
| 1 | `Antigravity` | `agy`, `antigravity-cli` | `󰚩 ` (`\u{F06A9}`) | `Color::Rgb(66, 133, 244)` | `#4285F4` | Azul Oficial Google Antigravity & DeepMind |
| 2 | `Hermes` | `hermes` | `⚚ ` (`\u{269A}`) | `Color::Rgb(255, 107, 107)` | `#FF6B6B` | Caduceo Hermético Carmesí Nous Research |
| 3 | `Claude` | `claude` | `󰭻 ` (`\u{F0B7B}`) | `Color::Rgb(217, 119, 87)` | `#D97757` | Terracota Cálido Anthropic Claude Code |
| 4 | `OpenCode` | `opencode` | ` ` (`\u{E795}`) | `Color::Rgb(0, 210, 106)` | `#00D26A` | Verde Terminal / Hacker Matrix OpenCode |
| 5 | `Codex` | `codex` | `󰘦 ` (`\u{F0626}`) | `Color::Rgb(16, 163, 127)` | `#10A37F` | Verde Esmeralda OpenAI Codex |
| 6 | `Gemini` | `gemini` | `󰊠 ` (`\u{F02A0}`) | `Color::Rgb(142, 68, 173)` | `#8E44AD` | Púrpura Estelar Google Gemini Multimodal |
| 7 | `GithubCopilot` | `copilot`, `gh-copilot` | ` ` (`\u{F09B}`) | `Color::Rgb(110, 84, 148)` | `#6E5494` | Octocat Violeta GitHub Copilot CLI |
| 8 | `Devin` | `devin` | `󰆍 ` (`\u{F018D}`) | `Color::Rgb(41, 128, 185)` | `#2980B9` | Azul Cobalto Cognition Devin SWE |
| 9 | `Cursor` | `cursor` | `󰨞 ` (`\u{F0A1E}`) | `Color::Rgb(0, 122, 204)` | `#007ACC` | Azul IDE Anysphere Cursor AI Editor |
| 10 | `Grok` | `grok` | `󰛡 ` (`\u{F06E1}`) | `Color::Rgb(230, 126, 34)` | `#E67E22` | Naranja Cósmico xAI Grok Engine |
| 11 | `Kimi` | `kimi` | `󰽤 ` (`\u{F0F64}`) | `Color::Rgb(26, 188, 156)` | `#1ABC9C` | Turquesa Menta Moonshot Kimi Chat |
| 12 | `Qwen` | `qwen`, `qwen-code` | `󰈸 ` (`\u{F0238}`) | `Color::Rgb(231, 76, 60)` | `#E74C3C` | Rojo Alibaba Cloud Qwen / Tongyi Qianwen |
| 13 | `Qodercli` | `qoder`, `qodercli` | `󰘧 ` (`\u{F0627}`) | `Color::Rgb(52, 152, 219)` | `#3498DB` | Azul Cian Neón Qoder Assistant |
| 14 | `Cline` | `cline` | `󰒍 ` (`\u{F048D}`) | `Color::Rgb(155, 89, 182)` | `#9B59B6` | Amatista Profundo Cline Autonomous |
| 15 | `Droid` | `droid` | `󰄛 ` (`\u{F011B}`) | `Color::Rgb(46, 204, 113)` | `#2ECC71` | Verde Androide Factory Droid |
| 16 | `Kilo` | `kilo` | `󰄯 ` (`\u{F012F}`) | `Color::Rgb(241, 196, 15)` | `#F1C40F` | Amarillo Alta Intensidad Kilo AI |
| 17 | `Letta` | `letta` | `󰐚 ` (`\u{F041A}`) | `Color::Rgb(230, 81, 0)` | `#E65100` | Naranja Memoria Persistente MemGPT/Letta |
| 18 | `Mastracode` | `mastracode`, `mastra`| `󰒍 ` (`\u{F048D}`) | `Color::Rgb(142, 68, 173)` | `#8E44AD` | Magenta TypeScript Agentic Mastra |
| 19 | `Pi` | `pi` | `󰄛 ` (`\u{F011B}`) | `Color::Rgb(255, 112, 67)` | `#FF7043` | Coral Empático Inflection AI Pi |
| 20 | `Omp` | `omp` | `󰊠 ` (`\u{F02A0}`) | `Color::Rgb(0, 188, 212)` | `#00BCD4` | Cian Shell OhMyPosh Prompt Agent |
| 21 | `Kiro` | `kiro` | `󰄯 ` (`\u{F012F}`) | `Color::Rgb(233, 30, 99)` | `#E91E63` | Rosa Neón Kiro Copilot |
| 22 | `Amp` | `amp` | `󰚩 ` (`\u{F06A9}`) | `Color::Rgb(255, 193, 7)` | `#FFC107` | Ámbar Eléctrico Amp Accelerated Agent |
| 23 | `Maki` | `maki` | `󰈸 ` (`\u{F0238}`) | `Color::Rgb(121, 85, 72)` | `#795548` | Bronce Robusto Maki Worker |
| 24 | `Muse` | `muse` | `󰛡 ` (`\u{F06E1}`) | `Color::Rgb(103, 58, 183)` | `#673AB7` | Índigo Creativo Muse Copilot |

### 3. Iconografía Semántica de Espacios de Trabajo y Git

En `src/client/shell/sidebar.rs`, los espacios de trabajo se enriquecen con glifos contextuales:
- **Carpeta de Espacio Abierto (Foco/Expandido)**: `󰝰 ` (`\u{F0770}`) en `palette.accent`.
- **Carpeta de Espacio Cerrado (Colapsado)**: `󰉋 ` (`\u{F024B}`) en `palette.overlay0`.
- **Git Worktree Vinculado**: `󰙅 ` (`\u{F0645}`) en `palette.mauve` (indica sub-árbol de trabajo desacoplado).
- **Rama Git Activa**: ` ` (`\u{E725}`) seguido del nombre de la rama y contadores de ahead/behind.

### 4. Ciclo de Vida de Agentes Traducido

| Estado Interno Rust | Etiqueta Upstream | Etiqueta HerdrEspañol | Semántica para el Desarrollador |
| :--- | :--- | :--- | :--- |
| `AgentStatus::Idle` | `idle` | **Listo** (🟢) | El agente terminó su tarea previa; el prompt está libre para nuevas órdenes. |
| `AgentStatus::Working`| `working` | **Trabajando...** (🟡) | El agente está ejecutando comandos en shell, llamando herramientas o generando respuestas. |
| `AgentStatus::Blocked`| `blocked` | **Esperando tu respuesta** (🔴) | El agente pausó y requiere confirmación humana interactiva (`Enter`, `Y/N`). |
| `AgentStatus::Done` | `done` | **Completado** (🔵) | Sub-tarea o background job concluido satisfactoriamente. |
| `AgentStatus::Unknown`| `unknown` | **Desconocido** (⚪) | Shell estándar sin agente IA detectado o proceso no clasificado. |

---

## Consecuencias

### Positivas
- **Velocidad de Reconocimiento Visual**: Tiempo de identificación de agente en el sidebar reducido a menos de 100 milisegundos gracias al contraste cromático y el favicon único.
- **Claridad Operativa en Español**: Los desarrolladores hispanohablantes no interpretan erróneamente los estados del ciclo de vida, sabiendo con exactitud cuándo un agente está esperando confirmación del usuario (`blocked` ➔ `Esperando tu respuesta`).
- **Arquitectura No Destructiva**: La compatibilidad con el binario oficial upstream se mantiene intacta a través del enlace de respaldo `herdr-original.exe` y la utilidad `herdr-idioma en/es`.

### Trade-offs y Mitigaciones
- **Dependencia de Nerd Fonts**: Para terminales que no cuenten con fuentes parcheadas (ej. Cascadia Code sin glifos NF, o cmd.exe antiguo), los glifos Unicode podrían mostrarse como rectángulos de reemplazo.  
  *Mitigación*: Se recomienda explícitamente en el instalador y la documentación el uso de **MesloLGS NF**, **FiraCode NF** o **JetBrainsMono NF** en Windows Terminal, iTerm2, WezTerm o Alacritty.
- **Soporte de Color TrueColor de 24-bit**: En entornos TTY minimalistas sin soporte de 24 bits, `ratatui` degrada elegantemente a la paleta ANSI de 256 colores sin lanzar pánico.

> [!TIP]
> Para probar la tematización completa en tiempo real sin reiniciar Herdr, ejecuta la acción del plugin:
> `pwsh -File ./herdr-espanol.ps1` o consulta `[[GRAPHIFY-ARCHITECTURE]]` para el mapeo completo del código fuente.
