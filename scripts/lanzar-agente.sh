#!/usr/bin/env bash
# ==============================================================================
# HerdrSpanis - Lanzador y Orquestador Multi-Agente (Linux / macOS)
# ==============================================================================

set -e

AGENTE="${1:-antigravity}"
DIRECCION="${2:-right}"
MODO_ESCUADRON=false

for arg in "$@"; do
    case "$arg" in
        -Escuadron|--escuadron|-HermesAuditor|--hermes-auditor)
            MODO_ESCUADRON=true
            ;;
    esac
done

export LANG="es_ES.UTF-8"
export LC_ALL="es_ES.UTF-8"
export HERMES_LANG="es"

HERDR_CMD=""
if [ -n "$HERDR_BIN_PATH" ] && [ -x "$HERDR_BIN_PATH" ]; then
    HERDR_CMD="$HERDR_BIN_PATH"
elif command -v herdr >/dev/null 2>&1; then
    HERDR_CMD="$(command -v herdr)"
elif [ -x "$HOME/.herdr/packages/standalone/current/herdr" ]; then
    HERDR_CMD="$HOME/.herdr/packages/standalone/current/herdr"
else
    HERDR_CMD="herdr"
fi

get_cmd() {
    local a="$1"
    case "$a" in
        antigravity) echo "agy" ;;
        claude)      echo "claude --prompt 'Por favor responde en español.'" ;;
        hermes)      echo "hermes" ;;
        opencode)    echo "opencode" ;;
        codex)       echo "codex" ;;
        gemini)      echo "gemini" ;;
        cursor)      echo "cursor" ;;
        devin)       echo "devin" ;;
        grok)        echo "grok" ;;
        kimi)        echo "kimi" ;;
        qwen)        echo "qwen" ;;
        cline)       echo "cline" ;;
        kiro)        echo "kiro" ;;
        droid)       echo "droid" ;;
        amp)         echo "amp" ;;
        kilo)        echo "kilo" ;;
        qodercli)    echo "qodercli" ;;
        letta)       echo "letta" ;;
        maki)        echo "maki" ;;
        muse)        echo "muse" ;;
        omp)         echo "omp" ;;
        mastracode)  echo "mastracode" ;;
        pi)          echo "pi" ;;
        terminal)    echo "bash" ;;
        *)           echo "bash" ;;
    esac
}

launch_pane() {
    local target="$1"
    local cmd="$2"
    local pane_id=""

    if [ "$target" = "tab" ]; then
        local res
        res=$($HERDR_CMD tab create 2>/dev/null || true)
        pane_id=$(echo "$res" | grep -oE '"pane_id": *"[^"]+"' | head -n 1 | cut -d'"' -f4 || true)
    elif [ "$target" = "right" ] || [ "$target" = "down" ]; then
        local res
        res=$($HERDR_CMD pane split --direction "$target" 2>/dev/null || true)
        pane_id=$(echo "$res" | grep -oE '"pane_id": *"[^"]+"' | head -n 1 | cut -d'"' -f4 || true)
    fi

    if [ -n "$pane_id" ] && [ -n "$cmd" ]; then
        sleep 0.25
        $HERDR_CMD pane run "$pane_id" "$cmd" 2>/dev/null || true
    fi
}

CMD_PRINCIPAL=$(get_cmd "$AGENTE")

if [ "$MODO_ESCUADRON" = true ]; then
    echo -e "\n\033[1;33m╔══════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;33m║       🚀 DESPLEGANDO ESCUADRÓN MULTI-AGENTE HERDR             ║\033[0m"
    echo -e "\033[1;33m╚══════════════════════════════════════════════════════════════╝\033[0m"
    echo -e "\033[0;36m Agente Principal : $AGENTE (Panel Izquierdo)\033[0m"
    echo -e "\033[0;32m Copiloto Auditor : ⚚ Hermes Agent (Panel Derecho)\033[0m"
    echo -e "\033[0;90m Modo             : Auditoría y background jobs simultáneos\033[0m\n"

    launch_pane "$DIRECCION" "$CMD_PRINCIPAL"
    sleep 0.4
    launch_pane "right" "hermes"
    echo -e "\033[0;32m[OK] Escuadrón multi-agente configurado en Herdr.\033[0m\n"
else
    echo -e "\n\033[0;36m=== LANZADOR DE AGENTES IA EN HERDR (ESPAÑOL) ===\033[0m"
    echo -e "\033[0;32mIniciando $AGENTE...\033[0m"
    launch_pane "$DIRECCION" "$CMD_PRINCIPAL"
fi
