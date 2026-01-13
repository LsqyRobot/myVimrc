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

# 安装系统依赖
install_system_deps() {
    print_info "开始安装系统依赖..."

    local distro=$(detect_distro)
    print_info "检测到系统: $distro"

    case $distro in
        ubuntu|debian|linuxmint)
            print_info "使用 apt 包管理器安装依赖..."
            sudo apt update
            sudo apt install -y vim git python3 python3-pip exuberant-ctags silversearcher-ag clang-format curl

            # 可选安装 node.js (Copilot需要)
            if ! command_exists node; then
                print_warning "Node.js 未安装，Copilot插件可能无法使用"
                read -p "是否安装 Node.js? (y/N): " install_node
                if [[ $install_node =~ ^[Yy]$ ]]; then
                    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                    sudo apt install -y nodejs
                fi
            fi
            ;;
        fedora|rhel|centos)
            print_info "使用 dnf/yum 包管理器安装依赖..."
            if command_exists dnf; then
                sudo dnf install -y vim git python3 python3-pip ctags the_silver_searcher clang-tools-extra curl
            else
                sudo yum install -y vim git python3 python3-pip ctags the_silver_searcher clang curl
            fi

            # Node.js 安装
            if ! command_exists node; then
                print_warning "Node.js 未安装，是否安装? (Copilot需要)"
                read -p "(y/N): " install_node
                if [[ $install_node =~ ^[Yy]$ ]]; then
                    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
                    sudo dnf install -y nodejs || sudo yum install -y nodejs
                fi
            fi
            ;;
        arch|manjaro)
            print_info "使用 pacman 包管理器安装依赖..."
            sudo pacman -Sy --needed vim git python python-pip ctags the_silver_searcher clang curl

            # Node.js 安装
            if ! command_exists node; then
                print_warning "Node.js 未安装，是否安装? (Copilot需要)"
                read -p "(y/N): " install_node
                if [[ $install_node =~ ^[Yy]$ ]]; then
                    sudo pacman -S --needed nodejs npm
                fi
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

    local plug_dir="$HOME/.vim/autoload"
    local plug_file="$plug_dir/plug.vim"

    if [[ -f "$plug_file" ]]; then
        print_warning "vim-plug 已安装，跳过"
        return
    fi

    mkdir -p "$plug_dir"
    curl -fLo "$plug_file" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    print_success "vim-plug 安装完成"
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

# 复制配置文件
setup_config_files() {
    print_info "设置vim配置文件..."

    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # 复制 .vimrc
    cp "$script_dir/.vimrc" "$HOME/.vimrc"
    print_success ".vimrc 已复制到 $HOME/.vimrc"

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

# 安装vim插件
install_vim_plugins() {
    print_info "安装vim插件... (这可能需要几分钟)"

    # 使用vim命令安装插件
    vim -E -s -u "$HOME/.vimrc" +PlugInstall +qall

    print_success "vim插件安装完成"
}

# Copilot 配置提示
setup_copilot() {
    if grep -q "copilot.vim" "$HOME/.vimrc"; then
        print_info "检测到 GitHub Copilot 插件"
        print_warning "请在vim中运行 :Copilot setup 来配置Copilot"
        print_info "需要GitHub账号和Copilot订阅"
    fi
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
    print_success "=== Vim配置安装完成！ ==="
    echo
    print_info "快速开始:"
    echo "  1. 打开vim: vim"
    echo "  2. 文件树: Ctrl+n"
    echo "  3. 快速注释: gcc (单行) 或 gc (选中多行)"
    echo "  4. Git状态: :Gstatus"
    echo "  5. 搜索文件内容: :Ag 关键字"
    echo
    print_info "配置文件位置:"
    echo "  - 主配置: ~/.vimrc"
    echo "  - C++格式化: ~/.clang-format"
    echo "  - 插件目录: ~/.vim/plugged/"
    echo
    print_info "如果遇到问题:"
    echo "  - 重新安装插件: vim +PlugInstall +qall"
    echo "  - 更新插件: vim +PlugUpdate +qall"
    echo "  - 查看插件状态: vim +PlugStatus"
    echo
    if grep -q "copilot.vim" "$HOME/.vimrc"; then
        print_warning "Copilot设置: 在vim中运行 :Copilot setup"
    fi
}

# 主安装流程
main() {
    echo
    print_success "=== Lucas的Vim配置一键安装脚本 ==="
    print_info "这个脚本将安装所有必要的依赖和插件"
    echo

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

    # 执行安装步骤
    install_system_deps
    install_vim_plug
    backup_existing_config
    setup_config_files
    configure_personal_info
    install_vim_plugins
    generate_ctags
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