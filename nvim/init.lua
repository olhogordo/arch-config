-- ==========================================================
-- NEOVIM - GRUVBOX DARK HARD
-- Configuração pessoal, minimalista, operacional
-- Neovim 0.11+ compatível (nvim-treesitter v1.0+ API)
-- ==========================================================

-- ---------- OPTIONS ----------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""              -- mouse desabilitado (teclado only)
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80,120"  -- rulers
vim.opt.textwidth = 80
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false        -- não fica marcando busca
vim.opt.incsearch = true        -- busca incremental

-- Indentação
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Performance
vim.opt.updatetime = 50

-- ---------- CURSOR ----------
vim.opt.guicursor = {
    "n:block-Cursor",
    "i:ver100-iCursor",
    "v:hor100-vCursor",
}

-- ---------- LEADER ----------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ---------- KEYMAPS ----------

-- Salvar e sair
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>")

-- Buffers
vim.keymap.set("n", "<A-h>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<A-l>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<A-w>", "<cmd>bdelete<CR>")

-- Splits
vim.keymap.set("n", "<A-v>", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<A-s>", "<cmd>split<CR>")

-- Navegação entre janelas (hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize splits
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>")
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>")

-- Centralizar cursor na busca
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Mover linhas
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Indentar no visual mode (mantém seleção)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clipboard
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>p", '"+p')

-- Desabilitar setas (força hjkl)
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

-- ---------- LAZY.NVIM (PLUGIN MANAGER) ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Tema Gruvbox Dark Hard
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "hard",
                transparent_mode = false,
                overrides = {
                    SignColumn = { bg = "#1d2021" },
                },
            })
            vim.cmd("colorscheme gruvbox")
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "gruvbox",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "▏" },
                scope = { enabled = false },
            })
        end,
    },

    -- Git signs no gutter
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "-" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    prompt_prefix = " λ ",
                    selection_caret = "❯ ",
                    layout_strategy = "horizontal",
                    layout_config = {
                        prompt_position = "top",
                        preview_width = 0.55,
                    },
                    sorting_strategy = "ascending",
                    winblend = 0,
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = false,
                    },
                },
            })
            telescope.load_extension("fzf")

            -- Keymaps
            vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>")
            vim.keymap.set("n", "<C-f>", "<cmd>Telescope live_grep<CR>")
            vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<CR>")
            vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
        end,
    },

    -- Treesitter (API v1.0+ — nvim-treesitter.configs REMOVIDO)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            -- API nova do nvim-treesitter (v1.0+)
            -- configs.lua foi removido, usar require direto
            local ok, treesitter = pcall(require, "nvim-treesitter")
            if ok and treesitter.setup then
                treesitter.setup({
                    ensure_installed = {
                        "rust", "python", "bash", "lua", "toml",
                        "json", "yaml", "markdown", "c", "cpp",
                    },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            else
                -- Fallback: configuração manual se setup não existir
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = { "rust", "python", "bash", "lua", "toml", "json", "yaml", "markdown", "c", "cpp" },
                    callback = function(args)
                        pcall(vim.treesitter.start, args.buf)
                    end,
                })
            end
        end,
    },

    -- LSP (Neovim 0.11+ nativo — SEM lspconfig framework)
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Função de attach para keymaps LSP
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            end

            -- Neovim 0.11+: API nativa vim.lsp.config (SEM framework deprecado)
            local servers = {
                rust_analyzer = {},
                pyright = {},
                bashls = {},
                ts_ls = {},
                jsonls = {},
                yamlls = {},
            }

            for server, config in pairs(servers) do
                vim.lsp.config[server] = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, config)
                vim.lsp.enable(server)
            end

            -- Lua LS com configuração especial
            vim.lsp.config["lua_ls"] = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            -- Completion
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },

    -- Auto-save
    {
        "okuuva/auto-save.nvim",
        config = function()
            require("auto-save").setup({
                debounce_delay = 1000,
                trigger_events = { "InsertLeave", "TextChanged" },
            })
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({
                plugins = { spelling = true },
                window = {
                    border = "none",
                    margin = { 1, 0, 1, 0 },
                    padding = { 1, 1, 1, 1 },
                },
            })
        end,
    },

    -- Comment.nvim
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },
})

-- ---------- DIAGNOSTICS ----------
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "none",
        source = "always",
    },
})

-- Mostrar diagnostics no cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
    end,
})

-- ---------- AUTO-COMMANDS ----------

-- Destacar yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Remover trailing whitespace ao salvar
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- ---------- FINAL ----------
vim.cmd([[filetype plugin indent on]])
