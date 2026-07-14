# Startup Initialization Design

## Goal

Attach LSP clients to files opened during Neovim startup while preserving the
intentional one-time configuration guard and the non-interactive installer
mode.

## Initialization Boundary

`config.lua` will configure runtime services immediately after plugin
registration when `vim.g.nvim_install_mode` is not set:

- Telescope setup and its mappings
- Mason and native LSP configuration
- Blink completion
- Gitsigns

`VimEnter` remains only for work that needs the settled startup buffer:

- opening `nvim-tree` when Neovim starts on a directory
- configuring `smear-cursor`

This makes `vim.lsp.enable()` run before the initial buffer's `FileType`
event. No changes are made to `vim.g.loaded_global_setting`.

## Installer Behavior

When `vim.g.nvim_install_mode` is set, interactive runtime setup remains
skipped. Plugin declarations still load so `PlugInstall` can operate, and the
installer continues to call the Mason bootstrap API explicitly.

## Verification

Use a temporary Python file and headless Neovim. After a short wait, its
buffer must have an attached client named `pyright` without manually replaying
the `FileType` event. Also verify that installer mode does not register the
interactive `VimEnter` setup.
