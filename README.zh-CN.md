# Neovim Configuration

[English](./README.en.md) | [简体中文](./README.zh-CN.md)

一套以 `lazy.nvim` 为核心、面向日常开发与调试的 Neovim 配置。  
该配置强调开箱可用、模块化组织与可扩展性，适合作为个人主力环境。  
主打透明背景，整体背景跟随终端主题。

## 特性

- 插件管理：`lazy.nvim`（自动引导安装）
- 语法高亮：`nvim-treesitter`（自动安装解析器）
- LSP 与补全：已集成语言服务与补全相关配置
- 调试能力：`nvim-dap` + `nvim-dap-ui` + virtual text
- Markdown 体验：渲染增强 + 预览支持
- GitHub Copilot：插入模式自动触发建议
- 输入法切换（macOS）：退出插入模式后自动切换英文输入法

## 基础依赖

请先确保以下依赖可用：

1. `git`
2. `gcc` 或 `clang`（编译相关工具链）
3. `make`
4. `tree-sitter-cli`
5. Nerd Font（推荐：`0xProto Nerd Font Propo`）

安装 `tree-sitter-cli`：

```bash
# 方式一：cargo
cargo install --locked tree-sitter-cli

# 方式二：npm
npm install -g tree-sitter-cli
```

## 安装

将仓库克隆到 Neovim 配置目录：

对于Linux:

```bash
git clone https://github.com/leexxq/nvim.git ~/.config/nvim
```


对于Windows

```bash
git clone https://github.com/leexxq/nvim.git ~/AppData/Local/nvim
```

首次启动 `nvim` 时会自动引导安装 `lazy.nvim` 及插件。

### 一键安装依赖

仓库根目录提供跨平台依赖安装脚本：

```bash
python3 install_deps.py
```

常用参数：

```bash
# 一键安装
python3 install_deps.py 

# 跳过确认提示
python3 install_deps.py -y
```

## 可选依赖

### Markdown

`markdown-preview.nvim` 依赖 Node.js 生态，建议安装：

- `node`
- `npm`
- `yarn`（可选，但推荐）

### 搜索

- `rg`（ripgrep，用于快速全文检索）

### GitHub Copilot

- `node`（Copilot 插件运行依赖）

### 调试（DAP）

当前配置已提供 C++ 调试支持，默认使用 `codelldb`。  
请确保终端中 `codelldb` 命令可直接调用到可执行文件；如需调整路径，请修改：

`lua/core/plugins/dap.lua`

`codelldb` 可通过 Mason 安装，其他语言适配器可按 `nvim-dap` 官方方式扩展。

## 输入法集成

### macOS

已配置插入模式/普通模式输入法自动切换。  
请安装并确保 `macism` 可在终端直接调用。相关实现见：

`lua/core/custom/input.lua`

### Windows / Linux

当前仓库未提供通用输入法自动切换方案，可按个人输入法工具自行适配。

## 项目结构

```text
.
├── init.lua
├── lua/
│   └── core/
│       ├── options.lua
│       ├── keymaps.lua
│       ├── lazy.lua
│       ├── custom.lua
│       └── plugins/
└── lazy-lock.json
```

## 自定义

- 插件配置：`lua/core/plugins/`
- 编辑器基础行为：`lua/core/options.lua`
- 键位映射：`lua/core/keymaps.lua`
- 自定义逻辑（输入法、LSP 扩展等）：`lua/core/custom/`

建议在已有模块上增量修改，保持结构一致，便于后续维护。
