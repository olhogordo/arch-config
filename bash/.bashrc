# Gruvbox Dark Minimalist Prompt
C_RESET="\[\e[0m\]"
C_ORANGE="\[\e[38;5;208m\]"   # fe8019
C_GREEN="\[\e[38;5;142m\]"    # b8bb26
C_RED="\[\e[38;5;167m\]"      # fb4934
C_FG="\[\e[38;5;180m\]"       # ebdbb2
C_GRAY="\[\e[38;5;245m\]"     # 928374

_tactical_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -n $branch ]]; then
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            echo "${C_RED}[${branch}]${C_RESET} "
        else
            echo "${C_GREEN}[${branch}]${C_RESET} "
        fi
    fi
}

export PS1="${C_GRAY}\u${C_FG}@${C_GRAY}\h ${C_FG}in ${C_ORANGE}\w${C_FG} \$(_tactical_git_branch)\n${C_FG}❯ ${C_RESET}"
