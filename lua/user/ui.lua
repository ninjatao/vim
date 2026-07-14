local M = {}

function M.setup_nvim_tree(keymaps)
    if vim.g.vscode then
        return
    end

    local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
    if not has_nvim_tree then
        return
    end

    nvim_tree.setup({
        disable_netrw = true,
        view = {
            width = 30,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = false,
        },
        hijack_directories = {
            enable = true,
        },
        update_focused_file = {
            enable = true,
        },
    })
    keymaps.setup_nvim_tree_keymaps()

    local startup_buf = vim.api.nvim_buf_get_name(0)
    if startup_buf ~= "" and vim.fn.isdirectory(startup_buf) == 1 then
        require("nvim-tree.api").tree.open({ path = startup_buf })
    end
end

function M.setup_telescope(keymaps)
    if vim.g.vscode then
        return
    end

    local has_telescope, telescope = pcall(require, "telescope")
    if not has_telescope then
        return
    end

    telescope.setup({
        defaults = {
            file_ignore_patterns = {
                "^node_modules/",
                "^dist/",
                "^build/",
                "^.venv/",
                "^.git/",
                "^.hg/",
                "^.svn/",
            },
            mappings = {
                i = {
                    ["<C-j>"] = "move_selection_next",
                    ["<C-k>"] = "move_selection_previous",
                    ["<C-f>"] = "results_scrolling_down",
                    ["<C-b>"] = "results_scrolling_up",
                },
                n = {
                    ["<C-f>"] = "results_scrolling_down",
                    ["<C-b>"] = "results_scrolling_up",
                },
            },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    })
    pcall(telescope.load_extension, "fzf")

    local has_builtin, builtin = pcall(require, "telescope.builtin")
    if has_builtin then
        keymaps.setup_telescope_keymaps(builtin)
    end
end

function M.setup_smear_cursor()
    if vim.g.vscode then
        return
    end

    local has_smear, smear_cursor = pcall(require, "smear_cursor")
    if not has_smear then
        return
    end

    smear_cursor.setup({
        stiffness = 0.55,
        trailing_stiffness = 0.35,
        damping = 0.72,
        trailing_exponent = 2,
        distance_stop_animating = 0.5,
        hide_target_hack = false,
        legacy_computing_symbols_support = false,
        smear_insert_mode = true,
        cursor_color = "#000000",
    })
end

return M
