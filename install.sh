#! /bin/bash
set -e

pluginsFullOnly=("bundle/ale")
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
    pip3 install pylint
    pip3 install flake8
    pip3 install cpplint
    pip3 install ipdb
    brew install cmake go nodejs
fi

workpath=$(cd `dirname $0`; pwd)
cd $workpath

if [ $install_checker = "false" ];
then
    excludeModules=''
    for mo in "${pluginsFullOnly[@]}"
    do
        excludeModules="$excludeModules -c submodule.${mo}.update=none "
    done
    git $excludeModules submodule update --init --recursive
else
    git submodule update --init --recursive
fi

cd $workpath/bundle/YouCompleteMe
python3 install.py

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/basics.vim"
echo $setting >> ~/.vimrc

