#!/bin/bash
# ROS2项目LSP快速配置脚本

echo "🤖 配置当前项目的ROS2 LSP环境..."

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

# 检查是否在ROS2工作空间中
if [[ -f "package.xml" || -f "../package.xml" || -f "../../package.xml" ]]; then
    echo "📦 检测到ROS2包环境"

    # 查找工作空间根目录
    WS_ROOT="."
    while [[ "$WS_ROOT" != "/" ]]; do
        if [[ -d "$WS_ROOT/src" && (-d "$WS_ROOT/build" || -d "$WS_ROOT/install") ]]; then
            echo "🏠 找到工作空间根目录: $(realpath "$WS_ROOT")"
            break
        fi
        WS_ROOT="$(dirname "$WS_ROOT")"
    done

    # 添加工作空间特定的包含路径
    if [[ -d "$WS_ROOT/install" ]]; then
        echo "    # 工作空间特定路径" >> .clangd
        if [[ -d "$WS_ROOT/install/include" ]]; then
            echo "    - -I$WS_ROOT/install/include" >> .clangd
        fi

        # 添加src中的包
        for pkg_dir in "$WS_ROOT/src"/*; do
            if [[ -d "$pkg_dir/include" ]]; then
                echo "    - -I$pkg_dir/include" >> .clangd
            fi
        done

        echo "🔧 工作空间配置完成！"
    fi
fi

echo ""
echo "🎉 ROS2项目LSP配置完成！"
echo "📝 下一步操作："
echo "   1. 在Neovim中打开.cpp文件"
echo "   2. 使用 :LspRestart 重启语言服务器"
echo "   3. 测试 #include <rclcpp/rclcpp.hpp>"
echo ""
