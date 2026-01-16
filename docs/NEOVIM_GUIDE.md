# 极致现代型 Neovim 使用指南

## 🚀 概述

这是一个极致现代化的 Neovim 配置，提供类似现代 IDE 的开发体验，包括：
- **LSP 智能补全**: 超越传统 ctags 的代码导航
- **Treesitter 语法高亮**: 精确的语法解析
- **Telescope 模糊搜索**: 快速查找文件和内容
- **现代 UI**: 美观的界面和状态栏
- **调试支持**: 内置调试器集成
- **Git 集成**: 完整的版本控制支持

## 📋 系统要求

- **Neovim 0.8+** (推荐 0.9+)
- **Node.js 16+** (Copilot 和某些插件需要)
- **Git** (版本控制)
- **ripgrep** (文本搜索)
- **fd** (文件搜索)
- **Nerd Font** (图标显示，可选)

## 🛠️ 安装

```bash
cd /home/lucas/myVimrc
./build.sh
# 选择选项 2: 极致现代型 Neovim
```

## ⌨️ 快捷键大全

### 基础操作

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Space + w` | 保存文件 | 快速保存 |
| `Space + q` | 退出 | 快速退出 |
| `Space + x` | 保存并退出 | |
| `Space + e` / `F2` | 文件树 | 切换 NvimTree ⭐ |
| `Ctrl + \` | 终端 | 浮动终端 |
| `ESC` | 清除高亮 | 取消搜索高亮 |

### 文件和搜索 (Telescope)

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Space + ff` | 搜索文件 | 模糊搜索项目文件 |
| `Space + fg` | 全局搜索 | 在文件内容中搜索 |
| `Space + fb` | 搜索缓冲区 | 已打开的文件 |
| `Space + fh` | 搜索帮助 | Neovim 帮助文档 |
| `Space + fr` | 搜索引用 | LSP 引用搜索 |
| `Space + fs` | 搜索符号 | 当前文件符号 |

### LSP 代码导航 (超越 ctags)

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `gd` | 跳转到定义 | 精确跳转 |
| `gD` | 跳转到声明 | 函数/变量声明 |
| `gi` | 跳转到实现 | 接口实现 |
| `gr` | 查找引用 | 所有引用位置 |
| `K` | 悬浮文档 | 显示函数文档 |
| `Ctrl + k` | 签名帮助 | 函数参数提示 |

### 代码操作

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Space + rn` | 智能重命名 | 跨文件重命名 |
| `Space + ca` | 代码操作 | Quick Fix, 重构等 |
| `Space + f` | 智能格式化 | 自动格式化代码 |
| `]d` / `[d` | 诊断导航 | 下/上一个错误 |
| `Space + e` | 诊断详情 | 错误详细信息 |

### 编辑增强

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `gcc` | 注释行 | 注释/取消注释 |
| `gc` (可视) | 注释块 | 选中内容注释 |
| `s + 字符` | 快速跳转 | Flash 跳转 |
| `Tab` | 补全选择 | 补全菜单导航 |
| `Ctrl + j` | Copilot 确认 | 确认 AI 建议 |

### 窗口管理

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Ctrl + h/j/k/l` | 窗口导航 | 左/下/上/右窗口 |
| `Shift + h/l` | 缓冲区切换 | 上/下一个缓冲区 |
| `Space + bd` | 删除缓冲区 | 关闭当前缓冲区 |

### 诊断和调试

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Space + xx` | 诊断面板 | Trouble 面板 |
| `Space + xw` | 工作区诊断 | 整个项目诊断 |

## 🔧 插件详解

### 1. LSP 配置 (nvim-lspconfig + Mason)

**自动支持的语言：**
- C/C++: `clangd`
- Python: `pyright`
- Go: `gopls`
- Rust: `rust-analyzer`
- JavaScript/TypeScript: `tsserver`
- Lua: `lua_ls`

**管理 LSP 服务器：**
```vim
:Mason                " 打开 LSP 服务器管理界面
:LspInfo             " 查看当前文件的 LSP 状态
:LspRestart          " 重启 LSP 服务器
```

### 2. 补全引擎 (nvim-cmp)

**补全源：**
- LSP 智能补全
- 代码片段 (LuaSnip)
- 文件路径
- 缓冲区内容
- 命令行补全

**使用技巧：**
- `Tab/Shift+Tab`: 选择补全项
- `Enter`: 确认补全
- `Ctrl+Space`: 强制触发补全

### 3. 语法高亮 (Treesitter)

**支持的语言：**
- C, C++, Python, Go, Rust
- Lua, Vim, JavaScript, TypeScript
- HTML, CSS, JSON, YAML

**管理 Treesitter：**
```vim
:TSInstall python    " 安装 Python 解析器
:TSUpdate           " 更新所有解析器
:TSPlayground       " 语法树查看器
```

### 4. 模糊搜索 (Telescope)

**搜索范围：**
- 项目文件
- 文件内容
- Git 文件
- 缓冲区
- 帮助文档
- 命令历史

**高级用法：**
```vim
:Telescope live_grep  " 实时文本搜索
:Telescope git_files  " 只搜索 Git 文件
:Telescope oldfiles   " 最近文件
```

### 5. 文件管理 (NvimTree)

**功能：**
- 文件树浏览
- Git 状态显示
- 文件操作 (创建、删除、重命名)
- 书签管理

**常用操作：**
- `a`: 新建文件/目录
- `d`: 删除
- `r`: 重命名
- `y`: 复制文件名
- `<CR>`: 打开文件

### 6. Git 集成 (GitSigns + Fugitive)

**Git 状态：**
- 行级别的 Git 状态显示
- 实时 diff 预览
- Git blame 信息

**Git 命令：**
```vim
:Git status          " Git 状态
:Git commit          " 提交
:Git push           " 推送
:Git pull           " 拉取
:Gitsigns preview_hunk  " 预览修改
```

## 🎨 主题和 UI

### 内置主题
- Tokyo Night (默认)
- Catppuccin
- 支持切换：`:colorscheme catppuccin`

### UI 组件
- **Lualine**: 现代状态栏
- **Bufferline**: 标签页显示
- **Which-key**: 快捷键提示
- **Web Devicons**: 文件图标

## 🐛 调试功能

### DAP (Debug Adapter Protocol)
```vim
:lua require'dap'.toggle_breakpoint()  " 设置断点
:lua require'dap'.continue()           " 开始调试
:lua require'dap'.step_over()         " 单步执行
```

## 📝 代码片段

### LuaSnip 片段
- 自动触发代码模板
- 可跳转的占位符
- 支持多种语言

### 常用片段（以 C++ 为例）
- `main` → main 函数模板
- `for` → for 循环
- `if` → if 语句
- `class` → 类模板

## 🔨 自定义配置

### 添加新的 LSP 服务器
```lua
-- 在 init.vim 的 Lua 配置中添加
lspconfig.new_server.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
```

### 自定义快捷键
```vim
" 在 init.vim 中添加
nnoremap <leader>custom :YourCommand<CR>
```

### 安装新插件
```vim
" 在 call plug#begin() 和 call plug#end() 之间添加
Plug 'author/plugin-name'
" 然后运行 :PlugInstall
```

## 🚨 故障排除

### 常见问题

1. **插件无法加载**
   ```bash
   nvim +PlugInstall +qall
   ```

2. **LSP 服务器未启动**
   ```vim
   :LspInfo
   :Mason
   ```

3. **补全不工作**
   - 检查 LSP 服务器状态
   - 确认文件类型正确识别

4. **搜索功能异常**
   - 确认 ripgrep 和 fd 已安装
   - 检查项目根目录

### 日志和调试
```vim
:messages            " 查看消息日志
:checkhealth         " 健康检查
:Telescope diagnostics  " 查看诊断信息
```

## 📚 学习资源

### 官方文档
- [Neovim 官网](https://neovim.io/)
- [LSP 配置指南](https://github.com/neovim/nvim-lspconfig)
- [Telescope 文档](https://github.com/nvim-telescope/telescope.nvim)

### 进阶技巧
1. 学习 Lua 配置语法
2. 自定义 LSP 配置
3. 编写自己的代码片段
4. 配置项目特定设置

## 💡 最佳实践

1. **项目根目录标识**: 使用 `.git`, `.root` 等文件标识项目根
2. **LSP 配置**: 项目级 LSP 配置文件 (`.clangd`, `pyproject.toml`)
3. **定期更新**: 定期运行 `:PlugUpdate` 和 `:Mason` 更新
4. **键盘优先**: 尽量使用快捷键而不是鼠标
5. **会话管理**: 使用 `:PersistenceLoad` 恢复会话

---

🎉 **恭喜！** 你现在拥有了一个功能强大的现代化编辑器环境。慢慢探索这些功能，它们会大大提高你的编程效率！
