#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Menú y Guía de Atajos en Español para Herdr (Popup Pane de HerdrSpanis).
#>

Clear-Host
Write-Host "╔══════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                   🇪🇸 HERDR - MENÚ Y ATAJOS EN ESPAÑOL                    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  🔑 MODO PREFIJO (Por defecto: " -NoNewline
Write-Host "Ctrl + b" -ForegroundColor Yellow -NoNewline
Write-Host ")"
Write-Host "  ──────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Prefijo + ?          ➔ Mostrar menú de ayuda y ajustes"
Write-Host "  Prefijo + s          ➔ Abrir configuración (Settings)"
Write-Host "  Prefijo + q          ➔ Desconectar sesión (Detach)"
Write-Host "  Prefijo + Shift + R  ➔ Recargar config.toml en vivo"
Write-Host "  Prefijo + b          ➔ Mostrar / ocultar barra lateral (Sidebar)"
Write-Host ""
Write-Host "  🗂️ ESPACIOS DE TRABAJO (WORKSPACES) Y PESTAÑAS (TABS)" -ForegroundColor Green
Write-Host "  ──────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Prefijo + w          ➔ Selector de Espacios de Trabajo"
Write-Host "  Prefijo + g          ➔ Navegador rápido de sesión"
Write-Host "  Prefijo + Shift + N  ➔ Nuevo Espacio de Trabajo"
Write-Host "  Prefijo + Shift + G  ➔ Nuevo Git Worktree aislado"
Write-Host "  Prefijo + Shift + W  ➔ Renombrar Espacio de Trabajo"
Write-Host "  Prefijo + Shift + D  ➔ Cerrar Espacio de Trabajo"
Write-Host "  Prefijo + c          ➔ Nueva Pestaña (Tab)"
Write-Host "  Prefijo + Shift + T  ➔ Renombrar Pestaña"
Write-Host "  Prefijo + p / n      ➔ Pestaña anterior / siguiente"
Write-Host "  Prefijo + 1..9       ➔ Ir a la Pestaña 1..9"
Write-Host "  Prefijo + Shift + X  ➔ Cerrar Pestaña actual"
Write-Host ""
Write-Host "  🪟 PANELES (PANES) Y AGENTES IA" -ForegroundColor Magenta
Write-Host "  ──────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  Prefijo + v          ➔ Dividir panel verticalmente (Derecha)"
Write-Host "  Prefijo + -          ➔ Dividir panel horizontalmente (Abajo)"
Write-Host "  Prefijo + h/j/k/l    ➔ Mover foco (Izquierda / Abajo / Arriba / Derecha)"
Write-Host "  Prefijo + Tab        ➔ Alternar entre paneles"
Write-Host "  Prefijo + z          ➔ Zoom / Maximizar panel actual"
Write-Host "  Prefijo + r          ➔ Modo redimensionar panel (Resize mode)"
Write-Host "  Prefijo + Shift + P  ➔ Renombrar panel"
Write-Host "  Prefijo + [          ➔ Modo copia / desplazamiento (Copy mode)"
Write-Host "  Prefijo + e          ➔ Editar historial del panel en editor"
Write-Host "  Prefijo + x          ➔ Cerrar panel actual"
Write-Host ""
Write-Host "  Presiona [Enter] o [q] para cerrar este menú..." -ForegroundColor Yellow
$null = Read-Host
