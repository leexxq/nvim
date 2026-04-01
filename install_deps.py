#!/usr/bin/env python3
"""
Cross-platform dependency installer for this Neovim configuration.
"""

from __future__ import annotations

import argparse
import platform
import shutil
import subprocess
import sys
from dataclasses import dataclass
from typing import Iterable


@dataclass(frozen=True)
class InstallTask:
    name: str
    check_cmd: list[str]
    install_cmds: list[list[str]]
    required: bool = True
    note: str | None = None


def command_exists(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def run(cmd: list[str], dry_run: bool = False) -> bool:
    print("$ " + " ".join(cmd))
    if dry_run:
        return True
    try:
        subprocess.run(cmd, check=True)
        return True
    except subprocess.CalledProcessError:
        return False


def is_installed(check_cmd: Iterable[str]) -> bool:
    try:
        subprocess.run(
            list(check_cmd),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except Exception:
        return False


def linux_pkg_manager() -> str | None:
    for pm in ("apt-get", "dnf", "pacman", "zypper"):
        if command_exists(pm):
            return pm
    return None


def build_tasks() -> tuple[list[InstallTask], list[str]]:
    system = platform.system().lower()
    warnings: list[str] = []

    if system == "darwin":
        if not command_exists("brew"):
            raise RuntimeError("Homebrew 未安装，请先安装：https://brew.sh")
        tasks = [
            InstallTask("git", ["git", "--version"], [["brew", "install", "git"]]),
            InstallTask("make", ["make", "--version"], [["brew", "install", "make"]]),
            InstallTask("node", ["node", "--version"], [["brew", "install", "node"]]),
            InstallTask("ripgrep", ["rg", "--version"], [["brew", "install", "ripgrep"]], required=False),
            InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
            InstallTask("yarn", ["yarn", "--version"], [["npm", "install", "-g", "yarn"]], required=False),
            InstallTask("codelldb", ["codelldb", "--version"], [["brew", "install", "codelldb"]], required=False),
            InstallTask("macism", ["macism"], [["brew", "install", "laishulu/homebrew/macism"]], required=False),
        ]
        return tasks, warnings

    if system == "linux":
        pm = linux_pkg_manager()
        if not pm:
            raise RuntimeError("未找到支持的包管理器（apt-get/dnf/pacman/zypper）。")

        if pm == "apt-get":
            tasks = [
                InstallTask("git", ["git", "--version"], [["sudo", "apt-get", "update"], ["sudo", "apt-get", "install", "-y", "git"]]),
                InstallTask("build-essential", ["make", "--version"], [["sudo", "apt-get", "install", "-y", "build-essential"]]),
                InstallTask("node", ["node", "--version"], [["sudo", "apt-get", "install", "-y", "nodejs", "npm"]]),
                InstallTask("ripgrep", ["rg", "--version"], [["sudo", "apt-get", "install", "-y", "ripgrep"]], required=False),
                InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
                InstallTask("yarn", ["yarn", "--version"], [["npm", "install", "-g", "yarn"]], required=False),
            ]
        elif pm == "dnf":
            tasks = [
                InstallTask("git", ["git", "--version"], [["sudo", "dnf", "install", "-y", "git"]]),
                InstallTask("make/gcc/clang", ["make", "--version"], [["sudo", "dnf", "install", "-y", "make", "gcc", "clang"]]),
                InstallTask("node", ["node", "--version"], [["sudo", "dnf", "install", "-y", "nodejs", "npm"]]),
                InstallTask("ripgrep", ["rg", "--version"], [["sudo", "dnf", "install", "-y", "ripgrep"]], required=False),
                InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
                InstallTask("yarn", ["yarn", "--version"], [["npm", "install", "-g", "yarn"]], required=False),
            ]
        elif pm == "pacman":
            tasks = [
                InstallTask("git", ["git", "--version"], [["sudo", "pacman", "-S", "--noconfirm", "--needed", "git"]]),
                InstallTask("build tools", ["make", "--version"], [["sudo", "pacman", "-S", "--noconfirm", "--needed", "base-devel", "clang"]]),
                InstallTask("node", ["node", "--version"], [["sudo", "pacman", "-S", "--noconfirm", "--needed", "nodejs", "npm"]]),
                InstallTask("ripgrep", ["rg", "--version"], [["sudo", "pacman", "-S", "--noconfirm", "--needed", "ripgrep"]], required=False),
                InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
                InstallTask("yarn", ["yarn", "--version"], [["sudo", "pacman", "-S", "--noconfirm", "--needed", "yarn"]], required=False),
            ]
        else:
            tasks = [
                InstallTask("git", ["git", "--version"], [["sudo", "zypper", "install", "-y", "git"]]),
                InstallTask("make/gcc/clang", ["make", "--version"], [["sudo", "zypper", "install", "-y", "make", "gcc", "clang"]]),
                InstallTask("node", ["node", "--version"], [["sudo", "zypper", "install", "-y", "nodejs", "npm"]]),
                InstallTask("ripgrep", ["rg", "--version"], [["sudo", "zypper", "install", "-y", "ripgrep"]], required=False),
                InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
                InstallTask("yarn", ["yarn", "--version"], [["npm", "install", "-g", "yarn"]], required=False),
            ]

        warnings.append("Linux 下 codelldb 建议通过 Mason 或发行版包管理器单独安装。")
        return tasks, warnings

    if system == "windows":
        if command_exists("winget"):
            def w(pkg: str) -> list[str]:
                return [
                    "winget", "install", "--id", pkg, "-e",
                    "--accept-package-agreements", "--accept-source-agreements",
                ]

            tasks = [
                InstallTask("git", ["git", "--version"], [w("Git.Git")]),
                InstallTask("node", ["node", "--version"], [w("OpenJS.NodeJS.LTS")]),
                InstallTask("ripgrep", ["rg", "--version"], [w("BurntSushi.ripgrep.MSVC")], required=False),
                InstallTask("yarn", ["yarn", "--version"], [w("Yarn.Yarn")], required=False),
                InstallTask("tree-sitter-cli", ["tree-sitter", "--version"], [["npm", "install", "-g", "tree-sitter-cli"]]),
                InstallTask("codelldb", ["codelldb", "--version"], [w("vadimcn.vscode-lldb")], required=False),
            ]
            warnings.append("Windows 下 gcc/make 可通过 MSYS2 或 MinGW 单独配置。")
            return tasks, warnings

        raise RuntimeError("Windows 未检测到 winget，请先安装 winget 后重试。")

    raise RuntimeError(f"不支持的系统：{platform.system()}")


def install_all(tasks: list[InstallTask], dry_run: bool) -> int:
    failed_required: list[str] = []
    failed_optional: list[str] = []

    for task in tasks:
        if is_installed(task.check_cmd):
            print(f"[OK] {task.name} 已安装")
            continue

        print(f"[INSTALL] {task.name}")
        ok = True
        for cmd in task.install_cmds:
            if not run(cmd, dry_run=dry_run):
                ok = False
                break

        if ok:
            print(f"[DONE] {task.name}")
        else:
            print(f"[FAIL] {task.name}")
            if task.note:
                print(f"  note: {task.note}")
            if task.required:
                failed_required.append(task.name)
            else:
                failed_optional.append(task.name)

    print("\n===== Summary =====")
    print("Required failed: " + (", ".join(failed_required) if failed_required else "none"))
    print("Optional failed: " + (", ".join(failed_optional) if failed_optional else "none"))
    return 1 if failed_required else 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Install dependencies for this Neovim config.")
    parser.add_argument("--dry-run", action="store_true", help="Only print commands without executing")
    parser.add_argument("-y", "--yes", action="store_true", help="Skip confirmation")
    args = parser.parse_args()

    try:
        tasks, warnings = build_tasks()
    except RuntimeError as err:
        print(f"[ERROR] {err}")
        return 1

    print(f"Detected OS: {platform.system()}")
    for w in warnings:
        print(f"[WARN] {w}")

    if not args.yes:
        ans = input("Proceed to install dependencies? [y/N]: ").strip().lower()
        if ans not in ("y", "yes"):
            print("Cancelled.")
            return 0

    return install_all(tasks, dry_run=args.dry_run)


if __name__ == "__main__":
    sys.exit(main())
