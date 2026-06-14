#!/bin/bash
# ==========================================================
# BACKUP AUTOMATICO - ARCH-CONFIG PARA GITHUB
# ==========================================================

set -euo pipefail

ARCH_CONFIG_DIR="$HOME/cfg/arch-config"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Iniciando backup automatico..."
cd "$ARCH_CONFIG_DIR"

# Sincroniza com remoto primeiro (evita conflitos)
echo "Sincronizando com GitHub..."
git pull origin main --rebase || {
    warn "Falha ao fazer pull. Tentando continuar..."
}

echo "Atualizando arquivos de configuracao..."

# i3
cp ~/.config/i3/config i3/

# Alacritty
cp ~/.config/alacritty/alacritty.toml alacritty/
cp ~/.config/alacritty/gruvbox_dark.toml alacritty/ 2>/dev/null || true

# Rofi
cp ~/.config/rofi/config.rasi rofi/

# Bash
cp ~/.bashrc bash/ 2>/dev/null || true

# Zellij
cp ~/.config/zellij/config.kdl zellij/ 2>/dev/null || true

# Neovim
cp ~/.config/nvim/init.lua nvim/ 2>/dev/null || true
if [ -d ~/.config/nvim/lua ]; then
    mkdir -p nvim/lua
    cp -r ~/.config/nvim/lua/* nvim/lua/ 2>/dev/null || true
fi

# i3status-rust
cp ~/.config/i3status-rust/config.toml i3status-rust/ 2>/dev/null || true

# Verifica mudancas
if git diff --quiet && git diff --staged --quiet; then
    echo "Nenhuma mudanca detectada. Backup nao necessario."
    exit 0
fi

git add .
git commit -m "Auto-backup: $TIMESTAMP"
echo "Enviando para GitHub..."
git push origin main

echo "Backup concluido com sucesso!"
