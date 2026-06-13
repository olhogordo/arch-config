#!/bin/bash
# ==========================================================
# ARCH LINUX CYBERPUNK SETUP - INSTALAÇÃO AUTOMATIZADA
# Filosofia: Simples > Complexo | Entendível > Otimizado
# ==========================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }
step()  { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }

CURRENT_USER=$(whoami)
HOME_DIR="/home/$CURRENT_USER"
ARCH_CONFIG_DIR="$HOME_DIR/cfg/arch-config"

step "1. Verificando permissões e sistema..."
if ! grep -q "Arch" /etc/os-release; then
    warn "Este script é feito para Arch Linux. Abortando."
    exit 1
fi

step "2. Atualizando sistema e instalando pacotes base (Pacman)..."
sudo pacman -Syu --noconfirm

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
    ripgrep fd bat eza zoxide bottom procs sd starship lazygit restic \
    fzf jq tree ncdu zathura nsxiv nushell dunst clipmenu helix

step "3. Instalando Paru (AUR Helper em Rust)..."
if ! command -v paru &> /dev/null; then
    info "Clonando e compilando paru..."
    cd /tmp
    rm -rf paru
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/paru
    info "Paru instalado com sucesso."
else
    info "Paru já está instalado."
fi

step "4. Instalando pacotes AUR permitidos..."
paru -S --noconfirm librewolf-bin

step "5. Criando estrutura de pastas semântica..."
mkdir -p "$HOME_DIR"/{cfg,proj,sec,mid/wallpapers,dl,ref,lab,tmp,bin}
mkdir -p "$HOME_DIR/cfg/scripts"

step "6. Baixando wallpaper do Wallhaven..."
WALLPAPER_DIR="$HOME_DIR/mid/wallpapers"
WALLPAPER_URL="https://w.wallhaven.cc/full/qz/wallhaven-qzqqp7.png"
WALLPAPER_FILE="$WALLPAPER_DIR/wallhaven-qzqqp7.png"

if [ ! -f "$WALLPAPER_FILE" ]; then
    mkdir -p "$WALLPAPER_DIR"
    info "Baixando wallpaper..."
    curl -L -o "$WALLPAPER_FILE" "$WALLPAPER_URL"
    info "Wallpaper baixado com sucesso!"
else
    info "Wallpaper já existe. Pulando download."
fi

step "7. Clonando/Atualizando Arch-Config do GitHub..."
if [ ! -d "$ARCH_CONFIG_DIR" ]; then
    info "Clonando repositório..."
    git clone https://github.com/olhogordo/arch-config.git "$ARCH_CONFIG_DIR"
else
    info "Repositório já existe. Atualizando..."
    cd "$ARCH_CONFIG_DIR" && git pull
fi

step "8. Criando Symlinks das configurações..."
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

# i3
create_link "$ARCH_CONFIG_DIR/i3/config" "$HOME_DIR/.config/i3/config"

# Alacritty
create_link "$ARCH_CONFIG_DIR/alacritty/alacritty.toml" "$HOME_DIR/.config/alacritty/alacritty.toml"
create_link "$ARCH_CONFIG_DIR/alacritty/gruvbox_dark.toml" "$HOME_DIR/.config/alacritty/gruvbox_dark.toml"

# Rofi
create_link "$ARCH_CONFIG_DIR/rofi/config.rasi" "$HOME_DIR/.config/rofi/config.rasi"

# Zellij
create_link "$ARCH_CONFIG_DIR/zellij/config.kdl" "$HOME_DIR/.config/zellij/config.kdl"

# Nushell
create_link "$ARCH_CONFIG_DIR/nushell/config.nu" "$HOME_DIR/.config/nushell/config.nu"

# Starship
create_link "$ARCH_CONFIG_DIR/starship.toml" "$HOME_DIR/.config/starship.toml"

# Dunst
create_link "$ARCH_CONFIG_DIR/dunst/dunstrc" "$HOME_DIR/.config/dunst/dunstrc"

# Helix
create_link "$ARCH_CONFIG_DIR/helix/config.toml" "$HOME_DIR/.config/helix/config.toml"

# Bash
create_link "$ARCH_CONFIG_DIR/bash/.bashrc" "$HOME_DIR/.bashrc"

step "9. Configurando Nushell como shell padrão..."
if ! grep -q "$(which nu)" /etc/shells; then
    echo "$(which nu)" | sudo tee -a /etc/shells > /dev/null
fi
chsh -s "$(which nu)"

step "10. Configurando Restic (Backup Criptografado)..."
BACKUP_SCRIPT="$HOME_DIR/cfg/scripts/restic-backup.sh"
if [ ! -f "$BACKUP_SCRIPT" ]; then
    cat > "$BACKUP_SCRIPT" << 'EOF'
#!/bin/bash
REPO="$HOME/sec/restic-repo"
PASSWORD_FILE="$HOME/sec/.restic-pass"

if [ -z "$RESTIC_PASSWORD" ] && [ ! -f "$PASSWORD_FILE" ]; then
    echo "ERRO: Defina RESTIC_PASSWORD ou crie $PASSWORD_FILE"
    exit 1
fi

if [ -f "$PASSWORD_FILE" ]; then
    export RESTIC_PASSWORD_FILE="$PASSWORD_FILE"
fi

echo "Iniciando backup com Restic..."

if [ ! -d "$REPO" ]; then
    echo "Inicializando novo repositório Restic em $REPO..."
    restic init --repo "$REPO"
fi

restic backup --repo "$REPO" \
    --exclude="*.tmp" \
    --exclude=".cache" \
    "$HOME/cfg" "$HOME/proj" "$HOME/sec" "$HOME/ref"

restic forget --repo "$REPO" --keep-daily 7 --keep-weekly 4 --prune

echo "Backup concluído com sucesso!"
EOF
    chmod +x "$BACKUP_SCRIPT"
    info "Script de backup Restic criado em ~/cfg/scripts/restic-backup.sh"
    warn "ACTION REQUIRED: Crie o arquivo ~/sec/.restic-pass com sua senha de backup!"
else
    info "Script de backup Restic já existe."
fi

step "11. Finalização e Limpeza..."
fc-cache -fv > /dev/null 2>&1
sudo pacman -Scc --noconfirm

echo ""
echo "=========================================================="
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "=========================================================="
echo ""
echo "🚀 PRÓXIMOS PASSOS (MANUAIS):"
echo "  1. REINICIE o computador (ou faça logout/login)"
echo "  2. Crie sua senha de backup: echo 'SUA_SENHA_FORTE' > ~/sec/.restic-pass"
echo "  3. Proteja o arquivo: chmod 600 ~/sec/.restic-pass"
echo "  4. ADICIONE ESTA MESMA SENHA NO KEEPASSXC"
echo "  5. Teste o backup: ~/cfg/scripts/restic-backup.sh"
echo ""
echo "🦀 Seu sistema agora está 100% automatizado e linkado!"
echo "=========================================================="
