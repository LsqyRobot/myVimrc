#!/bin/bash
# macOS 支持测试脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# 测试函数
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 跨平台 sed 函数
cross_platform_sed() {
    local pattern="$1"
    local file="$2"
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sed -i '' "$pattern" "$file"
    else
        sed -i "$pattern" "$file"
    fi
}

# 系统检测函数
detect_os() {
    local os_type=$(uname -s)
    case $os_type in
        Darwin)
            echo "macos"
            ;;
        Linux)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

echo "🧪 测试 macOS 兼容性支持..."
echo

# 1. 系统检测测试
print_info "1. 测试系统检测功能..."
OS=$(detect_os)
print_success "检测到系统: $OS"

if [[ "$OS" == "macos" ]]; then
    print_success "✅ macOS 检测正常"

    # 2. 测试 Homebrew 检测
    print_info "2. 测试 Homebrew 状态..."
    if command_exists brew; then
        print_success "✅ Homebrew 已安装: $(brew --version | head -1)"

        # 检查 Homebrew 路径
        if [[ -f /opt/homebrew/bin/brew ]]; then
            print_success "✅ Apple Silicon Mac - Homebrew 路径正确"
        elif [[ -f /usr/local/bin/brew ]]; then
            print_success "✅ Intel Mac - Homebrew 路径正确"
        fi
    else
        print_warning "⚠️ Homebrew 未安装，安装脚本会自动安装"
    fi

    # 3. 测试必要工具
    print_info "3. 检查必要工具..."
    tools=("git" "python3" "curl" "wget")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            print_success "✅ $tool 已安装"
        else
            print_warning "⚠️ $tool 未安装，安装脚本会自动安装"
        fi
    done

    # 4. 测试开发工具
    print_info "4. 检查开发工具..."
    dev_tools=("nvim" "node" "npm" "clang" "tree-sitter")
    for tool in "${dev_tools[@]}"; do
        if command_exists "$tool"; then
            print_success "✅ $tool 已安装"
        else
            print_warning "⚠️ $tool 未安装，安装脚本会自动安装"
        fi
    done

elif [[ "$OS" == "linux" ]]; then
    print_success "✅ Linux 系统检测正常"
    print_info "这是 Linux 系统，macOS 功能测试跳过"
else
    print_error "❌ 未知系统: $OS"
fi

# 5. 测试 sed 兼容性
print_info "5. 测试 sed 兼容性..."
test_file=$(mktemp)
echo "test line" > "$test_file"

cross_platform_sed 's/test/modified/' "$test_file"

if grep -q "modified" "$test_file"; then
    print_success "✅ sed 兼容性正常"
else
    print_error "❌ sed 兼容性测试失败"
fi

rm -f "$test_file"

echo
print_success "🎉 macOS 兼容性测试完成！"

if [[ "$OS" == "macos" ]]; then
    echo
    print_info "📋 macOS 用户建议:"
    echo "   1. 运行 ./build.sh --auto 进行一键安装"
    echo "   2. 阅读 docs/MACOS_INSTALL_GUIDE.md 了解详细配置"
    echo "   3. 考虑安装 iTerm2: brew install --cask iterm2"
    echo "   4. 安装 Nerd Font: brew install --cask font-fira-code-nerd-font"
fi