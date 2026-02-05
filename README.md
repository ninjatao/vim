# Neovim Configuration

## What is this?

Modern Neovim configuration with native LSP, Telescope, and Lua-based setup.

## Tested Platforms

- Mac
- Ubuntu
- Termux

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

- `<Space>` - Leader key
- `<leader>n` - Toggle file tree
- `<leader>s` - Search in files (live grep)
- `<leader>f` - Find files
- `<leader>b` - Find buffers (Neovim only)
- `<leader>w` - Search word under cursor (Neovim only)
- `<leader>cc` - Toggle Copilot Chat (Neovim only)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gr` - Show references
- `gn` - Rename symbol
- `K` - Hover documentation
- `[g` / `]g` - Navigate diagnostics
- `<C-c>` - Copy to system clipboard
- `<C-v>` - Paste from system clipboard

## VSCode/Kiro Integration

This configuration works in both native Neovim and VSCode/Kiro with Neovim extension:

- **Native Neovim**: Full features including LSP, completion, file tree, Telescope, Copilot
- **VSCode/Kiro**: Minimal subset with vim-surround, Comment.nvim, vim-fugitive
  - Telescope keybindings mapped to VSCode commands
  - Uses VSCode's native LSP and completion
  - Command-line window (`q:`) protection to prevent errors
