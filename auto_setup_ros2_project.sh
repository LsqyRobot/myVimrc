#!/bin/bash
# 智能ROS2项目LSP配置脚本 - 自动检测工作空间路径

echo "🤖 智能配置当前项目的ROS2 LSP环境..."

# 查找全局clangd配置文件的多个可能位置
GLOBAL_CONFIG_PATHS=(
    "$HOME/myVimrc/.clangd"
    "$HOME/.config/nvim/.clangd"
    "$(dirname "${BASH_SOURCE[0]}")/.clangd"
)

FOUND_CONFIG=""
for config_path in "${GLOBAL_CONFIG_PATHS[@]}"; do
    if [[ -f "$config_path" ]]; then
        FOUND_CONFIG="$config_path"
        echo "📍 找到全局配置: $config_path"
        break
    fi
done

# 复制全局clangd配置到当前项目
if [[ -n "$FOUND_CONFIG" ]]; then
    cp "$FOUND_CONFIG" "./.clangd"
    echo "✅ 已复制ROS2 clangd配置到当前项目"
else
    echo "❌ 未找到全局clangd配置！"
    echo ""
    echo "🔍 搜索的位置:"
    for path in "${GLOBAL_CONFIG_PATHS[@]}"; do
        echo "   - $path"
    done
    echo ""
    echo "💡 解决方案："
    echo "   1. 运行: ~/myVimrc/build.sh --ros2"
    echo "   2. 或者运行: ~/myVimrc/ros2_lsp_setup.sh --global"
    echo ""
    exit 1
fi

# 智能检测工作空间结构和include路径
CURRENT_DIR="$(pwd)"
WORKSPACE_ROOT="$CURRENT_DIR"

# 向上查找工作空间根目录
while [[ "$WORKSPACE_ROOT" != "/" ]]; do
    if [[ -d "$WORKSPACE_ROOT/src" ]]; then
        echo "🏠 找到工作空间根目录: $WORKSPACE_ROOT"
        break
    fi
    WORKSPACE_ROOT="$(dirname "$WORKSPACE_ROOT")"
done

if [[ "$WORKSPACE_ROOT" == "/" ]]; then
    echo "⚠️  未找到ROS2工作空间结构，使用当前目录"
    WORKSPACE_ROOT="$CURRENT_DIR"
fi

# 自动检测并添加所有include路径
if [[ -d "$WORKSPACE_ROOT/src" ]]; then
    echo "📦 检测到ROS2工作空间，正在添加include路径..."

    # 备份当前配置
    cp .clangd .clangd.backup.$(date +%Y%m%d_%H%M%S)

    # 查找所有include目录
    INCLUDE_DIRS=()
    while IFS= read -r -d '' include_dir; do
        INCLUDE_DIRS+=("$include_dir")
    done < <(find "$WORKSPACE_ROOT/src" -name "include" -type d -print0 2>/dev/null)

    echo "🔍 发现 ${#INCLUDE_DIRS[@]} 个include目录"

    # 在标准定义之后添加工作空间路径
    if [[ ${#INCLUDE_DIRS[@]} -gt 0 ]]; then
        # 找到插入点（在"# 标准定义"之前）
        sed -i '/# 标准定义/i\    # 工作空间include路径' .clangd

        for include_dir in "${INCLUDE_DIRS[@]}"; do
            # 插入include路径
            sed -i "/# 工作空间include路径/a\\    - -I$include_dir" .clangd
            echo "  ✓ 添加: $include_dir"
        done

        echo ""
        echo "🔧 工作空间配置完成！"
    fi

    # 检查install目录（如果存在）
    if [[ -d "$WORKSPACE_ROOT/install/include" ]]; then
        sed -i "/# 工作空间include路径/a\\    - -I$WORKSPACE_ROOT/install/include" .clangd
        echo "  ✓ 添加install路径: $WORKSPACE_ROOT/install/include"
    fi

    # 检查build目录中的生成头文件
    if [[ -d "$WORKSPACE_ROOT/build" ]]; then
        while IFS= read -r -d '' build_include; do
            sed -i "/# 工作空间include路径/a\\    - -I$build_include" .clangd
            echo "  ✓ 添加build路径: $build_include"
        done < <(find "$WORKSPACE_ROOT/build" -name "include" -type d -print0 2>/dev/null)
    fi
fi

# 添加第三方库路径
if [[ -d "$WORKSPACE_ROOT/third_party_src" ]]; then
    echo "📚 检测到第三方库，添加路径..."
    while IFS= read -r -d '' third_party_include; do
        sed -i "/# 工作空间include路径/a\\    - -I$third_party_include" .clangd
        echo "  ✓ 添加第三方库: $third_party_include"
    done < <(find "$WORKSPACE_ROOT/third_party_src" -name "include" -type d -print0 2>/dev/null)
fi

echo ""
echo "🎉 智能ROS2项目LSP配置完成！"
echo "📋 配置摘要："
echo "   - 工作空间根目录: $WORKSPACE_ROOT"
echo "   - 配置文件: $(pwd)/.clangd"
echo "   - 备份文件: $(pwd)/.clangd.backup.*"
echo ""
echo "📝 下一步操作："
echo "   1. 在Neovim中打开.cpp文件"
echo "   2. 使用 :LspRestart 重启语言服务器"
echo "   3. 测试 Ctrl+] 跳转到 PinocchioInterface"
echo "   4. 如有问题，可恢复备份: mv .clangd.backup.* .clangd"
echo ""