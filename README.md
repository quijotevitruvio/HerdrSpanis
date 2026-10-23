<div align="center">

# HerdrSpanis

[![Herdr Plugin](https://img.shields.io/badge/Herdr-Plugin-6366f1?style=for-the-badge&logo=terminal)](https://herdr.dev/plugins)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=for-the-badge)](https://github.com/quijotevitruvio/HerdrSpanis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Localización al Español y Tematización de Agentes IA para [Herdr](https://herdr.dev)**  
*Spanish Localization & AI Agent Visual Theming for [Herdr](https://herdr.dev)*

---

### 🌐 Selecciona tu Idioma / Select your Language

[🇪🇸 **Leer en Español**](#-español) &nbsp;&nbsp;|&nbsp;&nbsp; [🇬🇧 **Read in English**](#-english)

---

</div>

<br/>

<details open>
<summary><h2 id="-español" style="display:inline;">🇪🇸 Español</h2></summary>

### 💡 ¿Qué es HerdrSpanis?

**HerdrSpanis** es una solución pensada para que cualquier desarrollador hispanohablante disfrute de **Herdr** completamente en español, sin complicaciones ni comandos raros.

Ofrece **dos formas fáciles de usarlo**, según lo que necesites:

| Método | ¿Para quién es? | ¿Qué traduce? | Instalación |
| :--- | :--- | :--- | :--- |
| **Opción 1: Plugin Oficial** | Quienes ya usan Herdr oficial y quieren instalarlo en 1 segundo. | Estados de las IAs (`Listo`, `Trabajando...`, `Esperando tu respuesta`) e iconos de identidad. | `herdr plugin install quijotevitruvio/HerdrSpanis` |
| **Opción 2: Auto-Sincronización con el Oficial** | Quienes quieren estar **siempre en la versión oficial**, pero con **todo en español** y la opción de volver a inglés cuando quieran. | 100% de la interfaz completa de la terminal (`espacios`, `agentes`, menús y configuración) sin perder el binario oficial. | `herdr-actualizar-es` y alternar con `herdr-idioma [es\|en]` |
| **Opción 3: Binario Directo** | Quienes solo quieren descargar y correr el ejecutable listo. | 100% de la interfaz completa de la terminal. | Descargar `herdr-es.exe` desde [Releases](../../releases). |

---

### 🚀 Instalación y Comandos

#### Opción 1: Instalar como Plugin Oficial de Herdr
Si ya tienes Herdr abierto, abre cualquier terminal y escribe:
```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```
¡Y listo! Al iniciar Herdr, tus agentes y estados se adaptarán automáticamente al español.

#### Opción 2: Sincronizar con el Oficial y Alternar Idioma al Instante
Si usas la instalación oficial de Herdr (`herdr.dev`) y quieres que todo esté en español sin romper actualizaciones futuras:

1. **Actualizar y sincronizar con el oficial:**
   ```bash
   herdr-actualizar-es
   ```
   *Detecta la versión oficial más reciente, hace backup del binario original (`herdr-original.exe`), descarga/aplica el español y lo deja listo.*

2. **Alternar entre Español e Inglés oficial cuando quieras:**
   ```bash
   herdr-idioma es   # Activa la versión completa en Español
   herdr-idioma en   # Vuelve al Inglés oficial original
   herdr-idioma      # Muestra el idioma activo actual
   ```

#### Opción 3: Descargar Ejecutable Directo
1. Ve a la sección de [**Releases**](../../releases).
2. Descarga `herdr-es.exe`.
3. Ejecútalo y tendrás toda la interfaz en español nativo (`espacios`, `agentes`, `menú`, `configuración`).

---

### ✨ Iconos Canónicos de Agentes
HerdrSpanis reemplaza los emojis genéricos por los glifos tipográficos oficiales de cada inteligencia artificial:

* **`󰚩 Antigravity`** (Google Antigravity CLI)
* **`⚚ Hermes`** (Nous Research Hermes Agent)
* **` OpenCode`** (OpenCode TUI)
* **`󰭻 Claude`** (Anthropic Claude Code)
* **`󰘦 Codex`** (Codex)
* **` GitHub Copilot`** (GitHub Copilot CLI)
* **`󰆍 Devin`** (Devin Terminal)
* **`󰨞 Cursor`** (Cursor CLI)
* **`󰛡 Grok`** (xAI Grok)
* **`󰽤 Kimi`** (Moonshot Kimi)
* **`󰈸 Qwen`** (Alibaba Qwen Code)

---

### 📊 Estados Traducidos
- `idle` ➔ **Listo**
- `working` ➔ **Trabajando...**
- `blocked` ➔ **Esperando tu respuesta**
- `done` ➔ **Completado**
- `unknown` ➔ **Desconocido**

---

### 📖 Menú y Guía Rápida de Atajos
Si estás dentro de Herdr y quieres consultar todos los atajos en español en una ventana modal:
```bash
herdr plugin pane open --plugin herdr-spanis --entrypoint menu-ayuda --placement overlay
```

</details>

<br/>

---

<br/>

<details>
<summary><h2 id="-english" style="display:inline;">🇬🇧 English</h2></summary>

### 💡 What is HerdrSpanis?

**HerdrSpanis** is an all-in-one Spanish localization and agent branding suite for **Herdr** (the terminal multiplexer designed for autonomous AI coding agents).

It provides **two flexible installation tiers**:

| Method | Best for | What it translates | How to use |
| :--- | :--- | :--- | :--- |
| **Option 1: Official Plugin** | Users wanting a lightweight, 1-second install via the Herdr marketplace. | AI lifecycle states (`Listo`, `Trabajando...`, `Esperando tu respuesta`) and authentic agent icons. | `herdr plugin install quijotevitruvio/HerdrSpanis` |
| **Option 2: Official Sync & Toggle** | Users who want to **stay on official Herdr releases** while enjoying a full Spanish interface with 1-click language toggling. | 100% of the terminal TUI (`espacios`, `agentes`, context menus, settings) while keeping official binaries backed up. | `herdr-actualizar-es` and toggle via `herdr-idioma [es\|en]` |
| **Option 3: Direct Binary** | Users who just want a single standalone translated executable. | 100% of the terminal TUI. | Direct executable download from [Releases](../../releases). |

---

### 🚀 Installation & Commands

#### Option 1: Install via Herdr Plugin Manager
Run directly inside any terminal:
```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```

#### Option 2: Sync with Official Upstream & Toggle Language
For users running official `herdr.dev` installations:

1. **Update and sync with official releases:**
   ```bash
   herdr-actualizar-es
   ```
   *Detects latest official release, creates backup (`herdr-original.exe`), downloads/builds Spanish release, and points the active link.*

2. **Toggle language on demand:**
   ```bash
   herdr-idioma es   # Activate Spanish (100% localized)
   herdr-idioma en   # Switch back to official English
   herdr-idioma      # Show active language status
   ```

#### Option 3: Full Spanish Native Binary
1. Download `herdr-es.exe` directly from [**Releases**](../../releases).
2. Launch it to enjoy the complete translated experience out-of-the-box.

---

### ✨ Authentic AI Agent Icons
Clean Nerd Font glyphs representing each agent's true identity:
* **`󰚩 Antigravity`** (Google Antigravity CLI)
* **`⚚ Hermes`** (Nous Research Hermes Agent)
* **` OpenCode`** (OpenCode TUI)
* **`󰭻 Claude`** (Anthropic Claude Code)
* **`󰘦 Codex`** (Codex)
* **` GitHub Copilot`** (GitHub Copilot CLI)
* **`󰆍 Devin`** (Devin Terminal)
* **`󰨞 Cursor`** (Cursor CLI)
* **`󰛡 Grok`** (xAI Grok)
* **`󰽤 Kimi`** (Moonshot Kimi)
* **`󰈸 Qwen`** (Alibaba Qwen Code)

---

### 📊 Translated Lifecycle States
- `idle` ➔ **Listo** (Ready)
- `working` ➔ **Trabajando...** (Working)
- `blocked` ➔ **Esperando tu respuesta** (Waiting for input)
- `done` ➔ **Completado** (Completed)
- `unknown` ➔ **Desconocido** (Unknown)

---

### 📖 Interactive Keybind Guide
Launch the in-app Spanish help cheat-sheet at any time:
```bash
herdr plugin pane open --plugin herdr-spanis --entrypoint menu-ayuda --placement overlay
```

</details>

<br/>

---

## 📄 Licencia / License
MIT © [quijotevitruvio](https://github.com/quijotevitruvio)
