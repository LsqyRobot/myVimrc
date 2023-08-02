set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'kien/rainbow_parentheses.vim'  			" 花里胡哨的彩虹括号 -- 先试试看
Plugin 'tomasr/molokai'
Plugin 'davidhalter/jedi-vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdtree'
Plugin 'mzlogin/vim-markdown-toc'     			" 主要是在markdown里面生成目录的
Plugin 'ianva/vim-youdao-translater'   			" 利用有道云实现翻译
Plugin 'ervandew/supertab'  					" 比<C+n> 强一些 
" Plugin 'esukram/taglist-vim'  				" 用于浏览函数的
Plugin 'vim-scripts/taglist.vim'  				" 用于浏览函数的
Plugin 'tpope/vim-fugitive'  				    " 主要是用于看了哪些修改下的跳转， 在使用Git的时候
Plugin 'airblade/vim-gitgutter'   				" 主要用于直接查看做了哪些修改使用
" Plugin 'scrooloose/syntastic'                 " 语法检测，尚未配置成功
"Plugin 'ludovicchabant/vim-gutentags'          " 用于自动生成ctags的工具, 需要相应的配置
"Plugin 'dense-analysis/ale'                    " 自动检查语法的工具, 不太好用
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
" set rnu
set nu
syntax enable
se noro
set nomore
" 与设置缩进4个空格相关
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
" autocmd BufNewFile,BufRead *.md source ~/.vim/forLatex.vim

" 屏蔽掉最对YCM的设置
" set for cpp
" set omnifunc=syntaxcomplete#Complete
" let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_collect_identifiers_from_comments_and_strings=1
" let g:ycm_complete_in_strings=1
" let g:ycm_complete_in_comments=1

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
let Tlist_Show_One_File=1      " 给taglist设置的, 不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow=1    " 同上，如果taglist窗口是最后一个窗口，则退出vim
" let Tlist_Use_Right_Window=1   "同上， 在右侧窗口中显示taglist窗口, 默认为左侧， 我还是比较喜欢左侧的 

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

" set signcolumn=number   "在使用vim-gitgutter同时显示修改以及行号所使用, 要求vim版本在8.0以上
" " 配置vim-gutentags  -- 暂时不进行配置
" " gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
" let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
" " 所生成的数据文件的名称
" let g:gutentags_ctags_tagfile = 'tags'
" " 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
" let s:vim_tags = expand('~/.cache/tags')
" let g:gutentags_cache_dir = s:vim_tags
" " 配置 ctags 的参数
" let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
" let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 检测 ~/.cache/tags 不存在就新建
" if !isdirectory(s:vim_tags)
"    silent! call mkdir(s:vim_tags, 'p')
" endif


" 补全python代码
"===============================Jedi==================================
if has('python3')
let g:loaded_youcompleteme = 1 " 判断如果是python3的话，就禁用ycmd。
let g:jedi#force_py_version = 3
let g:pymode_python = 'python3'
endif
"===============================Jedi===================================



" 用于语法检测
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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

