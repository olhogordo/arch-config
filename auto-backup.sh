#!/bin/bash
# ==========================================================
# ARCH LINUX CYBERPUNK SETUP - INSTALAÇÃO AUTOMATIZADA
# Filosofia: Simples > Complexo | Entendível > Otimizado
# ==========================================================

set -e # Para o script imediatamente se qualquer comando falhar

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }
error() { echo -e "${RED}[ERRO]${NC} $1"; }
step()  { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }

# Detectar usuário e home dinamicamente (à prova de falhas)
CURRENT_USER=$(whoami)
HOME_DIR="/home/$CURRENT_USER"
ARCH_CONFIG_DIR="$HOME_DIR/cfg/arch-config"

step "1. Verificando permissões e sistema..."
if ! grep -q "Arch" /etc/os-release; then
    warn "Este script é feito para Arch Linux. Abortando."
    exit 1
fi

step "2. Atualizando sistema (com confirmação manual para segurança)..."
# Removido --noconfirm para evitar decisões forçadas em rolling release
sudo pacman -Syu

step "3. Instalando pacotes base (Pacman)..."
sudo pacman -S --needed --noconfirm \
    base-devel git curl wget vim nano \
    xorg xorg-xinit xorg-server \
    networkmanager network-manager-applet \
    pipewire pipewire-pulse pipewire-alsa alsa-utils \
    ttf-jetbrains-mono-nerd papirus-icon-theme \
    feh rofi alacritty i3-wm i3status-rust \
    thunar thunar-volman gvfs \
    dex xss-lock i3lock brightnessctl \
    keepassxc anki mpv obsidian \
    ripgrep fd bat eza zoxide bottom procs sd starship lazygit \
    fzf jq tree ncdu zathura nsxiv nushell dunst clipmenu helix

step "4. Instalando Paru (AUR Helper em Rust)..."
if ! command -v paru &> /dev/null; then
    info "Clonando e compilando paru..."
    cd /tmp
    rm -rf paru
    git clone https://aur.archlinux.org/paru.git || {
        error "Falha ao clonar paru. Verifique sua conexão com a internet."
        exit 1
    }
    cd paru
    makepkg -si --noconfirm || {
        error "Falha ao compilar paru. Verifique se base-devel está instalado."
        exit 1
    }
    cd ~
    rm -rf /tmp/paru
    info "Paru instalado com sucesso."
else
    info "Paru já está instalado."
fi

step "5. Instalando pacotes AUR permitidos..."
paru -S --noconfirm librewolf-bin || {
    error "Falha ao instalar librewolf-bin do AUR."
    exit 1
}

step "6. Criando estrutura de pastas semântica..."
mkdir -p "$HOME_DIR"/{cfg,proj,sec,mid/wallpapers,dl,ref,lab,tmp,bin}
mkdir -p "$HOME_DIR/cfg/scripts"

step "7. Baixando wallpaper do Wallhaven..."
WALLPAPER_DIR="$HOME_DIR/mid/wallpapers"
WALLPAPER_URL="https://w.wallhaven.cc/full/qz/wallhaven-qzqqp7.png"
WALLPAPER_FILE="$WALLPAPER_DIR/wallhaven-qzqqp7.png"

if [ ! -f "$WALLPAPER_FILE" ]; then
    mkdir -p "$WALLPAPER_DIR"
    info "Baixando wallpaper..."
    curl -L -o "$WALLPAPER_FILE" "$WALLPAPER_URL" || {
        warn "Falha ao baixar wallpaper. Você pode baixar manualmente depois."
    }
    if [ -f "$WALLPAPER_FILE" ]; then
        info "Wallpaper baixado com sucesso!"
    fi
else
    info "Wallpaper já existe. Pulando download."
fi

step "8. Clonando/Atualizando Arch-Config do GitHub..."
if [ ! -d "$ARCH_CONFIG_DIR" ]; then
    info "Clonando repositório..."
    git clone https://github.com/olhogordo/arch-config.git "$ARCH_CONFIG_DIR" || {
        error "Falha ao clonar repositório. Verifique sua conexão."
        exit 1
    }
else
    info "Repositório já existe. Atualizando..."
    cd "$ARCH_CONFIG_DIR" && git pull || {
        warn "Falha ao atualizar repositório. Continuando com versão local."
    }
fi

step "9. Criando Symlinks das configurações..."
create_link() {
    local target=$1
    local link=$2
    if [ -L "$link" ] || [ -f "$link" ]; then
        rm -f "$link"
    fi
    ln -sf "$target" "$link"
    info "Link criado: $link -> $target"
}

mkdir -p "$HOME_DIR/.config"/{i3,alacritty,rofi,nushell,zellij,dunst,helix}

create_link "$ARCH_CONFIG_DIR/i3/config" "$HOME_DIR/.config/i3/config"
create_link "$ARCH_CONFIG_DIR/alacritty/alacritty.toml" "$HOME_DIR/.config/alacritty/alacritty.toml"
create_link "$ARCH_CONFIG_DIR/alacritty/gruvbox_dark.toml" "$HOME_DIR/.config/alacritty/gruvbox_dark.toml"
create_link "$ARCH_CONFIG_DIR/rofi/config.rasi" "$HOME_DIR/.config/rofi/config.rasi"
create_link "$ARCH_CONFIG_DIR/zellij/config.kdl" "$HOME_DIR/.config/zellij/config.kdl"
create_link "$ARCH_CONFIG_DIR/nushell/config.nu" "$HOME_DIR/.config/nushell/config.nu"
create_link "$ARCH_CONFIG_DIR/starship.toml" "$HOME_DIR/.config/starship.toml"
create_link "$ARCH_CONFIG_DIR/dunst/dunstrc" "$HOME_DIR/.config/dunst/dunstrc"
create_link "$ARCH_CONFIG_DIR/helix/config.toml" "$HOME_DIR/.config/helix/config.toml"
create_link "$ARCH_CONFIG_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"

step "10. Configurando Nushell como shell padrão..."
if ! grep -q "$(which nu)" /etc/shells; then
    echo "$(which nu)" | sudo tee -a /etc/shells > /dev/null
fi
chsh -s "$(which nu)"

step "11. Finalização e Limpeza..."
fc-cache -f > /dev/null 2>&1
sudo pacman -Scc --noconfirm

echo ""
echo "=========================================================="
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "=========================================================="
echo ""
echo "🚀 PRÓXIMOS PASSOS (MANUAIS):"
echo "  1. REINICIE o computador (ou faça logout/login) para o Nushell e i3 carregarem."
echo "  2. Abra o KeePassXC e configure sua database em ~/sec/"
echo "  3. Abra o Obsidian e aponte para sua vault em ~/ref/ ou ~/proj/"
echo ""
echo "🦀 Seu sistema agora está 100% automatizado e linkado!"
echo "=========================================================="
