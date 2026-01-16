# 简化版 Neovim 安装指南 - C/C++/Python 专用

## 🛠️ 最新修复内容 (2025-01-16)
✅ **已修复 `lspconfig` 弃用警告** - 使用新的 `vim.lsp.config` API
✅ **已修复插件安装顺序问题** - 解决 "module 'mason' not found" 错误
✅ **修复文件树快捷键冲突** - `Ctrl+n` 改为 `Space+e` 和 `F2`
✅ **添加安全检查机制** - 所有插件都有存在性检查，避免崩溃
✅ **简化配置** - 仅支持 C、C++、Python 三种语言
✅ **优化安装流程** - 使用临时配置确保安装稳定性
✅ **智能错误处理** - 插件缺失时显示警告而不崩溃

## 快速安装

```bash
cd /home/lucas/myVimrc
./build.sh
# 选择选项 2: 极致现代型 Neovim
```

## 核心功能

### 支持语言
- **C/C++**: clangd 语言服务器
- **Python**: pyright 语言服务器
- **基础**: vim, lua, json 语法支持

### 主要特性
1. **智能补全** - nvim-cmp + LSP
2. **语法高亮** - Treesitter
3. **代码导航** - LSP 跳转和引用
4. **模糊搜索** - Telescope
5. **文件树** - nvim-tree
6. **Git 集成** - gitsigns
7. **代码格式化** - LSP 内置格式化
8. **终端集成** - toggleterm
9. **GitHub Copilot** - 可选 AI 代码补全

## 快捷键 (Leader键是空格)

### 基础操作
- `Space + w` - 保存文件
- `Space + q` - 退出
- `Space + e` - 打开/关闭文件树 ⭐
- `F2` - 打开/关闭文件树 (备用)
- `Ctrl + \` - 浮动终端

### 代码导航
- `gd` - 跳转到定义
- `gD` - 跳转到声明
- `gr` - 查找所有引用
- `gi` - 跳转到实现
- `K` - 显示文档
- `[d` / `]d` - 上/下一个诊断错误

### 搜索功能
- `Space + ff` - 搜索文件
- `Space + fg` - 全局文本搜索
- `Space + fb` - 搜索已打开的缓冲区
- `Space + fr` - 搜索引用
- `Space + fs` - 搜索符号

### 代码操作
- `Space + rn` - 重命名符号
- `Space + ca` - 代码操作菜单
- `Space + f` - 格式化代码
- `gcc` - 注释/取消注释当前行
- `gc` (可视模式) - 注释选中内容

### 其他功能
- `s + 字符` - 快速跳转到指定字符
- `Space + xx` - 打开诊断面板
- `Ctrl + j` - Copilot 确认建议 (需要配置)

## 首次使用

1. **启动 Neovim**:
   ```bash
   nvim
   ```

2. **等待插件安装完成** (首次启动会自动安装)

3. **检查 LSP 服务器状态**:
   ```
   :Mason
   ```

4. **配置 Copilot** (可选):
   ```
   :Copilot setup
   ```

5. **测试功能**: 打开一个 C++ 或 Python 文件试试智能补全

## 故障排除

### 🌳 文件树快捷键问题
**问题**: `Ctrl+n` 进入了奇怪的补全模式
**原因**: `Ctrl+n` 是 Vim 默认的自动补全快捷键
**解决**: 已改为新快捷键
- **`Space + e`** ⭐ (推荐，现代编辑器标准)
- **`F2`** (备用，绝不冲突)

### 如果遇到 LSP 错误
```bash
# 重新安装 LSP 服务器
nvim --headless +"MasonInstall clangd pyright" +qall
```

### 如果插件有问题
```bash
# 重新安装插件
nvim +PlugInstall +qall
```

### 清理并重装
```bash
# 删除现有配置
rm -rf ~/.config/nvim ~/.local/share/nvim

# 重新运行安装脚本
cd /home/lucas/myVimrc
./build.sh
```

## 配置文件位置

- **主配置**: `~/.config/nvim/init.vim`
- **插件目录**: `~/.config/nvim/plugged/`
- **LSP 数据**: `~/.local/share/nvim/mason/`
- **代码格式化**: `~/.clang-format` (C++)

## 注意事项

- 需要 Neovim 0.8+ 版本
- 首次启动会下载和安装插件，请耐心等待
- 如果网络较慢，某些插件可能安装失败，可以重新运行 `:PlugInstall`
- Copilot 需要 GitHub 账号和订阅才能使用