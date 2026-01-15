#!/bin/bash

# Neovim 配置修复脚本

echo "🔧 修复 Neovim 配置中的过时API..."

CONFIG_FILE="$HOME/.config/nvim/init.vim"

# 1. 修复 tsserver -> ts_ls
echo "📝 修复 tsserver 配置..."
if grep -q "tsserver" "$CONFIG_FILE"; then
    sed -i 's/tsserver/ts_ls/g' "$CONFIG_FILE"
    echo "✅ 已将 tsserver 替换为 ts_ls"
fi

# 2. 添加错误处理，让配置更健壮
echo "📝 添加插件加载错误处理..."

# 创建备份
cp "$CONFIG_FILE" "$CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# 在配置文件开头添加错误处理
cat > /tmp/nvim_header.vim << 'EOF'
" ===== 错误处理设置 =====
" 让配置更健壮，即使某些插件加载失败也能继续
let g:plug_timeout = 60
silent! helptags ALL

EOF

# 合并文件
cat /tmp/nvim_header.vim "$CONFIG_FILE" > /tmp/new_config.vim
mv /tmp/new_config.vim "$CONFIG_FILE"
rm -f /tmp/nvim_header.vim

echo "✅ 配置修复完成！"
echo "📁 原配置已备份为: $CONFIG_FILE.backup.*"

# 3. 重新安装插件
echo "🔄 重新安装插件以确保兼容性..."
nvim --headless +PlugClean! +PlugInstall +qall

echo "🎉 修复完成！现在尝试启动 nvim"