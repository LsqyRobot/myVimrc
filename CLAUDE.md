# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dual-mode Vim/Neovim configuration repository designed for modern C/C++/Python/ROS2 development with intelligent cross-platform automation.

**Dual Configuration System:**
- **Modern Neovim** (`init.vim`, 854 lines): LSP-powered IDE experience with Treesitter, Telescope, completion
- **Traditional Vim** (`.vimrc`, 201 lines): Lightweight ctags-based setup for servers/minimal environments

## Key Architecture Components

### Core Configuration Files

- `init.vim` - Modern Neovim configuration with LSP integration
- `.vimrc` - Traditional Vim configuration with ctags navigation
- `.clangd` - C/C++ Language Server configuration for ROS2 development
- `.clang-format` - Google C++ Style formatting rules

### Build and Setup System

**Primary Installation Script:**
```bash
./build.sh                 # Interactive setup with platform detection
./build.sh --auto          # Fully automated installation (Neovim + LSP)
./build.sh --ros2          # ROS2-specific LSP configuration
./build.sh --help          # Display all options
```

**Platform Support:**
- Auto-detects: macOS (Intel/ARM), Ubuntu/Debian, Fedora/CentOS, Arch Linux
- Installs appropriate package managers and dependencies
- Handles Neovim 0.8+ installation and plugin setup

**Specialized Scripts:**
- `macos_fix.sh` - Resolves macOS-specific plugin installation issues
- `ros2_lsp_setup.sh` - Auto-generates ROS2 workspace LSP configuration
- `setup_ros2_project.sh` - Per-project ROS2 setup
- `auto_setup_ros2_project.sh` - Intelligent workspace detection and configuration

### Plugin Architecture (Neovim)

**Language Server Protocol Stack:**
- `mason.nvim` + `mason-lspconfig.nvim` - LSP server management
- `nvim-lspconfig` - LSP client configuration
- Auto-installs: clangd (C/C++), pyright (Python), and others

**Code Intelligence:**
- `nvim-treesitter` - AST-based syntax highlighting
- `nvim-cmp` + completion sources - Intelligent code completion
- `LuaSnip` + `friendly-snippets` - Code snippets

**Navigation and Search:**
- `telescope.nvim` - Fuzzy finder for files/symbols/text
- `nvim-tree.lua` - Modern file explorer
- `flash.nvim` - Quick cursor jumping

**Development Tools:**
- `gitsigns.nvim` + `vim-fugitive` - Git integration
- `toggleterm.nvim` - Integrated terminal
- `overseer.nvim` - Task runner
- `github/copilot.vim` - AI assistance

## Common Development Workflows

### ROS2 Development Setup

```bash
# Quick ROS2 workspace setup
cd /path/to/ros2_workspace
./path/to/myVimrc/auto_setup_ros2_project.sh
```

**Generated `.clangd` includes:**
- ROS2 system paths (/opt/ros/humble/include)
- Workspace include directories (src/*/include, install/include)
- C++17 standard with Google style guidelines

### Code Navigation

**Neovim (Modern):**
- `Space + ff` - Find files
- `Space + fg` - Search text in files
- `Space + fs` - Find symbols/functions
- `gd` - Go to definition (LSP)
- `gr` - Find references (LSP)

**Traditional Vim:**
- `,ff` - Find files (LeaderF)
- `,ft` - Find functions (LeaderF)
- `Ctrl+]` - Jump to tag definition
- `,v` - Open Vista tag browser

### Project Management

**Tag Generation:**
- Automatic via `vim-gutentags` in both configurations
- Manual: `:call UpdateCtags()` or `,ct`
- Supports C/C++, Python, with project type detection

**Code Formatting:**
- Auto-format on save for C/C++ files (Google style)
- Manual: `:Format` command or `,f`
- Configured via `.clang-format`

## Important Configuration Patterns

### Cross-Platform Compatibility

Scripts use `cross_platform_sed()` function to handle macOS/Linux differences:
```bash
if [[ "$(uname -s)" == "Darwin" ]]; then
    sed -i '' "$pattern" "$file"    # macOS
else
    sed -i "$pattern" "$file"       # Linux
fi
```

### Safe Plugin Loading

All plugins use protected loading to prevent crashes:
```lua
local ok, module = pcall(require, 'plugin_name')
if not ok then
    vim.notify("Plugin not found", vim.log.levels.WARN)
    return
end
module.setup({...})
```

### Font Detection System

Icons adapt based on environment:
```lua
if vim.g.have_nerd_font == 1 or vim.env.NERD_FONT == "1" then
    -- Use Nerd Font icons
else
    -- Use ASCII fallback
end
```

## Build System Details

### Dependencies and Versions

**Required:**
- Neovim 0.8+ (for modern configuration)
- Git, curl (for plugin management)
- Node.js/npm or Rust/cargo (for tree-sitter compilation)

**Optional but Recommended:**
- clangd (C/C++ LSP server)
- pyright (Python LSP server)
- ROS2 environment (for robotics development)

### Installation Safety

- Automatic backup of existing configs with timestamps
- Pre-flight dependency checks before installation
- Rollback capability on installation failure
- Error recovery with colored status messages

### File Locations

**Neovim:**
- Config: `~/.config/nvim/init.vim`
- Plugins: `~/.config/nvim/plugged/`
- LSP servers: `~/.local/share/nvim/mason/bin/`
- Undo files: `~/.config/nvim/undo/`

**Traditional Vim:**
- Config: `~/.vimrc`
- Plugins: `~/.vim/plugged/`
- Tags cache: `~/.cache/vim/ctags/`

## Troubleshooting

### Common Issues

1. **"Mason plugin not found"** (macOS): Run `./macos_fix.sh`
2. **LSP not working**: Check `:LspStatus` and verify clangd installation
3. **Icons not displaying**: Set `export NERD_FONT=1` or install Nerd Font
4. **ROS2 includes missing**: Run `./ros2_lsp_setup.sh --force`

### Diagnostic Commands

- `:checkhealth` - Comprehensive system status
- `:LspStatus` - LSP server status
- `:LspRestart` - Restart LSP servers
- `:PlugStatus` - Plugin installation status

## Language Support Matrix

| Language | LSP Server | Formatter | Treesitter | Auto-completion |
|----------|------------|-----------|------------|-----------------|
| C/C++    | clangd     | clang-format | ✓ | ✓ |
| Python   | pyright    | yapf      | ✓ | ✓ |
| Go       | gopls      | gofmt     | ✓ | ✓ |
| Rust     | rust-analyzer | rustfmt | ✓ | ✓ |
| JS/TS    | tsserver   | prettier  | ✓ | ✓ |
| Lua      | lua-ls     | stylua    | ✓ | ✓ |

## Performance Considerations

- Modern configuration requires ~200MB RAM overhead for LSP servers
- Traditional configuration has minimal resource impact
- Plugin lazy-loading minimizes startup time
- Tree-sitter compilation may take 2-5 minutes on first install

## Version History Insights

Recent development focus:
- macOS compatibility improvements (M1/M2 Apple Silicon support)
- ROS2 ecosystem integration enhancements
- Cross-platform sed function bug fixes
- Automated workspace detection improvements
- Icon rendering fixes for various terminals

The configuration balances modern IDE features with traditional Vim reliability, prioritizing user experience through intelligent automation and comprehensive platform support.