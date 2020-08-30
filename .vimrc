set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
let g:molokai_original = 1
map <C-n> :NERDTreeToggle<CR>
map <C-g> :GitGutterLineHighlightsEnable<CR>
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
colorscheme molokai
autocmd BufNewFile *.sh exec ":call SlsqySH()" 
autocmd BufNewFile *.cpp exec ":call SlsqyCPP()" 
autocmd BufNewFile *.py exec ":call SlsqyPY()"
autocmd BufNewFile *.c exec ":call SlsqyC()" 
autocmd BufNewFile *.tex exec ":call SlsqyTex()" 
autocmd BufNewFile *.m exec ":call SlsqyOctave()" 
autocmd BufNewFile *.uml exec ":call SlsqyUML()" 
func SlsqySH() 
	call setline(1,"\#########################################################################") 
        call append(line("."), "\# FILE NAME: ".expand("%")) 
        call append(line(".")+1, "\# AUTHOR: lsqyRobot") 
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
        call append(line(".")+1, "    > Author: lsqyRobot") 
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
        call append(line(".")+1, "    > Author: lsqyRobot") 
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
        call append(line(".")+1, "    > Author: lsqyRobot")
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
        call append(line(".")+1, "%   > Author: lsqyRobot")
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ")
        call append(line(".")+3, "%   > Created Time: ".strftime("%c"))
        call append(line(".")+4, "%***********************************************************************/")
	autocmd BufNewFile * normal G
endfunc



func SlsqyOctave()
        source ~/.vim/mySimleLib/matlab.vim
        set dictionary=~/.vim/mySimleLib/matlabLib.vim
	call setline(1, "%*************************************************************************")
        call append(line("."),   "%   > File Name: ".expand("%"))
        call append(line(".")+1, "%   > Author: lsqyRobot")
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ")
        call append(line(".")+3, "%   > Created Time: ".strftime("%c"))
        call append(line(".")+4, "%***********************************************************************/")
	autocmd BufNewFile * normal G
endfunc

func SlsqyUML()
	call setline(1, "/'************************************************************************")
        call append(line("."),   "%   > File Name: ".expand("%"))
        call append(line(".")+1, "%   > Author: lsqyRobot")
        call append(line(".")+2, "%   > Mail: lsqyRobot@gmail.com ")
        call append(line(".")+3, "%   > Created Time: ".strftime("%c"))
        call append(line(".")+4, "%**********************************************************************'/")
	autocmd BufNewFile * normal G
endfunc



"检测文件类型并加载相应脚本,
"一开始都加载的话，势必会造成启动的慢速。写的非常累赘，但是为了结构清楚些。
autocmd BufNewFile,BufRead *.md source ~/.vim/mySimleLib/forMysite.vim
autocmd BufNewFile,BufRead *.tex  source ~/.vim/mySimleLib/LaTex.vim
autocmd BufNewFile,BufRead *.cls  source ~/.vim/mySimleLib/LaTex.vim
autocmd BufNewFile,BufRead *.uml source ~/.vim/mySimleLib/plantUML.vim
autocmd BufNewFile,BufRead *.uml set dictionary=~/.vim/mySimleLib/plantumlLib.vim



map rr :call CompileRun()<CR>     
"将所有的程序统一使用makefile来编译。
func! CompileRun()
    exec "w"
	if &filetype == 'tex' 
	    exec "!make all"
	end
	if &filetype == 'cpp'
    	exec "!make all"       
        end
endfunc









