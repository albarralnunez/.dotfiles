" set the runtime path to include Vundle and initialize
set rtp+=~/usr/share/vim/vimfiles/autoload/vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
if has("gui_running")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        set guifont=Inconsolata\ for\ Powerline:h15
    endif
endif
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Filesystem navigation
Plugin 'scrooloose/nerdtree'

" Search a project by filename to open
Plugin 'wincent/command-t'

" Nice parentheses
Plugin 'git://github.com/kien/rainbow_parentheses.vim.git'

" Live syntax checking for many languages, supports Vim 8's new features such as asynchronous jobs to ensure it doesn't freeze up Vim while running.
Plugin 'w0rp/ale'
" Syntastic is a syntax checking plugin for Vim created by Martin Grenfell. It
" runs files through external syntax checkers and displays any resulting
" errors to the user. This can be done on demand, or automatically as files
" are saved. If syntax errors are detected, the user is notified and is happy
" because they didn't have to compile their code or execute their script to
" find them.
" Plugin 'git://github.com/vim-syntastic/syntastic.git'

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

"Scala Related pluguins
Bundle 'derekwyatt/vim-scala'

"This is a Vim plugin that allows sbt to be used from within Vim.
Plugin 'git://github.com/ktvoelker/sbt-vim.git'

"This syntax file displays unicode characters for some Scala operators and
"built-in functions.
Plugin 'git://github.com/mpollmeier/vim-scalaConceal.git'

" This is an sbt plugin that generates a quickfix file that can be used with Vim.
Plugin 'https://github.com/dscleaver/sbt-quickfix.git'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Make Vim more useful
set nocompatible

set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol

set viminfo+=! " make sure vim history works
map <C-J> <C-W>j<C-W>_ " open and maximize the split below
map <C-K> <C-W>k<C-W>_ " open and maximize the split above
set wmh=0 " reduces splits to a single line 

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Enable line numbers
set number
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Respect modeline in files
set modeline
set modelines=4
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
        let save_cursor = getpos(".")
        let old_query = getreg('/')
        :%s/\s\+$//e
        call setpos('.', save_cursor)
        call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
        " Enable file type detection
        filetype on
        " Treat .json files as .js
        autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
endif

"  Auto-indent new lines
set autoindent
" Use spaces instead of tabs
set expandtab
" Number of auto-indent spaces
set shiftwidth=4
" Enable smart-indent
set smartindent
" Enable smart-tabs
set smarttab
" Number of spaces per Tab
set softtabstop=4	
" Relative line number
set relativenumber
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8


" The Silver Searcher
if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor
    " Use ag in CtrlP for listing files. Lightning fast and respects
    " .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" CTags config
set tags=./tags;

map <F12> :!ctags -R -f ./.git/tags .<CR>

