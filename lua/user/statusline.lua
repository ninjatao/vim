local M = {}

local theme = require("user.theme")

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
    no = "OP-PENDING",
    ic = "INSERT",
    ix = "INSERT",
    Rv = "V·REPLACE",
    rm = "MORE",
    cv = "EX",
}

local function filename()
    local current = vim.fn.expand("%:.")
    if current == "" then
        return "[No Name]"
    end

    local width = vim.api.nvim_win_get_width(0)
    if width < 80 then
        return vim.fn.pathshorten(current)
    end
    if width < 120 then
        local parts = vim.split(current, "/", { plain = true })
        if #parts > 2 then
            return table.concat({ "...", parts[#parts - 1], parts[#parts] }, "/")
        end
    end

    return current
end

function _G.custom_statusline()
    local raw_mode = vim.fn.mode()
    theme.set_statusline_colors(raw_mode)
    local mode = mode_map[raw_mode] or raw_mode
    local modified = vim.bo.modified and " [+]" or ""
    local encoding = vim.bo.fileencoding ~= "utf-8" and vim.bo.fileencoding ~= "" and "[" .. vim.bo.fileencoding .. "]" or ""
    local format = vim.bo.fileformat ~= "unix" and "[" .. vim.bo.fileformat .. "]" or ""
    local line = vim.fn.line(".")
    local total = vim.fn.line("$")
    local col = vim.fn.col(".")

    return string.format("%%#StatusLineMode# %s %%#StatusLineMeta# %s%s%%<%%=%%#StatusLineMeta#%s%s %d/%d:%d",
        mode, filename(), modified, encoding, format, line, total, col)
end

function M.setup()
    vim.opt.statusline = "%!v:lua.custom_statusline()"
end

return M
