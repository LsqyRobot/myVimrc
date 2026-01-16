#!/usr/bin/env python3
"""
LSP 跳转功能测试文件
使用方法：
1. 用 nvim 打开这个文件：nvim /home/lucas/myVimrc/test_lsp.py
2. 等待几秒钟让 LSP 服务器启动
3. 将光标移动到下面的函数调用处
4. 按 'gd' 测试跳转到定义
5. 按 'gr' 查看所有引用
6. 按 'K' 查看文档
"""

import os
import sys


def hello_world():
    """这是一个测试函数"""
    print("Hello, World!")
    return "success"


def calculate_sum(a, b):
    """计算两个数的和"""
    result = a + b
    return result


def main():
    # 测试函数调用 - 将光标放在这些函数名上并按 'gd' 进行跳转测试
    hello_world()  # 光标放在 hello_world 上按 'gd' 应该跳转到函数定义
    result = calculate_sum(1, 2)  # 测试跳转到 calculate_sum
    print(f"计算结果: {result}")

    # 测试 Python 标准库跳转
    current_dir = os.getcwd()  # 光标放在 getcwd 上按 'gd' 测试 LSP
    print(f"当前目录: {current_dir}")


if __name__ == "__main__":
    main()