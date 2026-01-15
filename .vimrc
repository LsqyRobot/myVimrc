set nocompatible
filetype off
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
Plug 'ludovicchabant/vim-gutentags'           " 自动管理 tags，比手动 ctags 智能
Plug 'liuchengxu/vista.vim'                  " 现代化的标签浏览器，替代 taglist
Plug 'Yggdroot/LeaderF'                      " 模糊搜索，包含函数搜索功能
Plug 'tpope/vim-fugitive'                     " 主要是用于看了哪些修改下的跳转， 在使用Git的时候
Plug 'airblade/vim-gitgutter'                 " 主要用于直接查看做了哪些修改使用
Plug 'itchyny/vim-cursorword'                 " 显示同一个出现的同一个单词
Plug 'vim-airline/vim-airline'                " 更美观的状态栏
"Plug 'alpertuna/vim-header'                   " 增加作者信息（可选，取消注释启用）
Plug 'github/copilot.vim'                     " github 上的copilot 工具
Plug 'rhysd/vim-clang-format'
Plug 'Chiel92/vim-autoformat'                 " 多语言代码格式化
Plug 'dhruvasagar/vim-table-mode'             " Markdown 表格模式
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
set incsearch                                " 可以开启增量搜索，使得在搜索时可以实时匹配输入的字符，按 :set noincsearch 可以关闭增量搜索。
set ignorecase
set smartcase

au BufWinLeave * silent mkview
au BufWinEnter * silent loadview

" ===== 改进的 ctags 配置 =====
" 设置 tags 文件路径（更完整的搜索路径）
set tags=./tags,tags,../tags,../../tags,../../../tags,../../../../tags
set tags+=~/.vim/tags/cpp_tags        " C++ 系统库 tags
set tags+=~/.vim/tags/python_tags     " Python 系统库 tags

" ===== gutentags 配置 =====
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags')
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" ===== vista.vim 配置 =====
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista_echo_cursor = 1
let g:vista_cursor_delay = 400

" ===== LeaderF 配置 =====
let g:Lf_ShortcutF = '<leader>ff'
let g:Lf_ShortcutB = '<leader>fb'
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_PreviewResult = {'Function': 1, 'Colorscheme': 1}

" 自动生成 ctags
function! UpdateCtags()
    " 检测项目类型并生成相应的 tags
    if filereadable('./Makefile') || filereadable('./CMakeLists.txt')
        " C/C++ 项目
        silent! !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ .
    elseif filereadable('./setup.py') || filereadable('./requirements.txt')
        " Python 项目
        silent! !ctags -R --python-kinds=-i --languages=python .
    else
        " 通用项目
        silent! !ctags -R --exclude=.git --exclude=node_modules --exclude=*.log .
    endif
    echo "Tags updated!"
endfunction

" Taglist 设置（保持兼容）
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

" ===== 可选：个人信息配置（vim-header 插件） =====
" 取消上方 vim-header 插件的注释后，下面的配置才会生效
" let g:header_auto_add_header = 1
" let g:header_auto_update_header = 1
" let g:header_field_author = 'zhangxiaolong'
" let g:header_field_author_email = 'lsqyRobot@gmail.com'
" let g:header_field_filename_path = 1
" let g:header_field_copyright = '@copyright Copyright (c) LsqyRobot'
" let g:header_field_timestamp_format = '%Y-%m-%d'

autocmd FileType cpp,cc,h,hpp ClangFormatAutoEnable
let g:clang_format#style_options = {
  \ "BasedOnStyle": "Google",
  \ "IndentWidth": 4,
  \ }

autocmd FileType cpp,cc,h,hpp ClangFormatAutoEnable

" ===== 键盘映射配置 =====
" 设置 leader 键
let mapleader = ","

" 传统映射
nnoremap <leader>m @a                 " 执行宏 @a

" ctags 相关快捷键
nnoremap <leader>ct :call UpdateCtags()<CR>
nnoremap <C-]> g<C-]>                 " 如果有多个定义，显示列表选择
nnoremap <leader>ts :ts<CR>           " 显示所有匹配的 tags
nnoremap <leader>tp :tp<CR>           " 上一个 tag
nnoremap <leader>tn :tn<CR>           " 下一个 tag

" Vista 和搜索快捷键
nnoremap <leader>v :Vista!!<CR>       " 打开/关闭 Vista 标签浏览器
nnoremap <leader>vf :Vista finder<CR> " 搜索函数/变量

" LeaderF 快捷键
nnoremap <leader>ff :Leaderf file<CR>     " 搜索文件
nnoremap <leader>fb :Leaderf buffer<CR>   " 搜索缓冲区
nnoremap <leader>ft :Leaderf function<CR> " 搜索函数
nnoremap <leader>fl :Leaderf line<CR>     " 搜索当前缓冲区行

" 自动更新 tags（保存文件时）
autocmd BufWritePost *.cpp,*.cc,*.c,*.h,*.hpp,*.py,*.java,*.go silent! call UpdateCtags()

" ===== 多语言代码格式化配置 =====
" Python 使用 yapf（Google 风格）
let g:formatdef_yapf = '"yapf --style google"'
let g:formatters_python = ['yapf']

" 手动触发格式化快捷键
autocmd FileType python nnoremap <buffer> <leader>f :Autoformat<CR>
autocmd FileType javascript nnoremap <buffer> <leader>f :Autoformat<CR>
autocmd FileType go nnoremap <buffer> <leader>f :Autoformat<CR>

" 保存前自动格式化（可选）
autocmd BufWritePre *.py silent! undojoin | Autoformat

" ===== vim-table-mode 配置 =====
let g:table_mode_corner='|'
" 打开/关闭表格模式
nnoremap <leader>tm :TableModeToggle<CR>
" 默认在 markdown 文件中启用表格模式
autocmd FileType markdown TableModeEnable
" 插入模式下输入 | 时，自动补全为表格对齐
let g:table_mode_map_prefix = '<leader>t'
