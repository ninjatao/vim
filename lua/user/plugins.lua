local M = {}

function M.setup()
    local vim_plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
    if vim.fn.empty(vim.fn.glob(vim_plug_path)) > 0 then
        vim.notify(
            "vim-plug not found. Run ./install.sh from the repository root, or install plug.vim before starting Neovim.",
            vim.log.levels.ERROR
        )
        return
    end

    local Plug = vim.fn["plug#"]
    vim.call("plug#begin")

    if not vim.g.vscode then
        Plug("nvim-tree/nvim-web-devicons")
        Plug("nvim-tree/nvim-tree.lua")
        Plug("nvim-lua/plenary.nvim")
        Plug("sphamba/smear-cursor.nvim")
        Plug("nvim-telescope/telescope.nvim")
        Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
        Plug("williamboman/mason.nvim")
        Plug("WhoIsSethDaniel/mason-tool-installer.nvim")
        Plug("Saghen/blink.cmp", { ["branch"] = "v1" })
        Plug("lewis6991/gitsigns.nvim")
    end

    Plug("tpope/vim-fugitive")
    Plug("tpope/vim-surround")

    vim.call("plug#end")
end

return M
