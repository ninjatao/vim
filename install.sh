#! /bin/bash
set -e

workpath=$(cd `dirname $0`; pwd)
cd $workpath

# plug.vim
DEST="$workpath/autoload/plug.vim"

if [ -f "$DEST" ]; then
    echo "plug.vim is already installed."
else
    curl -fLo "$DEST" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# for coc-pyright
if ! pip show pylint > /dev/null 2>&1; then
    pip install pylint
else
    echo "pylint is already installed."
fi

if [ "$(uname)" == "Darwin" ]; then
    echo "installing dependencies on Mac..."
    for pkg in cmake node ripgrep; do
        if ! brew list -1 | grep -q "^${pkg}\$"; then
            echo "Installing ${pkg}..."
            brew install ${pkg}
        else
            echo "${pkg} is already installed."
        fi
    done
elif [ "$(uname)" == "Linux" ]; then
    echo "installing dependencies on Linux..."
    for pkg in cmake nodejs ripgrep; do
        if ! dpkg -l | grep -q "^ii  ${pkg} "; then
            echo "Installing ${pkg}..."
            sudo apt-get install -y ${pkg}
        else
            echo "${pkg} is already installed."
        fi
    done
fi

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/config.vim"
echo $setting >> ~/.vimrc
echo "let g:coc_config_home = expand('$workpath')" >> ~/.vimrc
mkdir -p ~/.config/nvim
cp ~/.vimrc ~/.config/nvim/init.vim
