#!/usr/bin/env bash
# ==============================================================================
# HerdrSpanis - Alternador de Idioma (Español / Inglés Oficial) para Linux / macOS
# ==============================================================================

set -e

STANDALONE_DIR="$HOME/.herdr/packages/standalone"
CURRENT_LINK="$STANDALONE_DIR/current"
RELEASES_DIR="$STANDALONE_DIR/releases"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

if [ ! -d "$RELEASES_DIR" ]; then
    echo -e "${RED}[Error] No se encontró el directorio de versiones de Herdr en '$RELEASES_DIR'.${NC}"
    exit 1
fi

DIR_OFICIAL=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "*-espanol*" | sort -r | head -n 1)
DIR_ESPANOL=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d -name "*-espanol*" | sort -r | head -n 1)

ESTADO_ACTUAL="Desconocido"
TARGET_LINK=""

if [ -L "$CURRENT_LINK" ]; then
    TARGET_LINK=$(readlink "$CURRENT_LINK" || true)
    if [[ "$TARGET_LINK" == *"-espanol"* ]]; then
        ESTADO_ACTUAL="Español (Nativo traducido)"
    else
        ESTADO_ACTUAL="Inglés (Oficial original)"
    fi
fi

IDIOMA="$1"

if [ -z "$IDIOMA" ] || [ "$IDIOMA" = "estado" ] || [ "$IDIOMA" = "status" ]; then
    echo -e "\n${CYAN}=== ESTADO DE IDIOMA EN HERDR ===${NC}"
    echo -n "Idioma actual activo: "
    if [[ "$ESTADO_ACTUAL" == *"Español"* ]]; then
        echo -e "${GREEN}$ESTADO_ACTUAL${NC}"
    else
        echo -e "${YELLOW}$ESTADO_ACTUAL${NC}"
    fi
    echo -e "${GRAY}Destino de 'current': $TARGET_LINK${NC}"
    echo -e "\nPara cambiar de idioma ejecuta:"
    echo -e "  herdr-idioma es   -> Cambiar a Español (100% traducido)"
    echo -e "  herdr-idioma en   -> Cambiar a Inglés (Oficial de fábrica)"
    echo -e "\n${GRAY}⭐ GitHub: https://github.com/quijotevitruvio/HerdrSpanis | ☕ PayPal: https://paypal.me/bibliotecologo${NC}\n"
    exit 0
fi

if [ "$IDIOMA" = "es" ]; then
    if [ -z "$DIR_ESPANOL" ]; then
        echo -e "${RED}[Error] No se encontró ninguna versión en español en '$RELEASES_DIR'. Ejecuta 'herdr-actualizar-es' para generarla.${NC}"
        exit 1
    fi
    ln -sfn "$DIR_ESPANOL" "$CURRENT_LINK"
    echo -e "\n${GREEN}[OK] Herdr ha sido configurado en ESPAÑOL.${NC}"
    echo -e "${GRAY}Versión activa: $(basename "$DIR_ESPANOL")${NC}"
    echo -e "${CYAN}Reinicia tu terminal de Herdr para ver los cambios.${NC}\n"
elif [ "$IDIOMA" = "en" ]; then
    if [ -z "$DIR_OFICIAL" ]; then
        echo -e "${RED}[Error] No se encontró ninguna versión oficial en '$RELEASES_DIR'.${NC}"
        exit 1
    fi
    ln -sfn "$DIR_OFICIAL" "$CURRENT_LINK"
    echo -e "\n${YELLOW}[OK] Herdr ha sido restaurado al INGLÉS OFICIAL.${NC}"
    echo -e "${GRAY}Versión activa: $(basename "$DIR_OFICIAL")${NC}"
    echo -e "${CYAN}Reinicia tu terminal de Herdr para ver los cambios.${NC}\n"
else
    echo -e "${RED}[Error] Opción no válida: '$IDIOMA'. Usa 'es', 'en' o 'estado'.${NC}"
    exit 1
fi
