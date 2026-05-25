local M = {}

local function set(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

function M.set_statusline_colors()
    local mode = vim.fn.mode()
    if mode:match("^[iR]") then
        set("StatusLineMode", { fg = "#000000", bg = "#add8e6", bold = true })
    elseif mode:match("^[vsV\22]") then
        set("StatusLineMode", { fg = "#000000", bg = "#fff176", bold = true })
    else
        set("StatusLineMode", { fg = "#000000", bg = "#689637", bold = true })
    end
end

function M.apply()
    if vim.g.vscode then
        return
    end

    vim.opt.background = "light"
    vim.cmd.highlight("clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd.syntax("reset")
    end
    vim.g.colors_name = "custom_gruvbox_soft_light"

    set("Normal", { fg = "#504945", bg = "#f2e5bc" })
    set("NormalNC", { fg = "#504945", bg = "#f2e5bc" })
    set("NormalFloat", { fg = "#504945", bg = "#f6ebc8" })
    set("FloatBorder", { fg = "#bdae93", bg = "#f6ebc8" })
    set("CursorLine", { bg = "#ebdbb2" })
    set("CursorLineNr", { fg = "#7c6f64", bg = "#ebdbb2", bold = true })
    set("LineNr", { fg = "#bdae93", bg = "#f2e5bc" })
    set("SignColumn", { fg = "#928374", bg = "#f2e5bc" })
    set("StatusLine", { fg = "#504945", bg = "#ddc7a1" })
    set("StatusLineNC", { fg = "#928374", bg = "#e6d5ae" })
    set("StatusLineMeta", { fg = "#504945", bg = "#ddc7a1" })
    set("VertSplit", { fg = "#d5c4a1", bg = "#f2e5bc" })
    set("WinSeparator", { fg = "#d5c4a1", bg = "#f2e5bc" })
    set("Pmenu", { fg = "#504945", bg = "#efe1b7" })
    set("PmenuSel", { fg = "#282828", bg = "#d8c59d", bold = true })
    set("Visual", { bg = "#e0cfa1" })
    set("Search", { fg = "#3c3836", bg = "#f4c069" })
    set("IncSearch", { fg = "#282828", bg = "#e9b143", bold = true })
    set("Comment", { fg = "#928374", italic = true })
    set("Constant", { fg = "#b16286" })
    set("String", { fg = "#79740e" })
    set("Identifier", { fg = "#076678" })
    set("Function", { fg = "#427b58" })
    set("Statement", { fg = "#9d0006" })
    set("PreProc", { fg = "#8f3f71" })
    set("Type", { fg = "#b57614" })
    set("Special", { fg = "#af3a03" })
    set("Underlined", { fg = "#076678", underline = true })
    set("Todo", { fg = "#282828", bg = "#f4c069", bold = true })

    set("DiagnosticError", { fg = "#c14a4a" })
    set("DiagnosticWarn", { fg = "#b47109" })
    set("DiagnosticInfo", { fg = "#45707a" })
    set("DiagnosticHint", { fg = "#6c782e" })
    set("DiagnosticSignError", { fg = "#c14a4a", bg = "#f2e5bc" })
    set("DiagnosticSignWarn", { fg = "#b47109", bg = "#f2e5bc" })
    set("DiagnosticSignInfo", { fg = "#45707a", bg = "#f2e5bc" })
    set("DiagnosticSignHint", { fg = "#6c782e", bg = "#f2e5bc" })
    set("DiagnosticVirtualTextError", { fg = "#9d3c3c", bg = "#ecd4d4" })
    set("DiagnosticVirtualTextWarn", { fg = "#8a6308", bg = "#efe0be" })
    set("DiagnosticVirtualTextInfo", { fg = "#3d6570", bg = "#dbe7e9" })
    set("DiagnosticVirtualTextHint", { fg = "#56611f", bg = "#e4ead2" })
    set("DiagnosticUnderlineError", { sp = "#c14a4a", undercurl = true })
    set("DiagnosticUnderlineWarn", { sp = "#b47109", undercurl = true })
    set("DiagnosticUnderlineInfo", { sp = "#45707a", undercurl = true })
    set("DiagnosticUnderlineHint", { sp = "#6c782e", undercurl = true })

    M.set_statusline_colors()
end

return M
