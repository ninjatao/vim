" Vim configs

if exists('g:loaded_global_setting')
    finish " avoid loading twice
else
    let g:loaded_global_setting = 1
endif

if &compatible
    set nocompatible " Be iMproved
endif
filetype plugin on " Enable file type detection
filetype indent on

set history=999 " Remember more commands

set autoread autochdir " Reload files changed outside vim

let mapleader = "\\" " Leader Key

set wildmenu wildmode=longest:full,full wildoptions=pum " wild menu

command W w !sudo tee % > /dev/null " Save file with sudo

set scrolloff=999 " Keep cursor in middle when scrolling
set display+=lastline
let $LANG='en_US.UTF-8' " Fix bizzare \"+y not working problem

" Ignore files
set wildignore=*.o,*~,*.pyc,*.tag
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,[,]

set ignorecase smartcase hlsearch incsearch " Searching options

set magic " regex set to magic mode

" Show matching brackets when text indicator is over them
set showmatch mat=2

set foldcolumn=0 " Add a bit extra margin to the left

set number " Display line number

syntax enable " Enable syntax highlighting

set termguicolors " Enable 24-bit RGB color

set encoding=utf8

set ffs=unix,dos,mac

set writebackup nobackup " No backup files

set shiftwidth=4 tabstop=4 expandtab smarttab " 1 tab == 4 spaces

set linebreak textwidth=120 " Wrap lines at 120 characters

set autoindent smartindent wrap

set ttimeout " Enable timeout for key codes
set ttimeoutlen=200

set nrformats= " <C-a> and <C-x> work with decimal numbers

set list
set listchars=tab:▸\ ,trail:·

" Disable highlight when <leader><cr> is pressed
noremap <silent> <leader><CR> :noh<CR>

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
endtry

" Return to last edit position when opening files, except in committing.
autocmd BufReadPost * if &ft !~# 'commit' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set laststatus=2 " Always show the status line

noremap <C-c> "+y " Copy selection into system clipboard
noremap <C-v> "+gP " Paste from system clipboard

nnoremap <silent> [b :bprevious<CR> " Switch between buffers
nnoremap <silent> ]b :bnext<CR>

" Simplest statusline
let g:currentmode={'n' : 'NORMAL', 'v' : 'VISUAL', 'V' : 'V·Line', "\<C-V>" : 'V·Block', 'i' : 'INSERT', 'r' : 'PROMPT', 'R' : 'REPLACE', 'c' : 'COMMAND', 's' : 'SELECT', 't' : 'TERMINAL'}

function! MyStatusLine()
  return '%1*' . ' '. toupper(g:currentmode[mode()] . ' ') .
              \ '%2* %t' . (&modified ? ' [+]' : '') . (&readonly ? ' [x]' : '') . '%<%=' .
              \ '%2*' . ((&fileencoding != 'utf-8' && !empty(&fileencoding)) ? '[' . &fileencoding . ']' : '') . ((&fileformat != 'unix') ? '[' . &fileformat . ']' : '') .
              \ '%1* %l/%L:%2c'
endfunction

autocmd WinEnter,BufEnter * setlocal statusline=%!MyStatusLine()
autocmd WinLeave * setlocal statusline=

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
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_CommandMap = {'<C-K>': ['<S-Up>'], '<C-J>': ['<S-Down>']}
    noremap <leader>r <Plug>LeaderfRgPrompt
    noremap <leader>rr :<C-U>Leaderf rg --stayOpen -e<Space>
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

try " Set colorscheme after plugins loaded, because gruvbox is plugin
    colorscheme gruvbox
catch
    colorscheme retrobox
endtry
set background=dark

" Change statusline color based on mode, after colorscheme is set.
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
    local prompts = {
        Explain = {prompt = '/COPILOT_EXPLAIN 解释已被选中的代码段落。'},
        Fix = {prompt = '/COPILOT_EXPLAIN 代码中有错误，请检查和修复。'},
        Optimize = {prompt = '/COPILOT_EXPLAIN 优化选中的代码段落。'},
    }
    require("copilot").setup {suggestion = {auto_trigger = true}}
    if vim.fn.has('termux') == 1 then
        require("CopilotChat").setup {
            window = {layout = "horizontal"},
            prompts = prompts
        }
    else
        require("CopilotChat").setup {
            prompts = prompts
        }
    end
EOF

nnoremap <silent> <leader>c :CopilotChatToggle<CR> " CopilotChat window

"Use <Tab> to accept completion if visible
inoremap <silent><expr> <Tab> luaeval('require("copilot.suggestion").is_visible() and (require("copilot.suggestion").accept() or "") or "\t"')
endif
