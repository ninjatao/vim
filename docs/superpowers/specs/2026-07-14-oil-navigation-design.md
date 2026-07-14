# Oil Navigation Design

## Goal

Replace the native-Neovim `nvim-tree` sidebar with `oil.nvim` for directory
navigation and file operations. Keep Telescope as the project-wide file finder.

## Scope

- Remove the `nvim-tree` plugin declaration and its setup code.
- Add `stevearc/oil.nvim` and retain `nvim-web-devicons` for file icons.
- Map normal-mode `-` to open Oil at the current file's parent directory.
- Map `<leader>n` to open Oil at the current working directory.
- Preserve the existing VSCode/Kiro `<leader>n` mapping, where Oil is not
  loaded.
- Update the README's plugin and keymap documentation.

## Behavior

Oil opens directories as editable buffers. Enter opens the selected file or
directory; `-` returns to the parent directory; edits to names and paths are
applied when the Oil buffer is written. Telescope remains responsible for
cross-project file finding through `<leader>f`.

## Configuration

The Oil setup belongs in `lua/user/ui.lua`, beside Telescope. It will use the
existing icon dependency and default file-operation behavior. The global
keymaps belong in `lua/user/keymaps.lua`; no custom mappings are added inside
Oil buffers beyond Oil's defaults.

## Verification

Run headless Neovim to load the configuration and verify that Oil is declared
for vim-plug. After plugin synchronization, confirm that `:Oil` is available
and that the `-` mapping resolves to Oil in native Neovim.

## Non-Goals

- No replacement for Telescope file search.
- No changes to VSCode/Kiro navigation behavior.
- No migration or deletion of unrelated plugins.
