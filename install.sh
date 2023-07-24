#! /bin/bash
set -e

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip install pylint
pip install ipdb
pip install jedi
brew install cmake go nodejs rg

workpath=$(cd `dirname $0`; pwd)
cd $workpath

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/config.vim"
echo $setting >> ~/.vimrc
