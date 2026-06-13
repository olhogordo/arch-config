#!/bin/bash
# ==========================================================
# SCRIPT DE INSTALACAO AUTOMATICA - DOTFILES CYPHERPUNK
# ==========================================================
# Paleta de cores: Gruvbox Dark Hard
# Fonte original: https://github.com/morhetz/gruvbox
# Tema Alacritty: https://github.com/alacritty/alacritty-theme
# ==========================================================

set -e

echo "Iniciando instalacao dos dotfiles..."

# Criar diretorios de configuracao
mkdir -p ~/.config/i3
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/rofi
mkdir -p ~/.config/zellij

# Copiar arquivos
echo "Copiando configuracoes..."
cp i3/config ~/.config/i3/
cp alacritty/alacritty.toml ~/.config/alacritty/
cp alacritty/gruvbox_dark.toml ~/.config/alacritty/
cp rofi/config.rasi ~/.config/rofi/
cp bash/.bashrc ~/.bashrc

# Copiar zellij se existir
[ -f zellij/config.kdl ] && cp zellij/config.kdl ~/.config/zellij/

# Instalar pacotes essenciais (Arch Linux)
echo "Instalando pacotes essenciais..."
sudo pacman -S --noconfirm --needed \
    i3-wm i3status-rust alacritty rofi feh \
    zellij tmux btop yazi neovim \
    mpv vlc \
    keepassxc obsidian \
    pipewire pipewire-pulse wireplumber \
    git zoxide fzf \
    xorg-xinit xorg-server xorg-xsetroot \
    xorg-xset xorg-xrandr xorg-xinput

# Configurar teclado US International
echo "Configurando teclado US International..."
setxkbmap -layout us -variant intl

# Criar estrutura de pastas do usuario
echo "Criando estrutura de pastas..."
mkdir -p ~/cfg ~/proj ~/sec ~/mid ~/dl ~/ref

# Configurar Git (se ainda nao estiver configurado)
if ! git config --global user.name > /dev/null 2>&1; then
    echo "Configure seu Git:"
    echo "   git config --global user.name 'Seu Nome'"
    echo "   git config --global user.email 'seu@email.com'"
fi

echo "Instalacao concluida!"
echo "Recarregue o i3 com: i3-msg reload"
echo "Tema: Gruvbox Dark Hard (fonte: github.com/morhetz/gruvbox)"
