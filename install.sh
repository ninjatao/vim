#! /bin/bash
set -e

install_checker=false

for arg in "$@"
    do
        if [ "$arg" = "-all" -o "$arg" = "-checker" ];
        then
            install_checker=true
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

workscript="set runtimepath+="$workpath
echo $workscript > ~/.vimrc
setting="source "$workpath"/basics.vim"
echo $setting >> ~/.vimrc


