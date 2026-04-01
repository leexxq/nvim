# Neovim Configuration

[English](./README.md) | [简体中文](./README.zh-CN.md)

A Neovim setup built around `lazy.nvim` for daily development and debugging.  
This configuration focuses on out-of-the-box usability, modular structure, and easy customization.  
It is designed with transparent background styling so the editor background follows your terminal theme.

## Features

- Plugin management: `lazy.nvim` (auto bootstrap)
- Syntax highlighting: `nvim-treesitter` (auto parser install)
- LSP and completion: preconfigured core workflow
- Debugging: `nvim-dap` + `nvim-dap-ui` + virtual text
- Markdown experience: enhanced rendering + preview
- GitHub Copilot: auto-trigger suggestions in insert mode
- Input method switch (macOS): auto switch to English on leaving insert mode

## Requirements

Please make sure the following dependencies are available:

1. `git`
2. `gcc` or `clang` (build toolchain)
3. `make`
4. `tree-sitter-cli`
5. Nerd Font (recommended: `0xProto Nerd Font Propo`)

Install `tree-sitter-cli`:

```bash
# Option 1: cargo
cargo install --locked tree-sitter-cli

# Option 2: npm
npm install -g tree-sitter-cli
```

## Installation

Clone this repository into your Neovim config directory:

Linux:

```bash
git clone https://github.com/leexxq/nvim.git ~/.config/nvim
```

Windows:

```bash
git clone https://github.com/leexxq/nvim.git ~/AppData/Local/nvim
```

On first launch, `nvim` will bootstrap `lazy.nvim` and install plugins automatically.

### One-command dependency setup

A cross-platform dependency installer is provided in the repository root:

```bash
python3 install_deps.py
```

Common options:

```bash
# one-command install 
python3 install_deps.py

# Skip confirmation prompt
python3 install_deps.py -y
```

## Optional Dependencies

### Markdown

`markdown-preview.nvim` relies on the Node.js ecosystem. Recommended:

- `node`
- `npm`
- `yarn` (optional but recommended)

### Search

- `rg` (ripgrep for fast project-wide search)

### GitHub Copilot

- `node` (runtime dependency for Copilot plugin)

### Debug (DAP)

This config currently includes C++ debugging via `codelldb`.  
Make sure `codelldb` is available in your terminal `PATH`. If needed, adjust:

`lua/core/plugins/dap.lua`

You can install `codelldb` via Mason; for other adapters, follow `nvim-dap` docs.

## Input Method Integration

### macOS

Insert/normal mode input method switching is configured.  
Please install `macism` and ensure it is executable in terminal. See:

`lua/core/custom/input.lua`

### Windows / Linux

No universal input method auto-switch solution is included in this repository yet.

## Project Structure

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

## Customization

- Plugin configs: `lua/core/plugins/`
- Editor behavior: `lua/core/options.lua`
- Keymaps: `lua/core/keymaps.lua`
- Custom logic (input method, LSP extension, etc.): `lua/core/custom/`

It is recommended to extend existing modules incrementally for easier maintenance.
