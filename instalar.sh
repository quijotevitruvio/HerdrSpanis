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

echo -e "${YELLOW}[1/4] Verificando instalación de Herdr en Unix...${NC}"
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
echo -e "${YELLOW}[2/4] Respaldando ejecutable oficial de fábrica...${NC}"
BIN_OFICIAL="$DIR_OFICIAL/herdr"
BIN_BACKUP="$DIR_OFICIAL/herdr-original"

if [ -f "$BIN_OFICIAL" ] && [ ! -f "$BIN_BACKUP" ]; then
    cp "$BIN_OFICIAL" "$BIN_BACKUP"
    echo -e "${GREEN}[OK] Copia de seguridad guardada en: herdr-original${NC}"
fi

# 3. Descargar binario en español según sistema
echo -e "${YELLOW}[3/4] Descargando versión nativa en español...${NC}"
OS="$(uname -s)"
ARCH="$(uname -m)"
DIR_ESPANOL="$RELEASES_DIR/$NOMBRE_OFICIAL-espanol"
mkdir -p "$DIR_ESPANOL"

TAG_RELEASE="v0.9.5-espanol"
ASSET_NAME=""

if [ "$OS" = "Linux" ]; then
    ASSET_NAME="herdr-es-linux-x86_64.tar.gz"
elif [ "$OS" = "Darwin" ]; then
    ASSET_NAME="herdr-es-macos-arm64.tar.gz"
fi

if [ -n "$ASSET_NAME" ]; then
    URL="https://github.com/quijotevitruvio/HerdrSpanis/releases/download/$TAG_RELEASE/$ASSET_NAME"
    echo -e "${CYAN}    Descargando $ASSET_NAME desde GitHub Releases...${NC}"
    TMP_DIR=$(mktemp -d)
    if curl -fsSL "$URL" -o "$TMP_DIR/$ASSET_NAME"; then
        tar -xzf "$TMP_DIR/$ASSET_NAME" -C "$TMP_DIR"
        find "$TMP_DIR" -type f -name "herdr*" ! -name "*.tar.gz" -exec cp {} "$DIR_ESPANOL/herdr" \;
        chmod +x "$DIR_ESPANOL/herdr"
        echo -e "${GREEN}[OK] Binario en español instalado correctamente.${NC}"
        # Actualizar enlace current
        ln -sfn "$DIR_ESPANOL" "$CURRENT_LINK"
    else
        echo -e "${YELLOW}[!] El release compilado aún se está generando en GitHub. Se usará el plugin oficial por ahora.${NC}"
    fi
    rm -rf "$TMP_DIR"
fi

# 4. Instalar plugin oficial de tematización y agentes
echo -e "${YELLOW}[4/4] Activando plugin de agentes e interfaz en español...${NC}"
herdr plugin install quijotevitruvio/HerdrSpanis || true

echo -e "${MAGENTA}"
cat << "EOF"
  ╔════════════════════════════════════════════════════════════════════════════╗
  ║                 🎉  ¡HERDR EN ESPAÑOL ESTÁ LISTO PARA USAR!               ║
  ╚════════════════════════════════════════════════════════════════════════════╝

  Comandos rápidos:
    herdr                -> Inicia Herdr 100% en Español
    herdr plugin list    -> Verifica el plugin activo

  ────────────────────────────────────────────────────────────────────────────
  ⭐  ¿TE HA SERVIDO ESTE PROYECTO?
      Regálanos una estrella en GitHub para llegar a más desarrolladores:
      👉 https://github.com/quijotevitruvio/HerdrSpanis

  ☕  ¿QUIERES APOYAR EL DESARROLLO CONTINUO?
      Cómprame un café o dona a través de PayPal:
      👉 https://paypal.me/bibliotecologo

  👨‍💻  CREADO POR ANDRÉS VALENCIA TOBÓN
      X (Twitter): https://x.com/quijotevitruvio
      LinkedIn:    https://www.linkedin.com/in/andrés-valencia-tobón/
      TikTok:      https://www.tiktok.com/@quijotevitruvio
  ────────────────────────────────────────────────────────────────────────────
EOF
echo -e "${NC}"
