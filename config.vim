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
nmap <S-Up> <C-U>
nmap <S-Down> <C-D>

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

" Set ColorScheme
set termguicolors
colorscheme retrobox

"Enable mouse
set mouse=nvi

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
set timeoutlen=600 "Quicker ESC

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

" Custom statusline
let g:currentmode={'n' : 'NORMAL', 'v' : 'VISUAL', 'V' : 'V·Line', "\<C-V>" : 'V·Block', 'i' : 'INSERT', 'r' : 'PROMPT', 'R' : 'REPLACE', 'c' : 'Command', 's' : 'SELECT', 't' : 'TERMINAL'}

set statusline=
set statusline+=%1*\ %{toupper(g:currentmode[mode()].'\ ')}
set statusline+=%2*\ %t%{&modified?'\ [+]':''}%{&readonly?'\ ]':''}

" Truncate line here
set statusline+=%<%=

" Encoding & Fileformat
let b_show_encoding=&fileencoding=='utf-8'||&fileencoding==''
set statusline+=%2*%{b_show_encoding?'':'['.&fileencoding.']'}%{&fileformat=='unix'?'':'['.&fileformat.']'}

" Location of cursor line and column
set statusline+=%1*\ ~line:%l/%L\ col:%2c

" Change Statusline color based on mode
function! SetHighlight(m)
  if a:m=='i' || a:m=='R'
    hi User1 term=bold ctermfg=Black ctermbg=LightBlue
  elseif a:m=='v' || a:m=='V' || a:m=='\<C-V>' || a:m=='s'
    hi User1 term=bold ctermfg=Black ctermbg=DarkYellow
  else
    hi User1 term=bold ctermfg=Black ctermbg=DarkGreen
  endif
endfunction

au ColorScheme,VimEnter,ModeChanged * call SetHighlight(mode())
au ColorScheme,VimEnter * hi User2 ctermfg=LightBlue ctermbg=Black
"end of vim configs

"vim-plug
call plug#begin()

"nerdtree
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
au BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') &&
      \ b:NERDTree.isTabTree() | quit | endif

"vim-commentary
Plug 'tpope/vim-commentary'
au FileType python set commentstring=#\ %s
au FileType java,c,cpp,json set commentstring=//\ %s
au FileType sh,shell set commentstring=\"\ %s

"gutentags
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = expand('~/.cache/tags')
if !isdirectory(g:gutentags_cache_dir) | silent! call mkdir(g:gutentags_cache_dir, 'p') | endif

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
au BufReadPost *.c,*.h,*.cpp,*.hpp nmap <silent> gi <Plug>(coc-implementation)
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

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'

call plug#end()
"end of vim-plug

" custom functions
" Run scripts
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
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
