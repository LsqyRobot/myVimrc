set nocompatible           
filetype off
"install methods:  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" 采用更现代化的管理插件工具
call plug#begin('~/.vim/plugged')
Plug 'rking/ag.vim'                           " 对于vimgrep 的 搜索优化
Plug 'frazrepo/vim-rainbow'                   " 都是彩虹屁
Plug 'kien/rainbow_parentheses.vim'           " 花里胡哨的彩虹括号 -- 先试试看
Plug 'tomasr/molokai'                         " 目前个人喜欢的配色
Plug 'davidhalter/jedi-vim'                   " 忘记这玩意干啥了
Plug 'flazz/vim-colorschemes'                 " 应该是和代码配色相关的？
Plug 'scrooloose/nerdtree'                    " 文件树, 用于浏览当前目录
Plug 'tpope/vim-commentary'                   " 辅助快速注释用的
Plug 'mzlogin/vim-markdown-toc'               " 主要是在markdown里面生成目录的
Plug 'ervandew/supertab'                      " 比<C+n> 强一些 
Plug 'vim-scripts/taglist.vim'                " 用于浏览函数的
Plug 'tpope/vim-fugitive'                     " 主要是用于看了哪些修改下的跳转， 在使用Git的时候
Plug 'airblade/vim-gitgutter'                 " 主要用于直接查看做了哪些修改使用
Plug 'itchyny/vim-cursorword'                 " 显示同一个出现的同一个单词
Plug 'vim-airline/vim-airline'                " 更美观的状态栏
call plug#end()

filetype plugin on
let g:molokai_original = 1
let g:ackprg = 'ag --vimgrep'
map <C-n> :NERDTreeToggle<CR>
colorscheme molokai

set wildmenu
set wildmode=full
set nobackup
set autowrite
set ruler
set magic
set noswapfile
set hlsearch
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936o
set langmenu=zh_CN.UTF-8
set laststatus=2
set cmdheight=2
set viminfo+=!
set showcmd
set nu
syntax enable
se noro
set nomore

" 与设置缩进4个空格相关, 但是我感觉好像没啥用处，每次还是以一个tab键来占位
set tabstop=4
set shiftwidth=4
set ts=4        " 设置tab键为4个空格
set softtabstop=4
set expandtab
set autoindent
" 结束设置缩进4个空格

set incsearch   " 可以开启增量搜索，使得在搜索时可以实时匹配输入的字符，按 :set noincsearch 可以关闭增量搜索。
set ignorecase
set smartcase

au BufWinLeave * silent mkview
au BufWinEnter * silent loadview

" 设置 ctags
set tags=../*/tags,./*/tags,./tags,./../tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../../tags,./../../../../../../../../../tags,
let Tlist_Show_One_File=1      " 给taglist设置的, 不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow=1    " 同上，如果taglist窗口是最后一个窗口，则退出vim

" 针对花里胡哨的彩虹括号
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

" 更加智能的当前行高亮
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

