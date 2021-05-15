set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'mzlogin/vim-markdown-toc'
call vundle#end()            
filetype plugin indent on   
let g:molokai_original = 1
let g:ackprg = 'ag --vimgrep'
map <C-n> :NERDTreeToggle<CR>
colorscheme molokai
set completeopt=preview,menu
set nobackup
set autowrite
set ruler
set magic
set noswapfile
set hlsearch
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936oset langmenu=zh_CN.UTF-8
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2
set cmdheight=2
set viminfo+=!
set showcmd
set rnu
au BufWinLeave * silent mkview
au BufWinEnter * silent loadview
syntax enable
set background=dark
