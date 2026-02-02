-- Neovim Configuration
-- Modern Lua-based setup

-- Prevent loading twice
if vim.g.loaded_global_setting then
    return
end
vim.g.loaded_global_setting = 1

-- Leader key must be set before plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.compatible = false
vim.opt.mouse = ""
vim.opt.history = 999
vim.opt.autoread = true
vim.opt.autochdir = true

-- UI settings
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 999
vim.opt.display:append("lastline")
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.foldcolumn = "0"
vim.opt.laststatus = 2
vim.opt.showtabline = 2

-- Command line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"
vim.opt.wildignore = "*.o,*~,*.pyc,*.tag,.DS_Store,*/.git/*,*/.hg/*,*/.svn/*"

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.magic = true

-- Editing settings
vim.opt.backspace = "eol,start,indent"
vim.opt.whichwrap:append("<,>,[,]")
vim.opt.encoding = "utf8"
vim.opt.fileformats = "unix,dos,mac"
vim.opt.backup = false
vim.opt.writebackup = false

-- Indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 120

-- Timeout settings
vim.opt.timeout = true
vim.opt.ttimeoutlen = 200

-- Display whitespace
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·" }

-- Number format for increment/decrement
vim.opt.nrformats = ""

-- Buffer switching behavior
vim.opt.switchbuf = "useopen,usetab,newtab"

-- LSP settings
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- Custom statusline
local mode_map = {
    n = "NORMAL",
    v = "VISUAL",
    V = "V·LINE",
    ["\22"] = "V·BLOCK",
    i = "INSERT",
    r = "PROMPT",
    R = "REPLACE",
    c = "COMMAND",
    s = "SELECT",
    t = "TERMINAL",
}

function _G.custom_statusline()
    local mode = mode_map[vim.fn.mode()] or "UNKNOWN"
    local filename = vim.fn.expand("%:t")
    local modified = vim.bo.modified and " [+]" or ""
    local encoding = vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding ~= "" and "[" .. vim.bo.fileencoding .. "]" or ""
    local format = vim.bo.fileformat ~= "unix" and "[" .. vim.bo.fileformat .. "]" or ""
    local line = vim.fn.line(".")
    local total = vim.fn.line("$")
    local col = vim.fn.col(".")

    return string.format("%%1* %s %%2* %s%s%%<%%=%%2*%s%s%%1* %d/%d:%d",
        mode, filename, modified, encoding, format, line, total, col)
end

vim.opt.statusline = "%!v:lua.custom_statusline()"

-- Environment
vim.env.LANG = "en_US.UTF-8"

-- Enable filetype detection
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Keymaps
local keymap = vim.keymap.set

-- Disable highlight
keymap("n", "<leader><CR>", ":noh<CR>", { silent = true, desc = "Clear search highlight" })

-- System clipboard
keymap({"n", "v"}, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
keymap({"n", "v"}, "<C-v>", '"+gP', { desc = "Paste from system clipboard" })

-- Autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Return to last edit position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local ft = vim.bo.filetype
        if ft ~= "commit" and ft ~= "gitcommit" then
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end
    end,
    desc = "Return to last edit position"
})

-- Clean trailing whitespace and empty lines on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
        local ft = vim.bo.filetype
        if ft == "diff" or ft == "git" or ft == "gitcommit" then
            return
        end
        -- Save cursor position
        local save_cursor = vim.fn.getpos(".")
        -- Remove trailing whitespace
        vim.cmd([[%s/\s\+$//e]])
        -- Remove trailing empty lines
        vim.cmd([[%s/\n\+\%$//e]])
        -- Restore cursor position
        vim.fn.setpos(".", save_cursor)
    end,
    desc = "Clean trailing whitespace and empty lines"
})

-- Plugin Manager: vim-plug
local vim_plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.empty(vim.fn.glob(vim_plug_path)) > 0 then
    print("vim-plug not found. Run :PlugInstall after installation.")
end

local Plug = vim.fn["plug#"]
vim.call("plug#begin")

-- File explorer
Plug("nvim-tree/nvim-web-devicons") -- Icons for nvim-tree
Plug("nvim-tree/nvim-tree.lua")

-- Fuzzy finder
Plug("nvim-lua/plenary.nvim") -- Required by telescope
Plug("nvim-telescope/telescope.nvim", { branch = "0.1.x" })
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

-- LSP and completion (using Neovim 0.11+ native LSP)
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("L3MON4D3/LuaSnip")
Plug("saadparwaiz1/cmp_luasnip")

-- Treesitter for better syntax highlighting
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

-- Git integration
Plug("tpope/vim-fugitive")
Plug("lewis6991/gitsigns.nvim")

-- Editing enhancements
Plug("tpope/vim-surround")
Plug("numToStr/Comment.nvim") -- Modern commenting

-- AI assistance
Plug("github/copilot.vim")
Plug("CopilotC-Nvim/CopilotChat.nvim", { branch = "main" })

-- Colorscheme
Plug("morhetz/gruvbox")

vim.call("plug#end")

-- Plugin configurations
-- Load after plugins are installed
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Colorscheme
        vim.cmd("set background=light")
        pcall(vim.cmd, "colorscheme gruvbox")

        -- Custom statusline colors based on mode
        local function set_statusline_colors()
            local mode = vim.fn.mode()
            if mode:match("^[iR]") then
                vim.cmd("highlight User1 term=bold ctermfg=black guifg=black ctermbg=lightblue guibg=lightblue")
            elseif mode:match("^[vsV\22]") then
                vim.cmd("highlight User1 term=bold ctermfg=black guifg=black ctermbg=yellow guibg=yellow")
            else
                vim.cmd("highlight User1 term=bold ctermfg=black guifg=black ctermbg=green guibg=green")
            end
        end

        -- Apply statusline colors on mode change
        vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter", "ModeChanged"}, {
            callback = set_statusline_colors,
            desc = "Update statusline colors based on mode"
        })

        -- nvim-tree setup
        local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
        if has_nvim_tree then
            nvim_tree.setup({
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
            })
            keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
        end

        -- Telescope setup
        local has_telescope, telescope = pcall(require, "telescope")
        if has_telescope then
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                        },
                    },
                },
            })
            pcall(telescope.load_extension, "fzf")

            local has_builtin, builtin = pcall(require, "telescope.builtin")
            if has_builtin then
                keymap("n", "<leader>s", builtin.live_grep, { desc = "Search in files" })
                keymap("n", "<leader>f", builtin.find_files, { desc = "Find files" })
                keymap("n", "<leader>b", builtin.buffers, { desc = "Find buffers" })
                keymap("n", "<leader>w", builtin.grep_string, { desc = "Search word under cursor" })
            end
        end

        -- Mason setup (LSP installer)
        local has_mason, mason = pcall(require, "mason")
        if has_mason then
            mason.setup()
        end

        local has_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
        if has_mason_lsp then
            mason_lsp.setup({
                ensure_installed = { "pyright", "lua_ls" },
                automatic_installation = true,
            })
        end

        -- LSP configuration using Neovim 0.11+ native API
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Python LSP
        vim.lsp.config.pyright = {
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        }
        vim.lsp.enable("pyright")

        -- Lua LSP
        vim.lsp.config.lua_ls = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
        vim.lsp.enable("lua_ls")

        -- LSP keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local opts = { buffer = args.buf }
                keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
                keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                keymap("n", "gn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                keymap("n", "[g", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                keymap("n", "]g", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                keymap("n", "<leader>d", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                keymap("n", "<leader>r", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
                keymap("n", "<leader>i", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
            end,
        })

        -- nvim-cmp setup (completion)
        local has_cmp, cmp = pcall(require, "cmp")
        local has_luasnip, luasnip = pcall(require, "luasnip")

        if has_cmp and has_luasnip then
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end

        -- Treesitter setup
        local has_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
        if has_treesitter then
            treesitter.setup({
                ensure_installed = { "python", "lua", "vim", "vimdoc", "bash" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end

        -- Comment.nvim setup
        local has_comment, comment = pcall(require, "Comment")
        if has_comment then
            comment.setup()
        end

        -- Gitsigns setup
        local has_gitsigns, gitsigns = pcall(require, "gitsigns")
        if has_gitsigns then
            gitsigns.setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
            })
        end

        -- CopilotChat setup
        local has_copilot_chat, copilot_chat = pcall(require, "CopilotChat")
        if has_copilot_chat then
            copilot_chat.setup({
                model = "claude-3.5-sonnet",
                prompts = {
                    Explain = { prompt = "/COPILOT_EXPLAIN 解释已被选中的代码，用中文回答。" },
                    Fix = { prompt = "/COPILOT_EXPLAIN 请检查和修复代码中的错误，用中文回答。" },
                    Optimize = { prompt = "/COPILOT_EXPLAIN 优化选中的代码，用中文回答。" },
                },
            })
            keymap("n", "<leader>cc", ":CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
        end
    end,
})
