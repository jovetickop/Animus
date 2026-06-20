# 状态栏配置

## 概述

animus 提供了一个 `statusline.sh` 钩子脚本，用于在 Claude Code 底部显示状态栏。状态栏包含以下信息：

- Session 名称
- 模型名
- 工作目录
- 上下文余量百分比
- Vim 模式

脚本使用 `grep`/`sed` 解析 JSON，无需安装 `jq`，无外部依赖。

## 自动配置（推荐）

安装插件后运行自动配置脚本：

```bash
# Windows
# 路径中的 <版本号> 请替换为实际安装的版本号（如 1.0.0）
powershell -File ~/.claude/plugins/cache/animus-marketplace/animus/<版本号>/scripts/setup.ps1
```

脚本会自动检测插件路径并写入配置到 `settings.json`。如果已有 `statusLine`、环境变量等配置，会逐项询问是否覆盖。

## 手动配置

在 `~/.claude/settings.json` 中添加：

```json
"statusLine": {
  "command": "bash ~/.claude/plugins/cache/animus-marketplace/animus/<版本号>/hooks/statusline.sh",
  "type": "command"
}
```

将 `<版本号>` 替换为实际安装的版本号（如 `1.0.0`）。

## Mac/Linux 用户

在 `~/.claude/settings.json` 中添加上述手动配置即可。`statusline.sh` 为纯 bash 脚本，无额外依赖。

## 故障排除

| 问题 | 解决方法 |
|------|---------|
| 底部不显示状态栏 | 运行 `setup.ps1`，或检查 `settings.json` 中 `statusLine` 配置是否正确 |
| 路径不对 | 确认 `~/.claude/plugins/cache/animus-marketplace/animus/` 下的版本号目录名 |

## 脚本源码

插件安装后位于 `hooks/statusline.sh`，可通过插件更新获取最新版本。
