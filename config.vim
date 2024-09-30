" Vim configs

if exists('g:loaded_global_setting')
    finish
else
    let g:loaded_global_setting = 1
endif

" Enable filetype detection
if &compatible
    set nocompatible
endif
filetype plugin on
filetype indent on

" Sets how many lines of history VIM has to remember
set history=999

set autoread autochdir

" With a map leader it's possible to do extra key combinations
let mapleader = "\\"

" wild menu
set wildmenu wildmode=longest:full,full wildoptions=pum

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Set cursor always in the middle of screen.
set scrolloff=999
set display+=lastline

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'

" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.tag
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" lazydraw
set lazyredraw

"Always show current position
set ruler

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,[,]

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
set linebreak textwidth=120

set background=dark

"Auto indent, smart indent, wrap
set autoindent smartindent wrap

set ttimeout
set ttimeoutlen=200

" Set nrformats for <C-a> and <C-x> to work with decimal numbers
set nrformats=

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><CR> :noh<CR>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if &ft !~# 'commit' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Always show the status line
set laststatus=2

" Use ctrl+c to copy selection into system clipboard
noremap <C-c> "+y
" Use ctrl+v to paste from system clipboard
noremap <C-v> "+gP

" Simplest statusline
let g:currentmode={'n' : 'NORMAL', 'v' : 'VISUAL', 'V' : 'V·Line', "\<C-V>" : 'V·Block', 'i' : 'INSERT', 'r' : 'PROMPT', 'R' : 'REPLACE', 'c' : 'COMMAND', 's' : 'SELECT', 't' : 'TERMINAL'}

set statusline=%1*\ %{toupper(g:currentmode[mode()].'\ ')}
set statusline+=%2*\ %t%{&modified?'\ [+]':''}%{&readonly?'\ [x]':''}
set statusline+=%<%=
set statusline+=%2*%{(&fileencoding!='utf-8'&&!empty(&fileencoding))?'['.&fileencoding.']':''}%{&fileformat!='unix'?'['.&fileformat.']':''}
set statusline+=%1*\ %l/%L:%2c

" Remove trailing whitespaces and empty lines
autocmd BufWritePre * if &filetype != 'diff' | %s/\s\+$//e | %s/\n\+\%$//e | endif
" end of vim configs

" vim-plug
call plug#begin()

" NERDTree
Plug 'preservim/nerdtree'
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': ':CocInstall coc-pyright coc-vimlsp'}
set updatetime=300
set signcolumn=yes
" Make <CR> to accept selected completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm(): "\<c-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! SetCoCKeymap()
    " Use `[g` and `]g` to navigate diagnostics
    nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
    nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
    " GoTo code navigation
    nnoremap <silent> gd <Plug>(coc-definition)
    nnoremap <silent> gy <Plug>(coc-type-definition)
    nnoremap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> gr <Plug>(coc-references)
    " Symbol renaming
    nnoremap gn <Plug>(coc-rename)
endfunction
autocmd BufReadPost *.c,*.h,*.cpp,*.hpp,*.py,*.vim,*.vimrc,*.md,*.go call SetCoCKeymap()

" LeaderF
if has('python3') " needs python3
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    let g:Lf_CommandMap = {'<C-K>': ['<S-Up>'], '<C-J>': ['<S-Down>']}
    noremap <leader>r <Plug>LeaderfRgPrompt
    noremap <leader>w <Plug>LeaderfRgBangCwordRegexNoBoundary<CR>
    vnoremap <leader>w <Plug>LeaderfRgBangVisualLiteralNoBoundary<CR>
    let g:Lf_RgConfig = ["--iglob '!site-packages'", "--iglob '!*.map'"]
endif

" Copilot and CopilotChat
if has('nvim')
    Plug 'zbirenbaum/copilot.lua'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'CopilotC-Nvim/CopilotChat.nvim', {'branch': 'canary'}
else
    Plug 'github/copilot.vim'
end

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'
call plug#end()

" Set colorscheme after plugins loaded, because gruvbox is plugin
try
    colorscheme gruvbox
catch
    colorscheme retrobox
endtry

" Change statusline color based on mode
function! SetStatuslineHighlight(m)
    let l:highlight_cmd = 'highlight user1 term=bold ctermfg=black guifg=black'
    if a:m =~# '^[iR]$'
        execute l:highlight_cmd . ' ctermbg=lightblue guibg=lightblue'
    elseif a:m =~# '^[vsV\<C-V>]$'
        execute l:highlight_cmd . ' ctermbg=yellow guibg=yellow'
    else
        execute l:highlight_cmd . ' ctermbg=green guibg=green'
    endif
endfunction

" modechanged requires Vim 8.2+ or Neovim
autocmd colorscheme,VimEnter * call SetStatuslineHighlight(mode())
if has('nvim') || v:version >= 802
    autocmd modechanged * call SetStatuslineHighlight(mode())
endif

" Copilot and CopilotChat lua setup
if has('nvim')
lua << EOF
    require("copilot").setup {suggestion = {auto_trigger = true}}
    require("CopilotChat").setup {
        window = {layout = "horizontal"},
        prompts = {
            Explain = {prompt = '/COPILOT_EXPLAIN 解释已被选中的代码段落。'},
            Fix = {prompt = '/COPILOT_EXPLAIN 代码中有错误，请检查和修复。'},
            Optimize = {prompt = '/COPILOT_EXPLAIN 优化选中的代码段落。'},
        }
    }
EOF

"Use <Tab> to accept completion if visible
inoremap <silent><expr> <Tab> luaeval('require("copilot.suggestion").is_visible() and (require("copilot.suggestion").accept() or "") or "\t"')
endif
