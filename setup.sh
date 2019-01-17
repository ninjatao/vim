#! /bin/sh
set -e

pip install flake8
pip install cpplint

workpath=$(cd `dirname $0`; pwd)
cd $workpath
git submodule update --init --recursive

workscript=$"set runtimepath+="$workpath
echo $workscript > ~/.vimrc
setting=$"source "$workpath$"/basics.vim"
echo $setting >> ~/.vimrc


