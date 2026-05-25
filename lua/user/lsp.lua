local M = {}

function M.setup()
    if vim.g.vscode then
        return
    end

    local has_mason, mason = pcall(require, "mason")
    if has_mason then
        mason.setup()
    end

    local has_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
    if has_mason_lsp then
        mason_lsp.setup({
            ensure_installed = { "pyright", "lua_ls", "clangd" },
            automatic_installation = true,
        })
    end

    if vim.fn.has("nvim-0.11") ~= 1 then
        vim.notify("Neovim 0.11+ is required for built-in LSP config in this setup", vim.log.levels.WARN)
        return
    end

    local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if has_cmp_lsp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
    }
    vim.lsp.enable("pyright")

    vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }
    vim.lsp.enable("lua_ls")

    vim.lsp.config.clangd = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
        capabilities = capabilities,
    }
    vim.lsp.enable("clangd")
end

return M
