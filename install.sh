#! /bin/bash
set -e

pluginsFullOnly=("bundle/syntastic" "bundle/gutentags")
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

workscript="set runtimepath+=$workpath"
echo $workscript > ~/.vimrc
setting="source $workpath/basics.vim"
echo $setting >> ~/.vimrc


