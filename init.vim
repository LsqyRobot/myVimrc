" =====================================================
" 极致现代型 Neovim 配置 (需要 Neovim 0.8+)
" 作者: Lucas - 现代化 IDE 级别体验
" =====================================================

" ===== 基础设置 =====
set nocompatible
set encoding=utf-8
set fileencoding=utf-8
set number
set relativenumber
set cursorline
set signcolumn=yes
set updatetime=300
set timeoutlen=500
set mouse=a
set clipboard=unnamedplus

" 搜索设置
set hlsearch
set incsearch
set ignorecase
set smartcase

" 缩进和制表符
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

" 界面设置
set termguicolors
set pumheight=10
set cmdheight=2
set laststatus=3
set showtabline=2
set noshowmode

" 文件和备份
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.config/nvim/undo

" ===== 插件管理 (vim-plug) =====
call plug#begin('~/.config/nvim/plugged')

" === 核心插件 ===
Plug 'neovim/nvim-lspconfig'                    " LSP 配置
Plug 'williamboman/mason.nvim'                  " LSP 服务器管理
Plug 'williamboman/mason-lspconfig.nvim'        " Mason 和 lspconfig 桥接

" === 补全引擎 ===
Plug 'hrsh7th/nvim-cmp'                        " 补全引擎
Plug 'hrsh7th/cmp-nvim-lsp'                    " LSP 补全源
Plug 'hrsh7th/cmp-buffer'                      " 缓冲区补全
Plug 'hrsh7th/cmp-path'                        " 路径补全
Plug 'hrsh7th/cmp-cmdline'                     " 命令行补全
Plug 'hrsh7th/cmp-nvim-lua'                    " Lua API 补全

" === 代码片段 ===
Plug 'L3MON4D3/LuaSnip'                        " 片段引擎
Plug 'saadparwaiz1/cmp_luasnip'                " 片段补全源
Plug 'rafamadriz/friendly-snippets'            " 片段库

" === 语法高亮和解析 ===
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" === 模糊搜索 ===
Plug 'nvim-lua/plenary.nvim'                   " 依赖库
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}

" === 文件管理 ===
Plug 'nvim-tree/nvim-tree.lua'                 " 文件树
Plug 'nvim-tree/nvim-web-devicons'             " 文件图标

" === Git 集成 ===
Plug 'lewis6991/gitsigns.nvim'                 " Git 状态
Plug 'tpope/vim-fugitive'                      " Git 命令
Plug 'sindrets/diffview.nvim'                  " Git diff 查看器

" === 编辑增强 ===
Plug 'windwp/nvim-autopairs'                   " 自动配对
Plug 'tpope/vim-surround'                      " 环绕操作
Plug 'numToStr/Comment.nvim'                   " 智能注释
Plug 'mg979/vim-visual-multi'                  " 多光标
Plug 'folke/flash.nvim'                        " 快速跳转

" === UI 和主题 ===
Plug 'folke/tokyonight.nvim'                   " Tokyo Night 主题
Plug 'catppuccin/nvim', { 'as': 'catppuccin' } " Catppuccin 主题
Plug 'nvim-lualine/lualine.nvim'               " 状态栏
Plug 'akinsho/bufferline.nvim'                 " 缓冲区标签页
Plug 'folke/which-key.nvim'                    " 快捷键提示

" === 代码诊断和格式化 ===
Plug 'jose-elias-alvarez/null-ls.nvim'         " 格式化和 linting
Plug 'folke/trouble.nvim'                      " 诊断面板
Plug 'j-hui/fidget.nvim'                       " LSP 进度显示

" === 终端和任务 ===
Plug 'akinsho/toggleterm.nvim'                 " 终端管理
Plug 'stevearc/overseer.nvim'                  " 任务管理器

" === 特殊功能 ===
Plug 'github/copilot.vim'                      " GitHub Copilot (可选)

call plug#end()

" ===== 基础键位映射 =====
let g:mapleader = ' '
let g:maplocalleader = ','

" 基础编辑
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" 窗口导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 缓冲区导航
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" 清除高亮
nnoremap <ESC> :noh<CR>

" ===== Lua 配置加载 =====
" 主要的现代插件配置都写在 Lua 中
lua << EOF

-- =====================================================
-- Lua 配置部分 - 现代 Neovim 核心
-- =====================================================

-- ===== Mason (LSP 服务器管理) =====
-- 安全加载 mason 插件
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
    vim.notify("Mason plugin not found. Please install plugins first.", vim.log.levels.WARN)
else
    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
    mason_lspconfig.setup({
        ensure_installed = {
            "clangd",        -- C/C++
            "pyright",       -- Python
        },
        automatic_installation = true,
    })
end

-- ===== LSP 配置 =====
-- 安全加载 cmp_nvim_lsp
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
end

-- LSP 快捷键设置
local on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    -- 代码导航
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    -- 代码操作
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    -- 诊断
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
end

-- 配置 LSP 服务器 (使用新的 vim.lsp.config API)
-- C/C++ 语言服务器
vim.lsp.config.clangd = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    on_attach = on_attach,
    capabilities = capabilities,
}

-- Python 语言服务器
vim.lsp.config.pyright = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    on_attach = on_attach,
    capabilities = capabilities,
}

-- ===== 补全配置 (nvim-cmp) =====
local cmp_ok, cmp = pcall(require, 'cmp')
local luasnip_ok, luasnip = pcall(require, 'luasnip')

if cmp_ok and luasnip_ok then
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
        }, {
            { name = 'buffer' },
        })
    })

    -- 命令行补全
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })
else
    vim.notify("nvim-cmp or luasnip not found. Completion features disabled.", vim.log.levels.WARN)
end

-- ===== Treesitter 配置 =====
local treesitter_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if treesitter_ok then
    treesitter_configs.setup {
        ensure_installed = {
            "c", "cpp", "python", "vim", "vimdoc", "lua", "json"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
    }
else
    vim.notify("nvim-treesitter not found. Syntax highlighting may be limited.", vim.log.levels.WARN)
end

-- ===== Telescope 配置 =====
local telescope_ok, telescope = pcall(require, 'telescope')
local telescope_builtin_ok, telescope_builtin = pcall(require, 'telescope.builtin')

if telescope_ok then
    telescope.setup({
        defaults = {
            prompt_prefix = "🔍 ",
            selection_caret = "➤ ",
            path_display = { "truncate" },
            file_ignore_patterns = {
                "node_modules", ".git/", "*.pyc", "__pycache__",
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            }
        }
    })

    -- 尝试加载 fzf 扩展
    pcall(telescope.load_extension, 'fzf')

    -- Telescope 快捷键
    if telescope_builtin_ok then
        vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fr', telescope_builtin.lsp_references, {})
        vim.keymap.set('n', '<leader>fs', telescope_builtin.lsp_document_symbols, {})
    end
else
    vim.notify("Telescope not found. Search features disabled.", vim.log.levels.WARN)
end

-- ===== 文件树配置 =====
local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if nvim_tree_ok then
    nvim_tree.setup({
        disable_netrw = true,
        hijack_netrw = true,
        update_focused_file = {
            enable = true,
        },
        filters = {
            dotfiles = false,
        },
        git = {
            enable = true,
            ignore = false,
        },
        renderer = {
            icons = {
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                },
            },
        },
    })

    vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
else
    vim.notify("nvim-tree not found. File explorer disabled.", vim.log.levels.WARN)
end

-- ===== 其他插件安全加载 =====
-- Git Signs
pcall(function()
    require('gitsigns').setup {
        signs = {
            add          = { text = '│' },
            change       = { text = '│' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
    }
end)

-- 状态栏配置
pcall(function()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
    }
end)

-- 缓冲区标签页
pcall(function()
    require("bufferline").setup{
        options = {
            numbers = "none",
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            show_buffer_close_icons = false,
            show_close_icon = false,
        }
    }
end)

-- 自动配对
pcall(function()
    require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {
            lua = {'string'},
            javascript = {'template_string'},
        }
    })
end)

-- 注释插件
pcall(function() require('Comment').setup() end)

-- 快捷键提示
pcall(function()
    require("which-key").setup {
        popup_mappings = {
            scroll_down = '<c-d>',
            scroll_up = '<c-u>',
        },
    }
end)

-- 终端管理
pcall(function()
    require("toggleterm").setup{
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = 'curved',
        }
    }
end)

-- 诊断面板
local trouble_ok = pcall(function()
    require("trouble").setup {
        icons = false,
        fold_open = "v",
        fold_closed = ">",
        indent_lines = false,
        signs = {
            error = "error",
            warning = "warn",
            information = "info",
            hint = "hint"
        },
        use_diagnostic_signs = false
    }
end)

if trouble_ok then
    vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
    vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
end

-- Flash (快速跳转)
local flash_ok = pcall(function() require("flash").setup() end)
if flash_ok then
    vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
end

EOF

" ===== 主题设置 =====
try
    colorscheme tokyonight-night
catch
    colorscheme default
endtry

" ===== 其他设置 =====
" 自动命令
augroup MyAutoCommands
    autocmd!
    " 自动切换到文件所在目录
    autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

    " 保存时自动格式化（仅对支持的语言）
    autocmd BufWritePre *.py,*.js,*.ts,*.go,*.rs,*.cpp,*.c,*.h lua vim.lsp.buf.format({ async = false })

    " 高亮当前行（插入模式时取消）
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
augroup END

" Copilot 配置
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" ===== 快速开发快捷键总结 =====
" Space + w    = 保存文件
" Space + ff   = 搜索文件
" Space + fg   = 全局搜索
" Space + fb   = 搜索缓冲区
" Space + ca   = 代码操作
" Space + rn   = 重命名
" Space + f    = 格式化代码
" gd           = 跳转到定义
" gr           = 查找引用
" K            = 显示文档
" Ctrl + n     = 文件树
" Ctrl + \     = 终端
" s + 字符     = 快速跳转
" gcc          = 注释行
" Ctrl + j     = Copilot 确认建议