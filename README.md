# myVimrc

这个工具会随着你的使用，而愈加的熟悉，会愈加的上瘾，其中的技能会随着对之不断的了解而提升，这个工具从2018年开始使用，在日常的工作中，可以感受到其高效，而省去不少的时间学习其他的技能,开箱即用的，省去了折腾，可是不为无益之事，何以遣有涯之生？

## 🚀 一键安装

使用提供的自动安装脚本，无需手动配置：

```bash
# 克隆仓库
git clone [your-repo-url] ~/myVimrc
cd ~/myVimrc

# 运行一键安装脚本
./build.sh
```

### 安装脚本功能

- ✅ **自动检测系统** - 支持Ubuntu/Debian、Fedora/CentOS、Arch Linux
- ✅ **安装所有依赖** - vim, git, python3, ctags, ag, clang-format
- ✅ **备份现有配置** - 自动备份你的旧vim配置
- ✅ **安装插件管理器** - 自动安装vim-plug
- ✅ **配置个人信息** - 交互式设置作者信息
- ✅ **安装所有插件** - 自动下载并安装16个vim插件
- ✅ **生成ctags** - 为代码导航生成标签
- ✅ **验证安装** - 检查所有组件是否正确安装

### 手动安装步骤

如果你喜欢手动安装，可以按以下步骤：

1. **安装系统依赖**
   ```bash
   # Ubuntu/Debian
   sudo apt install vim git python3 python3-pip exuberant-ctags silversearcher-ag clang-format

   # Fedora/CentOS
   sudo dnf install vim git python3 python3-pip ctags the_silver_searcher clang-tools-extra

   # Arch Linux
   sudo pacman -S vim git python python-pip ctags the_silver_searcher clang
   ```

2. **安装vim-plug插件管理器**
   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

3. **复制配置文件**
   ```bash
   cp .vimrc ~/.vimrc
   cp .clang-format ~/.clang-format
   ```

4. **安装插件**
   ```bash
   vim +PlugInstall +qall
   ```

## 📦 包含的插件

| 插件 | 功能 | 快捷键 |
|------|------|---------|
| NERDTree | 文件树浏览器 | `Ctrl+n` |
| vim-commentary | 快速注释 | `gcc`, `gc` |
| vim-fugitive | Git集成 | `:Gstatus` |
| vim-gitgutter | Git修改显示 | 自动显示 |
| ag.vim | 快速搜索 | `:Ag 关键字` |
| jedi-vim | Python补全 | 自动补全 |
| supertab | 增强Tab补全 | `Tab` |
| taglist.vim | 函数标签浏览 | `:Tlist` |
| vim-airline | 美观状态栏 | 自动显示 |
| copilot.vim | AI代码助手 | `:Copilot setup` |
| vim-clang-format | C++代码格式化 | 保存时自动 |
| molokai | 配色主题 | 默认启用 |

## ⚡ 快速使用

### 基本操作
- **文件树**: `Ctrl+n` 打开/关闭NERDTree
- **快速搜索**: `:Ag 搜索内容` 在所有文件中搜索
- **注释代码**: `gcc` 注释单行，`gc` 注释选中区域
- **Git状态**: `:Gstatus` 查看git状态

### Python开发
- **自动补全**: 输入后按`Tab`或`Ctrl+n`
- **跳转定义**: `Ctrl+]` (需要ctags)
- **函数列表**: `:Tlist` 显示当前文件函数列表

### C++开发
- **代码格式化**: 保存时自动按Google风格格式化
- **手动格式化**: `:ClangFormat`
- **包含头文件**: 自动补全和语法检查

### Git集成
- **查看修改**: 左侧会显示git diff标记
- **Git命令**: `:Git add .`, `:Git commit` 等
- **跳转修改**: `]c` 下一个修改，`[c` 上一个修改

## 🔧 配置说明

### 个人信息设置
编辑 `~/.vimrc` 中的作者信息：
```vim
let g:header_field_author = '你的名字'
let g:header_field_author_email = '你的邮箱'
let g:header_field_copyright = '@copyright Copyright (c) 你的版权'
```

### C++代码风格
编辑 `~/.clang-format` 自定义代码格式，当前使用Google风格，4空格缩进。

### GitHub Copilot设置
如果你有Copilot订阅：
```vim
:Copilot setup
```

## 🛠 故障排除

### 插件安装失败
```bash
vim +PlugClean +PlugInstall +qall
```

### Python补全不工作
```bash
pip3 install jedi
```

### ag搜索命令不存在
```bash
# Ubuntu/Debian
sudo apt install silversearcher-ag

# 或使用grep替代
:grep -r "搜索内容" .
```

### ctags不生成
在项目根目录运行：
```bash
ctags -R .
```

## 📝 更新记录

- **20250715** 增加谷歌编程风格插件及配置文件 `.clang-format`
- **20260113** 添加一键安装脚本 `build.sh` 和完整文档
