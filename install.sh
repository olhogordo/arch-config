#!/bin/bash
# ==========================================================
# ARCH LINUX SETUP - PÓS ARCHINSTALL
# Roda após archinstall com i3wm já configurado
# Filosofia: Simples > Complexo | Entendível > Otimizado
# ==========================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; }
step()  { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }

CURRENT_USER=$(whoami)
HOME_DIR="/home/$CURRENT_USER"
ARCH_CONFIG_DIR="$HOME_DIR/cfg/arch-config"

step "1. Verificando sistema..."
if ! grep -q "Arch" /etc/os-release; then
    error "Este script é feito para Arch Linux. Abortando."
    exit 1
fi

step "2. Atualizando sistema..."
sudo pacman -Syu --noconfirm || {
    error "Falha ao atualizar o sistema."
    exit 1
}

step "3. Instalando pacotes..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git curl wget nano \
    pipewire pipewire-pulse pipewire-alsa alsa-utils \
    ttf-jetbrains-mono-nerd \
    feh rofi alacritty i3status-rust \
    thunar thunar-volman gvfs \
    dex xss-lock i3lock brightnessctl \
    keepassxc anki mpv obsidian \
    ripgrep fd bat eza zoxide bottom starship lazygit \
    fzf jq tree ncdu zathura nsxiv neovim zellij || {
    error "Falha ao instalar pacotes."
    exit 1
}

step "4. Criando estrutura de pastas..."
mkdir -p "$HOME_DIR"/{cfg,proj,sec,mid/wallpapers,dl,ref,lab,tmp,bin}
mkdir -p "$HOME_DIR/cfg/scripts"

step "5. Baixando wallpaper..."
WALLPAPER_DIR="$HOME_DIR/mid/wallpapers"
WALLPAPER_URL="https://w.wallhaven.cc/full/qz/wallhaven-qzqqp7.png"
WALLPAPER_FILE="$WALLPAPER_DIR/wallhaven-qzqqp7.png"

if [ ! -f "$WALLPAPER_FILE" ]; then
    mkdir -p "$WALLPAPER_DIR"
    info "Baixando wallpaper..."
    curl -L -o "$WALLPAPER_FILE" "$WALLPAPER_URL" || warn "Falha ao baixar wallpaper."
    [ -f "$WALLPAPER_FILE" ] && info "Wallpaper baixado!"
else
    info "Wallpaper já existe. Pulando."
fi

step "6. Clonando/Atualizando Arch-Config..."
if [ ! -d "$ARCH_CONFIG_DIR" ]; then
    git clone https://github.com/olhogordo/arch-config.git "$ARCH_CONFIG_DIR" || {
        error "Falha ao clonar repositório."
        exit 1
    }
else
    cd "$ARCH_CONFIG_DIR" && git pull || warn "Falha ao atualizar repositório."
fi

step "7. Criando Symlinks..."
create_link() {
    local target=$1
    local link=$2
    if [ -L "$link" ] || [ -f "$link" ] || [ -d "$link" ]; then
        rm -rf "$link"
    fi
    mkdir -p "$(dirname "$link")"
    ln -sf "$target" "$link"
    info "Link: $link -> $target"
}

mkdir -p "$HOME_DIR/.config"/{alacritty,rofi,zellij,nvim,i3status-rust}

create_link "$ARCH_CONFIG_DIR/i3/config" "$HOME_DIR/.config/i3/config"
create_link "$ARCH_CONFIG_DIR/alacritty/alacritty.toml" "$HOME_DIR/.config/alacritty/alacritty.toml"
create_link "$ARCH_CONFIG_DIR/alacritty/gruvbox_dark.toml" "$HOME_DIR/.config/alacritty/gruvbox_dark.toml"
create_link "$ARCH_CONFIG_DIR/rofi/config.rasi" "$HOME_DIR/.config/rofi/config.rasi"
create_link "$ARCH_CONFIG_DIR/zellij/config.kdl" "$HOME_DIR/.config/zellij/config.kdl"
create_link "$ARCH_CONFIG_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"
create_link "$ARCH_CONFIG_DIR/nvim/init.lua" "$HOME_DIR/.config/nvim/init.lua"

if [ -f "$ARCH_CONFIG_DIR/i3status-rust/config.toml" ]; then
    create_link "$ARCH_CONFIG_DIR/i3status-rust/config.toml" "$HOME_DIR/.config/i3status-rust/config.toml"
fi

echo ""
echo "=========================================================="
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${NC}"
echo "=========================================================="
echo "🚀 PRÓXIMOS PASSOS:"
echo "  1. REINICIE para carregar as configs."
echo "  2. Abra Neovim e execute :Lazy para instalar plugins."
echo "  3. Configure KeePassXC em ~/sec/"
echo "  4. Aponte Obsidian para ~/ref/ ou ~/proj/"
echo "=========================================================="
