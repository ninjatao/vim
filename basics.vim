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

"ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_working_path_mode = 'ra'

"nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&b:NERDTree.isTabTree()) | q | endif

"vim-airline
let g:airline_extensions = []



