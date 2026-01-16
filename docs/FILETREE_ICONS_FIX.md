# 🌳 文件树图标乱码修复指南

## ❌ 问题描述
使用 `Space + e` 打开文件树后，文件和文件夹前面显示乱码字符，类似 ``, ``, `` 等。

## 🔍 问题原因
nvim-tree 默认使用 **Nerd Font 图标**，这些是特殊的 Unicode 字符，需要特定的字体支持。如果系统字体不支持这些字符，就会显示为乱码。

## 🚀 解决方案（按推荐程度排序）

### 方案一：使用简单图标 ⭐ **推荐**
最简单快速的解决方案，不需要安装任何字体。

在 Neovim 中运行：
```vim
:NvimTreeSimpleIcons
```
然后重启 Neovim。

**效果**：
- 文件夹用 `[D]`, `[E]` 等 ASCII 字符表示
- 展开/收缩用 `+`, `-` 表示
- Git 状态用 `M`, `A`, `D` 等字母表示

### 方案二：完全禁用图标 🔧
如果你不需要任何图标，只要纯文本显示。

在 Neovim 中运行：
```vim
:NvimTreeDisableIcons
```
然后重启 Neovim。

**效果**：
- 不显示任何文件类型图标
- 只显示文件名和基本的展开标记

### 方案三：安装 Nerd Font 📚 **最完整**
如果你想要完整的图标体验，需要安装支持的字体。

#### Ubuntu/Debian 系统
```bash
# 下载 Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# 下载流行的编程字体
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip

# 解压字体文件
unzip FiraCode.zip -d FiraCode/
unzip JetBrainsMono.zip -d JetBrainsMono/

# 刷新字体缓存
fc-cache -fv

# 清理下载文件
rm *.zip
```

#### 配置终端字体
设置终端使用 Nerd Font：
- **GNOME Terminal**: 编辑 → 首选项 → 配置文件 → 字体 → 选择 "FiraCode Nerd Font"
- **VS Code Terminal**: 设置 `terminal.integrated.fontFamily` 为 `'FiraCode Nerd Font'`
- **其他终端**: 查找字体设置选项

#### 启用 Nerd Font 图标
在 Neovim 中运行：
```vim
:NvimTreeEnableNerdFont
```
然后重启 Neovim。

## 🔄 切换模式

你可以随时切换图标模式：

| 命令 | 效果 | 需要重启 |
|------|------|----------|
| `:NvimTreeSimpleIcons` | 简单 ASCII 图标 | ✅ |
| `:NvimTreeDisableIcons` | 禁用所有图标 | ✅ |
| `:NvimTreeEnableNerdFont` | 启用 Nerd Font 图标 | ✅ |

## 🧪 测试字体支持

你可以用这个简单测试来检查字体支持：

```bash
echo "Testing Nerd Font icons:"
echo "📁 📄   "
```

如果你看到正方形或问号而不是文件夹和文档图标，说明字体不支持。

## ⚡ 环境变量配置

### 永久启用 Nerd Font
如果你已安装 Nerd Font 并想默认启用，添加到 shell 配置：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export NERD_FONT=1
```

### 永久使用简单图标
```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export NVIM_SIMPLE_ICONS=1
```

## 🔍 故障排除

### Q: 运行命令后没有效果？
A: 确保重启了 Neovim。配置更改需要重启才能生效。

### Q: 简单图标模式下还有乱码？
A: 可能是终端编码问题。确保终端使用 UTF-8 编码：
```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### Q: 安装 Nerd Font 后终端其他地方显示异常？
A: 只在编程相关的终端中使用 Nerd Font，系统终端可以使用普通字体。

### Q: 如何检查当前使用的图标模式？
A: 启动 Neovim 时会显示提示信息：
- "Using simple ASCII icons for file tree"
- "File tree icons disabled"
- "Using Nerd Font icons for file tree"

## 💡 字体推荐

如果选择安装 Nerd Font，推荐这些编程友好的字体：

1. **FiraCode Nerd Font** - 支持连字，美观
2. **JetBrains Mono** - JetBrains 官方字体
3. **Hack Nerd Font** - 专为编程设计
4. **Source Code Pro** - Adobe 开源字体

## 📝 配置原理

修复后的配置会：
1. 自动检测字体支持
2. 默认使用简单 ASCII 图标（兼容性最好）
3. 提供用户命令快速切换模式
4. 显示当前使用的图标模式

这样既保证了兼容性，又给有需要的用户提供了完整的图标体验！