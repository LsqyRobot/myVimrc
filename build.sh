#!/bin/bash

# Vim Configuration Auto Setup Script
# 作者: Lucas的Vim配置一键安装脚本
# 用途: 自动安装所有依赖和插件，配置vim环境

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 安装 tree-sitter-cli
install_tree_sitter_cli() {
    if command_exists tree-sitter; then
        print_info "tree-sitter-cli 已安装，跳过"
        return 0
    fi

    print_info "安装 tree-sitter-cli..."

    # 方法1: 尝试使用 npm (如果 Node.js 已安装)
    if command_exists npm; then
        print_info "通过 npm 安装 tree-sitter-cli..."
        if npm install -g tree-sitter-cli 2>/dev/null; then
            print_success "通过 npm 安装 tree-sitter-cli 成功"
            return 0
        else
            print_warning "npm 安装失败，尝试其他方法..."
        fi
    fi

    # 方法2: 尝试使用 cargo (如果 Rust 已安装)
    if command_exists cargo; then
        print_info "通过 cargo 安装 tree-sitter-cli..."
        if cargo install tree-sitter-cli 2>/dev/null; then
            print_success "通过 cargo 安装 tree-sitter-cli 成功"
            return 0
        else
            print_warning "cargo 安装失败，尝试其他方法..."
        fi
    fi

    # 方法3: 下载预编译二进制文件
    print_info "下载 tree-sitter-cli 预编译二进制文件..."
    local arch=$(uname -m)
    local os="linux"

    # 确定架构
    case $arch in
        x86_64) arch="x64";;
        aarch64|arm64) arch="arm64";;
        *)
            print_warning "不支持的架构: $arch，跳过 tree-sitter-cli 安装"
            print_info "你可以稍后手动安装: npm install -g tree-sitter-cli"
            return 1
            ;;
    esac

    local download_url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-${os}-${arch}.gz"
    local temp_dir=$(mktemp -d)

    # 保存当前目录
    local current_dir=$(pwd)
    cd "$temp_dir"

    print_info "正在从 GitHub 下载 tree-sitter..."
    if (wget -q "$download_url" 2>/dev/null || curl -sL "$download_url" -o "tree-sitter-${os}-${arch}.gz" 2>/dev/null); then
        if [[ -f "tree-sitter-${os}-${arch}.gz" ]] && [[ $(stat -c%s "tree-sitter-${os}-${arch}.gz" 2>/dev/null || echo 0) -gt 1000 ]]; then
            if gunzip "tree-sitter-${os}-${arch}.gz" 2>/dev/null; then
                if [[ -f "tree-sitter-${os}-${arch}" ]]; then
                    chmod +x "tree-sitter-${os}-${arch}"
                    if sudo mv "tree-sitter-${os}-${arch}" /usr/local/bin/tree-sitter 2>/dev/null; then
                        print_success "tree-sitter-cli 预编译二进制安装成功"
                        cd "$current_dir"
                        rm -rf "$temp_dir"
                        return 0
                    else
                        print_warning "移动二进制文件到 /usr/local/bin 失败"
                    fi
                else
                    print_warning "解压后文件不存在"
                fi
            else
                print_warning "解压 gz 文件失败"
            fi
        else
            print_warning "下载的文件损坏或为空"
        fi
    else
        print_warning "下载失败，可能是网络问题"
    fi

    cd "$current_dir"
    rm -rf "$temp_dir"
    print_warning "所有安装方法都失败，tree-sitter-cli 将不可用"
    print_info "请稍后手动安装，可选方法："
    print_info "  - npm install -g tree-sitter-cli (需要 Node.js)"
    print_info "  - cargo install tree-sitter-cli (需要 Rust)"
    print_info "或者跳过此工具，Neovim 仍可正常使用"
    return 1
}

# 检测Linux发行版
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo $ID
    elif command_exists lsb_release; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    else
        echo "unknown"
    fi
}

# 选择编辑器类型
choose_editor_type() {
    echo
    print_info "选择编辑器配置类型:"
    echo "1) 传统 Vim (稳定，兼容性好)"
    echo "2) 极致现代型 Neovim (功能强大，需要 Neovim 0.8+)"
    echo
    read -p "请选择 [1-2]: " editor_choice

    case $editor_choice in
        1)
            EDITOR_TYPE="vim"
            print_success "已选择传统 Vim 配置"
            ;;
        2)
            EDITOR_TYPE="neovim"
            print_success "已选择极致现代型 Neovim 配置"
            ;;
        *)
            print_warning "无效选择，默认使用传统 Vim"
            EDITOR_TYPE="vim"
            ;;
    esac
}

# 安装系统依赖
install_system_deps() {
    print_info "开始安装系统依赖..."

    local distro=$(detect_distro)
    print_info "检测到系统: $distro"

    case $distro in
        ubuntu|debian|linuxmint)
            print_info "使用 apt 包管理器安装依赖..."
            sudo apt update

            # 基础工具
            sudo apt install -y git python3 python3-pip curl wget unzip

            # 编辑器相关
            if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                print_info "安装 Neovim 和现代工具链..."
                # 安装最新版 Neovim
                sudo apt install -y neovim
                # 如果系统版本过旧，尝试安装最新版本
                if ! nvim --version | grep -E "v0\.[8-9]|v[1-9]" > /dev/null 2>&1; then
                    print_warning "系统 Neovim 版本过旧，尝试安装最新版本..."

                    # 方法1: 尝试使用 snap (推荐)
                    if command_exists snap; then
                        print_info "尝试使用 snap 安装最新版 Neovim..."
                        if sudo snap install nvim --classic 2>/dev/null; then
                            print_success "通过 snap 安装最新版 Neovim 成功"
                            # 创建软链接
                            sudo ln -sf /snap/bin/nvim /usr/local/bin/nvim 2>/dev/null || true
                        else
                            print_warning "snap 安装失败，尝试其他方法..."
                            try_appimage_install=true
                        fi
                    else
                        try_appimage_install=true
                    fi

                    # 方法2: AppImage 下载
                    if [[ "$try_appimage_install" == "true" ]]; then
                        print_info "尝试下载 Neovim AppImage..."
                        APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

                        if wget -O nvim.appimage "$APPIMAGE_URL" 2>/dev/null || curl -L -o nvim.appimage "$APPIMAGE_URL" 2>/dev/null; then
                            # 验证下载文件
                            if [[ -f nvim.appimage ]] && [[ $(stat -c%s nvim.appimage) -gt 10000000 ]]; then
                                chmod +x nvim.appimage
                                sudo mv nvim.appimage /usr/local/bin/nvim
                                print_success "Neovim AppImage 安装成功"
                            else
                                print_warning "AppImage 下载失败，使用系统版本"
                                rm -f nvim.appimage
                            fi
                        else
                            print_warning "无法下载最新版本，使用系统版本"
                            print_info "可以手动运行: sudo snap install nvim --classic"
                        fi
                    fi
                fi

                # 现代工具
                sudo apt install -y ripgrep fd-find
                # 创建软链接 (Ubuntu/Debian 特殊处理)
                sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true

                # 单独安装 tree-sitter-cli
                install_tree_sitter_cli
            else
                sudo apt install -y vim universal-ctags silversearcher-ag
            fi

            # 代码格式化工具
            print_info "安装代码格式化工具..."
            sudo apt install -y clang-format python3-yapf golang gofmt || print_warning "某些格式化工具安装失败"

            # 安装 Node.js (Copilot和某些插件需要)
            if ! command_exists node; then
                print_warning "Node.js 未安装，Copilot和某些插件可能无法使用"
                read -p "是否安装 Node.js? (Y/n): " install_node
                if [[ ! $install_node =~ ^[Nn]$ ]]; then
                    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                    sudo apt install -y nodejs

                    # 如果是 neovim 并且 tree-sitter 还没安装，现在重新尝试
                    if [[ "$EDITOR_TYPE" == "neovim" ]] && ! command_exists tree-sitter; then
                        print_info "Node.js 安装完成，重新尝试安装 tree-sitter-cli..."
                        install_tree_sitter_cli
                    fi
                fi
            fi

            # 创建 ctags 配置目录
            mkdir -p ~/.cache/vim/ctags
            ;;
        fedora|rhel|centos)
            print_info "使用 dnf/yum 包管理器安装依赖..."

            # 基础工具
            if command_exists dnf; then
                sudo dnf install -y git python3 python3-pip curl wget unzip

                if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                    sudo dnf install -y neovim ripgrep fd-find
                    # 单独安装 tree-sitter-cli
                    install_tree_sitter_cli
                else
                    sudo dnf install -y vim ctags the_silver_searcher
                fi

                sudo dnf install -y clang-tools-extra python3-yapf
            else
                sudo yum install -y git python3 python3-pip curl wget unzip

                if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                    sudo yum install -y neovim
                    # 单独安装 tree-sitter-cli
                    install_tree_sitter_cli
                else
                    sudo yum install -y vim ctags the_silver_searcher
                fi

                sudo yum install -y clang
            fi

            # Node.js 安装
            if ! command_exists node; then
                print_warning "Node.js 未安装，是否安装? (Copilot需要)"
                read -p "(Y/n): " install_node
                if [[ ! $install_node =~ ^[Nn]$ ]]; then
                    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
                    sudo dnf install -y nodejs || sudo yum install -y nodejs

                    # 如果是 neovim 并且 tree-sitter 还没安装，现在重新尝试
                    if [[ "$EDITOR_TYPE" == "neovim" ]] && ! command_exists tree-sitter; then
                        print_info "Node.js 安装完成，重新尝试安装 tree-sitter-cli..."
                        install_tree_sitter_cli
                    fi
                fi
            fi

            # 创建配置目录
            if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                mkdir -p ~/.config/nvim
                mkdir -p ~/.local/share/nvim
            else
                mkdir -p ~/.cache/vim/ctags
            fi
            ;;
        arch|manjaro)
            print_info "使用 pacman 包管理器安装依赖..."

            # 基础工具
            sudo pacman -Sy --needed git python python-pip curl wget unzip

            if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                sudo pacman -S --needed neovim ripgrep fd
                # 尝试安装 tree-sitter-cli
                if ! sudo pacman -S --needed tree-sitter-cli 2>/dev/null; then
                    print_warning "pacman 安装 tree-sitter-cli 失败，使用通用方法"
                    install_tree_sitter_cli
                fi
            else
                sudo pacman -S --needed vim ctags the_silver_searcher
            fi

            sudo pacman -S --needed clang python-yapf

            # Node.js 安装
            if ! command_exists node; then
                print_warning "Node.js 未安装，是否安装? (Copilot需要)"
                read -p "(Y/n): " install_node
                if [[ ! $install_node =~ ^[Nn]$ ]]; then
                    sudo pacman -S --needed nodejs npm

                    # 如果是 neovim 并且 tree-sitter 还没安装，现在重新尝试
                    if [[ "$EDITOR_TYPE" == "neovim" ]] && ! command_exists tree-sitter; then
                        print_info "Node.js 安装完成，重新尝试安装 tree-sitter-cli..."
                        install_tree_sitter_cli
                    fi
                fi
            fi

            # 创建配置目录
            if [[ "$EDITOR_TYPE" == "neovim" ]]; then
                mkdir -p ~/.config/nvim
                mkdir -p ~/.local/share/nvim
            else
                mkdir -p ~/.cache/vim/ctags
            fi
            ;;
        *)
            print_warning "未识别的Linux发行版: $distro"
            print_info "请手动安装以下依赖: vim git python3 python3-pip ctags ag clang-format"
            read -p "按Enter继续，或者Ctrl+C退出..."
            ;;
    esac
}

# 安装 vim-plug 插件管理器
install_vim_plug() {
    print_info "安装 vim-plug 插件管理器..."

    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        # Neovim 安装路径
        local plug_dir="$HOME/.local/share/nvim/site/autoload"
        local plug_file="$plug_dir/plug.vim"
        local config_plug_dir="$HOME/.config/nvim/autoload"
        local config_plug_file="$config_plug_dir/plug.vim"

        # 检查是否已安装（检查两个可能的位置）
        if [[ -f "$plug_file" ]] || [[ -f "$config_plug_file" ]]; then
            print_warning "vim-plug 已安装，跳过"
            return
        fi

        # 安装到标准位置
        print_info "为 Neovim 安装 vim-plug..."
        mkdir -p "$plug_dir"
        if curl -fLo "$plug_file" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            print_success "vim-plug 安装完成 (Neovim)"
        else
            print_error "vim-plug 下载失败"
            return 1
        fi

        # 同时在配置目录创建软链接以确保兼容性
        mkdir -p "$config_plug_dir"
        ln -sf "$plug_file" "$config_plug_file" 2>/dev/null || true
    else
        # 传统 Vim 安装路径
        local plug_dir="$HOME/.vim/autoload"
        local plug_file="$plug_dir/plug.vim"

        if [[ -f "$plug_file" ]]; then
            print_warning "vim-plug 已安装，跳过"
            return
        fi

        print_info "为传统 Vim 安装 vim-plug..."
        mkdir -p "$plug_dir"
        if curl -fLo "$plug_file" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
            print_success "vim-plug 安装完成 (Vim)"
        else
            print_error "vim-plug 下载失败"
            return 1
        fi
    fi
}

# 备份现有配置
backup_existing_config() {
    print_info "备份现有vim配置..."

    local backup_dir="$HOME/.vim_backup_$(date +%Y%m%d_%H%M%S)"

    if [[ -f "$HOME/.vimrc" ]] || [[ -d "$HOME/.vim" ]]; then
        mkdir -p "$backup_dir"

        [[ -f "$HOME/.vimrc" ]] && cp "$HOME/.vimrc" "$backup_dir/"
        [[ -d "$HOME/.vim" ]] && cp -r "$HOME/.vim" "$backup_dir/"

        print_success "配置已备份到: $backup_dir"
    else
        print_info "未发现现有配置，无需备份"
    fi
}

# 设置自动 ctags 配置
setup_auto_ctags_config() {
    print_info "配置自动 ctags 生成功能..."

    local config_file="$HOME/.config/nvim/init.vim"

    # 检查是否已经有 gutentags 配置
    if grep -q "vim-gutentags" "$config_file"; then
        print_warning "gutentags 插件已配置，跳过"
        return
    fi

    # 添加 gutentags 插件
    if ! grep -q "Plug 'ludovicchabant/vim-gutentags'" "$config_file"; then
        # 在插件部分的末尾添加 gutentags
        sed -i "/call plug#end()/i\\
\\
\" 自动 ctags 管理\\
Plug 'ludovicchabant/vim-gutentags'" "$config_file"
    fi

    # 添加 gutentags 配置
    cat >> "$config_file" << 'EOF'

" ===== Gutentags 自动 ctags 配置 =====
" 启用 gutentags
let g:gutentags_enabled = 1

" 项目根目录标识文件
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" tags 文件名
let g:gutentags_ctags_tagfile = '.tags'

" 同时开启 ctags 支持
let g:gutentags_modules = ['ctags']

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁用 gutentags 自动生成 gtags 数据库的功能
let g:gutentags_auto_add_gtags_cscope = 0

" 在状态栏中显示 tags 生成状态
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_new = 1

" 缓存目录，避免污染项目目录
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 跳转快捷键
nnoremap <C-]> g<C-]>
nnoremap g<C-]> <C-]>
nnoremap <C-t> :pop<CR>
EOF

    print_success "自动 ctags 配置已添加"
}

# 修复编码和乱码问题
fix_encoding_issues() {
    print_info "修复编码和乱码问题..."

    local config_file="$HOME/.config/nvim/init.vim"

    # 在配置文件开头添加编码设置
    if ! grep -q "set encoding=utf-8" "$config_file"; then
        # 在文件开头添加编码配置
        local temp_file=$(mktemp)
        cat > "$temp_file" << 'EOF'
" ===== 编码设置 (修复乱码) =====
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,big5
set termencoding=utf-8
scriptencoding utf-8

EOF
        cat "$config_file" >> "$temp_file"
        mv "$temp_file" "$config_file"
        print_success "已添加编码配置"
    fi

    # 修复状态栏显示问题
    if grep -q "lualine.setup" "$config_file"; then
        # 替换可能导致乱码的特殊字符
        sed -i "s/component_separators = '|'/component_separators = { left = '|', right = '|' }/g" "$config_file"
        sed -i "s/section_separators = ''/section_separators = { left = '', right = '' }/g" "$config_file"
        print_success "已修复状态栏显示问题"
    fi
}

# 复制配置文件
setup_config_files() {
    print_info "设置编辑器配置文件..."

    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        # 设置 Neovim 配置
        mkdir -p ~/.config/nvim
        cp "$script_dir/init.vim" "$HOME/.config/nvim/init.vim"
        print_success "Neovim 配置已复制到 ~/.config/nvim/init.vim"

        # 创建 undo 目录
        mkdir -p ~/.config/nvim/undo
        print_info "已创建 undo 目录"

        # 创建 tags 缓存目录
        mkdir -p ~/.cache/tags
        print_info "已创建 tags 缓存目录"

        # 修复编码和乱码问题
        fix_encoding_issues

        # 自动添加 gutentags 插件配置到 init.vim
        setup_auto_ctags_config

        # 为了兼容，也创建 vim 的软链接
        ln -sf "$HOME/.config/nvim/init.vim" "$HOME/.vimrc" 2>/dev/null || true
        print_info "已创建 ~/.vimrc 软链接以兼容传统 vim"
    else
        # 设置传统 Vim 配置
        cp "$script_dir/.vimrc" "$HOME/.vimrc"
        print_success "Vim 配置已复制到 ~/.vimrc"
    fi

    # 复制 .clang-format
    if [[ -f "$script_dir/.clang-format" ]]; then
        cp "$script_dir/.clang-format" "$HOME/.clang-format"
        print_success ".clang-format 已复制到 $HOME/.clang-format"
    fi
}

# 个人信息配置
configure_personal_info() {
    print_info "配置个人信息..."

    local vimrc="$HOME/.vimrc"

    # 检查是否启用 vim-header 插件
    if grep -q "^\s*\".*vim-header" "$vimrc"; then
        print_warning "vim-header 插件被注释，个人信息配置将不生效"
        read -p "是否启用 vim-header 插件? (y/N): " enable_header
        if [[ $enable_header =~ ^[Yy]$ ]]; then
            sed -i 's/^\s*"\s*Plug.*vim-header/Plug/' "$vimrc"
            print_success "已启用 vim-header 插件"
        fi
    fi

    # 获取用户信息
    echo
    print_info "请输入个人信息 (直接回车保持默认值):"

    read -p "作者姓名 [zhangxiaolong]: " author_name
    author_name=${author_name:-zhangxiaolong}

    read -p "邮箱 [lsqyRobot@gmail.com]: " author_email
    author_email=${author_email:-lsqyRobot@gmail.com}

    read -p "版权信息 [@copyright Copyright (c) LsqyRobot]: " copyright
    copyright=${copyright:-@copyright Copyright (c) LsqyRobot}

    # 更新配置文件
    sed -i "s/let g:header_field_author = .*/let g:header_field_author = '$author_name'/" "$vimrc"
    sed -i "s/let g:header_field_author_email = .*/let g:header_field_author_email = '$author_email'/" "$vimrc"
    sed -i "s/let g:header_field_copyright = .*/let g:header_field_copyright = '$copyright'/" "$vimrc"

    print_success "个人信息配置完成"
}

# 创建临时插件配置
create_temp_plugin_config() {
    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        local temp_config="$HOME/.config/nvim/temp_init.vim"
        print_info "创建临时插件配置..."

        # 只包含插件定义部分，不包含插件配置
        cat > "$temp_config" << 'EOF'
" 临时配置 - 仅用于插件安装
call plug#begin('~/.config/nvim/plugged')

" === 核心插件 ===
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" === 补全引擎 ===
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" === 代码片段 ===
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" === 语法高亮 ===
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" === 模糊搜索 ===
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}

" === 文件管理 ===
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" === Git 集成 ===
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" === 编辑增强 ===
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'folke/flash.nvim'

" === UI 和主题 ===
Plug 'folke/tokyonight.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'folke/which-key.nvim'

" === 代码诊断 ===
Plug 'folke/trouble.nvim'

" === 终端 ===
Plug 'akinsho/toggleterm.nvim'

" === 特殊功能 ===
Plug 'github/copilot.vim'

call plug#end()
EOF
    fi
}

# 安装编辑器插件
install_editor_plugins() {
    print_info "安装编辑器插件... (这可能需要几分钟)"

    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        # 创建临时配置用于插件安装
        create_temp_plugin_config

        # 使用临时配置安装插件
        print_info "正在安装 Neovim 插件..."
        nvim -u "$HOME/.config/nvim/temp_init.vim" --headless +PlugInstall +qall

        # 移除临时配置
        rm -f "$HOME/.config/nvim/temp_init.vim"

        # 现在使用完整配置安装其他组件
        print_info "安装 Treesitter 解析器..."
        nvim --headless +"TSInstall c cpp python vim lua json" +qall 2>/dev/null || print_warning "部分 Treesitter 解析器安装失败"

        # 安装 LSP 服务器 (仅 C/C++ 和 Python)
        print_info "安装 LSP 服务器..."
        nvim --headless +"MasonInstall clangd pyright" +qall 2>/dev/null || print_warning "部分 LSP 服务器安装失败"

        print_success "Neovim 插件安装完成"
    else
        # 安装传统 Vim 插件
        vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall
        print_success "Vim 插件安装完成"
    fi
}

# Copilot 配置提示
setup_copilot() {
    if grep -q "copilot.vim" "$HOME/.vimrc"; then
        print_info "检测到 GitHub Copilot 插件"
        print_warning "请在vim中运行 :Copilot setup 来配置Copilot"
        print_info "需要GitHub账号和Copilot订阅"
    fi
}

# 创建ctags配置文件
create_ctags_config() {
    print_info "创建ctags配置文件..."

    local ctags_config="$HOME/.ctags"

    cat > "$ctags_config" << 'EOF'
--recurse=yes
--exclude=.git
--exclude=BUILD
--exclude=.svn
--exclude=*.pyc
--exclude=*.pyo
--exclude=*.pyd
--exclude=*.so
--exclude=*.dll
--exclude=*.exe
--exclude=node_modules
--exclude=*.log
--exclude=*.tmp
--exclude=*.swp
--exclude=.tags

# C/C++ 优化
--langdef=C++
--langmap=C++:+.inl
--c++-kinds=+p
--fields=+iaS
--extra=+q

# Python 优化
--python-kinds=-i
--langmap=python:+.pyx

# Go 支持
--langdef=Go
--langmap=go:.go
--regex-go=/func([ \t]+\([^)]+\))?[ \t]+([a-zA-Z0-9_]+)/\2/d,func/
--regex-go=/var[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/d,var/
--regex-go=/type[ \t]+([a-zA-Z_][a-zA-Z0-9_]+)/\1/d,type/
EOF

    print_success "ctags配置文件已创建: $ctags_config"
}

# 生成ctags
generate_ctags() {
    print_info "为当前项目生成ctags..."

    if command_exists ctags; then
        cd "$(dirname "${BASH_SOURCE[0]}")"
        ctags -R . 2>/dev/null || print_warning "ctags生成失败，可能是空目录"
        print_success "ctags生成完成"
    else
        print_warning "ctags未安装，跳过标签生成"
    fi
}

# 验证安装
verify_installation() {
    print_info "验证安装结果..."

    local errors=0

    # 检查必要命令
    for cmd in vim git python3; do
        if ! command_exists "$cmd"; then
            print_error "$cmd 未正确安装"
            ((errors++))
        fi
    done

    # 检查vim配置
    if [[ ! -f "$HOME/.vimrc" ]]; then
        print_error ".vimrc 文件不存在"
        ((errors++))
    fi

    # 检查vim-plug
    if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
        print_error "vim-plug 未正确安装"
        ((errors++))
    fi

    if [[ $errors -eq 0 ]]; then
        print_success "所有组件验证通过！"
        return 0
    else
        print_error "发现 $errors 个问题，请检查上述错误"
        return 1
    fi
}

# 显示使用说明
show_usage_tips() {
    echo
    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        print_success "=== 极致现代型 Neovim 配置安装完成！ ==="
    else
        print_success "=== 传统 Vim 配置安装完成！ ==="
    fi
    echo

    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        print_info "🚀 现代化 Neovim 快捷键 (Leader键是空格):"
        echo "  === 基础操作 ==="
        echo "  - Space + w: 保存文件"
        echo "  - Space + q: 退出"
        echo "  - Ctrl + n: 文件树"
        echo "  - Ctrl + \\: 浮动终端"
        echo
        echo "  === 代码导航与搜索 ==="
        echo "  - Space + ff: 模糊搜索文件"
        echo "  - Space + fg: 全局文本搜索"
        echo "  - Space + fb: 搜索缓冲区"
        echo "  - Space + fh: 搜索帮助"
        echo "  - Space + fr: 搜索引用"
        echo "  - Space + fs: 搜索符号"
        echo
        echo "  === LSP 功能 (超越传统 ctags) ==="
        echo "  - gd: 跳转到定义"
        echo "  - gD: 跳转到声明"
        echo "  - gi: 跳转到实现"
        echo "  - gr: 查找所有引用"
        echo "  - K: 显示悬浮文档"
        echo "  - Space + rn: 智能重命名"
        echo "  - Space + ca: 代码操作"
        echo "  - Space + f: 智能格式化"
        echo
        echo "  === 诊断与调试 ==="
        echo "  - ]d / [d: 下/上一个诊断"
        echo "  - Space + e: 显示诊断详情"
        echo "  - Space + xx: 诊断面板"
        echo
        echo "  === 编辑增强 ==="
        echo "  - gcc: 注释/取消注释行"
        echo "  - gc (可视模式): 注释选中内容"
        echo "  - s + 字符: Flash 快速跳转"
        echo "  - Tab: 补全选择/片段跳转"
        echo "  - Ctrl + j: Copilot 确认建议"
        echo
        print_info "📁 配置文件位置:"
        echo "  - 主配置: ~/.config/nvim/init.vim"
        echo "  - LSP 数据: ~/.local/share/nvim/"
        echo "  - 插件目录: ~/.config/nvim/plugged/"
        echo "  - Undo 历史: ~/.config/nvim/undo/"
        echo
        print_info "🔧 管理命令:"
        echo "  - nvim +PlugInstall +qall: 安装插件"
        echo "  - nvim +PlugUpdate +qall: 更新插件"
        echo "  - nvim +Mason: 管理 LSP 服务器"
        echo "  - nvim +Copilot setup: 配置 Copilot"
    else
        print_info "基础操作:"
        echo "  1. 打开vim: vim"
        echo "  2. 文件树: Ctrl+n"
        echo "  3. 快速注释: gcc (单行) 或 gc (选中多行)"
        echo "  4. Git状态: :Gstatus"
        echo "  5. 搜索文件内容: :Ag 关键字"
        echo
        print_info "代码导航 (Leader键是逗号 ,):"
        echo "  - ,ct: 更新ctags"
        echo "  - ,v: 打开/关闭Vista标签浏览器"
        echo "  - ,vf: 搜索函数/变量"
        echo "  - ,ff: 模糊搜索文件"
        echo "  - ,fb: 搜索缓冲区"
        echo "  - ,ft: 搜索函数"
        echo "  - ,fl: 搜索当前文件的行"
        echo "  - ,f: 格式化代码 (Python/JS/Go)"
        echo "  - ,tm: 切换Markdown表格模式"
        echo
        print_info "ctags 导航:"
        echo "  - Ctrl+]: 跳转到定义"
        echo "  - ,ts: 显示所有匹配的标签"
        echo "  - ,tp: 上一个标签"
        echo "  - ,tn: 下一个标签"
        echo
        print_info "配置文件位置:"
        echo "  - 主配置: ~/.vimrc"
        echo "  - ctags配置: ~/.ctags"
        echo "  - C++格式化: ~/.clang-format"
        echo "  - 插件目录: ~/.vim/plugged/"
        echo "  - 标签缓存: ~/.cache/vim/ctags/"
        echo
        print_info "可选配置:"
        echo "  - 启用作者信息: 取消.vimrc中vim-header插件的注释"
        echo
        print_info "如果遇到问题:"
        echo "  - 重新安装插件: vim +PlugInstall +qall"
        echo "  - 更新插件: vim +PlugUpdate +qall"
        echo "  - 查看插件状态: vim +PlugStatus"
        echo "  - 清理无用插件: vim +PlugClean +qall"
    fi

    echo
    if [[ "$EDITOR_TYPE" == "neovim" ]]; then
        print_warning "🔥 首次启动建议:"
        echo "  1. 运行 nvim，等待插件自动安装完成"
        echo "  2. 运行 :Mason 检查 LSP 服务器状态"
        echo "  3. 运行 :Copilot setup 配置 GitHub Copilot"
        echo "  4. 尝试打开一个 C++/Python 文件体验智能补全"
    else
        if grep -q "copilot.vim" "$HOME/.vimrc"; then
            print_warning "Copilot设置: 在vim中运行 :Copilot setup"
        fi
    fi
}

# 升级 Neovim 到最新版本
upgrade_neovim() {
    print_success "=== Neovim 升级工具 ==="
    print_info "当前 Neovim 版本:"
    nvim --version | head -1

    echo
    print_info "选择升级方法:"
    echo "1) 使用 Snap (推荐，最新稳定版)"
    echo "2) 下载 AppImage (便携，最新版)"
    echo "3) 使用官方 PPA (Ubuntu 专用)"
    echo "4) 取消升级"
    echo

    read -p "请选择 [1-4]: " upgrade_choice

    case $upgrade_choice in
        1)
            print_info "使用 Snap 升级 Neovim..."
            if command_exists snap; then
                sudo snap install nvim --classic
                sudo ln -sf /snap/bin/nvim /usr/local/bin/nvim
                print_success "Snap 安装完成"
            else
                print_error "系统不支持 Snap"
                exit 1
            fi
            ;;
        2)
            print_info "下载 Neovim AppImage..."
            APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"

            if wget -O nvim.appimage "$APPIMAGE_URL" || curl -L -o nvim.appimage "$APPIMAGE_URL"; then
                chmod +x nvim.appimage
                sudo mv nvim.appimage /usr/local/bin/nvim
                print_success "AppImage 安装完成"
            else
                print_error "下载失败"
                exit 1
            fi
            ;;
        3)
            print_info "使用官方 PPA 升级..."
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt update
            sudo apt install neovim -y
            print_success "PPA 安装完成"
            ;;
        4)
            print_info "取消升级"
            exit 0
            ;;
        *)
            print_warning "无效选择"
            exit 1
            ;;
    esac

    echo
    print_success "升级完成！新版本："
    nvim --version | head -1
    echo
    print_info "现在你可以使用极致现代型配置了！"
    print_info "运行: ./build.sh 选择选项 2"
}

# 主安装流程
main() {
    echo
    print_success "=== Lucas的Vim配置一键安装脚本 ==="
    print_info "这个脚本将安装所有必要的依赖和插件"
    echo

    # 检查是否是升级模式
    if [[ "$1" == "--upgrade-neovim" ]]; then
        upgrade_neovim
        exit 0
    fi

    # 询问用户确认
    read -p "是否继续安装? (Y/n): " confirm
    if [[ $confirm =~ ^[Nn]$ ]]; then
        print_info "安装已取消"
        exit 0
    fi

    # 检查是否为root用户
    if [[ $EUID -eq 0 ]]; then
        print_error "请不要以root用户运行此脚本"
        exit 1
    fi

    # 选择编辑器类型
    choose_editor_type

    # 执行安装步骤
    install_system_deps
    install_vim_plug
    backup_existing_config
    setup_config_files

    if [[ "$EDITOR_TYPE" == "vim" ]]; then
        create_ctags_config
        generate_ctags
    fi

    configure_personal_info
    install_editor_plugins
    setup_copilot

    # 验证和结束
    if verify_installation; then
        show_usage_tips
        print_success "安装完成！享受你的vim之旅吧！ 🎉"
    else
        print_error "安装过程中出现问题，请检查错误信息"
        exit 1
    fi
}

# 脚本入口点
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi