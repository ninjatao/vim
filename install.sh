#!/bin/bash
set -e

workpath=$(cd `dirname $0`; pwd)
cd $workpath

# Install vim-plug
PLUG_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_PATH" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install dependencies
install_pkg() {
    local pkg_checker=$1
    shift
    local pkg_installer=$1
    shift
    for pkg in "$@"; do
        if ! $pkg_checker | grep "^${pkg}" > /dev/null 2>&1; then
            echo "Installing ${pkg}..."
            $pkg_installer install ${pkg}
        fi
    done
}

if [ "$(uname)" == "Darwin" ]; then
    echo "Installing dependencies on Mac..."
    install_pkg "brew list -1 " "brew" neovim node ripgrep make gcc
elif [ "$(uname)" == "Linux" ]; then
    if [ -n "$PREFIX" ] && [ -x "$(command -v pkg)" ]; then
        echo "Installing dependencies on Termux..."
        install_pkg "pkg list-installed " "pkg" neovim nodejs ripgrep make clang
    else
        echo "Installing dependencies on Linux..."
        install_pkg "apt list --installed " "sudo apt-get" neovim nodejs ripgrep make gcc
    fi
fi

# Install pylint for Python linting
if command -v pip3 > /dev/null 2>&1; then
    if ! pip3 show pylint > /dev/null 2>&1; then
        echo "Installing pylint..."
        pip3 install pylint
    fi
fi

# Create config directory and init.lua
mkdir -p ~/.config/nvim

cat <<INITLUA > ~/.config/nvim/init.lua
-- Neovim init.lua
-- Load configuration from repository
vim.opt.runtimepath:prepend('$workpath')
dofile('$workpath/config.lua')
INITLUA

echo "✓ Created ~/.config/nvim/init.lua"

# Install plugins
if command -v nvim > /dev/null 2>&1; then
    echo "Installing Neovim plugins..."
    nvim --headless "+PlugInstall --sync" "+qall"
    echo "✓ Plugins installed successfully!"
else
    echo "✗ Neovim is not installed. Please install Neovim first."
    exit 1
fi

echo ""
echo "=========================================="
echo "Installation complete!"
echo "Run 'nvim' to start using Neovim"
echo "=========================================="
