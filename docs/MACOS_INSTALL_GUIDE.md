# 🍎 macOS 安装指南 - Vim/Neovim 现代化配置

## 🚀 一键安装

### 自动安装（推荐）⭐
```bash
cd /home/lucas/myVimrc
./build.sh --auto
```
**特点**: 自动安装 Homebrew、Neovim 和所有依赖，一键完成！

### 交互式安装
```bash
cd /home/lucas/myVimrc
./build.sh
```

## 🔧 macOS 特定的安装步骤

### 1. **系统要求**
- macOS 10.15+ (推荐 macOS 11+)
- 已安装 Xcode Command Line Tools
  ```bash
  xcode-select --install
  ```

### 2. **Homebrew 自动安装**
脚本会自动：
- ✅ 检测并安装 Homebrew
- ✅ 配置 Apple Silicon (M1/M2) 和 Intel 的路径
- ✅ 自动添加到 ~/.zprofile

### 3. **安装的软件包**

#### **Neovim 模式**
```bash
# 通过 Homebrew 自动安装:
brew install neovim git python3 curl wget
brew install ripgrep fd node
brew install clang-format universal-ctags

# Python 工具
pip3 install yapf

# Node.js 工具
npm install -g tree-sitter-cli
```

#### **传统 Vim 模式**
```bash
brew install vim git python3
brew install universal-ctags the_silver_searcher
brew install clang-format
```

## 🎨 macOS 终端配置建议

### **终端应用选择**
1. **iTerm2** (推荐) - 功能最强大
   ```bash
   brew install --cask iterm2
   ```

2. **Alacritty** - 高性能 GPU 加速
   ```bash
   brew install --cask alacritty
   ```

3. **系统自带终端** - 基本够用

### **字体配置**

#### **方式一: 安装 Nerd Font (完整图标支持)**
```bash
# 安装热门编程字体
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-hack-nerd-font
```

**设置终端字体**:
- iTerm2: Preferences → Profiles → Text → Font → 选择 "FiraCode Nerd Font"
- 系统终端: Terminal → Preferences → Profiles → Text → Font

#### **方式二: 使用简单 ASCII 图标 (兼容性最好)**
```bash
# 在 Neovim 中运行:
:NvimTreeSimpleIcons
```

## 🔍 macOS 特定的快捷键

### **终端中的 Vim 快捷键**
- `Cmd + ,` - 打开终端偏好设置
- `Cmd + T` - 新建标签页
- `Cmd + W` - 关闭标签页
- `Cmd + +/-` - 放大/缩小字体

### **系统剪贴板集成**
```vim
" 在 Vim 中复制到系统剪贴板
"+y

" 从系统剪贴板粘贴
"+p
```

## 🛠️ 故障排除

### **Homebrew 相关问题**

#### **问题**: "command not found: brew"
**解决方案**:
```bash
# Apple Silicon Mac (M1/M2)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Mac
eval "$(/usr/local/bin/brew shellenv)"

# 添加到 shell 配置
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

#### **问题**: 权限问题
**解决方案**:
```bash
# 修复 Homebrew 权限
sudo chown -R $(whoami) /opt/homebrew/*
```

### **字体显示问题**

#### **问题**: 文件树显示乱码 (、、等)
**解决方案**:
1. 安装 Nerd Font (见上方字体配置)
2. 或使用简单图标:
   ```vim
   :NvimTreeSimpleIcons
   ```

#### **问题**: 状态栏显示异常
**解决方案**:
```vim
# 在 Neovim 中切换图标模式
:ToggleNerdFont
```

### **LSP 服务器问题**

#### **问题**: clangd 找不到
**解决方案**:
```bash
# 重新安装 clangd
brew install llvm

# 如果还是有问题，手动安装
nvim --headless +"MasonInstall clangd pyright" +qall
```

### **Python 环境问题**

#### **问题**: pip3 命令找不到
**解决方案**:
```bash
# 重新安装 Python
brew reinstall python3

# 或者使用 python -m pip
python3 -m pip install yapf
```

## ⚡ 性能优化建议

### **macOS 特定优化**
1. **启用金属渲染** (iTerm2):
   - Preferences → Advanced → Metal renderer → Yes

2. **关闭透明效果**:
   - System Preferences → Accessibility → Display → Reduce transparency

3. **增加终端历史记录**:
   - iTerm2: Preferences → Profiles → Terminal → Scrollback lines: 10000

### **Neovim 特定优化**
```vim
" 在 ~/.config/nvim/init.vim 中添加 (macOS 优化)
set clipboard=unnamedplus  " 系统剪贴板集成
set mouse=a                " 启用鼠标支持
```

## 🔄 更新和维护

### **更新配置**
```bash
cd /home/lucas/myVimrc
git pull origin main
./build.sh  # 重新安装
```

### **更新软件包**
```bash
# 更新 Homebrew 和所有软件包
brew update && brew upgrade

# 更新 Neovim 插件
nvim +PlugUpdate +qall

# 更新 LSP 服务器
nvim +Mason
```

## 📱 与其他 Apple 设备集成

### **通用剪贴板**
- 在 Mac 上复制，在 iPad/iPhone 上粘贴
- 需要同一 Apple ID 登录且开启 Handoff

### **iCloud Drive 同步配置**
```bash
# 将配置同步到 iCloud Drive
ln -s ~/.config/nvim ~/Library/Mobile\ Documents/com~apple~CloudDocs/nvim-config
```

## 🎯 macOS 专用功能

### **Spotlight 搜索集成**
```bash
# 让 Spotlight 能搜索到代码文件
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "DOCUMENTS";}' \
  '{"enabled" = 1;"name" = "SOURCE";}' \
  '{"enabled" = 1;"name" = "APPLICATIONS";}'
```

### **Quick Look 支持**
```bash
# 安装代码文件的 Quick Look 插件
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv
```

---

🍎 **macOS 用户现在可以享受完整的现代化 Vim/Neovim 体验了！**