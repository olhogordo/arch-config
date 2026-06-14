# Arch Linux Configuration

Setup automatizado para Arch Linux com i3wm, focado em produtividade via teclado e ferramentas Rust.

## Filosofia

- Simples > Complexo
- Entendível > Otimizado
- Controlável > Perfeito
- **Sem AUR** — só Pacman oficial

## Stack Técnica

**Core:**

- Window Manager: i3wm (nativo, com gaps)
- Terminal: Alacritty + Zellij
- Shell: Bash
- Editor: Neovim
- Launcher: Rofi
- File Manager: Thunar

**Tema:**

- Colorscheme: Gruvbox Dark Hard
- Font: JetBrainsMono Nerd Font 10

**Ferramentas Rust:**

- ripgrep (rg) — busca de texto
- fd — busca de arquivos
- bat — visualização de arquivos com syntax highlighting
- eza — listagem de diretórios
- zoxide — navegação inteligente (comando `z`)
- bottom (btm) — monitoramento de processos
- lazygit — interface TUI para git
- i3status-rust — barra de status

**Aplicações:**

- Firefox (navegador — via Pacman)
- Obsidian (notas)
- KeePassXC (gerenciador de senhas)
- Anki (flashcards)
- mpv (player de vídeo)
- zathura (visualizador de PDF)
- nsxiv (visualizador de imagens)

## Instalação

Após instalação base do Arch Linux com archinstall (perfil i3wm):

```bash
git clone https://github.com/olhogordo/arch-config.git ~/cfg/arch-config
cd ~/cfg/arch-config
chmod +x install.sh
./install.sh
```

O script executa:

1. Atualização do sistema
2. Instalação de todos os pacotes via Pacman
3. Criação da estrutura de pastas
4. Download do wallpaper
5. Clone/atualização do repositório
6. Criação de symlinks para todas as configurações
7. Limpeza

## Estrutura de Pastas

```
~/
├── cfg/              # Configurações e dotfiles
│   ├── arch-config/  # Este repositório
│   └── scripts/      # Scripts customizados
├── proj/             # Projetos ativos
├── sec/              # Segurança (KeePassXC, chaves)
├── mid/              # Mídia (wallpapers, música)
│   └── wallpapers/
├── dl/               # Downloads
├── ref/              # Referência (Obsidian vault, docs)
├── lab/              # Laboratório (testes)
├── tmp/              # Temporário
└── bin/              # Binários portáteis
```

## Symlinks

Todos os arquivos de configuração são linkados automaticamente do repositório para `~/.config/`:

- `~/.config/i3/config` → `~/cfg/arch-config/i3/config`
- `~/.config/alacritty/alacritty.toml` → `~/cfg/arch-config/alacritty/alacritty.toml`
- `~/.config/alacritty/gruvbox_dark.toml` → `~/cfg/arch-config/alacritty/gruvbox_dark.toml`
- `~/.config/rofi/config.rasi` → `~/cfg/arch-config/rofi/config.rasi`
- `~/.config/zellij/config.kdl` → `~/cfg/arch-config/zellij/config.kdl`
- `~/.config/nvim/init.lua` → `~/cfg/arch-config/nvim/init.lua`
- `~/.config/i3status-rust/config.toml` → `~/cfg/arch-config/i3status-rust/config.toml`
- `~/.bashrc` → `~/cfg/arch-config/bash/.bashrc`

**Fluxo de trabalho:**

1. Edite qualquer arquivo em `~/cfg/arch-config/`
2. Execute `./auto-backup.sh` para sincronizar com o GitHub
3. Em nova instalação, execute `./install.sh` para restaurar tudo

## Atalhos i3wm

**Mod4 = Tecla Windows/Super**

**Lançadores:**

- `Mod4 + Enter` — Terminal (Alacritty)
- `Mod4 + d` — Launcher de aplicativos (Rofi)
- `Mod4 + b` — Firefox
- `Mod4 + o` — Obsidian
- `Mod4 + t` — Thunar

**Navegação (HJKL):**

- `Mod4 + h/j/k/l` — Focar janela esquerda/baixo/cima/direita
- `Mod4 + Shift + h/j/k/l` — Mover janela
- `Mod4 + semicolon/v` — Dividir horizontal/vertical
- `Mod4 + f` — Tela cheia
- `Mod4 + Shift + q` — Fechar janela

**Workspaces:**

- `Mod4 + 1-0` — Mudar para workspace 1-10
- `Mod4 + Shift + 1-0` — Mover janela para workspace 1-10

**Sistema:**

- `Mod4 + Shift + c` — Recarregar configuração
- `Mod4 + Shift + r` — Reiniciar i3
- `Mod4 + Shift + e` — Menu de saída (lock/logout/suspend/reboot/shutdown)
- `Mod4 + r` — Entrar no modo redimensionar

## Manutenção

**Backup automático:**

```bash
cd ~/cfg/arch-config
./auto-backup.sh
```

**Atualizar do GitHub:**

```bash
cd ~/cfg/arch-config
git pull
```

**Recarregar i3:**
Pressione `Mod4 + Shift + c` ou execute `i3-msg restart`

## Pós-Instalação

Após executar o script:

1. Reinicie o computador para o i3 carregar
2. Abra o Neovim e execute `:Lazy` para instalar plugins
3. Configure sua database do KeePassXC em `~/sec/`
4. Aponte o Obsidian para sua vault em `~/ref/` ou `~/proj/`
5. Verifique se o wallpaper foi baixado em `~/mid/wallpapers/`

## Segurança

- **Pacman:** Apenas repositório oficial
- **AUR:** Não utilizado
- **Verificação de erros:** Script para em caso de falha crítica
- **KeePassXC:** Gerenciamento centralizado de senhas

## Requisitos

- Arch Linux instalado via archinstall (perfil i3wm)
- Conexão com internet
- Usuário com permissões sudo
```

---

## 📋 O que mudou no README

| Antes | Agora |
|---|---|
| "Cyberpunk Setup" | Removido — não reflete o visual |
| LibreWolf mencionado | Firefox (via Pacman) |
| Paru/AUR mencionado | **"Sem AUR — só Pacman oficial"** |
| Helix como editor | Neovim |
| Nushell mencionado | Bash (consistente) |
| Passo 9: "Configuração do Nushell" | Removido |
| Starship na lista de tools | Removido |
| Picom/Dunst mencionados | Removidos (você não usa) |
| `Mod4 + Shift + e` → i3-nagbar | Menu próprio de saída |
| Atalhos com `semicolon` para right | `h/j/k/l` para navegação |

---

Quer que eu ajuste o tom, adicione mais seções, ou remova algo? 🚀
