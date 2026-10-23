# Herdr en Español 🇪🇸

Skill y demonio de localización automática para **[Herdr](https://herdr.dev)** (terminal workspace manager para flotas de agentes AI).

Herdr está compilado en Rust en inglés, pero su API nativa de socket expone el comando `pane report-metadata`, el cual permite sobreescribir las etiquetas de estado del ciclo de vida y los nombres de los agentes en tiempo real sin modificar el binario.

## 🚀 ¿Qué traduce?

| Estado Original | Traducción en Herdr |
| :--- | :--- |
| `idle` | **Listo** |
| `working` | **Trabajando...** |
| `blocked` | **Esperando tu respuesta** |
| `done` | **Completado** |
| `unknown` | **Desconocido** |

Además renombra amigablemente los agentes en la barra lateral:
- `agy` ➔ **Antigravity (Español)**
- `hermes` ➔ **Hermes Agent (Español)**
- `opencode` ➔ **OpenCode (Español)**
- `claude` ➔ **Claude Code (Español)**

---

## 📦 Instalación y Uso

### 1. Clonar el repositorio
```bash
git clone https://github.com/quijotevitruvio/herdr-espanol.git
cd herdr-espanol
```

### 2. Ejecutar la traducción (Una sola vez)
Aplica el español a todos los paneles y agentes que tengas abiertos actualmente:
```powershell
pwsh -File ./herdr-espanol.ps1
```

### 3. Modo Daemon / Vigilante
Si sueles abrir y cerrar paneles o crear pestañas continuamente, déjalo corriendo en segundo plano:
```powershell
pwsh -File ./herdr-espanol.ps1 -Watch
```

---

## 🛠️ Requisitos
- Windows / Linux / macOS con PowerShell (`pwsh`)
- [Herdr](https://herdr.dev) instalado y en ejecución

## 📄 Licencia
MIT © [quijotevitruvio](https://github.com/quijotevitruvio)
