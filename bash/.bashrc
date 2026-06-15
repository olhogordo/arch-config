# ==========================================================
# BASHRC — GRUVBOX DARK MINIMALIST
# Shell: Bash | Tema: Gruvbox Dark Hard
# Zero AUR. Zero Starship. Prompt puro.
# ==========================================================

# ---------- CORES GRUVBOX ----------
C_RESET="\[\e[0m\]"
C_ORANGE="\[\e[38;5;208m\]"   # fe8019
C_GREEN="\[\e[38;5;142m\]"    # b8bb26
C_RED="\[\e[38;5;167m\]"      # fb4934
C_FG="\[\e[38;5;180m\]"       # ebdbb2
C_GRAY="\[\e[38;5;245m\]"     # 928374

# ---------- PROMPT ----------
_tactical_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            echo "${C_RED}(${branch})${C_RESET} "
        else
            echo "${C_GREEN}(${branch})${C_RESET} "
        fi
    fi
}

export PS1="${C_GRAY}\u${C_FG}@${C_GRAY}\h ${C_FG}in ${C_ORANGE}\w${C_FG} \$(_tactical_git_branch)\n${C_FG}❯ ${C_RESET}"

# ---------- HISTORICO ----------
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%Y-%m-%d %H:%M  "
shopt -s histappend
shopt -s cmdhist

# ---------- COMPLETION ----------
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# ---------- EDITOR ----------
export EDITOR="nvim"
export VISUAL="nvim"

# ---------- PATH ----------
export PATH="$HOME/.local/bin:$PATH"

# ---------- FZF ----------
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --level=2 --color=always --icons=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview' --preview-window=right:60%:wrap --height=70% --layout=reverse --border=rounded"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=always {} | head -200' --preview-window=right:60% --height=70% --layout=reverse --border=rounded"
export FZF_CTRL_R_OPTS="--height=50% --layout=reverse --border=rounded"

# ---------- ALIASES ----------
# NÃO sobrescreva builtins (grep, find, cat, cd, top) — scripts shell quebram.
# Use nomes curtos alternativos para as ferramentas modernas.

# ls -> eza (eza é compatível o suficiente com ls para uso interativo)
alias ls="eza --icons --group-directories-first"
alias ll="eza -lah --git --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons --group-directories-first"
alias lta="eza --tree --level=2 --icons --group-directories-first -a"

# cat -> bat (não sobrescreve o builtin; use 'c' ou 'b')
alias c="bat --paging=never"
alias b="bat"

# grep -> ripgrep (não sobrescreve o builtin; use 'g' ou 'rg')
alias g="rg"
alias rg="rg"

# find -> fd (não sobrescreve o builtin; use 'f' ou 'ff')
alias f="fd"
alias ff="fd --type f"

# top -> bottom (não sobrescreve o builtin; use 't')
alias t="btm"

# cd -> zoxide (zoxide init já cria 'z' e 'zi'; não sobrescreva 'cd')
# 'z' e 'zi' já estão disponíveis via zoxide init abaixo
alias j="z"          # alternativa curta para zoxide
alias cdi="zi"       # fuzzy cd

# Navegação rápida
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# mkdir seguro
alias mkdir="mkdir -p"

# git -> lazygit
alias lg="lazygit"

# pacman
alias pacs="pacman -Ss"
alias pacq="pacman -Qi"
alias pacu="sudo pacman -Syu"
alias pacc="sudo pacman -Scc"
alias pacr="sudo pacman -Rns"

# ---------- FUNCOES ----------
# Extract (usa bsdtar para rar/7z se disponível, evita dependências extras)
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2|*.tbz2)  tar xjf "$1"   ;;
            *.tar.gz|*.tgz)    tar xzf "$1"   ;;
            *.tar.xz)          tar xf "$1"    ;;
            *.tar)             tar xf "$1"    ;;
            *.bz2)             bunzip2 "$1"   ;;
            *.gz)              gunzip "$1"    ;;
            *.zip)             unzip "$1"     ;;
            *.Z)               uncompress "$1";;
            *.7z)              7z x "$1"      ;;
            *.rar)             bsdtar xf "$1" 2>/dev/null || unrar x "$1" ;;
            *)                 echo "'''$1''' formato nao suportado" ;;
        esac
    else
        echo "'''$1''' nao e um arquivo valido"
    fi
}

# Fuzzy open com nvim
v() {
    local file
    file=$(fd --type f --hidden --exclude .git | fzf --preview "$show_file_or_dir_preview" --preview-window=right:60%:wrap --height=70% --layout=reverse --border=rounded)
    [[ -n "$file" ]] && nvim "$file"
}

# Fuzzy kill
killf() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --header="[kill process]" | awk '''{print $2}'''')
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -9
}

# ---------- INICIALIZACAO ----------
eval "$(zoxide init bash --cmd z)"

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
