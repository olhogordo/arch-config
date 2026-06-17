" ==========================================================
" VIM — GRUVBOX DARK HARD
" Simples > Complexo | Entendível > Otimizado
" ==========================================================

" ---------- BÁSICO ----------
set number
set relativenumber
set mouse=
set cursorline
set scrolloff=5
set signcolumn=yes
set colorcolumn=80,120
set textwidth=80
set nowrap
set clipboard=unnamedplus
set undofile
set ignorecase
set smartcase
set nohlsearch
set incsearch

" Indentação
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Performance
set updatetime=50

" ---------- TEMA ----------
set termguicolors
set background=dark

" ---------- LEADER ----------
let mapleader = " "
let maplocalleader = " "

" ---------- KEYMAPS ----------

" Salvar e sair
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" Buffers
nnoremap <A-h> :bprev<CR>
nnoremap <A-l> :bnext<CR>
nnoremap <A-w> :bdelete<CR>

" Splits
nnoremap <A-v> :vsplit<CR>
nnoremap <A-s> :split<CR>

" Navegação entre janelas
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>

" Centralizar busca
nnoremap n nzzzv
nnoremap N Nzzzv

" Mover linhas (visual mode)
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Indentar mantendo seleção
vnoremap < <gv
vnoremap > >gv

" Clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+p

" Desabilitar setas
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

" ---------- PLUGINS (vim-plug) ----------
call plug#begin('~/.vim/plugged')

" Tema Gruvbox
Plug 'morhetz/gruvbox'

" Fuzzy finder (usa fzf do sistema, sem hook de instalação)
Plug 'junegunn/fzf.vim'

" Comentar código
Plug 'tpope/vim-commentary'

" Surround
Plug 'tpope/vim-surround'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Auto-save
Plug '907th/vim-auto-save'

call plug#end()

" ---------- CONFIGURAÇÃO DOS PLUGINS ----------

" Gruvbox
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-b> :Buffers<CR>

" Auto-save
let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged"]

" Git gutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" ---------- AUTO-COMMANDS ----------

" Remover trailing whitespace ao salvar
augroup trim_whitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

" ---------- FINAL ----------
filetype plugin indent on
syntax on
