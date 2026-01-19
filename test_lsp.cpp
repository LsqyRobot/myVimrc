/**
 * LSP 跳转功能测试文件 (C++)
 * 使用方法：
 * 1. 用 nvim 打开这个文件：nvim /home/lucas/myVimrc/test_lsp.cpp
 * 2. 等待几秒钟让 LSP 服务器启动
 * 3. 将光标移动到下面的函数调用处
 * 4. 按 'gd' 测试跳转到定义
 * 5. 按 'gr' 查看所有引用
 * 6. 按 'K' 查看文档
 */

#include <iostream>
#include <string>
#include <vector>

class Calculator {
public:
  /**
   * 计算两个数的和
   * @param a 第一个数
   * @param b 第二个数
   * @return 两数之和
   */
  int add(int a, int b) { return a + b; }

  /**
   * 计算两个数的乘积
   */
  int multiply(int a, int b) { return a * b; }
};

// 全局函数
void printMessage(const std::string &message) {
  std::cout << "Message: " << message << std::endl;
}

int main() {
  Calculator calc; // 光标放在 Calculator 上按 'gd' 应该跳转到类定义

  // 测试成员函数跳转
  int sum = calc.add(5, 3);          // 光标放在 add 上按 'gd' 测试跳转
  int product = calc.multiply(4, 7); // 光标放在 multiply 上按 'gd' 测试跳转

  std::cout << "Sum: " << sum << std::endl;
  std::cout << "Product: " << product << std::endl;

  // 测试函数调用跳转
  printMessage("LSP test successful"); // 光标放在 printMessage 上测试

  // 测试标准库跳转
  std::vector<int> numbers = {1, 2, 3, 4, 5}; // 光标放在 vector 上测试
  std::cout << "Vector size: " << numbers.size()
            << std::endl; // 测试 size() 跳转

  return 0;
}
