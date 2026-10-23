---
name: herdr-spanis
description: "Aplica estados en español y añade iconos visuales a cada IA/Agente en los paneles de Herdr (✨ Antigravity, ⚡ Hermes, 🤖 OpenCode, 🧠 Claude, etc.)."
---

# HerdrSpanis

Skill y orquestador de localización para **Herdr**. Permite identificar visualmente cada agente mediante iconos y traducir los estados del ciclo de vida a español nativo sin modificar los binarios.

## Iconos de Agentes

| Agente | Nombre con Icono |
| :--- | :--- |
| `agy` | ✨ Antigravity |
| `hermes` | ⚡ Hermes |
| `opencode` | 🤖 OpenCode |
| `claude` | 🧠 Claude |
| `copilot` | 🐙 Copilot |
| `devin` | 🎯 Devin |
| `grok` | 🌌 Grok |

## Estados Traducidos
- `idle` ➔ **Listo**
- `working` ➔ **Trabajando...**
- `blocked` ➔ **Esperando tu respuesta**
- `done` ➔ **Completado**
- `unknown` ➔ **Desconocido**

## Uso
```powershell
# Una sola ejecución
pwsh -File ./herdr-espanol.ps1

# Modo continuo (vigilante en segundo plano)
pwsh -File ./herdr-espanol.ps1 -Watch
```
