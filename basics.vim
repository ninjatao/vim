syntax on
filetype on
set number
set tabstop=2
set autochdir
set incsearch
set hlsearch
set showmatch

colorscheme desert

execute pathogen#infect()
execute pathogen#infect('bundle/{}', '~/.vim_tao/bundle/{}')
