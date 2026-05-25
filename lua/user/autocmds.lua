local M = {}

function M.setup(theme)
    local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        callback = function()
            if vim.bo.buftype ~= "" or not vim.bo.modifiable or vim.bo.readonly then
                return
            end

            local ft = vim.bo.filetype
            if ft == "diff" or ft == "git" or ft == "gitcommit" or ft == "markdown" or ft == "mail" then
                return
            end

            local view = vim.fn.winsaveview()
            local last_line = vim.fn.line("$")
            vim.cmd([[%s/\s\+$//e]])
            if last_line <= 5000 then
                vim.cmd([[%s/\n\+\%$//e]])
            end
            vim.fn.winrestview(view)
        end,
        desc = "Clean trailing whitespace and empty lines",
    })

    vim.api.nvim_create_autocmd({ "ColorScheme", "ModeChanged" }, {
        group = augroup,
        callback = theme.set_statusline_colors,
        desc = "Keep statusline highlight in sync with mode and colorscheme",
    })
end

return M
