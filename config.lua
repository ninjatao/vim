-- Neovim Configuration
-- Modern Lua-based setup


-- Disable netrw early to avoid directory-opening races with nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic settings
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
    r = "REPLACE",
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

-- Enable filetype detection
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Keymaps
local keymap = vim.keymap.set

-- Disable command-line window in VSCode (causes errors)
if vim.g.vscode then
    keymap("n", "q:", "<Nop>", { desc = "Disable command-line window" })
    keymap("n", "q/", "<Nop>", { desc = "Disable search command-line window" })
    keymap("n", "q?", "<Nop>", { desc = "Disable search command-line window" })
end

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

-- Skip most plugins in VSCode
if not vim.g.vscode then
    -- File explorer
    Plug("nvim-tree/nvim-web-devicons")
    Plug("nvim-tree/nvim-tree.lua")

    -- Fuzzy finder
    Plug("nvim-lua/plenary.nvim")
    Plug("nvim-telescope/telescope.nvim")
    Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

    -- LSP and completion
    Plug("williamboman/mason.nvim")
    Plug("williamboman/mason-lspconfig.nvim")
    Plug("hrsh7th/nvim-cmp")
    Plug("hrsh7th/cmp-nvim-lsp")
    Plug("hrsh7th/cmp-buffer")
    Plug("hrsh7th/cmp-path")

    -- Git integration
    Plug("lewis6991/gitsigns.nvim")

    -- Colorscheme
    Plug("morhetz/gruvbox")
end

-- Plugins that work in both Neovim and VSCode
Plug("tpope/vim-fugitive")
Plug("tpope/vim-surround")
Plug("numToStr/Comment.nvim")

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

        -- Set initial colors
        set_statusline_colors()

        -- Apply statusline colors on mode change
        vim.api.nvim_create_autocmd({"ColorScheme", "ModeChanged"}, {
            callback = set_statusline_colors,
            desc = "Update statusline colors based on mode"
        })

        -- nvim-tree setup (Neovim only)
        if vim.g.vscode then
            -- VSCode file explorer
            keymap("n", "<leader>n", "<Cmd>call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>", { silent = true, desc = "Toggle file tree" })
        else
            local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
            if has_nvim_tree then
                nvim_tree.setup({
                    disable_netrw = true,
                    view = {
                        width = 30,
                    },
                    renderer = {
                        group_empty = true,
                    },
                    filters = {
                        dotfiles = false,
                    },
                    hijack_directories = {
                        enable = true,
                        auto_open = true,
                    },
                })
                keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
                local startup_buf = vim.api.nvim_buf_get_name(0)
                if startup_buf ~= "" and vim.fn.isdirectory(startup_buf) == 1 then
                    require("nvim-tree.api").tree.open({ path = startup_buf })
                end
            end
        end

        -- Telescope setup (Neovim only)
        -- In VSCode, use native commands instead
        if vim.g.vscode then
            -- VSCode-specific keymaps
            keymap("n", "<leader>s", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", { desc = "Search in files" })
            keymap("n", "<leader>f", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", { desc = "Find files" })
        else
            -- Telescope setup (Neovim only)
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
        end

        -- Mason setup (LSP installer)
        local has_mason, mason = pcall(require, "mason")
        if has_mason then
            mason.setup()
        end

        local has_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
        if has_mason_lsp then
            mason_lsp.setup({
                ensure_installed = { "pyright", "lua_ls", "clangd" },
                automatic_installation = true,
            })
        end

        -- LSP configuration (Neovim only, VSCode has its own LSP)
        if not vim.g.vscode then
            -- vim.lsp.config / vim.lsp.enable require Neovim >= 0.11.
            local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            if has_cmp_lsp then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

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

            -- C/C++ LSP
            vim.lsp.config.clangd = {
                cmd = { "clangd" },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
                capabilities = capabilities,
            }
            vim.lsp.enable("clangd")
        end

        -- nvim-cmp setup (completion, Neovim only)
        if not vim.g.vscode then
            local has_cmp, cmp = pcall(require, "cmp")

            if has_cmp then
                cmp.setup({
                    mapping = cmp.mapping.preset.insert({
                        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<C-e>"] = cmp.mapping.abort(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                        ["<Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                fallback()
                            end
                        end, { "i", "s" }),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp", priority = 1000 },
                        { name = "buffer", priority = 700 },
                        { name = "path", priority = 600 },
                    }),
                })
            end
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
    end,
})
