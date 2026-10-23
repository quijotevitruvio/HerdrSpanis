---
name: herdr-espanol
description: "Aplica traducción y localización al español en la interfaz de Herdr (estados, nombres de agentes y alertas). Actívala cada vez que inicies Herdr o quieras que los paneles muestren Listo, Trabajando..., Esperando respuesta, etc."
---

# Herdr en Español

Esta Skill permite traducir y mantener las etiquetas de estado, nombres de agentes y notificaciones de **Herdr** en español de manera automática y en tiempo real utilizando la API nativa de metadatos de Herdr (`herdr pane report-metadata`).

## Funcionalidades
1. **Estados de Agentes en Español:**
   - `idle` ➔ **Listo**
   - `working` ➔ **Trabajando...**
   - `blocked` ➔ **Esperando tu respuesta**
   - `done` ➔ **Completado**
   - `unknown` ➔ **Desconocido**

2. **Nombres de Agentes Localizados:**
   - `agy` ➔ **Antigravity (Español)**
   - `hermes` ➔ **Hermes Agent (Español)**
   - `opencode` ➔ **OpenCode (Español)**
   - `claude` ➔ **Claude Code (Español)**

## Uso Rápido

Para aplicar la traducción a todos los paneles activos de la sesión actual:

```powershell
pwsh -File ./herdr-espanol.ps1
```

Para mantener la traducción activa en segundo plano (vigilando paneles nuevos):

```powershell
pwsh -File ./herdr-espanol.ps1 -Watch
```
