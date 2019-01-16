syntax on
filetype on
set number
set tabstop=2
set autochdir
set incsearch
set hlsearch
set showmatch
set noswapfile

colorscheme desert

" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h *.md  set fileformat=unix

" python indents
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

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

"tagbar
nmap <F8> :TagbarToggle<CR>

"syntastic
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = '!'
let g:syntastic_style_warning_symbol = '?'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1
let g:syntastic_always_populate_loc_list = 1

let g:syntastic_python_checkers=['flake8']
let g:python_highlight_all=1
let g:syntastic_cpp_cpplint_exec = 'cpplint'
let g:syntastic_cpp_checkers = ['cpplint', 'gcc']
let g:syntastic_aggregate_errors = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'


