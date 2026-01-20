#!/bin/bash

# ========================================
# ROS2 LSP 自动配置脚本
# 自动检测ROS2环境并生成clangd配置
# ========================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
}

# 显示帮助信息
show_help() {
    cat << EOF
ROS2 LSP 自动配置脚本

用法: $0 [选项] [目标目录]

选项:
  -h, --help          显示帮助信息
  -d, --detect-only   仅检测ROS2环境，不生成配置
  -f, --force         强制覆盖现有配置
  -v, --verbose       详细输出
  --global           生成全局配置（在vim配置目录）
  --local            生成本地配置（在当前目录）

目标目录:
  指定.clangd配置文件的生成位置（默认：当前目录）

示例:
  $0                          # 在当前目录生成配置
  $0 --global                 # 在vim配置目录生成全局配置
  $0 /path/to/ros2/project    # 在指定项目目录生成配置
  $0 --detect-only            # 仅检测ROS2环境
EOF
}

# 检测ROS2安装
detect_ros2() {
    local ros_paths=(
        "/opt/ros"
        "/usr/local/opt/ros"
        "$HOME/ros2_install"
        "$HOME/.local/opt/ros"
    )

    local found_distros=()

    for base_path in "${ros_paths[@]}"; do
        if [[ -d "$base_path" ]]; then
            for distro in "$base_path"/*; do
                if [[ -d "$distro" && -f "$distro/setup.bash" ]]; then
                    local distro_name=$(basename "$distro")
                    found_distros+=("$distro:$distro_name")
                    log_debug "发现ROS2发行版: $distro_name 在 $distro"
                fi
            done
        fi
    done

    if [[ ${#found_distros[@]} -eq 0 ]]; then
        log_error "未找到ROS2安装！请确保ROS2已正确安装。"
        return 1
    fi

    echo "${found_distros[@]}"
}

# 选择ROS2发行版
select_ros2_distro() {
    local distros=("$@")

    if [[ ${#distros[@]} -eq 1 ]]; then
        echo "${distros[0]}"
        return 0
    fi

    log_info "发现多个ROS2发行版："
    for i in "${!distros[@]}"; do
        local distro_info="${distros[$i]}"
        local distro_name="${distro_info##*:}"
        local distro_path="${distro_info%%:*}"
        echo "  $((i+1)). $distro_name ($distro_path)"
    done

    if [[ -n "${ROS_DISTRO:-}" ]]; then
        for distro_info in "${distros[@]}"; do
            local distro_name="${distro_info##*:}"
            if [[ "$distro_name" == "$ROS_DISTRO" ]]; then
                log_info "使用当前环境变量中的ROS发行版: $ROS_DISTRO"
                echo "$distro_info"
                return 0
            fi
        done
    fi

    echo -n "请选择要配置的ROS2发行版 [1]: "
    read -r choice
    choice="${choice:-1}"

    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#distros[@]} ]]; then
        echo "${distros[$((choice-1))]}"
    else
        log_error "无效选择，使用第一个发行版"
        echo "${distros[0]}"
    fi
}

# 获取ROS2包列表
get_ros2_packages() {
    local ros_path="$1"
    local include_dir="$ros_path/include"

    if [[ ! -d "$include_dir" ]]; then
        log_warn "头文件目录不存在: $include_dir"
        return 1
    fi

    local packages=()
    for pkg_dir in "$include_dir"/*; do
        if [[ -d "$pkg_dir" ]]; then
            local pkg_name=$(basename "$pkg_dir")
            packages+=("$pkg_name")
        fi
    done

    echo "${packages[@]}"
}

# 生成clangd配置
generate_clangd_config() {
    local ros_path="$1"
    local distro_name="$2"
    local packages=($3)
    local output_file="$4"

    log_info "生成clangd配置文件: $output_file"
    log_info "ROS2路径: $ros_path"
    log_info "发行版: $distro_name"
    log_info "发现 ${#packages[@]} 个ROS2包"

    # 备份现有配置
    if [[ -f "$output_file" ]]; then
        local backup_file="${output_file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "备份现有配置到: $backup_file"
        cp "$output_file" "$backup_file"
    fi

    # 生成配置内容
    cat > "$output_file" << EOF
# ========================================
# ROS2 LSP 配置文件 (自动生成)
# ROS发行版: $distro_name
# 生成时间: $(date)
# ROS路径: $ros_path
# ========================================

CompileFlags:
  Add:
    # C++标准和基础编译选项
    - -std=c++17                         # 使用C++17标准
    - -Wall                              # 启用所有警告
    - -Wextra                            # 额外警告
    - -Wpedantic                         # 严格标准符合性

    # C++标准库头文件
    - -I/usr/include/c++/11
    - -I/usr/include/x86_64-linux-gnu/c++/11
    - -I/usr/include/c++/11/backward
    - -I/usr/lib/gcc/x86_64-linux-gnu/11/include
    - -I/usr/local/include
    - -I/usr/include/x86_64-linux-gnu
    - -I/usr/include

    # ROS2 $distro_name 主要头文件路径
    - -I$ros_path/include              # ROS2主头文件目录
EOF

    # 添加所有ROS2包的头文件路径
    log_info "添加ROS2包头文件路径..."
    local common_packages=(
        "rclcpp" "rclcpp_lifecycle" "rclcpp_action" "rclcpp_components"
        "rcl" "rcl_lifecycle" "rcutils" "rmw"
        "std_msgs" "geometry_msgs" "sensor_msgs" "nav_msgs" "tf2_msgs"
        "tf2" "tf2_ros" "tf2_geometry_msgs" "tf2_eigen"
        "lifecycle_msgs" "builtin_interfaces"
        "ament_index_cpp" "class_loader" "pluginlib"
    )

    for pkg in "${common_packages[@]}"; do
        if [[ " ${packages[*]} " =~ " $pkg " ]]; then
            echo "    - -I$ros_path/include/$pkg    # $pkg头文件" >> "$output_file"
        fi
    done

    # 添加编译定义
    cat >> "$output_file" << EOF

    # 标准定义
    - -D_GNU_SOURCE                      # GNU扩展
    - -D_USE_MATH_DEFINES                # 数学常量（M_PI等）
    - -D__STDC_CONSTANT_MACROS           # 标准C常量宏
    - -D__STDC_LIMIT_MACROS              # 标准C限制宏

    # ROS2相关定义
    - -DROS_DISTRO_$(echo "$distro_name" | tr '[:lower:]' '[:upper:]')  # ROS2发行版标识
    - -DRCUTILS_ENABLE_FAULT_INJECTION=0 # 禁用故障注入
    - -DRCL_LOGGING_ENABLED              # 启用RCL日志
    - -DRCLCPP_LIFECYCLE_ENABLED         # 启用lifecycle支持
    - -DQT_NO_KEYWORDS                   # 避免Qt关键字冲突

    # 性能优化定义
    - -DNDEBUG                           # 禁用调试断言（Release模式）
    - -O2                                # 优化级别2

Diagnostics:
  ClangTidy:
    Add:
      - modernize-*
      - readability-*
      - performance-*
      - cppcoreguidelines-*
      - bugprone-*
    Remove:
      - modernize-use-trailing-return-type
      - readability-magic-numbers
      - cppcoreguidelines-avoid-magic-numbers
      - cppcoreguidelines-pro-bounds-array-to-pointer-decay

Index:
  Background: Build

# ========================================
# 配置说明:
# 1. 此配置适用于ROS2 $distro_name
# 2. 包含了常用ROS2包的头文件路径
# 3. 启用了适当的编译优化和诊断
# 4. 如需添加自定义包，请在CompileFlags->Add中添加对应的-I路径
# ========================================
EOF

    log_info "配置文件生成完成！"
    log_info "包含的主要ROS2包："
    for pkg in "${common_packages[@]}"; do
        if [[ " ${packages[*]} " =~ " $pkg " ]]; then
            echo "  ✓ $pkg"
        fi
    done
}

# 创建项目级配置脚本
create_project_setup_script() {
    local target_dir="$1"
    local script_path="$target_dir/setup_ros2_lsp.sh"

    cat > "$script_path" << 'EOF'
#!/bin/bash
# ROS2项目LSP快速配置脚本
# 用法: ./setup_ros2_lsp.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查是否在ROS2工作空间中
if [[ -f "$SCRIPT_DIR/package.xml" || -f "$SCRIPT_DIR/../package.xml" || -f "$SCRIPT_DIR/../../package.xml" ]]; then
    echo "检测到ROS2包环境"

    # 查找工作空间根目录
    WS_ROOT="$SCRIPT_DIR"
    while [[ "$WS_ROOT" != "/" ]]; do
        if [[ -d "$WS_ROOT/src" && (-d "$WS_ROOT/build" || -d "$WS_ROOT/install") ]]; then
            echo "找到工作空间根目录: $WS_ROOT"
            break
        fi
        WS_ROOT="$(dirname "$WS_ROOT")"
    done

    # 生成包含工作空间路径的配置
    if [[ -d "$WS_ROOT/install" ]]; then
        echo "生成包含工作空间的clangd配置..."

        # 调用主配置脚本
        if command -v ros2_lsp_setup.sh >/dev/null 2>&1; then
            ros2_lsp_setup.sh --local
        else
            echo "未找到ros2_lsp_setup.sh，请确保已安装"
            exit 1
        fi

        # 添加工作空间特定的包含路径
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

        echo "工作空间配置完成！"
    fi
else
    # 普通项目，调用标准配置
    if command -v ros2_lsp_setup.sh >/dev/null 2>&1; then
        ros2_lsp_setup.sh --local
    else
        echo "未找到ros2_lsp_setup.sh，请确保已安装"
        exit 1
    fi
fi
EOF

    chmod +x "$script_path"
    log_info "创建项目配置脚本: $script_path"
}

# 主函数
main() {
    local target_dir="."
    local detect_only=false
    local force_overwrite=false
    local verbose=false
    local global_config=false
    local local_config=false

    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--detect-only)
                detect_only=true
                shift
                ;;
            -f|--force)
                force_overwrite=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            --global)
                global_config=true
                shift
                ;;
            --local)
                local_config=true
                shift
                ;;
            -*)
                log_error "未知选项: $1"
                show_help
                exit 1
                ;;
            *)
                target_dir="$1"
                shift
                ;;
        esac
    done

    # 设置目标目录
    if [[ "$global_config" == true ]]; then
        target_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
        log_info "使用全局配置目录: $target_dir"
    elif [[ "$local_config" == true ]]; then
        target_dir="."
        log_info "使用本地配置目录: $(pwd)"
    fi

    # 确保目标目录存在
    if [[ ! -d "$target_dir" ]]; then
        log_error "目标目录不存在: $target_dir"
        exit 1
    fi

    log_info "开始ROS2 LSP配置..."
    log_info "目标目录: $(realpath "$target_dir")"

    # 检测ROS2
    log_info "检测ROS2环境..."
    local distros_info
    if ! distros_info=$(detect_ros2); then
        exit 1
    fi

    local distros=($distros_info)
    log_info "发现 ${#distros[@]} 个ROS2发行版"

    if [[ "$detect_only" == true ]]; then
        log_info "仅检测模式，显示发现的ROS2环境："
        for distro_info in "${distros[@]}"; do
            local distro_name="${distro_info##*:}"
            local distro_path="${distro_info%%:*}"
            echo "  ✓ $distro_name -> $distro_path"
        done
        exit 0
    fi

    # 选择ROS2发行版
    local selected_distro
    selected_distro=$(select_ros2_distro "${distros[@]}")
    local ros_path="${selected_distro%%:*}"
    local distro_name="${selected_distro##*:}"

    log_info "选择的ROS2发行版: $distro_name"
    log_info "ROS2路径: $ros_path"

    # 获取ROS2包列表
    log_info "扫描ROS2包..."
    local packages
    if ! packages=$(get_ros2_packages "$ros_path"); then
        log_error "无法获取ROS2包列表"
        exit 1
    fi

    # 检查输出文件
    local output_file="$target_dir/.clangd"
    if [[ -f "$output_file" && "$force_overwrite" != true ]]; then
        echo -n "配置文件已存在，是否覆盖？ [y/N]: "
        read -r overwrite
        if [[ "$overwrite" != [yY] ]]; then
            log_info "取消操作"
            exit 0
        fi
    fi

    # 生成配置
    generate_clangd_config "$ros_path" "$distro_name" "$packages" "$output_file"

    # 创建项目级配置脚本
    create_project_setup_script "$target_dir"

    log_info "================================"
    log_info "ROS2 LSP配置完成！"
    log_info "配置文件: $output_file"
    log_info "================================"
    log_info ""
    log_info "下一步操作："
    log_info "1. 在Neovim中打开ROS2 C++文件"
    log_info "2. 使用 :LspRestart 重启语言服务器"
    log_info "3. 测试代码补全和跳转功能"
    log_info ""
    log_info "项目级配置脚本已创建: $target_dir/setup_ros2_lsp.sh"
    log_info "在其他ROS2项目中运行该脚本可快速配置LSP"
}

# 执行主函数
main "$@"