"vim configs

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

set autoread
set autochdir

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\\"

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Set cursor always in the middle of screen.
set scrolloff=999

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.tag
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Map S-Up to scrol half screen up, S-Down to scroll half screen down
nnoremap <S-Up> <C-U>
nnoremap <S-Down> <C-D>

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,[,]

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch 

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch 
set mat=2

" Add a bit extra margin to the left
set foldcolumn=0

" Display line number
set number

" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set background=light

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" backup files
set writebackup

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set timeoutlen=400 "Quicker ESC

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><CR> :noh<CR>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Always show the status line
set laststatus=2

" Use ctrl+c to copy selection into system clipboard
noremap <c-c> "+y
" Use ctrl+v to paste from system clipboard
noremap <c-v> "+gP

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif
"end of vim configs

"vim-plug
call plug#begin()

"nerdtree
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') &&
      \ b:NERDTree.isTabTree() | quit | endif

"vim-commentary
Plug 'tpope/vim-commentary'
autocmd FileType python set commentstring=#\ %s
autocmd FileType java,c,cpp set commentstring=//\ %s
autocmd FileType sh,shell set commentstring=\"\ %s
autocmd FileType json set commentstring=//\ %s

"gutentags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-json coc-pyright'}

set updatetime=300
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

"LeaderF
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_RootMarkers = ['.git', '.svn', '.root']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_CommandMap = {'<C-K>': ['<S-Up>'], '<C-J>': ['<S-Down>']}
let g:Lf_PreviewResult = {'Function': 0, 'rg': 0 }
noremap <Leader>r :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR><CR>
let g:Lf_RgConfig = [
        \ "--iglob '!site-packages'",
        \ "--iglob '!*.map'",
        \ ]

"Colorscheme
Plug 'morhetz/gruvbox'
autocmd vimenter * ++nested colorscheme gruvbox
set termguicolors

" lightline
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'materia',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'fugitive', 'modified' ] ] },
		  \ 'component_function': {
		  \   'fugitive': 'LightlineFugitive' }
      \ }
function! LightlineFugitive()
	if exists('*FugitiveHead')
		return FugitiveHead()
	endif
		return ''
endfunction

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'

call plug#end()
"end of vim-plug

" custom functions
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python %"
    endif
endfunc

map <F6> :call DebugRunGcc()<CR>
func! DebugRunGcc()
    exec "w"
    if &filetype == 'python'
        exec "!time python -m ipdb %"
    endif
endfunc
" end of custom functions
