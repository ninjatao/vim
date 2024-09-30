#! /bin/bash
set -e

workpath=$(cd `dirname $0`; pwd)
cd $workpath

# plug.vim
DEST="$workpath/autoload/plug.vim"

if [ ! -f "$DEST" ]; then
    curl -fLo "$DEST" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# for coc-pyright
if command -v pip > /dev/null 2>&1; then
    if ! pip show pylint > /dev/null 2>&1; then
        pip install pylint
    fi
fi

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
    echo "installing dependencies on Mac..."
    install_pkg "brew list -1 " "brew" cmake node ripgrep
elif [ "$(uname)" == "Linux" ]; then
    if [ -n "$PREFIX" ] && [ -x "$(command -v pkg)" ]; then
        echo "installing dependencies on Termux..."
        install_pkg "pkg list-installed " "pkg" cmake nodejs ripgrep
    else
        echo "installing dependencies on Linux..."
        install_pkg "apt list --installed " "sudo apt-get" cmake nodejs ripgrep
    fi
fi

cat <<VIMRC > ~/.vimrc
set runtimepath+=$workpath
source $workpath/config.vim
let g:coc_config_home=expand('$workpath')
VIMRC

mkdir -p ~/.config/nvim
cp ~/.vimrc ~/.config/nvim/init.vim

# Check if Vim or Neovim is installed and run PlugInstall
if command -v nvim > /dev/null 2>&1; then
    nvim +PlugInstall +qall
elif command -v vim > /dev/null 2>&1; then
    vim +PlugInstall +qall
else
    echo "Neither Vim nor Neovim is installed, skip plugins."
fi
