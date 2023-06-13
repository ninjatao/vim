#! /bin/bash
set -e

pluginsFullOnly=("bundle/ale")
install_checker=false

for arg in "$@"
    do
        if [ "$arg" = "-all" -o "$arg" = "-init" ];
        then
            install_checker=true
        fi
    done

if [ $install_checker = "true" ];
then
    pip install pylint
    pip install cpplint
    pip install ipdb
    brew install cmake go nodejs rg
fi

workpath=$(cd `dirname $0`; pwd)
cd $workpath

if [ $install_checker = "true" ];
then
    excludeModules=''
    for mo in "${pluginsFullOnly[@]}"
    do
        excludeModules="$excludeModules -c submodule.${mo}.update=none "
    done
    git $excludeModules submodule update --init --recursive
    cd $workpath/bundle/YouCompleteMe
    /usr/local/bin/python3 install.py
else
    git submodule update --init --recursive
fi

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/basics.vim"
echo $setting >> ~/.vimrc

