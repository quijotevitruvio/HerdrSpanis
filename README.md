<div align="center">

# HerdrSpanis 🇪🇸

[![Herdr Plugin](https://img.shields.io/badge/Herdr-Plugin-6366f1?style=for-the-badge&logo=terminal)](https://herdr.dev/plugins)
[![GitHub Stars](https://img.shields.io/github/stars/quijotevitruvio/HerdrSpanis?style=for-the-badge&logo=github&color=gold)](https://github.com/quijotevitruvio/HerdrSpanis/stargazers)
[![Donar con PayPal](https://img.shields.io/badge/Donar-PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/bibliotecologo)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-blue?style=for-the-badge)](https://github.com/quijotevitruvio/HerdrSpanis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**La solución definitiva para tener [Herdr](https://herdr.dev) completamente en español sin perder las actualizaciones ni el binario oficial.**  
*The ultimate solution for a 100% Spanish Herdr experience without losing official upstream releases.*

---

### 🌐 Selecciona tu Idioma / Select your Language

[🇪🇸 **Leer en Español (Guía para Principiantes)**](#-español) &nbsp;&nbsp;|&nbsp;&nbsp; [🇬🇧 **Read in English (Beginner Guide)**](#-english)

---

</div>

<br/>

<details open>
<summary><h2 id="-español" style="display:inline;">🇪🇸 Español — Guía Paso a Paso (Para Dummies)</h2></summary>

### 💡 ¿Qué es HerdrSpanis y por qué lo necesitas?

[Herdr](https://herdr.dev) es un gestor y multiplexor de terminales diseñado para trabajar con agentes de Inteligencia Artificial (Antigravity, Claude, Hermes, OpenCode, Codex, Devin, etc.). Sin embargo, su interfaz original viene **100% en inglés**.

**HerdrSpanis resuelve esto por completo:**
* Traduce absolutamente toda la interfaz (`espacios`, `agentes`, `menú`, `configuración` y clic derecho).
* Traduce los estados de las IAs a español real: `Listo`, `Trabajando...`, `Esperando tu respuesta`.
* Sustituye los emojis genéricos por los **iconos tipográficos oficiales** de cada IA.
* **No pierdes la versión oficial:** Puedes volver al inglés oficial cuando quieras y actualizarte con cada nueva versión de Herdr.

---

### 🚀 Instalación Ultra Fácil en 1 Solo Paso (Recomendada)

Si estás en **Windows**, abre PowerShell (la terminal azul o Windows Terminal) y pega esta única línea:

```powershell
irm https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/instalar.ps1 | iex
```

#### ¿Qué hace este comando automáticamente por ti?
1. Detecta si ya tienes Herdr instalado (si no lo tienes, lo instala por ti).
2. Hace una copia de respaldo segura de tu ejecutable oficial (`herdr-original.exe`).
3. Descarga la versión en español ya compilada y optimizada.
4. Instala los comandos globales en tu sistema (`herdr`, `herdr-idioma`, `herdr-actualizar-es`).
5. ¡Listo! Solo abres una nueva terminal, escribes `herdr` y ya lo ves todo en español.

---

### 🎮 Comandos Disponibles y Cómo Usarlos

Una vez instalado, tienes estos sencillos comandos en cualquier ventana de tu computadora:

| Comando | ¿Qué hace? | ¿Cuándo usarlo? |
| :--- | :--- | :--- |
| `herdr` | Inicia Herdr normalmente. | Para abrir tu entorno de trabajo con agentes IA. |
| `herdr-idioma es` | Activa el modo **100% en Español**. | Cuando quieras ver toda la interfaz en español. |
| `herdr-idioma en` | Restaura el **Inglés oficial de fábrica**. | Cuando quieras volver temporalmente al inglés original. |
| `herdr-idioma` | Muestra el estado del idioma actual. | Para verificar qué versión tienes activa. |
| `herdr-actualizar-es` | Actualiza Herdr y sincroniza el español. | Cada vez que el equipo de Herdr lance una nueva versión oficial. |

---

### 🛠️ Métodos Alternativos de Instalación

Si prefieres hacerlo manualmente según tu caso:

#### Método A: Como Plugin Oficial de Herdr (Solo estados e iconos)
Si ya tienes Herdr oficial abierto y solo quieres traducir los estados de los agentes e iconos:
```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```

#### Método B: Descargar el Ejecutable Directo (.exe)
1. Ve a la pestaña de [**Releases**](https://github.com/quijotevitruvio/HerdrSpanis/releases).
2. Descarga el archivo [`herdr-es.exe`](https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v0.9.5-espanol/herdr-es.exe).
3. Haz doble clic o ejecútalo en tu terminal: `.\herdr-es.exe`.

---

### ✨ Iconos Canónicos de Agentes IA

HerdrSpanis reemplaza los emojis planos por la identidad visual tipográfica de cada herramienta:

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

### 📖 Guía Rápida de Atajos de Teclado
Dentro de Herdr puedes abrir en cualquier momento la chuleta modal de atajos en español:
```bash
herdr plugin pane open --plugin herdr-spanis --entrypoint menu-ayuda --placement overlay
```

* **Prefijo por defecto:** `Ctrl + b`
* `Ctrl + b` luego `v`: Dividir panel verticalmente (derecha).
* `Ctrl + b` luego `-`: Dividir panel horizontalmente (abajo).
* `Ctrl + b` luego `z`: Maximizar o des-maximizar panel.
* `Ctrl + b` luego `c`: Crear nueva pestaña.
* `Ctrl + b` luego `w`: Abrir menú de espacios de trabajo.
* `Ctrl + b` luego `x`: Cerrar panel.

---

### 💖 Apoya este Proyecto

Si este proyecto te ha sido útil, te ahorró dolores de cabeza o te ayuda a trabajar más cómodo en tu idioma:

* ⭐ **Regálanos una estrella en GitHub:** [github.com/quijotevitruvio/HerdrSpanis](https://github.com/quijotevitruvio/HerdrSpanis) (¡Nos ayuda muchísimo a ganar visibilidad!).
* ☕ **Donaciones por PayPal:** Si deseas invitarme un café o apoyar el mantenimiento de futuras versiones y traducciones:
  👉 **[https://paypal.me/bibliotecologo](https://paypal.me/bibliotecologo)**

</details>

<br/>

---

<br/>

<details>
<summary><h2 id="-english" style="display:inline;">🇬🇧 English — Beginner-Friendly Guide</h2></summary>

### 💡 What is HerdrSpanis?

[Herdr](https://herdr.dev) is an agent-centric terminal workspace manager for AI coding tools. By default, its entire interface is hardcoded in English.

**HerdrSpanis** provides complete Spanish localization without losing official upstream support:
* Translates 100% of the native terminal TUI (`espacios`, `agentes`, `menú`, context menus, settings).
* Translates lifecycle states: `Listo` (Ready), `Trabajando...` (Working), `Esperando tu respuesta` (Waiting for input).
* Adds authentic Nerd Font / glyph icons for AI coding agents.
* Keeps the official upstream executable backed up with 1-second language toggling.

---

### 🚀 1-Line Automatic Installer (Windows)

Open PowerShell and paste this single command:

```powershell
irm https://raw.githubusercontent.com/quijotevitruvio/HerdrSpanis/main/instalar.ps1 | iex
```

It will detect your current Herdr install, create a safety backup (`herdr-original.exe`), install the translated binary, and configure global commands.

---

### 🎮 Global Command Reference

| Command | Description |
| :--- | :--- |
| `herdr` | Launch Herdr in full Spanish. |
| `herdr-idioma es` | Activate 100% Spanish interface. |
| `herdr-idioma en` | Restore official English factory binary. |
| `herdr-idioma` | Check current active language. |
| `herdr-actualizar-es` | Auto-sync and rebuild/download Spanish version when Herdr updates. |

---

### 🛠️ Alternative Installation Methods

* **Official Plugin Only (States & Icons):**
  ```bash
  herdr plugin install quijotevitruvio/HerdrSpanis
  ```
* **Direct Standalone Binary:**
  Download [`herdr-es.exe`](https://github.com/quijotevitruvio/HerdrSpanis/releases/download/v0.9.5-espanol/herdr-es.exe) from [Releases](https://github.com/quijotevitruvio/HerdrSpanis/releases).

---

### 💖 Support & Donations

If this project saves you time or makes your terminal workflow easier:
* ⭐ **Star the repository:** [quijotevitruvio/HerdrSpanis](https://github.com/quijotevitruvio/HerdrSpanis)
* ☕ **Donate via PayPal:** [https://paypal.me/bibliotecologo](https://paypal.me/bibliotecologo)

</details>

<br/>

---
<div align="center">
  Hecho con dedicación para la comunidad hispanohablante de desarrollo con IA.  
  <b><a href="https://paypal.me/bibliotecologo">☕ Apoyar en PayPal</a> &nbsp;•&nbsp; <a href="https://github.com/quijotevitruvio/HerdrSpanis">⭐ Dar Estrella en GitHub</a></b>
</div>
