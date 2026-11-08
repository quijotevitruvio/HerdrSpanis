#!/usr/bin/env bash
# ==============================================================================
# HerdrSpanis - Comprobador de Actualizaciones para Herdr en Español (Linux/macOS)
# ==============================================================================

VERSION_PLUGIN="0.3.0"
REPO_OWNER="quijotevitruvio"
REPO_NAME="HerdrSpanis"
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"

CACHE_DIR="$HOME/.herdr/cache"
CACHE_FILE="$CACHE_DIR/last-update-check.json"
CACHE_TTL=86400 # 24 horas en segundos

SILENT=false
CHECK_ONLY=false
FORCE=false

for arg in "$@"; do
    case "$arg" in
        -s|--silent|-Silent)
            SILENT=true
            ;;
        -c|--check-only|-CheckOnly)
            CHECK_ONLY=true
            ;;
        -f|--force|-ForceCheck)
            FORCE=true
            ;;
    esac
done

# Detectar versión local instalada de Herdr
LOCAL_HERDR_VERSION=""
RELEASES_DIR="$HOME/.herdr/packages/standalone/releases"
if [ -d "$RELEASES_DIR" ]; then
    DIR_ESP=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d -name "*-espanol*" | sort -r | head -n 1)
    if [ -z "$DIR_ESP" ]; then
        DIR_ESP=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d | sort -r | head -n 1)
    fi
    if [ -n "$DIR_ESP" ]; then
        DIR_BASE=$(basename "$DIR_ESP")
        LOCAL_HERDR_VERSION=$(echo "$DIR_BASE" | grep -oE '^[0-9]+\.[0-9]+(\.[0-9]+)?')
    fi
fi

# Función para comparar versiones semánticas (v1 < v2)
semver_gt() {
    local v1="${1#[vV]}"
    local v2="${2#[vV]}"
    v1="${v1%%-*}"
    v2="${v2%%-*}"

    if [ "$v1" = "$v2" ]; then
        return 1
    fi

    local IFS=.
    local i ver1=($v1) ver2=($v2)
    for ((i=0; i<${#ver1[@]} || i<${#ver2[@]}; i++)); do
        local n1=${ver1[i]:-0}
        local n2=${ver2[i]:-0}
        if ((n2 > n1)); then
            return 0
        elif ((n2 < n1)); then
            return 1
        fi
    done
    return 1
}

mostrar_banner() {
    local tag="$1"
    [[ "$tag" != v* ]] && tag="v$tag"
    echo ""
    echo -e "\033[1;33m╭─────────────────────────────────────────────────────────────╮\033[0m"
    printf "\033[1;33m│\033[0m 📢 \033[1;33mNUEVA ACTUALIZACIÓN DE HERDR EN ESPAÑOL DISPONIBLE (%-9s)│\033[0m\n" "$tag"
    echo -e "\033[1;33m│\033[0m \033[0;36mEjecuta 'herdr-actualizar-es' para actualizar al instante\033[0m   \033[1;33m│\033[0m"
    echo -e "\033[1;33m╰─────────────────────────────────────────────────────────────╯\033[0m"
    echo ""
}

DEBE_CONSULTAR=true
LATEST_TAG=""

if [ "$FORCE" = false ] && [ -f "$CACHE_FILE" ]; then
    NOW=$(date +%s)
    FILE_TIME=$(date -r "$CACHE_FILE" +%s 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
    DIFF=$((NOW - FILE_TIME))
    if [ "$DIFF" -lt "$CACHE_TTL" ]; then
        DEBE_CONSULTAR=false
        LATEST_TAG=$(grep -oE '"latest_tag": *"[^"]+"' "$CACHE_FILE" | head -n 1 | cut -d'"' -f4)
    fi
fi

if [ "$DEBE_CONSULTAR" = true ]; then
    mkdir -p "$CACHE_DIR"
    RESPONSE=$(curl -fsSL -m 4 -H "User-Agent: HerdrSpanis-CheckActualizacion/$VERSION_PLUGIN" -H "Accept: application/vnd.github.v3+json" "$API_URL" 2>/dev/null || true)
    if [ -n "$RESPONSE" ]; then
        REMOTE_TAG=$(echo "$RESPONSE" | grep -oE '"tag_name": *"[^"]+"' | head -n 1 | cut -d'"' -f4)
        if [ -n "$REMOTE_TAG" ]; then
            LATEST_TAG="$REMOTE_TAG"
            cat << EOF > "$CACHE_FILE"
{
  "last_check": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "latest_tag": "$LATEST_TAG"
}
EOF
        fi
    fi
fi

HAY_ACTUALIZACION=false
if [ -n "$LATEST_TAG" ]; then
    if [[ "$LATEST_TAG" == *"-espanol"* ]] && [ -n "$LOCAL_HERDR_VERSION" ]; then
        if semver_gt "$LOCAL_HERDR_VERSION" "$LATEST_TAG"; then
            HAY_ACTUALIZACION=true
        fi
    else
        if semver_gt "$VERSION_PLUGIN" "$LATEST_TAG"; then
            HAY_ACTUALIZACION=true
        fi
    fi
fi

if [ "$SILENT" = true ]; then
    if [ "$HAY_ACTUALIZACION" = true ]; then
        exit 1
    else
        exit 0
    fi
fi

if [ "$HAY_ACTUALIZACION" = true ]; then
    mostrar_banner "$LATEST_TAG"
elif [ "$CHECK_ONLY" = true ]; then
    echo -e "\n\033[0;32m[HerdrSpanis] Versión local del plugin: v$VERSION_PLUGIN\033[0m"
    if [ -n "$LOCAL_HERDR_VERSION" ]; then
        echo -e "\033[0;90m[HerdrSpanis] Versión de Herdr instalada: v$LOCAL_HERDR_VERSION\033[0m"
    fi
    if [ -n "$LATEST_TAG" ]; then
        echo -e "\033[0;90m[HerdrSpanis] Última versión en GitHub: $LATEST_TAG\033[0m"
    fi
    echo -e "\033[0;32m[HerdrSpanis] ¡Tu instalación de Herdr en Español está al día!\033[0m\n"
fi
