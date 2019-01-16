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

"vim-gutentags
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
let g:gutentags_ctags_tagfile = '.tags'

let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']






