# Lucas 的现代化 Vim/Neovim 配置

> 这个工具会随着你的使用，而愈加的熟悉，会愈加的上瘾，其中的技能会随着对之不断的了解而提升。从 2018 年开始使用，在日常工作中可以感受到其高效，省去了不少时间学习其他技能。开箱即用的配置，省去了折腾，"可是不为无益之事，何以遣有涯之生？"

## 🎯 双模式配置选择

本配置系统提供两种模式，满足不同用户的需求：

| 模式 | 适合人群 | 特点 | 主要技术 |
|------|----------|------|----------|
| **传统 Vim** | 追求稳定、新手友好 | 兼容性强，配置简单 | ctags + 传统插件 |
| **极致现代型 Neovim** | 追求最新功能 | IDE 级体验，功能强大 | LSP + Treesitter + Lua |

## 🚀 一键安装

### 自动安装（推荐）⭐
```bash
cd /home/lucas/myVimrc
./build.sh --auto
```
**特点**: 自动选择极致现代型 Neovim，跳过个人信息，一键完成！

### 交互式安装
```bash
cd /home/lucas/myVimrc
./build.sh
```
安装过程中会提示选择配置类型：
- **选项 1**: 传统稳定 Vim 配置
- **选项 2**: 极致现代型 Neovim 配置 ⭐

### 查看所有选项
```bash
./build.sh --help
```

## 🔥 极致现代型 Neovim 特性

### 🧠 LSP 智能代码支持
- **实时错误检查**: 代码问题即时发现
- **智能补全**: 类型感知的代码补全
- **跨文件重构**: 安全重命名变量
- **悬浮文档**: 函数说明即时显示
- **调用层级**: 完整的代码导航

### 🔍 Telescope 模糊搜索
- **文件搜索**: `Space + ff`
- **内容搜索**: `Space + fg`
- **符号搜索**: `Space + fs`
- **引用搜索**: `Space + fr`

### 🎨 现代 UI 界面
- **Tokyo Night 主题**: 护眼暗色主题
- **Web 图标**: 精美的文件类型图标
- **现代状态栏**: 信息丰富的 Lualine
- **浮动终端**: `Ctrl + \` 随时调用

### 🚀 支持语言 (LSP)
- **C/C++**: clangd
- **Python**: pyright
- **Go**: gopls
- **Rust**: rust-analyzer
- **JavaScript/TypeScript**: tsserver
- **Lua**: lua_ls

## 📦 安装脚本功能

### 🔧 智能系统检测
- ✅ **多发行版支持**: Ubuntu/Debian、Fedora/CentOS、Arch Linux
- ✅ **版本检测**: 自动检测并安装合适版本的 Neovim
- ✅ **依赖管理**: 自动安装所有必需依赖

### 🛡️ 安全备份
- ✅ **配置备份**: 自动备份现有配置文件
- ✅ **时间戳**: 带时间戳的备份目录
- ✅ **回滚支持**: 出问题可快速恢复

### ⚙️ 自动化配置
- ✅ **插件管理**: 自动安装 vim-plug
- ✅ **LSP 服务器**: Mason 自动安装语言服务器
- ✅ **Treesitter**: 自动安装语法解析器
- ✅ **个人信息**: 可选的作者信息配置

## 💻 快捷键对比

### 传统 Vim 模式 (Leader: `,`)
| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 文件树 | `Ctrl + n` | NERDTree |
| 搜索文件 | `,ff` | LeaderF |
| 更新 ctags | `,ct` | 手动更新标签 |
| 标签浏览 | `,v` | Vista |

### 极致现代型 Neovim (Leader: `Space`)
| 功能 | 快捷键 | 说明 |
|------|--------|------|
| 文件树 | `Space + e` / `F2` | NvimTree ⭐ |
| 搜索文件 | `Space + ff` | Telescope |
| 全局搜索 | `Space + fg` | 内容搜索 |
| 跳转定义 | `gd` | LSP 智能跳转 |
| 智能重命名 | `Space + rn` | LSP 重构 |
| 代码操作 | `Space + ca` | Quick Fix |
| 浮动终端 | `Ctrl + \` | ToggleTerm |

## 📚 详细文档

所有详细文档都放在 `docs/` 目录中：

📋 **[docs/README.md](docs/README.md)** - 文档导航页 (查看所有文档说明)

### 完整指南
- **[docs/SIMPLE_INSTALL_GUIDE.md](docs/SIMPLE_INSTALL_GUIDE.md)**: 📋 **简化安装指南** ⭐ **推荐新手**
  - C/C++/Python 专用配置
  - 修复弃用警告
  - 快速上手指南
  - 常见问题解决

- **[docs/NEOVIM_GUIDE.md](docs/NEOVIM_GUIDE.md)**: 📖 **完整使用指南** (7KB+)
  - 详细快捷键表
  - 插件配置说明
  - 故障排除指南
  - 最佳实践建议

- **[docs/UPGRADE_GUIDE.md](docs/UPGRADE_GUIDE.md)**: 🔄 **升级指南**
  - 版本升级说明
  - 配置迁移步骤
  - 兼容性说明

### 📁 配置文件结构
```
myVimrc/
├── init.vim           # Neovim 配置 (15KB+)
├── .vimrc             # 传统 Vim 配置 (8KB+)
├── build.sh           # 智能安装脚本 (20KB+)
├── .clang-format      # C++ 格式化配置
├── README.md          # 项目说明 (当前文件)
└── docs/              # 📚 文档目录
    ├── README.md                # 文档导航页
    ├── AUTO_INSTALL_GUIDE.md    # 自动安装指南 🚀
    ├── SIMPLE_INSTALL_GUIDE.md  # 简化安装指南 ⭐
    ├── NEOVIM_GUIDE.md          # 详细使用指南
    ├── INSTALL_FIX_GUIDE.md     # 安装问题修复
    ├── FILETREE_ICONS_FIX.md   # 文件树图标乱码修复 🔧
    └── UPGRADE_GUIDE.md         # 升级指南
```

## 🆚 功能对比表

| 特性 | 传统 Vim | 极致现代型 Neovim |
|------|----------|-------------------|
| **启动速度** | ⚡ 极快 | 🚀 快速 |
| **内存占用** | 🪶 轻量 | 📊 适中 |
| **学习成本** | 📚 简单 | 🎓 中等 |
| **功能丰富度** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **代码补全** | 基础补全 | 智能补全 + AI |
| **错误检查** | 语法高亮 | 实时诊断 |
| **重构支持** | 手动 | 自动化 |
| **调试功能** | 无 | 内置调试器 |
| **适用场景** | 服务器编辑 | 日常开发 |

## 🎯 推荐使用场景

### 选择传统 Vim 如果你：
- 👨‍💻 主要在服务器上工作
- ⚡ 需要极快的启动速度
- 🔒 追求配置稳定性
- 📱 在低配置机器上工作

### 选择极致现代型 Neovim 如果你：
- 💻 本地开发为主
- 🚀 想要 IDE 级别的功能
- 🎨 喜欢现代化界面
- 🔧 愿意探索新功能

## 🛠️ 故障排除

### Neovim 相关问题
```bash
# 检查 Neovim 版本
nvim --version

# 健康检查
nvim +checkhealth

# 重新安装插件
nvim +PlugInstall +qall

# LSP 服务器管理
nvim +Mason
```

### 传统 Vim 问题
```bash
# 重新安装插件
vim +PlugClean +PlugInstall +qall

# 更新 ctags
ctags -R .

# Python 补全问题
pip3 install jedi
```

## 🔄 升级和维护

### 配置更新
```bash
cd /home/lucas/myVimrc
git pull origin main
./build.sh  # 重新运行安装脚本
```

### 插件更新
```bash
# Neovim
nvim +PlugUpdate +qall
nvim +Mason  # 更新 LSP 服务器

# 传统 Vim
vim +PlugUpdate +qall
```

## 📈 性能建议

### Neovim 优化
- 使用 `lazy.nvim` 插件管理器 (高级用户)
- 配置项目特定的 LSP 设置
- 定期清理无用的 Treesitter 解析器

### 通用优化
- 定期更新插件
- 清理无用的配置
- 使用 SSD 存储配置文件

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

### 参与方式
1. 🐛 **Bug 报告**: 详细描述问题和复现步骤
2. 💡 **功能建议**: 提出新功能想法
3. 📚 **文档改进**: 完善文档和示例
4. 🔧 **代码贡献**: 修复 Bug 或添加功能

## 📝 更新记录

- **2025-01-16** 🛠️ **修复更新**: 解决插件安装问题
  - 修复 `lspconfig` 弃用警告
  - 解决 "module 'mason' not found" 错误
  - 修复文件树快捷键冲突 (`Ctrl+n` → `Space+e`)
  - **修复文件树图标乱码问题** 🔧 - 提供多种图标模式
  - 修复包安装错误 (移除不存在的 `gofmt` 包)
  - **添加自动安装选项** (`./build.sh --auto`) ⭐
  - **可选择跳过个人信息配置**
  - 添加安全检查机制，避免配置崩溃
  - 优化安装流程，使用临时配置确保稳定性
  - 简化配置，专注 C/C++/Python 三种语言

- **2025-01-15** 🚀 **重大更新**: 添加极致现代型 Neovim 配置
  - LSP 智能补全支持
  - Telescope 模糊搜索
  - Treesitter 语法高亮
  - 现代化 UI 界面
  - 双模式选择支持

- **2024-01-13** 📦 添加一键安装脚本和完整文档
- **2024-07-15** 🎨 增加 Google 编程风格和 `.clang-format` 配置

## ⭐ 特别鸣谢

感谢开源社区的贡献者们，特别是：
- Neovim 核心团队
- LSP 协议维护者
- 各插件作者
- Vim 社区

---

💡 **提示**: 建议新用户选择极致现代型 Neovim 配置，体验现代化的开发环境！
