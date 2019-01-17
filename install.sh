#! /bin/bash
set -e

install_checker=true

for arg in "$@"
    do
        if [ "$arg" = "-light" ];
        then
            echo "light mode"
            install_checker=false
        fi
    done

if [ $install_checker = "true" ];
then
    pip install flake8
    pip install cpplint
fi

workpath=$(cd `dirname $0`; pwd)
cd $workpath
git submodule update --init --recursive

workscript=$"set runtimepath+="$workpath
echo $workscript > ~/.vimrc
setting=$"source "$workpath$"/basics.vim"
echo $setting >> ~/.vimrc


