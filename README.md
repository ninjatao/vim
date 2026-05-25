# Neovim Configuration

## What Is This?

This repository contains a modular Neovim configuration built around:

- native LSP on Neovim `0.11+`
- Telescope for search and file picking
- `nvim-tree` for file browsing
- `nvim-cmp` for completion
- a custom soft light theme inspired by `gruvbox light`

The config is designed to work in both:

- native Neovim
- VSCode/Kiro with a Neovim extension

## Tested Platforms

- macOS
- Ubuntu

## Prerequisites

- Neovim `>= 0.11`
- Python 3
- Node.js `>= 18`
- `ripgrep`
- `make` and a C compiler for `telescope-fzf-native`

## Plugin Manager

The setup uses [vim-plug](https://github.com/junegunn/vim-plug).

## Installation

### Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/ninjatao/vim/main/install_remote.sh | bash
```

### Manual Install

1. Install Neovim `>= 0.11`.
2. Clone this repo to `~/.vim`.
3. Run:

```bash
cd ~/.vim
./install.sh
```

## Configuration Layout

The entry file is [config.lua](/Users/duantao/.vim/config.lua:1). It loads the following modules:

- [lua/user/options.lua](/Users/duantao/.vim/lua/user/options.lua:1): core editor options
- [lua/user/theme.lua](/Users/duantao/.vim/lua/user/theme.lua:1): custom light theme and statusline colors
- [lua/user/statusline.lua](/Users/duantao/.vim/lua/user/statusline.lua:1): custom statusline rendering
- [lua/user/keymaps.lua](/Users/duantao/.vim/lua/user/keymaps.lua:1): global, LSP, Telescope, and VSCode keymaps
- [lua/user/autocmds.lua](/Users/duantao/.vim/lua/user/autocmds.lua:1): save-time cleanup and color-sync autocmds
- [lua/user/plugins.lua](/Users/duantao/.vim/lua/user/plugins.lua:1): `vim-plug` plugin declarations
- [lua/user/ui.lua](/Users/duantao/.vim/lua/user/ui.lua:1): `nvim-tree` and Telescope setup
- [lua/user/lsp.lua](/Users/duantao/.vim/lua/user/lsp.lua:1): Mason and built-in LSP configuration
- [lua/user/completion.lua](/Users/duantao/.vim/lua/user/completion.lua:1): `nvim-cmp` setup
- [lua/user/integrations.lua](/Users/duantao/.vim/lua/user/integrations.lua:1): `Comment.nvim` and `gitsigns.nvim`

## Theme

The current UI theme is a custom soft light palette with:

- warm paper-like background
- muted foreground contrast
- a custom statusline mode block

Statusline mode colors:

- normal: medium green
- insert/replace: light blue
- visual: bright yellow

The theme is defined entirely in [lua/user/theme.lua](/Users/duantao/.vim/lua/user/theme.lua:1), without depending on an external colorscheme plugin.

## Key Mappings

### Core

- `<Space>`: leader key
- `<leader><CR>`: clear search highlight

### LSP

- `gd`: go to definition
- `gD`: go to declaration
- `gi`: go to implementation
- `grr`: list references
- `grn`: rename symbol
- `gra`: code action
- `grt`: go to type definition

When an LSP client is not attached, some mappings fall back to native motions and some show a warning.

### Native Neovim UI

- `<leader>n`: toggle `nvim-tree`
- `<leader>s`: Telescope live grep
- `<leader>f`: Telescope find files
- `<leader>b`: Telescope buffers
- `<leader>w`: grep word under cursor
- `<leader>o`: recent files
- `<leader>r`: resume last Telescope picker
- `<leader>ls`: document symbols

### VSCode / Kiro

- `<leader>n`: focus file explorer
- `<leader>s`: Find in Files
- `<leader>f`: Quick Open
- `q:` / `q/` / `q?`: disabled to avoid command-line window issues

### Plugin Defaults

- `gc`, `gb`: comment toggles from `Comment.nvim`
- `ys`, `ds`, `cs`: surround operations from `vim-surround`
- `:Git`, `:Gdiffsplit`, `:Git blame`: common `vim-fugitive` commands

## Behavior Notes

- `netrw` is disabled early because `nvim-tree` handles directory browsing in native Neovim.
- trailing whitespace is cleaned on save for normal editable files
- `markdown`, `mail`, `gitcommit`, and similar special cases are excluded from aggressive cleanup
- Telescope ignores common generated directories such as `node_modules`, `dist`, `build`, and `.venv`

## Native Neovim vs VSCode

### Native Neovim

You get the full stack:

- custom theme
- native LSP
- completion
- Telescope
- `nvim-tree`
- `gitsigns`

### VSCode / Kiro

You get a reduced setup:

- shared keymaps where appropriate
- `vim-surround`
- `Comment.nvim`
- `vim-fugitive`
- VSCode-native search, explorer, LSP, and completion

## Notes

- if `vim-plug` is missing, the config prints a reminder to run `:PlugInstall`
- if Neovim is older than `0.11`, built-in LSP setup is skipped and a warning is shown
