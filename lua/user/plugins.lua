local M = {}

function M.setup()
    local vim_plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
    if vim.fn.empty(vim.fn.glob(vim_plug_path)) > 0 then
        print("vim-plug not found. Run :PlugInstall after installation.")
    end

    local Plug = vim.fn["plug#"]
    vim.call("plug#begin")

    if not vim.g.vscode then
        Plug("nvim-tree/nvim-web-devicons")
        Plug("nvim-tree/nvim-tree.lua")
        Plug("nvim-lua/plenary.nvim")
        Plug("nvim-telescope/telescope.nvim")
        Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
        Plug("williamboman/mason.nvim")
        Plug("williamboman/mason-lspconfig.nvim")
        Plug("hrsh7th/nvim-cmp")
        Plug("hrsh7th/cmp-nvim-lsp")
        Plug("hrsh7th/cmp-buffer")
        Plug("hrsh7th/cmp-path")
        Plug("lewis6991/gitsigns.nvim")
    end

    Plug("tpope/vim-fugitive")
    Plug("tpope/vim-surround")
    Plug("numToStr/Comment.nvim")

    vim.call("plug#end")
end

return M
