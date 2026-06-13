# ==========================================================
# NUSHELL CONFIG - Minimalista & Rust-Powered
# ==========================================================

# 1. Starship Prompt
$env.STARSHIP_SHELL = "nu"
let starship_cmd = (which starship | get path)
$env.PROMPT_COMMAND = {|| ^$starship_cmd prompt }
$env.PROMPT_COMMAND_RIGHT = {|| ^$starship_cmd prompt --right }

# 2. Aliases para ferramentas Rust modernas
alias ls = eza --icons --color=always --group-directories-first
alias ll = eza -l --icons --color=always --group-directories-first
alias cat = bat --theme="gruvbox-dark" --style=numbers,changes
alias grep = rg
alias find = fd
alias ps = procs
alias sed = sd
alias top = btm

# 3. Integração Zoxide (cd inteligente)
^zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu
alias cd = z

# 4. Atalhos úteis
alias la = ls -a
alias mkdir = mkdir -p
alias cls = clear
alias lg = lazygit
