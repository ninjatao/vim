"Vim configs

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

set autoread autochdir

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\\"

" wild menu
set wildmenu wildmode=longest:full,full wildoptions=pum

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
nmap <S-LEFT> 20<LEFT>
nmap <S-RIGHT> 20<RIGHT>

" lazydraw
set lazyredraw

"Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>

" Searching
set ignorecase smartcase hlsearch incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch mat=2

" Add a bit extra margin to the left
set foldcolumn=0

" Display line number
set number

" Enable syntax highlighting
syntax enable

" Set ColorScheme
set termguicolors

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" backup files
set writebackup nobackup

" 1 tab == 4 spaces
set shiftwidth=4 tabstop=4 expandtab smarttab

" Linebreak
set lbr
set tw=120

set ai si wrap "Auto indent, smart indent, wrap
set timeoutlen=400 "Quicker ESC
set ttimeoutlen=400 "Quicker ESC

" Set nrformats for <C-a> and <C-x> to work with decimal numbers
set nrformats=

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
noremap <C-c> "+y
" Use ctrl+v to paste from system clipboard
noremap <C-v> "+gP

" Custom statusline
let g:currentmode={'n' : 'NORMAL', 'v' : 'VISUAL', 'V' : 'V·Line', "\<C-V>" : 'V·Block', 'i' : 'INSERT', 'r' : 'PROMPT', 'R' : 'REPLACE', 'c' : 'COMMAND', 's' : 'SELECT', 't' : 'TERMINAL'}

set statusline=
set statusline+=%1*\ %{toupper(g:currentmode[mode()].'\ ')}
set statusline+=%2*\ %t%{&modified?'\ [+]':''}%{&readonly?'\ [x]':''}

" Truncate line here
set statusline+=%<%=

" Encoding & Fileformat
let b_ignore_encoding=&fileencoding=='utf-8'||&fileencoding==''
set statusline+=%2*%{b_ignore_encoding?'':'['.&fileencoding.']'}%{&fileformat=='unix'?'':'['.&fileformat.']'}

" Location of cursor line and column
set statusline+=%1*\ %l/%L:%2c

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

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-pyright coc-markdownlint coc-vimlsp'}
set updatetime=1000
set signcolumn=yes

" Make <CR> to accept selected completion item or notify coc.nvim to format. <c-g>u changes undo behavior.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<c-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! SetCoCKeymap()
  " Use `[g` and `]g` to navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  " GoTo code navigation
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  " Symbol renaming
  nmap gn <Plug>(coc-rename)
endfunction
au BufReadPost *.c,*.h,*.cpp,*.hpp,*.py,*.vim,*.vimrc,*.md,*.go call SetCoCKeymap()

"LeaderF
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_CommandMap = {'<C-K>': ['<S-Up>'], '<C-J>': ['<S-Down>']}
noremap <leader>r <Plug>LeaderfRgPrompt
noremap <leader>w <Plug>LeaderfRgBangCwordRegexNoBoundary<CR>
vnoremap <leader>w <Plug>LeaderfRgBangVisualLiteralNoBoundary<CR>
let g:Lf_RgConfig = [
        \ "--iglob '!site-packages'",
        \ "--iglob '!*.map'",
        \ ]

Plug 'github/copilot.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_light = 'soft'
call plug#end()

" set colorscheme after plugins loaded, because gruvbox is plugin
colorscheme gruvbox
function! SetBackgroundColor()
    let hour = strftime("%H")
    if hour >= 7 && hour < 19
        set bg=light
    else
        set bg=dark
    endif
endfunction
autocmd VimEnter * call SetBackgroundColor()

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

" ModeChanged requires vim 8.2+
autocmd ColorScheme,VimEnter,ModeChanged * call SetHighlight(mode())
