#!/bin/bash
# ==========================================================
# SCRIPT DE INSTALAÇÃO - MEU ARCH LINUX
# Rodar após instalação limpa do Arch (com internet)
# Uso: chmod +x install.sh && ./install.sh
# ==========================================================

set -e  # Para o script se algum comando falhar

# Cores para output bonito
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }

# ----------------------------------------------------------
# 1. VERIFICAÇÕES INICIAIS
# ----------------------------------------------------------
info "Verificando se é Arch Linux..."
if ! grep -q "Arch" /etc/os-release; then
    echo "Este script é feito para Arch Linux. Abortando."
    exit 1
fi

# ----------------------------------------------------------
# 2. ATUALIZAR SISTEMA E INSTALAR BASE
# ----------------------------------------------------------
info "Atualizando sistema..."
sudo pacman -Syu --noconfirm

info "Instalando dependências base..."
sudo pacman -S --needed --noconfirm \
    base-devel git curl wget vim nano \
    xorg xorg-xinit xorg-server \
    networkmanager network-manager-applet \
    pulseaudio pulseaudio-alsa alsa-utils \
    ttf-jetbrains-mono-nerd \
    feh rofi alacritty i3-wm i3status-rust \
    thunar thunar-volman gvfs \
    dex xss-lock i3lock \
    brightnessctl pipewire pipewire-pulse pipewire-alsa

# ----------------------------------------------------------
# 3. INSTALAR YAY (AUR HELPER)
# ----------------------------------------------------------
if ! command -v yay &> /dev/null; then
    info "Instalando yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay-bin
else
    info "yay já está instalado."
fi

# ----------------------------------------------------------
# 4. INSTALAR PACOTES DO AUR
# ----------------------------------------------------------
info "Instalando pacotes do AUR..."
yay -S --noconfirm \
    librewolf-bin \
    obsidian

# ----------------------------------------------------------
# 5. CLONAR DOTFILES (se ainda não existir)
# ----------------------------------------------------------
DOTFILES_DIR="$HOME/cfg/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    info "Clonando dotfiles do GitHub..."
    mkdir -p "$HOME/cfg"
    git clone https://github.com/olhogordo/arch-config.git "$DOTFILES_DIR"
else
    info "Dotfiles já existem. Atualizando..."
    cd "$DOTFILES_DIR" && git pull
fi

# ----------------------------------------------------------
# 6. CRIAR ESTRUTURA DE PASTAS
# ----------------------------------------------------------
info "Criando estrutura de pastas..."
mkdir -p "$HOME/cfg" "$HOME/proj" "$HOME/mid/wallpapers"

# ----------------------------------------------------------
# 7. CRIAR SYMLINKS DAS CONFIGS
# ----------------------------------------------------------
info "Criando links simbólicos das configurações..."

mkdir -p "$HOME/.config"

# i3
mkdir -p "$HOME/.config/i3"
[ -L "$HOME/.config/i3/config" ] || ln -sf "$DOTFILES_DIR/i3/config" "$HOME/.config/i3/config"

# Alacritty
mkdir -p "$HOME/.config/alacritty"
[ -L "$HOME/.config/alacritty/alacritty.toml" ] || ln -sf "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# Rofi
mkdir -p "$HOME/.config/rofi"
[ -L "$HOME/.config/rofi/config.rasi" ] || ln -sf "$DOTFILES_DIR/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"

# i3status-rust
mkdir -p "$HOME/.config/i3status-rust"
[ -L "$HOME/.config/i3status-rust/config.toml" ] || ln -sf "$DOTFILES_DIR/i3status-rust/config.toml" "$HOME/.config/i3status-rust/config.toml"

# ----------------------------------------------------------
# 8. CONFIGURAR .xinitrc (para startx)
# ----------------------------------------------------------
if [ ! -f "$HOME/.xinitrc" ]; then
    info "Criando .xinitrc..."
    cat > "$HOME/.xinitrc" << 'EOF'
#!/bin/sh
userresources=$HOME/.Xresources
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
exec i3
EOF
    chmod +x "$HOME/.xinitrc"
fi

# ----------------------------------------------------------
# 9. HABILITAR SERVIÇOS
# ----------------------------------------------------------
info "Habilitando serviços..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth 2>/dev/null || true

# ----------------------------------------------------------
# 10. FINALIZAÇÃO
# ----------------------------------------------------------
echo ""
echo "=========================================="
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA!${NC}"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "  1. Reinicie o computador"
echo "  2. No tty, faça login e rode: startx"
echo "  3. Ou instale um display manager (lightdm, sddm) se preferir"
echo ""
echo "⚠️  Ajustes MANUAIS que você precisa fazer:"
echo "  - Login no Obsidian (sincronização)"
echo "  - Login em navegadores/extensões"
echo "  - Wallpaper: coloque uma imagem em ~/mid/wallpapers/"
echo "  - Ajuste o caminho do wallpaper no i3/config"
echo ""
