# arch-config

Configuração pessoal de Arch Linux. i3wm, Neovim, ferramentas Rust. Reprodutível em minutos.

## Princípios

- Só Pacman oficial. Zero AUR.
- Tudo via teclado. Zero mouse.
- Tudo em texto. Tudo versionado.
- Dados locais. Nuvem é computador de outro alguém.

## Stack

| Camada | Ferramenta |
|---|---|
| WM | i3wm (gaps nativo) |
| Terminal | Alacritty + Zellij |
| Shell | Bash |
| Editor | Neovim |
| Launcher | Rofi |
| Files | Thunar |
| Status | i3status-rust |

**Tema:** Gruvbox Dark Hard, JetBrainsMono Nerd Font 10

**Ferramentas Rust:**

- `rg` — busca de texto
- `fd` — busca de arquivos
- `bat` — cat com syntax highlight
- `eza` — ls com ícones e git status
- `zoxide` — cd inteligente (`z`)
- `btm` — monitor de processos
- `lazygit` — git TUI
- `i3status-rust` — barra de status

**Aplicações:**

- Obsidian — notas (vault local)
- KeePassXC — senhas (banco offline)
- Anki — flashcards
- mpv — vídeo
- zathura — PDF
- nsxiv — imagens

## Instalação

```bash
git clone https://github.com/olhogordo/arch-config.git ~/cfg/arch-config
cd ~/cfg/arch-config
chmod +x install.sh
./install.sh
```

Requer Arch Linux com i3wm (archinstall). Depois do script, reinicie.

## Estrutura

```
~/
├── cfg/arch-config/  # este repo
│   └── scripts/      # scripts pessoais
├── proj/             # projetos (cada um é repo git)
├── sec/              # chaves, senhas, certs
├── mid/wallpapers/   # mídia
└── ref/              # Obsidian vault, docs
```

## Workflow

1. Editar em `~/cfg/arch-config/`
2. Testar no momento (`i3-msg reload`)
3. `./auto-backup.sh` para sincronizar

## Atalhos

**Mod4 = Super**

| Atalho | Ação |
|---|---|
| `Mod+Enter` | Terminal |
| `Mod+d` | Rofi (apps) |
| `Mod+Tab` | Rofi (janelas) |
| `Mod+o` | Obsidian |
| `Mod+t` | Thunar |
| `Mod+h/j/k/l` | Focar janela |
| `Mod+Shift+h/j/k/l` | Mover janela |
| `Mod+semicolon/v` | Split horizontal/vertical |
| `Mod+f` | Fullscreen |
| `Mod+Shift+q` | Fechar |
| `Mod+1-0` | Workspace |
| `Mod+Shift+1-0` | Mover para workspace |
| `Mod+Shift+e` | Menu saída |
| `Mod+Shift+c` | Reload i3 |
| `Mod+r` | Modo resize |

## Manutenção

```bash
cd ~/cfg/arch-config && ./auto-backup.sh   # backup
sudo pacman -Syu                              # atualizar
pacman -Qdt                                   # órfãos
```

## Pós-instalação

1. Reiniciar
2. Neovim: `:Lazy` para instalar plugins
3. KeePassXC: criar banco em `~/sec/`
4. Obsidian: apontar vault para `~/ref/`

## Métricas

- ~400 pacotes
- ~300MB idle
- Boot < 5s
- Zero AUR
