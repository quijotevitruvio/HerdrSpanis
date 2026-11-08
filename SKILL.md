---
name: herdr-spanis
description: "Aplica estados en español, tematización con iconos canónicos para 24 IAs en Herdr, orquestación de escuadrones con Hermes Auditor y sistema de notificaciones de actualización con caché TTL."
---

# HerdrSpanis

Skill y orquestador de localización para **Herdr**. Permite identificar visualmente cada agente mediante iconos tipográficos Nerd Fonts, traducir los estados del ciclo de vida a español nativo y desplegar escuadrones multi-agente con copiloto auditor en tiempo real.

## Catálogo de 24 IAs Soportadas

| Agente | Nombre e Icono Canónico |
| :--- | :--- |
| `antigravity` / `agy` | 󰚩 Antigravity |
| `claude` | 󰭻 Claude |
| `hermes` | ⚚ Hermes |
| `opencode` |  OpenCode |
| `codex` | 󰘦 Codex |
| `gemini` | 󰊠 Gemini |
| `cursor` | 󰨞 Cursor |
| `devin` | 󰆍 Devin |
| `grok` | 󰛡 Grok |
| `kimi` | 󰽤 Kimi |
| `qwen` / `qwen-code` | 󰈸 Qwen |
| `cline` | 󰞋 Cline |
| `kiro` | 󰘧 Kiro |
| `droid` | 󰄛 Droid |
| `amp` | 󰘦 Amp |
| `kilo` | 󰄯 Kilo |
| `qoder` / `qodercli` | 󰘧 Qoder |
| `letta` | 󰐚 Letta |
| `maki` | 󰒍 Maki |
| `muse` | 󰝚 Muse |
| `omp` | 󰊠 OhMyPosh |
| `mastra` / `mastracode` | 󰒍 Mastra |
| `pi` | 󰄛 Pi |
| `terminal` |  Terminal |
| `copilot` |  Copilot |

## Estados Traducidos
- `idle` ➔ **Listo**
- `working` ➔ **Trabajando...**
- `blocked` ➔ **Esperando tu respuesta**
- `done` ➔ **Completado**
- `unknown` ➔ **Desconocido**

## Modos de Ejecución y Orquestación

```powershell
# Aplicar localización a paneles existentes
pwsh -File ./herdr-espanol.ps1

# Modo continuo (vigilante en segundo plano)
pwsh -File ./herdr-espanol.ps1 -Watch

# Desplegar Escuadrón Multi-Agente (Antigravity + Hermes Copiloto Auditor)
pwsh -File ./scripts/lanzar-agente.ps1 -Escuadron

# Lanzar cualquier IA individual en español
pwsh -File ./scripts/lanzar-agente.ps1 -Agente claude -Direccion right

# Verificar actualizaciones contra GitHub Releases
pwsh -File ./scripts/check-actualizacion.ps1 -CheckOnly
```
