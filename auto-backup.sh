#!/bin/bash
# ==========================================================
# BACKUP AUTOMATICO - ARCH-CONFIG PARA GITHUB
# ==========================================================

set -e

ARCH_CONFIG_DIR="$HOME/cfg/arch-config"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Iniciando backup automatico..."

cd "$ARCH_CONFIG_DIR"

# Copiar configs atuais (sobrescreve as do repositorio)
echo "Atualizando arquivos de configuracao..."

cp ~/.config/i3/config i3/
cp ~/.config/alacritty/alacritty.toml alacritty/
cp ~/.config/alacritty/gruvbox_dark.toml alacritty/
cp ~/.config/rofi/config.rasi rofi/
cp ~/.bashrc bash/
cp ~/.config/zellij/config.kdl zellij/ 2>/dev/null || true
cp ~/.config/nushell/config.nu nushell/ 2>/dev/null || true
cp ~/.config/starship.toml starship.toml 2>/dev/null || true
cp ~/.config/dunst/dunstrc dunst/ 2>/dev/null || true
cp ~/.config/helix/config.toml helix/ 2>/dev/null || true

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
