set nocompatible              " be iMproved, required
filetype off                  " required
" 管理插件的工具
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rking/ag.vim'                           " 对于vimgrep 的 搜索优化
Plugin 'frazrepo/vim-rainbow'                   " 都是彩虹屁
Plugin 'kien/rainbow_parentheses.vim'  			" 花里胡哨的彩虹括号 -- 先试试看
Plugin 'tomasr/molokai'                         " 目前个人喜欢的配色
Plugin 'davidhalter/jedi-vim'                   " 忘记这玩意干啥了
Plugin 'flazz/vim-colorschemes'                 " 应该是和代码配色相关的？
Plugin 'scrooloose/nerdtree'                    " 文件树, 用于浏览当前目录
Plugin 'tpope/vim-commentary'                   " 辅助快速注释用的
Plugin 'mzlogin/vim-markdown-toc'     			" 主要是在markdown里面生成目录的
Plugin 'ianva/vim-youdao-translater'   			" 利用有道云实现翻译
Plugin 'ervandew/supertab'  					" 比<C+n> 强一些 
Plugin 'vim-scripts/taglist.vim'  				" 用于浏览函数的
Plugin 'tpope/vim-fugitive'  				    " 主要是用于看了哪些修改下的跳转， 在使用Git的时候
Plugin 'airblade/vim-gitgutter'   				" 主要用于直接查看做了哪些修改使用
"Plugin 'scrooloose/syntastic'                  " 语法检测，尚未配置成功
"Plugin 'ludovicchabant/vim-gutentags'          " 用于自动生成ctags的工具, 需要相应的配置
"Plugin 'dense-analysis/ale'                    " 自动检查语法的工具, 不太好用
Plugin 'itchyny/vim-cursorword'                 " 显示同一个出现的同一个单词
Plugin 'tpope/vim-surround'                      " 快捷键 如cs"
call vundle#end()            
filetype plugin indent on   
let g:molokai_original = 1
let g:ackprg = 'ag --vimgrep'
map <C-n> :NERDTreeToggle<CR>
colorscheme molokai

" set tab replace c-n
set wildmenu
set wildmode=full
set completeopt=menu,menuone,preview
inoremap <Tab> <C-n>
" end set 

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
au BufWinLeave * silent mkview
au BufWinEnter * silent loadview

" 设置 gD 查找函数的最初定义位置
nnoremap <leader>gd :call GotoDef()<CR>
function! GotoDef()
  let l:save_cursor = getpos(".")
  execute "normal! gD"
  if col(".") == 1 && getline(".") =~# '\v\s*<\w+>'
    execute "normal! \<C-w>\<C-]>"
  endif
  if line(".") == 1 && col(".") == 1
    execute "normal! \<C-w>T"
  endif
  call setpos(".", l:save_cursor)
endfunction

" 在整个文件夹中查找函数定义
" set path+=**


" inoremap <expr> <Tab> MyCompletionFunction(getline('.'), '', col('.'))
" autocmd BufNewFile,BufRead *.cpp source ~/.vim/mycompletions.vim

" 设置 ctags
let Tlist_Ctags_Cmd="/opt/homebrew/bin/ctags"
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
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" 利用有道云在线实现翻译的一些配置
vnoremap <silent> <C-T> :<C-u>Ydv<CR>
nnoremap <silent> <C-T> :<C-u>Ydc<CR>
noremap <leader>yd :<C-u>Yde<CR>




" 补全python代码, 感觉补全的太多了，不太推荐使用
"===============================Jedi==================================
if has('python3')
let g:loaded_youcompleteme = 1 " 判断如果是python3的话，就禁用ycmd。
let g:jedi#force_py_version = 3
let g:pymode_python = 'python3'
endif
"===============================Jedi===================================

" 用于语法检测
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

"
" YouCompleteMe options
"

let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:Show_diagnostics_ui = 1 "default 1

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''

let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
let g:ycm_confirm_extra_conf = 1

let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
set completeopt=menu,menuone

let g:ycm_semantic_triggers =  {
           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
           \ 'cs,lua,javascript': ['re!\w{2}'],
           \ }
" end YCM config


" 每行超过100个字符用下划线提示
" au BufRead,BufNewFile *.asm,*.c,*.cpp,*.java,*.cs,*.sh,*.lua,*.pl,*.pm,*.py,*.rb,*.hs,*.vim 2match Underlined /.\%101v/

" 用于快速注释的配置
autocmd FileType apache setlocal commentstring=#\ %s

" 更加智能的当前行高亮
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline


function! AddTitle()      " 增加个人信息
  call append(0, "/********************************************************")
  call append(1, "* Author : zhangxiaolong")
  call append(2, "* Email : lsqyRobot@gmail.com")
  call append(3, "* Last modified : ".strftime("%Y-%m-%d %H:%M"))
  call append(4, "* Filename : ".expand("%:t"))
  call append(5, "* Description : ")
  call append(6, "*************")
endfunction

" 打开文件时恢复光标位置
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

"定义一些启动函数函数
autocmd BufNewFile *.sh exec ":call SlsqySH()" 
autocmd BufNewFile *.cpp exec ":call SlsqyCPP()" 
autocmd BufNewFile *.h exec ":call SlsqyCPP()" 
autocmd BufNewFile *.hpp exec ":call SlsqyCPP()" 
autocmd BufNewFile *.py exec ":call SlsqyPY()"
autocmd BufNewFile *.c exec ":call SlsqyC()" 
autocmd BufNewFile *.tex exec ":call SlsqyTex()" 
autocmd BufNewFile *.m exec ":call SlsqyOctave()" 
autocmd BufNewFile *.uml exec ":call SlsqyUML()" 

func SlsqySH() 
	call setline(1,"\#########################################################################") 
        call append(line("."), "\# FILE NAME: ".expand("%")) 
        call append(line(".")+1, "\# AUTHOR: zhangxiaolong") 
        call append(line(".")+2, "\# MAIL: lsqyRobot@gmail.com") 
        call append(line(".")+3, "\# CREATED TIME: ".strftime("%c")) 
        call append(line(".")+4, "\#########################################################################") 
        call append(line(".")+5, "\#!/bin/zsh") 
        call append(line(".")+6, "") 
	autocmd BufNewFile * normal G
endfunc 

func SlsqyCPP() 
	call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: zhangxiaolong") 
        call append(line(".")+2, "    > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "") 
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
	autocmd BufNewFile * normal G
endfunc 

func SlsqyPY() 
	call setline(1, "''' ") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: zhangxiaolong") 
        call append(line(".")+2, "    > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "'''") 
        call append(line(".")+5, "# -*- coding:utf-8 -*- ")
        call append(line(".")+6, "")
	autocmd BufNewFile * normal G
endfunc

func SlsqyC() 
	call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: zhangxiaolong") 
        call append(line(".")+2, "    > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "    > Created Time: ".strftime("%c")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "") 
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
	autocmd BufNewFile * normal G
endfunc

func SlsqyTex() 
	call setline(1, "%*************************************************************************") 
        call append(line("."),   "%   > File Name: ".expand("%")) 
        call append(line(".")+1, "%   > Author: zhangxiaolong") 
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "%   > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "%***********************************************************************/") 
	autocmd BufNewFile * normal G
endfunc

func SlsqyOctave() 
	call setline(1, "%*************************************************************************") 
        call append(line("."),   "%   > File Name: ".expand("%")) 
        call append(line(".")+1, "%   > Author: zhangxiaolong") 
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "%   > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "%***********************************************************************/") 
	autocmd BufNewFile * normal G
endfunc

func SlsqyUML() 
	call setline(1, "/'************************************************************************") 
        call append(line("."),   "%   > File Name: ".expand("%")) 
        call append(line(".")+1, "%   > Author: zhangxiaolong") 
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ") 
        call append(line(".")+3, "%   > Created Time: ".strftime("%c")) 
        call append(line(".")+4, "%**********************************************************************'/") 
	autocmd BufNewFile * normal G
endfunc
