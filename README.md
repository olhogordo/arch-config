# 🏴 Arch Linux Cypherpunk Setup

Configuração pessoal minimalista e automatizada para Arch Linux com i3wm.

## 🎯 Filosofia

- **Simples > Complexo**
- **Entendível > Otimizado**
- **Controlável > Perfeito**

## 📦 Stack Tecnológica

- **Window Manager:** i3wm
- **Terminal:** Alacritty + Zellij
- **Shell:** Nushell (Rust)
- **Editor:** Helix (Rust)
- **Tema:** Gruvbox Dark Hard
- **Font:** JetBrainsMono Nerd Font
- **Backup:** Restic (criptografado)

## 🦀 Ferramentas Rust Modernas

- `ripgrep` (rg) → substitui grep
- `fd` → substitui find
- `bat` → substitui cat
- `eza` → substitui ls
- `zoxide` → substitui cd
- `bottom` (btm) → substitui htop
- `procs` → substitui ps
- `sd` → substitui sed
- `lazygit` → TUI para git
- `starship` → prompt cross-shell

## 🚀 Instalação Automática

```bash
# Após instalar Arch Linux com archinstall
git clone https://github.com/olhogordo/arch-config.git ~/cfg/arch-config
cd ~/cfg/arch-config
chmod +x install.sh
./install.sh
