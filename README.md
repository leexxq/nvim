# 需要安装的依赖

1. git
2. neovim

# 编辑说明

## 其他环境依赖

### 对于markdown

1. yarn
2. npm
3. node-js

### 对于模糊搜索

1. fzf
2. Rg
3. Ag

### 对于dap

目前提供了对c++的支持，现在dap的adapter是codelldb，注意在终端中codelldb命令确保已经指向codelldb的可执行文件，请检查plugins/dap.lua中的配置。

## 对于输入法

1. macos

 记得安装macism，并且确定能够在终端使用,具体请见./lua/core/custom/input.lua

2. windows

  对于不同的输入法有不同的解决方案，不提供。
