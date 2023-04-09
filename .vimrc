set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'kien/rainbow_parentheses.vim'  "花里胡哨的彩虹括号 -- 先试试看
Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdtree'
Plugin 'mzlogin/vim-markdown-toc'
Plugin 'ianva/vim-youdao-translater'  "利用有道云实现翻译
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
set rnu
syntax enable
se noro
set nomore
set tabstop=4
set shiftwidth=4
au BufWinLeave * silent mkview
au BufWinEnter * silent loadview
" autocmd BufNewFile,BufRead *.md source ~/.vim/forLatex.vim

" set for cpp
set omnifunc=syntaxcomplete#Complete
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_complete_in_strings=1
let g:ycm_complete_in_comments=1

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
set tags=../*/tags,./*/tags,./tags,./../tags
" let Tlist_Show_One_File=1
" let Tlist_Exit_OnlyWindow=1
" let Tlist_Use_Right_Window=1

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

