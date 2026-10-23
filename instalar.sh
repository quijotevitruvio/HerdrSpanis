#!/usr/bin/env bash
# ==============================================================================
# HerdrSpanis - Instalador Automático de Herdr en Español (Linux / macOS)
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
cat << "EOF"
  ██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ ███╗   ██╗██╗███████╗
  ██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗  ██║██║██╔════╝
  ███████║█████╗  ██████╔╝██║  ██║███████╗██████╔╝███████║██╔██╗ ██║██║███████╗
  ██╔══██║██╔══╝  ██╔══██╗██║  ██║╚════██║██╔═══╝ ██╔══██║██║╚██╗██║██║╚════██║
  ██║  ██║███████╗██║  ██║██████╔╝███████║██║     ██║  ██║██║ ╚████║██║███████║
  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚══════╝
                     Localización al Español para Herdr
EOF
echo -e "${NC}"

echo -e "${YELLOW}[1/3] Verificando instalación de Herdr en Unix...${NC}"
HERDR_DIR="$HOME/.herdr"
RELEASES_DIR="$HERDR_DIR/packages/standalone/releases"
CURRENT_LINK="$HERDR_DIR/packages/standalone/current"

if [ ! -d "$RELEASES_DIR" ]; then
    echo -e "${YELLOW}[!] No se detectó Herdr instalado. Descargando Herdr oficial...${NC}"
    curl -fsSL https://herdr.dev/install.sh | bash
fi

# Detectar versión instalada
DIR_OFICIAL=$(find "$RELEASES_DIR" -maxdepth 1 -mindepth 1 -type d ! -name "*-espanol*" | sort -r | head -n 1)

if [ -z "$DIR_OFICIAL" ]; then
    echo -e "${RED}[Error] No se encontró la carpeta oficial de releases de Herdr.${NC}"
    exit 1
fi

NOMBRE_OFICIAL=$(basename "$DIR_OFICIAL")
echo -e "${GREEN}[OK] Versión oficial detectada: $NOMBRE_OFICIAL${NC}"

# 2. Respaldar binario oficial
echo -e "${YELLOW}[2/3] Respaldando ejecutable oficial de fábrica...${NC}"
BIN_OFICIAL="$DIR_OFICIAL/herdr"
BIN_BACKUP="$DIR_OFICIAL/herdr-original"

if [ -f "$BIN_OFICIAL" ] && [ ! -f "$BIN_BACKUP" ]; then
    cp "$BIN_OFICIAL" "$BIN_BACKUP"
    echo -e "${GREEN}[OK] Copia de seguridad guardada en: herdr-original${NC}"
fi

# 3. Instalar plugin oficial de tematización y agentes
echo -e "${YELLOW}[3/3] Activando plugin de agentes e interfaz en español...${NC}"
herdr plugin install quijotevitruvio/HerdrSpanis || true

echo -e "${MAGENTA}"
cat << "EOF"
  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                 🎉  ¡HERDR EN ESPAÑOL ESTÁ LISTO PARA USAR!               ║
  ╚════════════════════════════════════════════════════════════════════════════╝

  Comandos rápidos:
    herdr                -> Inicia Herdr en Español
    herdr plugin list    -> Verifica el plugin activo

  ────────────────────────────────────────────────────────────────────────────
  ⭐  ¿TE HA SERVIDO ESTE PROYECTO?
      Regálanos una estrella en GitHub para llegar a más desarrolladores:
      👉 https://github.com/quijotevitruvio/HerdrSpanis

  ☕  ¿QUIERES APOYAR EL DESARROLLO CONTINUO?
      Cómprame un café o dona a través de PayPal:
      👉 https://paypal.me/bibliotecologo
  ────────────────────────────────────────────────────────────────────────────
EOF
echo -e "${NC}"
