Configuracao pessoal de Arch Linux. i3wm, Vim, ferramentas Rust. Reprodutivel em minutos.

---

## PRINCIPIOS

- Um AUR: yay + librewolf-bin (browser). Resto: Pacman oficial.
- Tudo via teclado. Zero mouse.
- Tudo em texto. Tudo versionado.
- Dados locais. Nuvem e computador de outro alguem.

---

## STACK

| Camada| Ferramenta|
| ---| ---|
| WM| i3wm (gaps nativo)|
| Terminal| Alacritty + Zellij|
| Shell| Bash|
| Editor| Vim |
| Launcher| Rofi|
| Files| Yazi (TUI) |
| Status| i3status-rust|
| Browser| LibreWolf|

TEMA: Gruvbox Dark Hard, JetBrainsMono Nerd Font 10

FERRAMENTAS RUST:

- rg - busca de texto
- fd - busca de arquivos
- bat - cat com syntax highlight
- eza - ls com icones e git status
- zoxide - cd inteligente (z)
- btm - monitor de processos
- lazygit - git TUI
- i3status-rust - barra de status
- yazi - gerenciador de arquivos TUI

APLICACOES:

- LibreWolf - browser (privacy-focused, Firefox fork)
- Obsidian - notas (vault local)
- KeePassXC - senhas (banco offline)
- Anki - flashcards
- mpv - video
- zathura - PDF
- nsxiv - imagens

---

## INSTALACAO

```
git clone https://github.com/olhogordo/arch-config.git ~/cfg/arch-config
cd ~/cfg/arch-config
chmod +x install.sh
./install.sh
```

Requer Arch Linux com i3wm (archinstall). Depois do script, reinicie.

---

## ESTRUTURA

```
~/
|-- cfg/
|   |-- arch-config/   # este repo
|   |-- yay/           # AUR helper
|   |-- scripts/       # scripts pessoais
|-- proj/              # projetos (cada um e repo git)
|-- sec/               # chaves, senhas, certs
|-- mid/wallpapers/    # midia
|-- ref/               # Obsidian vault, docs

```

---

## WORKFLOW

1. Editar em ~/cfg/arch-config/
2. Testar no momento (i3-msg reload)
3. ./auto-backup.sh para sincronizar

---

## ATALHOS

Mod4 = Super

NAVEGACAO E JANELAS:

| Atalho| Acao|
| ---| ---|
| Mod+Enter| Terminal|
| Mod+d| Rofi (apps)|
| Mod+Tab| Rofi (janelas)|
| Mod+h/j/k/l| Focar janela|
| Mod+Shift+h/j/k/l| Mover janela|
| Mod+semicolon/v| Split horizontal/vertical|
| Mod+f| Fullscreen|
| Mod+Shift+q| Fechar|
| Mod+1-0| Workspace|
| Mod+Shift+1-0| Mover para workspace|
| Mod+Shift+e| Menu saida|
| Mod+Shift+c| Reload i3|
| Mod+r| Modo resize|

APLICACOES:

| Atalho| Aplicacao|
| ---| ---|
| Mod+b| LibreWolf|
| Mod+o| Obsidian|
| Mod+n| Anki|
| Mod+t| Yazi (files) |

CONTROLE DE VOLUME (teclas fisicas):

| Tecla| Acao|
| ---| ---|
| F2| Diminuir volume (-5%)|
| F3| Aumentar volume (+5%)|
| F4| Mutar/Desmutar |

---

## MANUTENCAO

```
cd ~/cfg/arch-config && ./auto-backup.sh    # backup
sudo pacman -Syu                               # atualizar
pacman -Qdt                                    # orfaos

```

---

## POS-INSTALACAO

1. Reiniciar
2. Vim: :PlugInstall para instalar plugins
3. KeePassXC: criar banco em ~/sec/
4. Obsidian: apontar vault para ~/ref/

---

## METRICAS

- ~400 pacotes
- ~300MB idle
- Boot < 5s
- Um AUR: librewolf-bin
