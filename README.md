# HerdrSpanis 🇪🇸

Plugin oficial y completo de localización, tematización de agentes AI y menú de ayuda en español para **[Herdr](https://herdr.dev)**.

Cumple estrictamente con la especificación oficial de **[https://herdr.dev/docs/plugins/](https://herdr.dev/docs/plugins/)**.

---

## ✨ Características

### 1. Tematización de Agentes con Iconos Visuales
Identifica fácilmente cada inteligencia artificial en la barra lateral de Herdr:
- `✨ Antigravity` (`agy` / `gemini`)
- `⚡ Hermes` (`hermes`)
- `🤖 OpenCode` (`opencode`)
- `🧠 Claude` (`claude`)
- `💻 Codex` (`codex`)
- `🐙 Copilot` (`copilot`)
- `🎯 Devin` (`devin`)
- `⚡ Cursor` (`cursor`)
- `🌌 Grok` (`grok`)
- `🌙 Kimi` (`kimi`)
- `🐉 Qwen` (`qwen`)
- `🛠️ Qoder` (`qodercli`)
- `🧬 Letta` (`letta`)

### 2. Estados del Ciclo de Vida Traducidos
- `idle` ➔ **Listo**
- `working` ➔ **Trabajando...**
- `blocked` ➔ **Esperando tu respuesta**
- `done` ➔ **Completado**
- `unknown` ➔ **Desconocido**

### 3. Event Hooks Nativos (Sin Bucles)
El plugin escucha los eventos del socket de Herdr:
- `pane.created`
- `pane.agent_detected`
- `pane.agent_status_changed`
- `tab.created`

### 4. Menú y Atajos en Español (`[[panes]]` y `[[actions]]`)
Añade una acción global y un panel emergente modal con la referencia completa de comandos traducidos al español.

---

## 🚀 Instalación

```bash
herdr plugin install quijotevitruvio/HerdrSpanis
```

O para desarrollo local:
```bash
herdr plugin link /ruta/a/HerdrSpanis
```

---

## 🛠️ Acciones Disponibles en Herdr

Puedes invocar las acciones desde los menús contextuales de Herdr o mediante CLI:
- **Traducir paneles e iconos:**
  ```bash
  herdr plugin action invoke traducir --plugin herdr-spanis
  ```
- **Abrir Menú y Atajos en Español:**
  ```bash
  herdr plugin pane open herdr-spanis menu-ayuda
  ```

---

## 📄 Licencia
MIT © [quijotevitruvio](https://github.com/quijotevitruvio)
