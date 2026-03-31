# Neovim Configuration

## What is this?

Modern Neovim configuration with native LSP, Telescope, and Lua-based setup.

## Tested Platforms

- Mac
- Ubuntu

## Prerequisite

- Neovim >= 0.11
- Python3 & pip3
- node.js >= 18 (for Copilot)
- ripgrep (for Telescope search)
- make & gcc (for telescope-fzf-native)

## Plugin Manager

[vim-plug](http://github.com/junegunn/vim-plug)

## Installation

### Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/ninjatao/vim/main/install_remote.sh | bash
```

### Manual Install

1. Install Neovim (>= 0.11)
2. Clone this repo: `git clone https://github.com/ninjatao/vim.git ~/.vim`
3. Run install script: `cd ~/.vim && ./install.sh`


## Key Mappings

### Custom Mappings

- `<Space>`: leader key
- `<leader><CR>`: clear search highlight
- `<C-c>`: copy selection or current line to the system clipboard
- `<C-v>`: paste from the system clipboard

### Native Neovim

- `<leader>n`: toggle `nvim-tree`
- `<leader>s`: Telescope live grep
- `<leader>f`: Telescope find files
- `<leader>b`: Telescope buffers
- `<leader>w`: Telescope grep string under cursor

### VSCode / Kiro

- `<leader>n`: focus the VSCode file explorer
- `<leader>s`: open VSCode "Find in Files"
- `<leader>f`: open VSCode Quick Open
- `q:`: disabled to avoid command-line window issues
- `q/`: disabled to avoid search command-line window issues
- `q?`: disabled to avoid search command-line window issues

### Plugin Default Mappings

- `gc`: toggle line comments via `Comment.nvim`
- `gb`: toggle block comments via `Comment.nvim`
- `ys`, `ds`, `cs`: add, delete, and change surroundings via `vim-surround`
- `:Git`, `:Gdiffsplit`, `:Git blame`: common `vim-fugitive` commands available after plugin load

## VSCode/Kiro Integration

This configuration works in both native Neovim and VSCode/Kiro with Neovim extension:

- **Native Neovim**: Full features including native LSP, completion, file tree, Telescope, and Git signs
- **VSCode/Kiro**: Minimal subset with vim-surround, Comment.nvim, vim-fugitive
  - Telescope keybindings mapped to VSCode commands
  - Uses VSCode's native LSP and completion
  - Command-line window (`q:`) protection to prevent errors
