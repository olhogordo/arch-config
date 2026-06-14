#!/bin/bash
# ==========================================================
# BACKUP AUTOMATICO - ARCH-CONFIG PARA GITHUB
# ==========================================================

set -e

ARCH_CONFIG_DIR="$HOME/cfg/arch-config"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Iniciando backup automatico..."
cd "$ARCH_CONFIG_DIR"

echo "Atualizando arquivos de configuracao..."
cp ~/.config/i3/config i3/
cp ~/.config/alacritty/alacritty.toml alacritty/
cp ~/.config/alacritty/gruvbox_dark.toml alacritty/ 2>/dev/null || true
cp ~/.config/rofi/config.rasi rofi/
cp ~/.bashrc bash/ 2>/dev/null || true
cp ~/.config/zellij/config.kdl zellij/ 2>/dev/null || true
cp ~/.config/nvim/init.lua nvim/ 2>/dev/null || true
cp ~/.config/nvim/lua/ nvim/ -r 2>/dev/null || true
cp ~/.config/i3status-rust/config.toml i3status-rust/ 2>/dev/null || true

if git diff --quiet && git diff --staged --quiet; then
    echo "Nenhuma mudanca detectada. Backup nao necessario."
    exit 0
fi

git add .
git commit -m "Auto-backup: $TIMESTAMP"
echo "Enviando para GitHub..."
git push origin main

echo "Backup concluido com sucesso!"
