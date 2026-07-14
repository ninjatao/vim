-- Neovim Configuration
-- Modern Lua-based setup

if vim.g.loaded_global_setting then
    return
end
vim.g.loaded_global_setting = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local options = require("user.options")
local statusline = require("user.statusline")
local keymaps = require("user.keymaps")
local theme = require("user.theme")
local autocmds = require("user.autocmds")
local plugins = require("user.plugins")
local lsp = require("user.lsp")
local completion = require("user.completion")
local integrations = require("user.integrations")
local ui = require("user.ui")

options.setup()
statusline.setup()
keymaps.setup()
plugins.setup()
theme.apply()
autocmds.setup(theme)

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        ui.setup_nvim_tree(keymaps)
        ui.setup_smear_cursor()
        ui.setup_telescope(keymaps)
        lsp.setup()
        completion.setup()
        integrations.setup_gitsigns()
    end,
})
