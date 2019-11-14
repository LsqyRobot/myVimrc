source ~/.vim/simple.vim
set dictionary=~/.vim/myKeyWords.vim
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.m,*.tex,*.txt,*.py,*.jl,*.nb,*.cc,*.uml,*.R,*.dta,*.wls  exec ":call SetTitle()" 
func SetTitle() 
	if &filetype == 'sh' 
		call setline(1, "##########################################################################") 
		call append(line("."), "# File Name: ".expand("%")) 
		call append(line(".")+1, "# Author: lsqyRobot") 
		call append(line(".")+2, "# mail: lsqyRobot@gmail.com") 
		call append(line(".")+3, "# Created Time: ".strftime("%c")) 
		call append(line(".")+4, "#########################################################################") 
		call append(line(".")+5, "#!/bin/zsh")
		call append(line(".")+6, "PATH=/home/lsqyrobot/")
		call append(line(".")+7, "export PATH")
		call append(line(".")+8, "")
	else 
		call setline(1, "/*************************************************************************") 
		call append(line("."), "	> File Name: ".expand("%")) 
		call append(line(".")+1, "	> Author: lsqyRobot") 
		call append(line(".")+2, "	> Mail: lsqyRobot@gmail.com") 
		call append(line(".")+3, "	> Created Time: ".strftime("%c")) 
		call append(line(".")+4, " ************************************************************************/") 
		call append(line(".")+5, "")
	endif
	if &filetype == 'cpp'
		call append(line(".")+6, "#include<iostream>")
    	call append(line(".")+7, "using namespace std;")
		call append(line(".")+8, "")
	endif
	if &filetype == 'c'
		call append(line(".")+6, "#include<stdio.h>")
		call append(line(".")+7, "")
	endif
	if &filetype == 'wls' 
		call append(line(".")+6, "#!/usr/bin/env wolframscript")
		call append(line(".")+7, "")
	endif	
	"	if &filetype == 'java'
	"		call append(line(".")+6,"public class ".expand("%"))
	"		call append(line(".")+7,"")
	"	endif
	autocmd BufNewFile * normal G
endfunc 
 
set autoread
autocmd FileType c,cpp,wls map <buffer> <leader><space> :w<cr>:make<cr>
set completeopt=preview,menu 
filetype plugin on
set nobackup
set autowrite
set ruler       
set cursorline  
set cursorcolumn
set magic      
set nocompatible
set syntax=on
set noeb
set confirm
"set autoindent
"set cindent
"set tabstop=4
"set softtabstop=4
"set shiftwidth=4
set noexpandtab
set smarttab
set number
set history=500
set nobackup
set noswapfile
set hlsearch
set ignorecase smartcase
set incsearch
set gdefault
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set langmenu=zh_CN.UTF-8
set helplang=cn
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
set laststatus=2
set cmdheight=2
filetype on
set viminfo+=!
set linespace=0
set wildmenu
"set backspace=2
set whichwrap+=<,>,h,l
 au BufRead,BufNewFile *  setfiletype txt
function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction
filetype plugin indent on 
set completeopt=longest,menu
set wildmenu
set showcmd
imap ii <Esc>
au BufWinLeave * silent mkview
au BufWinEnter * silent loadview
