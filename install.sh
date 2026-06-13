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
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[AVISO]${NC} $1"; }
step()  { echo -e "\n${BLUE}==>${NC} ${YELLOW}$1${NC}"; }

# Detectar usuário e home dinamicamente (à prova de falhas)
CURRENT_USER=$(whoami)
HOME_DIR="/home/$CURRENT_USER"
DOTFILES_DIR="$HOME_DIR/cfg/dotfiles"

step "1. Verificando permissões e sistema..."
if ! grep -q "Arch" /etc/os-release; then
    warn "Este script é feito para Arch Linux. Abortando."
    exit 1
fi

step "2. Atualizando sistema e instalando pacotes base (Pacman)..."
sudo pacman -Syu --noconfirm

# Lista massiva de pacotes do repositório oficial (Segurança e Estabilidade)
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
    fzf jq tree ncdu zathura nsxiv nushell

step "3. Instalando Paru (AUR Helper em Rust - Compilando do fonte)..."
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
# Apenas o LibreWolf, conforme sua regra de segurança
paru -S --noconfirm librewolf-bin

step "5. Criando estrutura de pastas semântica..."
mkdir -p "$HOME_DIR"/{cfg,proj,sec,mid/wallpapers,dl,ref,lab,tmp,bin}
mkdir -p "$HOME_DIR/cfg/scripts"

step "6. Clonando/Atualizando Dotfiles do GitHub..."
if [ ! -d "$DOTFILES_DIR" ]; then
    info "Clonando repositório..."
    git clone https://github.com/olhogordo/arch-config.git "$DOTFILES_DIR"
else
    info "Repositório já existe. Atualizando..."
    cd "$DOTFILES_DIR" && git pull
fi

step "7. Criando Symlinks das configurações..."
# Função auxiliar para criar symlink com segurança
create_link() {
    local target=$1
    local link=$2
    if [ -L "$link" ] || [ -f "$link" ]; then
        rm -f "$link" # Remove arquivo ou link antigo para evitar conflito
    fi
    ln -sf "$target" "$link"
    info "Link criado: $link -> $target"
}

mkdir -p "$HOME_DIR/.config"/{i3,alacritty,rofi,nushell,i3status-rust}

create_link "$DOTFILES_DIR/i3/config" "$HOME_DIR/.config/i3/config"
create_link "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME_DIR/.config/alacritty/alacritty.toml"
create_link "$DOTFILES_DIR/rofi/config.rasi" "$HOME_DIR/.config/rofi/config.rasi"

step "8. Configurando Nushell (Shell moderno em Rust)..."
# Definir Nushell como shell padrão
if ! grep -q "$(which nu)" /etc/shells; then
    echo "$(which nu)" | sudo tee -a /etc/shells > /dev/null
fi
chsh -s "$(which nu)"

# Gerar config.nu automatizada com aliases e integrações
cat > "$HOME_DIR/.config/nushell/config.nu" << 'EOF'
# ==========================================================
# NUSHELL CONFIG - Minimalista & Rust-Powered
# ==========================================================

# 1. Starship Prompt
$env.STARSHIP_SHELL = "nu"
let starship_cmd = (which starship | get path)
$env.PROMPT_COMMAND = {|| ^$starship_cmd prompt }
$env.PROMPT_COMMAND_RIGHT = {|| ^$starship_cmd prompt --right }

# 2. Aliases para ferramentas Rust modernas
alias ls = eza --icons --color=always --group-directories-first
alias ll = eza -l --icons --color=always --group-directories-first
alias cat = bat --theme="gruvbox-dark" --style=numbers,changes
alias grep = rg
alias find = fd
alias ps = procs
alias sed = sd
alias top = btm

# 3. Integração Zoxide (cd inteligente)
# Inicializa o zoxide e salva o script de integração
^zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
alias cd = z

# 4. Atalhos úteis
alias la = ls -a
alias mkdir = mkdir -p
alias cls = clear
EOF
info "Nushell configurado com Starship, aliases Rust e Zoxide."

step "9. Configurando Restic (Backup Criptografado)..."
BACKUP_SCRIPT="$HOME_DIR/cfg/scripts/restic-backup.sh"
if [ ! -f "$BACKUP_SCRIPT" ]; then
    cat > "$BACKUP_SCRIPT" << 'EOF'
#!/bin/bash
# Script de Backup Automatizado com Restic
# Requer: RESTIC_PASSWORD definida no ambiente ou em um arquivo seguro

REPO="$HOME/sec/restic-repo" # Mude para sftp:// ou rclone: no futuro
PASSWORD_FILE="$HOME/sec/.restic-pass" # Opcional: arquivo com a senha

# Verifica se a senha está definida
if [ -z "$RESTIC_PASSWORD" ] && [ ! -f "$PASSWORD_FILE" ]; then
    echo "ERRO: Defina RESTIC_PASSWORD ou crie $PASSWORD_FILE"
    exit 1
fi

if [ -f "$PASSWORD_FILE" ]; then
    export RESTIC_PASSWORD_FILE="$PASSWORD_FILE"
fi

echo "Iniciando backup com Restic..."

# Inicializa o repositório se não existir
if [ ! -d "$REPO" ]; then
    echo "Inicializando novo repositório Restic em $REPO..."
    restic init --repo "$REPO"
fi

# Faz o backup das pastas sagradas
restic backup --repo "$REPO" \
    --exclude="*.tmp" \
    --exclude=".cache" \
    "$HOME/cfg" "$HOME/proj" "$HOME/sec" "$HOME/ref"

# Limpa snapshots antigos (mantém os últimos 7 dias e 4 semanais)
restic forget --repo "$REPO" --keep-daily 7 --keep-weekly 4 --prune

echo "Backup concluído com sucesso!"
EOF
    chmod +x "$BACKUP_SCRIPT"
    info "Script de backup Restic criado em ~/cfg/scripts/restic-backup.sh"
    warn "ACTION REQUIRED: Crie o arquivo ~/sec/.restic-pass com sua senha de backup!"
else
    info "Script de backup Restic já existe."
fi

step "10. Finalização e Limpeza..."
# Atualizar cache de fontes
fc-cache -fv > /dev/null 2>&1

# Limpar cache do pacman
sudo pacman -Scc --noconfirm

echo ""
echo "=========================================================="
echo -e "${GREEN}✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO!${NC}"
echo "=========================================================="
echo ""
echo "🚀 PRÓXIMOS PASSOS (MANUAIS):"
echo "  1. REINICIE o computador (ou faça logout/login) para o Nushell e i3 carregarem."
echo "  2. Crie sua senha de backup: echo 'SUA_SENHA_FORTE' > ~/sec/.restic-pass"
echo "  3. Teste o backup: ~/cfg/scripts/restic-backup.sh"
echo "  4. Abra o KeePassXC e aponte para sua database em ~/sec/"
echo "  5. Abra o Obsidian e aponte para sua vault em ~/ref/ ou ~/proj/"
echo ""
echo "🦀 Seu sistema agora roda Nushell + Ferramentas Rust + Restic."
echo "=========================================================="
