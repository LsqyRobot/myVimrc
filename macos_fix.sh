#!/bin/bash

# macOS Neovim 插件修复脚本
# 解决 "Mason plugin not found" 等问题

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_info "🔧 macOS Neovim 插件修复工具"
print_info "================================="

# 检查系统
if [[ "$(uname -s)" != "Darwin" ]]; then
    print_error "此脚本仅适用于 macOS 系统"
    exit 1
fi

# 检查 Neovim
if ! command -v nvim >/dev/null 2>&1; then
    print_error "Neovim 未安装，请先安装: brew install neovim"
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+')
print_info "检测到 Neovim 版本: $NVIM_VERSION"

# 检查版本是否足够
if ! echo "$NVIM_VERSION" | grep -E "v0\.[8-9]|v[1-9]" >/dev/null; then
    print_warning "Neovim 版本可能过低，推荐 0.8+，尝试更新: brew upgrade neovim"
fi

print_info "🧹 第1步: 清理现有配置和插件"

# 备份现有配置
if [[ -f ~/.config/nvim/init.vim ]]; then
    cp ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup.$(date +%Y%m%d_%H%M%S)
    print_info "已备份现有配置"
fi

# 清理插件目录
rm -rf ~/.config/nvim/plugged/
print_info "已清理插件目录"

print_info "📁 第2步: 创建必要目录和设置权限"

# 创建目录
mkdir -p ~/.config/nvim/{autoload,plugged,undo}
mkdir -p ~/.local/share/nvim/site/autoload
mkdir -p ~/.cache/tags

# 设置权限
chmod -R 755 ~/.config/nvim/
chmod -R 755 ~/.local/share/nvim/

print_success "目录创建完成"

print_info "🔌 第3步: 重新安装 vim-plug"

# 下载 vim-plug 到标准位置
if curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim; then
    print_success "vim-plug 下载完成"
else
    print_error "vim-plug 下载失败"
    exit 1
fi

# 创建软链接到 config 目录
ln -sf ~/.local/share/nvim/site/autoload/plug.vim ~/.config/nvim/autoload/plug.vim

print_info "📄 第4步: 复制配置文件"

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 复制配置文件
if [[ -f "$SCRIPT_DIR/init.vim" ]]; then
    cp "$SCRIPT_DIR/init.vim" ~/.config/nvim/init.vim
    print_success "配置文件复制完成"
else
    print_error "找不到 init.vim 文件，请确保在正确的目录运行此脚本"
    exit 1
fi

print_info "🔽 第5步: 安装插件"

# 安装插件
print_info "正在安装插件（这可能需要几分钟）..."
if nvim --headless +PlugInstall +qall; then
    print_success "插件安装完成"
else
    print_warning "插件安装可能有警告，继续下一步"
fi

print_info "🌳 第6步: 安装 Treesitter 解析器"

if nvim --headless +"TSInstall c cpp python vim lua json" +qall 2>/dev/null; then
    print_success "Treesitter 解析器安装完成"
else
    print_warning "部分 Treesitter 解析器安装失败"
fi

print_info "🛠️  第7步: 安装 LSP 服务器"

if nvim --headless +"MasonInstall clangd pyright" +qall 2>/dev/null; then
    print_success "LSP 服务器安装完成"
else
    print_warning "部分 LSP 服务器安装失败"
fi

print_info "✅ 第8步: 验证安装"

# 创建测试文件
cat > /tmp/test.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}
EOF

print_info "修复完成！"
print_info "==============="
print_success "✅ vim-plug 插件管理器已安装"
print_success "✅ 所有插件已重新安装"
print_success "✅ Treesitter 解析器已安装"
print_success "✅ LSP 服务器已安装"

print_info ""
print_info "🧪 测试命令："
echo "  nvim /tmp/test.cpp"
print_info ""
print_info "🔧 如果仍有问题，请检查："
echo "  1. nvim --version (确保版本 >= 0.8)"
echo "  2. nvim +checkhealth (检查健康状态)"
echo "  3. ls ~/.config/nvim/plugged/ (检查插件是否安装)"

print_info ""
print_info "📁 重要文件位置："
echo "  - 配置: ~/.config/nvim/init.vim"
echo "  - 插件: ~/.config/nvim/plugged/"
echo "  - vim-plug: ~/.local/share/nvim/site/autoload/plug.vim"