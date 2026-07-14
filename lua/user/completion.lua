local M = {}

function M.setup()
    if vim.g.vscode then
        return
    end

    local has_blink, blink = pcall(require, "blink.cmp")
    if not has_blink then
        return
    end

    blink.setup({
        keymap = {
            preset = "default",
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "cancel", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
        },
        snippets = { preset = "default" },
        sources = {
            default = { "lsp", "path", "buffer" },
        },
    })
end

return M
