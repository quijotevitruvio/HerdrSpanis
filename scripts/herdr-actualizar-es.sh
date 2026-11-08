#!/usr/bin/env bash
# ==============================================================================
# HerdrSpanis - Actualizador de Herdr en Español (Linux / macOS)
# ==============================================================================

set -e

STANDALONE_DIR="$HOME/.herdr/packages/standalone"
CURRENT_LINK="$STANDALONE_DIR/current"
RELEASES_DIR="$STANDALONE_DIR/releases"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "\n${CYAN}=== ACTUALIZADOR DE HERDR EN ESPAÑOL ===${NC}"

if [ ! -d "$RELEASES_DIR" ]; then
    echo -e "${RED}[Error] No se encontró el directorio de instalaciones en '$RELEASES_DIR'.${NC}"
    exit 1
fi

DIR_OFICIAL=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "*-espanol*" | sort -r | head -n 1)

if [ -z "$DIR_OFICIAL" ]; then
    echo -e "${RED}[Error] No se encontró ninguna versión oficial instalada.${NC}"
    exit 1
fi

NOMBRE_OFICIAL=$(basename "$DIR_OFICIAL")
VERSION=$(echo "$NOMBRE_OFICIAL" | grep -oE '^[0-9]+\.[0-9]+(\.[0-9]+)?')
echo -e "Versión oficial detectada: ${GREEN}$VERSION ($NOMBRE_OFICIAL)${NC}"

# Respaldar binario oficial
if [ -f "$DIR_OFICIAL/herdr" ] && [ ! -f "$DIR_OFICIAL/herdr-original" ]; then
    cp "$DIR_OFICIAL/herdr" "$DIR_OFICIAL/herdr-original"
    echo -e "\033[0;90m[Backup] Binario original respaldado en: herdr-original\033[0m"
fi

if [ "$1" = "-CheckOnly" ] || [ "$1" = "--check-only" ]; then
    echo -e "${CYAN}Comprobación finalizada.${NC}"
    exit 0
fi

DIR_ESPANOL="$RELEASES_DIR/$NOMBRE_OFICIAL-espanol"
mkdir -p "$DIR_ESPANOL"

OS="$(uname -s)"
TAG_RELEASE="v$VERSION-espanol"
ASSET_NAME=""

if [ "$OS" = "Linux" ]; then
    ASSET_NAME="herdr-es-linux-x86_64.tar.gz"
elif [ "$OS" = "Darwin" ]; then
    ASSET_NAME="herdr-es-macos-arm64.tar.gz"
fi

DESCARGADO=false

if [ -n "$ASSET_NAME" ]; then
    URL="https://github.com/quijotevitruvio/HerdrSpanis/releases/download/$TAG_RELEASE/$ASSET_NAME"
    URL_LATEST="https://github.com/quijotevitruvio/HerdrSpanis/releases/latest/download/$ASSET_NAME"
    echo -e "${CYAN}Buscando binario en español en GitHub ($URL)...${NC}"
    
    TMP_DIR=$(mktemp -d)
    if curl -fsSL "$URL" -o "$TMP_DIR/$ASSET_NAME" 2>/dev/null || curl -fsSL "$URL_LATEST" -o "$TMP_DIR/$ASSET_NAME" 2>/dev/null; then
        tar -xzf "$TMP_DIR/$ASSET_NAME" -C "$TMP_DIR"
        find "$TMP_DIR" -type f -name "herdr*" ! -name "*.tar.gz" -exec cp {} "$DIR_ESPANOL/herdr" \;
        chmod +x "$DIR_ESPANOL/herdr"
        ln -sfn "$DIR_ESPANOL" "$CURRENT_LINK"
        DESCARGADO=true
        echo -e "${GREEN}[OK] Binario en español actualizado correctamente.${NC}"
    fi
    rm -rf "$TMP_DIR"
fi

if [ "$DESCARGADO" = false ]; then
    echo -e "${YELLOW}[!] No se pudo descargar el release precompilado de GitHub.${NC}"
    echo -e "Puedes compilar con cargo o activar el plugin de tematización."
    exit 1
fi

echo -e "\n\033[0;32m========================================================\033[0m"
echo -e "\033[0;32m ¡Herdr v$VERSION está 100% actualizado y en Español!\033[0m"
echo -e "\033[0;32m========================================================\033[0m"
echo -e "\033[0;90mComando activo: herdr (apunta a $NOMBRE_OFICIAL-espanol)\033[0m"
echo -e "\033[0;36mPara volver al inglés en cualquier momento: herdr-idioma en\033[0m\n"
