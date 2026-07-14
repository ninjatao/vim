local M = {}

function M.setup_gitsigns()
    if vim.g.vscode then
        return
    end

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
end

return M
