# Arch Linux Configuration

Setup automatizado para Arch Linux com i3wm, focado em produtividade via teclado e ferramentas Rust.

## Filosofia

- Simples > Complexo
- Entendível > Otimizado
- Controlável > Perfeito

## Stack Técnica

**Core:**
- Window Manager: i3wm
- Terminal: Alacritty + Zellij
- Shell: Nushell
- Editor: Helix
- Launcher: Rofi
- File Manager: Thunar

**Tema:**
- Colorscheme: Gruvbox Dark Hard
- Font: JetBrainsMono Nerd Font 10

**Ferramentas Rust:**
- ripgrep (rg) - busca de texto
- fd - busca de arquivos
- bat - visualização de arquivos com syntax highlighting
- eza - listagem de diretórios
- zoxide - navegação inteligente (comando `z`)
- bottom (btm) - monitoramento de processos
- lazygit - interface TUI para git
- starship - prompt cross-shell

**Aplicações:**
- LibreWolf (navegador)
- Obsidian (notas)
- KeePassXC (gerenciador de senhas)
- Anki (flashcards)
- mpv (player de vídeo)
- zathura (visualizador de PDF)
- nsxiv (visualizador de imagens)

## Instalação

Após instalação base do Arch Linux com archinstall:

```bash
git clone https://github.com/olhogordo/arch-config.git ~/cfg/arch-config
cd ~/cfg/arch-config
chmod +x install.sh
./install.sh
