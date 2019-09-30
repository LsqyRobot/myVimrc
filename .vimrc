source ~/.vim/simple.vim
"set spell
"set spelllang=en_us
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
set runtimepath+=~/.vim/bundle/YouCompleteMe
autocmd InsertLeave * if pumvisible() == 0|pclose|endif 
let g:ycm_seed_identifiers_with_syntax = 1    
let g:ackprg = 'ag --vimgrep'
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0             
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>'] 
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_complete_in_comments = 1                         
let g:ycm_complete_in_strings = 1                          
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0                         
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"   
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR> 
let g:ycm_min_num_of_chars_for_completion=2                
"Plugin 'VundleVim/Vundle.vim'
"Plugin 'vim-airline/vim-airline'
"Plugin 'jalvesaq/Nvim-R'
"Plugin 'honza/vim-snippets'
let g:deoplete#enable_at_startup = 1
set t_Co=256
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#buffer_nr_show = 1
Plugin 'The-NERD-tree'
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinSize=25 
"Plugin 'indentLine.vim'
"Plugin 'delimitMate.vim'
call vundle#end()
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
set ignorecase
set hlsearch
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
