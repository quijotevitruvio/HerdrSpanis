# HerdrSpanis 🇪🇸 / 🇬🇧

**HerdrSpanis** es una solución completa de localización al español y tematización visual para **[Herdr](https://herdr.dev)** (el gestor y multiplexor de terminales para flotas de agentes de IA).

Ofrece dos modos de uso complementarios:
1. **Plugin Oficial de Herdr (`herdr-plugin.toml`):** Traduce dinámicamente los estados del ciclo de vida y tematiza la barra lateral con los iconos limpios y originales de cada IA sin tocar ningún ejecutable.
2. **Binario Nativo en Español (`herdr-es.exe`):** Binario optimizado y recompilado desde el código fuente oficial en Rust que traduce de raíz el 100% de la interfaz de la terminal (`espacios`, `agentes`, menús contextuales, configuración y atajos de teclado).

---

## 🇪🇸 Español

### Características Principales

#### 1. Identificación Visual de Agentes (Iconos Nerd Fonts / Tipográficos)
Sustituye los textos planos o emojis genéricos por símbolos tipográficos y glifos reconocibles de cada herramienta:
* **`󰚩 Antigravity`** (`agy` / `gemini`)
* **`⚚ Hermes`** (`hermes`)
* **` OpenCode`** (`opencode`)
* **`󰭻 Claude`** (`claude`)
* **`󰘦 Codex`** (`codex`)
* **` GitHub Copilot`** (`copilot`)
* **`󰆍 Devin`** (`devin`)
* **`󰨞 Cursor`** (`cursor`)
* **`󰛡 Grok`** (`grok`)
* **`󰽤 Kimi`** (`kimi`)
* **`󰈸 Qwen`** (`qwen`)
* **`󰘧 Qoder`** (`qodercli`)
* **`󰐚 Letta`** (`letta`)

#### 2. Ciclo de Vida Traducido al Español
* `idle` ➔ **Listo**
* `working` ➔ **Trabajando...**
* `blocked` ➔ **Esperando tu respuesta**
* `done` ➔ **Completado**
* `unknown` ➔ **Desconocido**

#### 3. Interfaz Completa en Español (Binario Nativo `herdr-es.exe`)
* **Barra lateral:** `espacios`, `agentes`, `nuevo`, `menú`.
* **Menú Global y Contextual (clic derecho):** `Renombrar`, `Cerrar`, `Nueva pestaña`, `Dividir a la derecha/abajo`, `Maximizar / Zoom`, `Configuración`, `Atajos de teclado`.
* **Ajustes:** `tema`, `indicadores`, `sonido`, `notificaciones`, `integraciones`.

---

### Instalación y Uso

#### Como Plugin de Herdr:
```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```

O para desarrollo local:
```bash
herdr plugin link F:\666999\0.Programador\HerdrEspañol
```

#### Para ejecutar la interfaz nativa 100% traducida:
```powershell
.\herdr-es.exe
```

---
---

## 🇬🇧 English

### Overview

**HerdrSpanis** provides comprehensive Spanish localization and visual agent branding for **[Herdr](https://herdr.dev)** (the terminal workspace manager built for autonomous AI coding agents).

It delivers:
1. **Official Herdr Workflow Plugin:** Dynamically translates lifecycle states and enhances the sidebar with clean typography and authentic developer glyphs for every recognized AI coding agent without patching binaries.
2. **Full Native Spanish Binary (`herdr-es.exe`):** A production-ready executable compiled directly from upstream Rust source code that localizes 100% of the terminal TUI (`espacios`, `agentes`, context menus, settings, and keybind overlays).

---

### Features

#### 1. Authentic AI Agent Icons (Nerd Fonts / Glyphs)
Clean typographic symbols representing the original identity of each agent:
* **`󰚩 Antigravity`** (Google Antigravity CLI)
* **`⚚ Hermes`** (Nous Research Hermes Agent)
* **` OpenCode`** (OpenCode TUI)
* **`󰭻 Claude`** (Anthropic Claude Code)
* **`󰘦 Codex`** (Codex CLI)
* **` GitHub Copilot`** (GitHub Copilot CLI)
* **`󰆍 Devin`** (Devin Terminal)
* **`󰨞 Cursor`** (Cursor CLI)
* **`󰛡 Grok`** (xAI Grok)
* **`󰽤 Kimi`** (Moonshot Kimi)
* **`󰈸 Qwen`** (Alibaba Qwen Code)

#### 2. Localized Lifecycle States
* `idle` ➔ **Listo**
* `working` ➔ **Trabajando...**
* `blocked` ➔ **Esperando tu respuesta**
* `done` ➔ **Completado**
* `unknown` ➔ **Desconocido**

#### 3. Native Spanish Shell (`herdr-es.exe`)
* **Sidebar:** `espacios`, `agentes`, `nuevo`, `menú`.
* **Context & Global Menus:** Fully translated popups, action triggers, and configuration screens.

---

### Installation & Quickstart

#### Via Herdr Plugin Marketplace:
```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```

#### Local Development Linking:
```bash
herdr plugin link F:\666999\0.Programador\HerdrEspañol
```

#### Running the Native Spanish TUI:
```powershell
.\herdr-es.exe
```

---

## 📄 Licencia / License
MIT © [quijotevitruvio](https://github.com/quijotevitruvio)
