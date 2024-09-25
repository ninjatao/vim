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
if ! pip show pylint > /dev/null 2>&1; then
    pip install pylint
fi

install_pkg() {
    local pkg_manager=$1
    shift
    for pkg in "$@"; do
        if [ "$pkg_manager" == "pkg" ]; then
            if ! $pkg_manager list-installed | grep -q "^${pkg}"; then
                echo "Installing ${pkg}..."
                $pkg_manager install ${pkg}
            fi
        else
            if ! $pkg_manager list -1 | grep -q "^${pkg}\$"; then
                echo "Installing ${pkg}..."
                $pkg_manager install ${pkg}
            fi
        fi
    done
}

if [ "$(uname)" == "Darwin" ]; then
    echo "installing dependencies on Mac..."
    install_pkg "brew" cmake node ripgrep
elif [ "$(uname)" == "Linux" ]; then
    if [ -n "$PREFIX" ] && [ -x "$(command -v pkg)" ]; then
        echo "installing dependencies on Termux..."
        install_pkg "pkg" cmake nodejs ripgrep
    else
        echo "installing dependencies on Linux..."
        install_pkg "sudo apt-get -y" cmake nodejs ripgrep
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
