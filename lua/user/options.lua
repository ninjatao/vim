local M = {}

function M.setup()
    vim.opt.mouse = ""
    vim.opt.history = 999
    vim.opt.autoread = true

    vim.opt.number = true
    vim.opt.termguicolors = true
    vim.opt.background = "light"
    vim.opt.scrolloff = 6
    vim.opt.display:append("lastline")
    vim.opt.showmatch = true
    vim.opt.matchtime = 2
    vim.opt.foldcolumn = "0"
    vim.opt.laststatus = 2
    vim.opt.showtabline = 2

    vim.opt.wildmenu = true
    vim.opt.wildmode = "longest:full,full"
    vim.opt.wildoptions = "pum"
    vim.opt.wildignore = {}
    vim.opt.wildignore:append({
        "*.o",
        "*~",
        "*.pyc",
        "*.tag",
        ".DS_Store",
        "*/.git/*",
        "*/.hg/*",
        "*/.svn/*",
        "*/node_modules/*",
        "*/dist/*",
        "*/build/*",
        "*/.venv/*",
    })

    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    vim.opt.magic = true

    vim.opt.backspace = "eol,start,indent"
    vim.opt.whichwrap:append("<,>,[,]")
    vim.opt.fileformats = "unix,dos,mac"
    vim.opt.backup = false
    vim.opt.writebackup = false

    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true
    vim.opt.smarttab = true
    vim.opt.autoindent = true
    vim.opt.smartindent = true

    vim.opt.timeout = true
    vim.opt.ttimeoutlen = 200

    vim.opt.list = true
    vim.opt.listchars = { tab = "▸ ", trail = "·" }

    vim.opt.nrformats = ""
    vim.opt.switchbuf = "useopen,usetab,newtab"
    vim.opt.updatetime = 300
    vim.opt.signcolumn = "yes"

    vim.cmd.syntax("enable")
end

return M
