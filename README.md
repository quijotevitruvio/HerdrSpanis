<div align="center">

# HerdrSpanis 🇪🇸

[![Herdr](https://img.shields.io/badge/Herdr-v0.9.5-6366f1?style=for-the-badge&logo=terminal)](https://herdr.dev)
[![GitHub Stars](https://img.shields.io/github/stars/quijotevitruvio/HerdrSpanis?style=for-the-badge&logo=github&color=gold)](https://github.com/quijotevitruvio/HerdrSpanis/stargazers)
[![Donar con PayPal](https://img.shields.io/badge/Donar-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/bibliotecologo)
[![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=for-the-badge)](https://github.com/quijotevitruvio/HerdrSpanis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**La solución definitiva para tener [Herdr](https://herdr.dev) 100% en español sin perder las actualizaciones ni el binario oficial.**  
*The ultimate solution for a 100% Spanish Herdr experience without losing official upstream releases.*

---

### 🌐 Selecciona tu Idioma / Select your Language

[🇪🇸 **Leer en Español (Guía para Principiantes)**](#-español) &nbsp;&nbsp;|&nbsp;&nbsp; [🇬🇧 **Read in English (Beginner Guide)**](#-english)

---

</div>

<br/>

<details open>
<summary><h2 id="-español" style="display:inline;">🇪🇸 Español — Guía Paso a Paso</h2></summary>

### 💡 ¿Por qué HerdrSpanis?

[Herdr](https://herdr.dev) es un potente gestor y multiplexor de terminales para agentes de Inteligencia Artificial (Antigravity, Claude, Hermes, OpenCode, Codex, Devin, etc.). Sin embargo, su interfaz original viene **completamente en inglés**.

**HerdrSpanis lo traduce todo con un solo comando y sin romper nada:**
* ✅ **100% en Español:** Barra lateral (`espacios`, `agentes`, `menú`), menús contextuales de clic derecho y configuración.
* ✅ **Ciclo de vida en español:** `Listo`, `Trabajando...`, `Esperando tu respuesta`, `Completado`.
* ✅ **Iconos oficiales tipográficos:** Cada IA tiene su glifo distintivo en lugar de emojis planos.
* ✅ **Seguridad total:** Mantiene una copia de tu binario oficial (`herdr-original.exe`). Puedes alternar entre español e inglés cuando quieras.

---

### 🚀 Instalación en 1 Solo Paso (Elige tu situación)

Abre **PowerShell** (o Windows Terminal) y pega este único comando:

```powershell
irm https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/instalar.ps1 | iex
```

El instalador detecta automáticamente en qué situación estás y hace todo por ti:

#### 🟢 Camino 1: Si YA tienes Herdr instalado en inglés
* **¿Se borran mis proyectos, pestañas o configuraciones?**  
  **¡No, absolutamente nada!** Todo tu trabajo, historial y ajustes se mantienen intactos.
* **¿Qué hace el comando en tu equipo?**
  1. Detecta la versión oficial que tienes instalada.
  2. Guarda una copia de seguridad automática de tu ejecutable oficial llamada `herdr-original.exe` (nunca pierdes lo oficial).
  3. Descarga la versión en español para esa misma versión y la conecta al sistema.
  4. Deja listos los comandos para que puedas volver al inglés oficial cuando quieras.
* **Para verlo:** Cierra tu ventana actual de Herdr, abre una terminal nueva y escribe `herdr`.

#### 🔵 Camino 2: Si es tu PRIMERA VEZ y lo quieres en español desde cero
* **¿Necesitas descargar o instalar algo antes?**  
  **¡No necesitas nada previo!** Solo pega la misma línea de comando.
* **¿Qué hace el comando en tu equipo?**
  1. Detecta que no tienes Herdr instalado.
  2. Descarga e instala la versión oficial de Herdr de fondo.
  3. Aplica de inmediato la traducción completa al español y el paquete de iconos tipográficos para cada IA.
  4. Configura el comando `herdr` globalmente en tu computadora.
* **Para comenzar:** Abre una terminal nueva, escribe `herdr` y listo para programar.

---

### 🎮 Comandos Globales y Cómo Usarlos

Una vez instalado, usa estos comandos directamente en cualquier terminal:

| Comando | ¿Qué hace? | ¿Cuándo usarlo? |
| :--- | :--- | :--- |
| `herdr` | Inicia Herdr completamente en español. | Para tu trabajo diario con agentes IA. |
| `herdr-idioma es` | Activa el modo **100% en Español**. | Cuando quieras ver la interfaz traducida. |
| `herdr-idioma en` | Vuelve al **Inglés oficial de fábrica**. | Cuando quieras usar temporalmente el binario original intacto. |
| `herdr-idioma` | Consulta qué idioma está activo. | Para verificar el estado de tu instalación. |
| `herdr-actualizar-es` | Actualiza y sincroniza con nuevas versiones. | Cuando el equipo oficial de Herdr lance una actualización. |

---

### ✨ Iconos Canónicos de Agentes IA

HerdrSpanis reconoce tus agentes y los muestra con sus iconos tipográficos oficiales:

| Agente / CLI | Icono | Estado traducido |
| :--- | :---: | :--- |
| **Google Antigravity** | `󰚩 Antigravity` | `idle` ➔ **Listo** |
| **Nous Hermes** | `⚚ Hermes` | `working` ➔ **Trabajando...** |
| **OpenCode** | ` OpenCode` | `blocked` ➔ **Esperando tu respuesta** |
| **Anthropic Claude Code**| `󰭻 Claude` | `done` ➔ **Completado** |
| **Codex** | `󰘦 Codex` | `unknown` ➔ **Desconocido** |
| **GitHub Copilot** | ` GitHub Copilot` | |
| **Devin** | `󰆍 Devin` | |
| **Cursor** | `󰨞 Cursor` | |
| **xAI Grok** | `󰛡 Grok` | |
| **Moonshot Kimi** | `󰽤 Kimi` | |
| **Alibaba Qwen** | `󰈸 Qwen` | |

---

### 📖 Atajos de Teclado Útiles

* **Prefijo:** `Ctrl + b`
* `Ctrl + b` luego `v`: Dividir panel verticalmente (derecha).
* `Ctrl + b` luego `-`: Dividir panel horizontalmente (abajo).
* `Ctrl + b` luego `z`: Maximizar / restaurar panel.
* `Ctrl + b` luego `c`: Nueva pestaña.
* `Ctrl + b` luego `w`: Menú de espacios de trabajo.
* `Ctrl + b` luego `x`: Cerrar panel actual.

---

### 💖 Apoya el Proyecto

Si esta herramienta te ayuda en tu día a día programando con Inteligencia Artificial:

* ⭐ **Danos una estrella en GitHub:** [github.com/quijotevitruvio/HerdrSpanis](https://github.com/quijotevitruvio/HerdrSpanis) (¡Nos ayuda muchísimo a llegar a más gente!).
* ☕ **Donaciones por PayPal:** Invítame un café o apoya el mantenimiento de futuras versiones y traducciones:  
  👉 **[https://paypal.me/bibliotecologo](https://paypal.me/bibliotecologo)**

</details>

<br/>

---

<br/>

<details>
<summary><h2 id="-english" style="display:inline;">🇬🇧 English — Quickstart Guide</h2></summary>

### 💡 Why HerdrSpanis?

[Herdr](https://herdr.dev) is an agent-centric terminal workspace multiplexer built for AI coding tools. By default, the interface is hardcoded in English.

**HerdrSpanis** provides full Spanish localization while preserving official upstream compatibility:
* Translates 100% of the interface (`espacios`, `agentes`, context menus, settings).
* Translates AI lifecycle states: `Listo` (Ready), `Trabajando...` (Working), `Esperando tu respuesta` (Waiting for input).
* Adds authentic developer glyphs/icons for AI agents.
* Retains the official upstream binary as a backup (`herdr-original.exe`) with 1-click language toggling.

---

### 🚀 1-Step Installation (Choose your situation)

Paste this single command in **PowerShell**:

```powershell
irm https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/instalar.ps1 | iex
```

The installer detects your scenario automatically:

#### 🟢 Path 1: You ALREADY have Herdr installed in English
* **Will I lose any data or workspaces?** No, nothing is lost. All sessions, configurations, and workspaces remain intact.
* **What does the command do?**
  1. Detects your current official English installation.
  2. Creates an automatic backup named `herdr-original.exe` (you never lose upstream).
  3. Downloads and links the matching Spanish build.
  4. Sets up `herdr-idioma` so you can revert to English anytime.
* **To see it:** Restart your terminal and run `herdr`.

#### 🔵 Path 2: It is your FIRST TIME and you want Spanish from scratch
* **Do you need to install anything beforehand?** No prerequisite downloads needed.
* **What does the command do?**
  1. Detects Herdr is missing.
  2. Downloads and installs upstream Herdr in the background.
  3. Immediately applies complete Spanish localization and authentic AI glyphs.
  4. Configures global `herdr` commands on your PATH.
* **To start:** Open a new terminal and type `herdr`.

---

### 🎮 Global Commands

| Command | Action |
| :--- | :--- |
| `herdr` | Launch Herdr in full Spanish. |
| `herdr-idioma es` | Switch to Spanish interface. |
| `herdr-idioma en` | Revert to official upstream English binary. |
| `herdr-idioma` | Check active language. |
| `herdr-actualizar-es` | Auto-sync and update Spanish version against upstream releases. |

---

### 💖 Support & Donations

* ⭐ **Star this repo:** [quijotevitruvio/HerdrSpanis](https://github.com/quijotevitruvio/HerdrSpanis)
* ☕ **PayPal Donation:** [https://paypal.me/bibliotecologo](https://paypal.me/bibliotecologo)

</details>

<br/>

---
<div align="center">
  <b><a href="https://paypal.me/bibliotecologo">☕ Apoyar en PayPal</a> &nbsp;•&nbsp; <a href="https://github.com/quijotevitruvio/HerdrSpanis">⭐ Dar Estrella en GitHub</a></b>
</div>
