#! /bin/bash
set -e

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# for coc-pyright
pip install pylint

# node js for coc.nvim
# rg/ripgrep for Leaderf
if [ "$(uname)" == "Darwin" ]; then
    echo "installing dependencies on Mac..."
    brew install cmake go nodejs rg
elif [ "$(uname)" == "Linux" ]; then
    echo "installing dependencies on Linux..."
    apt-get install cmake go nodejs ripgrep
fi

workpath=$(cd `dirname $0`; pwd)
cd $workpath

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/config.vim"
echo $setting >> ~/.vimrc
