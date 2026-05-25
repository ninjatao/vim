local M = {}

local function has_lsp_client(bufnr)
    return not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = bufnr or 0 }))
end

local function lsp_or_fallback(lsp_fn, fallback_keys)
    return function()
        if has_lsp_client(0) then
            lsp_fn()
        else
            vim.cmd.normal({ fallback_keys, bang = true })
        end
    end
end

local function lsp_or_notify(lsp_fn, message)
    return function()
        if has_lsp_client(0) then
            lsp_fn()
        else
            vim.notify(message, vim.log.levels.WARN)
        end
    end
end

function M.telescope_lsp_or_fallback(telescope_picker, lsp_fn, fallback)
    return function()
        if has_lsp_client(0) then
            local has_builtin, builtin = pcall(require, "telescope.builtin")
            if has_builtin and builtin[telescope_picker] then
                builtin[telescope_picker]()
            else
                lsp_fn()
            end
        elseif fallback then
            vim.cmd.normal({ fallback, bang = true })
        else
            vim.notify("No LSP client attached", vim.log.levels.WARN)
        end
    end
end

function M.setup_vscode_keymaps()
    local keymap = vim.keymap.set
    keymap("n", "q:", "<Nop>", { desc = "Disable command-line window" })
    keymap("n", "q/", "<Nop>", { desc = "Disable search command-line window" })
    keymap("n", "q?", "<Nop>", { desc = "Disable search command-line window" })
    keymap("n", "<leader>n", "<Cmd>call VSCodeNotify('workbench.files.action.focusFilesExplorer')<CR>", { silent = true, desc = "Toggle file tree" })
    keymap("n", "<leader>s", "<Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>", { desc = "Search in files" })
    keymap("n", "<leader>f", "<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>", { desc = "Find files" })
end

function M.setup_nvim_tree_keymaps()
    vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true, desc = "Toggle file tree" })
end

function M.setup_telescope_keymaps(builtin)
    local keymap = vim.keymap.set
    keymap("n", "<leader>s", builtin.live_grep, { desc = "Search in files" })
    keymap("n", "<leader>f", builtin.find_files, { desc = "Find files" })
    keymap("n", "<leader>b", builtin.buffers, { desc = "Find buffers" })
    keymap("n", "<leader>w", builtin.grep_string, { desc = "Search word under cursor" })
    keymap("n", "<leader>o", builtin.oldfiles, { desc = "Recent files" })
    keymap("n", "<leader>r", builtin.resume, { desc = "Resume Telescope picker" })
    keymap("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Document symbols" })
end

function M.setup()
    local keymap = vim.keymap.set

    if vim.g.vscode then
        M.setup_vscode_keymaps()
    end

    keymap("n", "<leader><CR>", ":noh<CR>", { silent = true, desc = "Clear search highlight" })
    keymap("n", "gd", lsp_or_fallback(vim.lsp.buf.definition, "gd"), { desc = "Go to definition (LSP preferred)" })
    keymap("n", "gD", lsp_or_fallback(vim.lsp.buf.declaration, "gD"), { desc = "Go to declaration (LSP preferred)" })
    keymap("n", "gi", M.telescope_lsp_or_fallback("lsp_implementations", vim.lsp.buf.implementation, "gi"), { desc = "Go to implementation (Telescope preferred)" })
    keymap("n", "grr", M.telescope_lsp_or_fallback("lsp_references", vim.lsp.buf.references), { desc = "List references (Telescope preferred)" })
    keymap("n", "grn", lsp_or_notify(vim.lsp.buf.rename, "No LSP client attached for rename"), { desc = "Rename symbol" })
    keymap({ "n", "x" }, "gra", lsp_or_notify(vim.lsp.buf.code_action, "No LSP client attached for code actions"), { desc = "Code action" })
    keymap("n", "grt", lsp_or_notify(vim.lsp.buf.type_definition, "No LSP client attached for type definition"), { desc = "Go to type definition" })
end

return M
