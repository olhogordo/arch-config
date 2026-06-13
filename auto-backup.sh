#!/bin/bash
# ==========================================================
# BACKUP AUTOMATICO - DOTFILES PARA GITHUB
# ==========================================================
# Este script copia as configs atuais, faz commit e push
# Agendado para rodar semanalmente via cron
# ==========================================================

set -e

DOTFILES_DIR="$HOME/cfg/dotfiles"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Iniciando backup automatico..."

cd "$DOTFILES_DIR"

# Copiar configs atuais (sobrescreve as do repositorio)
echo "Atualizando arquivos de configuracao..."
cp ~/.config/i3/config i3/
cp ~/.config/alacritty/alacritty.toml alacritty/
cp ~/.config/alacritty/gruvbox_dark.toml alacritty/
cp ~/.config/rofi/config.rasi rofi/
cp ~/.bashrc bash/
cp ~/.config/zellij/config.kdl zellij/ 2>/dev/null || true

# Verificar se ha mudancas
if git diff --quiet && git diff --staged --quiet; then
    echo "Nenhuma mudanca detectada. Backup nao necessario."
    exit 0
fi

# Adicionar mudancas
git add .

# Commit com timestamp
git commit -m "Auto-backup: $TIMESTAMP"

# Push para GitHub
echo "Enviando para GitHub..."
git push origin main

echo "Backup concluido com sucesso!"
