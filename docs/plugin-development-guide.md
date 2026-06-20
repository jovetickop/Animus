# Claude Code 插件开发与发布指南

以 `animus-toolkit` 为实例，从头到尾教你创建一个 Claude Code 插件并发布到 GitHub。

---

## 目录

1. [插件系统简介](#1-插件系统简介)
2. [创建插件项目](#2-创建插件项目)
3. [编写元数据](#3-编写元数据)
4. [添加技能](#4-添加技能)
5. [添加 Hook](#5-添加-hook)
6. [添加配置模板](#6-添加配置模板)
7. [添加自动配置脚本](#7-添加自动配置脚本)
8. [编写文档](#8-编写文档)
9. [添加许可证和忽略规则](#9-添加许可证和忽略规则)
10. [发布到 GitHub](#10-发布到-github)
11. [用户安装方式](#11-用户安装方式)
12. [后续开发流程](#12-后续开发流程)
13. [版本管理](#13-版本管理)
14. [常见问题](#14-常见问题)

---

## 1. 插件系统简介

### 插件结构

一个 Claude Code 插件本质上是一个**特定结构目录的 GitHub 仓库**。插件系统的工作流程如下：

```
用户执行 /plugin marketplace add owner/repo
    → Claude Code 克隆你的 GitHub 仓库
    → 读取 .claude-plugin/marketplace.json（发现这是一个市场）
    → 读取 .claude-plugin/plugin.json（了解插件信息）
    → 缓存到 ~/.claude/plugins/cache/
    → 用户启用后，skills、hooks 等生效
```

### 最小结构

```
my-plugin/
├── .claude-plugin/
│   ├── marketplace.json      # 必须：市场注册信息
│   └── plugin.json           # 必须：插件元数据
├── skills/                   # 推荐：技能文件
│   └── .../
├── hooks/                    # 可选：钩子脚本
├── README.md                 # 强烈推荐：文档
├── LICENSE                   # 推荐
└── package.json              # 推荐：npm 元数据
```

### 核心概念

| 术语 | 说明 |
|------|------|
| **marketplace** | 插件市场，一个 GitHub 仓库就是一个市场 |
| **marketplace name** | 市场名称，如 `animus-toolkit-marketplace` |
| **plugin** | 市场里包含的插件 |
| **plugin key** | 安装标识，格式 `插件名@市场名`，如 `animus-toolkit@animus-toolkit-marketplace` |
| **source: "./"** | 表示插件源码就在仓库根目录 |
| **CLAUDE_PLUGIN_ROOT** | 环境变量，指向插件当前版本的缓存安装路径 |

---

## 2. 创建插件项目

### 2.1 创建目录结构

```bash
# 在本地创建项目目录
mkdir my-plugin
cd my-plugin

# 创建核心目录
mkdir -p .claude-plugin
mkdir -p skills
mkdir -p hooks
mkdir -p config-templates
mkdir -p scripts
```

### 2.2 创建 .gitignore

```gitignore
# 技能子目录中按需生成的临时文件
.claude/commands/
.claude/agents/
.claude/rules/
.claude/harness/
.claude/templates/

# 编辑器
.idea/
.vscode/
*.swp
*~
.DS_Store
Thumbs.db
```

---

## 3. 编写元数据

### 3.1 plugin.json

插件描述文件，定义插件名称、版本、作者等信息。

```json
{
  "name": "my-plugin",
  "description": "插件的简短描述，会显示在安装界面",
  "version": "1.0.0",
  "author": {
    "name": "你的名字"
  },
  "homepage": "https://github.com/你的用户名/my-plugin",
  "repository": "https://github.com/你的用户名/my-plugin",
  "license": "MIT",
  "keywords": ["skills", "your-keyword"]
}
```

关键字段：

| 字段 | 说明 |
|------|------|
| `name` | **插件名**，安装命令中的前半部分。一经确定不建议更改 |
| `version` | **语义化版本号**，更新时递增 |
| `description` | 插件描述，会出现在 `/plugin list` 中 |

### 3.2 marketplace.json

市场注册文件。如果插件自身就是市场，`source` 设为 `"./"`。

```json
{
  "name": "my-plugin-marketplace",
  "description": "市场描述",
  "owner": {
    "name": "你的名字"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "description": "插件的详细描述",
      "version": "1.0.0",
      "source": "./"
    }
  ]
}
```

关键字段：

| 字段 | 说明 |
|------|------|
| `name` | **市场名**，安装命令中的后半部分。全局唯一 |
| `plugins[].source` | 插件源码位置。`"./"` 表示就在这个仓库根目录 |
| `plugins[].name` | 必须与 `plugin.json` 中的 `name` 一致 |

### 3.3 package.json

虽然 Claude Code 不直接使用 npm，但插件系统会读取此文件。

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "插件的简短描述",
  "license": "MIT",
  "type": "module"
}
```

> **注意**：`plugin.json`、`marketplace.json`、`package.json` 三者的 `version` 必须保持一致。

---

## 4. 添加技能

### 4.1 技能目录结构

每个技能是一个独立目录，放在 `skills/` 下：

```
skills/
├── my-skill/
│   ├── SKILL.md          # 必须：技能入口文件
│   ├── README.md         # 推荐：技能说明
│   ├── scripts/          # 可选：辅助脚本
│   └── templates/        # 可选：模板文件
└── another-skill/
    └── SKILL.md
```

### 4.2 SKILL.md 格式

```markdown
---
name: my-skill
description: "技能触发条件描述。用于 Claude 判断何时自动调用此技能"
---

# 技能标题

## 适用场景
- 场景1
- 场景2

## 使用方式
[技能的具体工作流程]

## 注意事项
[路径引用、依赖等说明]
```

### 4.3 关于路径引用（重要）

SKILL.md 中引用其他文件时需注意路径解析方式：

| 引用方式 | 解析路径 | 说明 |
|---------|---------|------|
| `.claude/harness/` | 用户当前工作目录下的 `.claude/harness/` | 指向目标项目 |
| `$CLAUDE_PLUGIN_ROOT/hooks/statusline.sh` | 插件缓存目录下的 hooks/ | 指向插件自身文件 |
| `~/.claude/skills/my-skill/` | 用户 skills 目录 | 本地直接复制模式 |

**推荐做法**：
- 如果文件在技能目录内（供技能自身使用），用 `$CLAUDE_PLUGIN_ROOT` 引用
- 如果文件在目标项目中（供用户项目使用），用相对路径引用
- 如果首次使用需要复制文件到目标项目，在 SKILL.md 中说明

### 4.4 从 GitHub 拉取技能到插件（推荐）

在打包插件时，从技能的原 GitHub 仓库拉取最新版本，而不是从本地复制：

```bash
# 从 GitHub 克隆最新版本
git clone https://github.com/作者/技能仓库.git skills/你的技能名

# 删除 Git 元数据（因为这是嵌入到插件仓库中的）
rm -rf skills/你的技能名/.git

# 删除不需要的开发文档
rm -rf skills/你的技能名/.planning  # 如果存在
rm -rf skills/你的技能名/.github
```

### 4.5 从本地复制技能

```bash
cp -r ~/.claude/skills/你的技能名 skills/你的技能名/
```

---

## 5. 添加 Hook

### 5.1 Hook 文件

将脚本放在 `hooks/` 目录下：

```
hooks/
└── statusline.sh          # 状态栏脚本
```

### 5.2 无外部依赖原则

Hook 脚本**不应依赖外部工具**（如 jq、python 等），以确保跨平台可用。

**错误做法**（依赖 jq）：
```bash
session=$(echo "$input" | jq -r '.session_name')
```

**正确做法**（使用内置命令）：
```bash
session=$(echo "$input" | grep -o '"session_name":"[^"]*"' | head -1 | sed 's/"session_name":"//;s/"//')
```

### 5.3 Hook 类型

| 类型 | 配置位置 | 说明 |
|------|---------|------|
| statusLine | `settings.json` 中 `statusLine` 字段 | 底部状态栏 |
| PreToolUse / PostToolUse | 项目 `.claude/hooks/hooks.json` | 工具调用前后 |
| SessionStart | 项目 `.claude/hooks/hooks.json` | 会话启动时 |
| Stop | 项目 `.claude/hooks/hooks.json` | 会话结束时 |

### 5.4 Hook 注册方式

**方式一：statusLine**（在 `~/.claude/settings.json` 中配置）
```json
"statusLine": {
  "command": "bash <实际安装路径>/hooks/statusline.sh",
  "type": "command"
}
```

**方式二：事件 Hook**（在项目 `.claude/hooks/hooks.json` 中配置）
```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/scripts/format-all.py\"",
          "type": "command",
          "timeout": 15
        }
      ]
    }
  ]
}
```

---

## 6. 添加配置模板

### 6.1 模板文件

放在 `config-templates/` 下，供用户参考：

```
config-templates/
├── settings.template.json    # Claude Code 全局配置模板
├── mcp.template.json         # MCP 服务器配置示例
└── README.md                 # 模板使用说明
```

### 6.2 模板规范

**重要规则**：
- 所有 `.template.json` 文件必须是**标准 JSON 格式**，不含注释
- 敏感信息用 `<占位符>` 替代
- 说明文字只写在 README 中

```json
{
  "mcpServers": {
    "example": {
      "command": "npx",
      "args": [
        "-y",
        "<YOUR_MCP_PACKAGE>"
      ]
    }
  }
}
```

---

## 7. 添加自动配置脚本

### 7.1 为什么需要自动配置

用户安装插件后，某些配置（如 statusLine）需要写入 `~/.claude/settings.json`。手动编辑 JSON 文件对用户不友好，且容易出错。

自动配置脚本应：

1. **自动检测插件安装路径**（通过脚本自身位置推算）
2. **冲突检测**：如果用户已有相同配置，询问保留还是覆盖
3. **逐项处理**：每个配置项单独询问，避免批量覆盖

### 7.2 setup.ps1 示例（旧版，不推荐使用）

> **注意**：以下为早期版本的字符串替换示例，容易出错（括号嵌套、逗号残留等）。推荐使用 7.3 节的 PSObject 方法。

```powershell
# setup.ps1 — 自动配置脚本
# 运行方式：powershell -File setup.ps1

# 自动检测插件安装路径（根据脚本自身位置推算）
$pluginDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$settingsPath = "$env:USERPROFILE\.claude\settings.json"

Write-Host "=== 自动配置 ===" -ForegroundColor Cyan

# 读取或初始化 settings.json
$content = Get-Content $settingsPath -Raw -ErrorAction SilentlyContinue
if (-not $content) { $content = "{}" }

# statusLine 冲突处理
if ($content -match '"statusLine"') {
  $choice = Read-Host "检测到已有 statusLine 配置，是否覆盖为插件版本？(y=覆盖/n=保留) [n]"
  if ($choice -eq 'y') {
    # 清除旧的 statusLine
    $content = $content -replace '"statusLine"\s*:\s*\{[\s\S]*?\}(,\s*)?', ''
    $modified = $true
  }
}

# 环境变量冲突处理（逐条询问）
$envVars = @{ "KEY" = "value" }
foreach ($key in $envVars.Keys) {
  $pattern = '"' + $key + '"\s*:\s*"[^"]*"'
  if ($content -match $pattern) {
    $currentValue = [regex]::Match($content, $pattern).Value
    $choice = Read-Host "检测到 $key，是否覆盖？(y/n) [n]"
    if ($choice -eq 'y') {
      $content = $content -replace $pattern, "`"$key`": `"$($envVars[$key])`""
    }
  }
}

# 写回文件
if ($modified) {
  # 使用 ConvertFrom-Json / ConvertTo-Json 确保格式正确
  $jsonObj = $content | ConvertFrom-Json
  $jsonObj | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
}
```

### 7.3 推荐做法：用对象操作替代字符串替换

字符串替换 JSON 容易出错（括号嵌套、逗号残留等），推荐用 PowerShell 的对象操作：

```powershell
$jsonObj = Get-Content $settingsPath -Raw | ConvertFrom-Json
if (-not $jsonObj.statusLine) {
  $jsonObj | Add-Member -NotePropertyName "statusLine" -NotePropertyValue @{
    command = "bash $statuslinePath"
    type = "command"
  }
}
$jsonObj | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
```

### 7.4 跨平台支持

如果插件需要支持 Mac/Linux，提供对应的 bash 版本：

```
scripts/
├── setup.ps1       # Windows
└── setup.sh        # Mac/Linux
```

---

## 8. 编写文档

### 8.1 README.md

中文 README 应包含以下章节：

```markdown
# 插件名称

插件的用途和简介。

## 包含的内容

### 技能名 — 技能说明
- 功能描述
- 触发场景
- 使用效果

### Hook 名 — 功能说明
- 显示内容
- 依赖说明

## 安装指南

### 方式一：通过 GitHub 市场（推荐）

```bash
/plugin marketplace add 用户名/仓库名
/plugin install 插件名@市场名
```

### 方式二：通过 Git URL（备选）

```json
在 extraKnownMarketplaces 中添加 URL 源
```

## 验证安装

```bash
/plugin list
```

## 状态栏配置（如有）

运行自动配置脚本。

## 故障排除

| 问题 | 原因 | 解决方法 |
|------|------|---------|

## 许可证
```

### 8.2 CLAUDE.md

CLAUDE.md 在插件仓库中同时面向两类用户：

```markdown
# 前半部分：给使用者
说明如何安装和使用。

---

# 后半部分：给贡献者
说明如何新增技能、发布版本等开发指引。
```

---

## 9. 添加许可证和忽略规则

### 9.1 LICENSE（MIT）

```
MIT License

Copyright (c) 2026 你的名字

Permission is hereby granted...
```

### 9.2 .gitignore

参考标准忽略规则，确保不提交不必要的文件。

### 9.3 验证 JSON 格式

所有 `.json` 文件必须可通过标准 JSON 解析器解析：

```bash
# 使用 Node.js 验证
node -e "JSON.parse(require('fs').readFileSync('.claude-plugin/plugin.json','utf8')); console.log('OK')"

# 或使用 PowerShell 验证
powershell -c "Get-Content .claude-plugin/plugin.json | ConvertFrom-Json | Out-Null; Write-Host 'OK'"
```

---

## 10. 发布到 GitHub

### 10.1 创建 GitHub 仓库

在 GitHub 上创建新仓库 `你的用户名/你的插件名`（不要勾选 README 和 LICENSE，因为本地已有）。

### 10.2 推送代码

```bash
# 在本地项目目录执行
git init
git add -A
git commit -m "feat: initial plugin release v1.0.0"

# 添加远程仓库
git remote add origin https://github.com/你的用户名/你的插件名.git
git branch -M main
git push -u origin main
```

### 10.3 创建 Release

```bash
# 打标签
git tag v1.0.0
git push origin v1.0.0

# 或者通过 GitHub Web 界面创建 Release
# 访问 https://github.com/你的用户名/你的插件名/releases
# 点击 "Create a new release"
```

创建 Release 的好处：
- 用户可以看到版本变更历史
- 便于后续版本管理和回滚
- 插件系统根据版本号缓存

---

## 11. 用户安装方式

### 11.1 方式一：GitHub 市场（推荐）

用户执行：

```bash
# 第一步：添加你的仓库为市场
/plugin marketplace add 你的用户名/你的插件名

# 第二步：安装插件
/plugin install 插件名@市场名

# 第三步（如果已添加过市场，只执行第二步即可）
/plugin install 插件名@市场名
```

添加市场后 Claude Code 会在 `~/.claude/settings.json` 中写入：
```json
"extraKnownMarketplaces": {
  "你的市场名": {
    "source": {
      "source": "github",
      "repo": "你的用户名/你的插件名"
    }
  }
}
```

### 11.2 方式二：Git URL（备选）

适用于 Gitee、GitLab、Phabricator 等平台：

```json
// 在 ~/.claude/settings.json 的 extraKnownMarketplaces 中添加：
"你的市场名": {
  "source": {
    "source": "url",
    "url": "https://你的git平台.com/你的用户名/你的插件名.git"
  }
}
```

然后执行 `/plugin install 插件名@市场名`。

> ⚠️ 此方式未经充分测试。所有现有 marketplace 均使用 `"source": "github"`。

### 11.3 方式三：本地直放 skills 目录

```bash
git clone https://github.com/你的用户名/你的插件名.git
cp -r skills/* ~/.claude/skills/
```

这是最通用的方式，不受插件市场系统限制。

### 11.4 用户更新插件

```bash
/plugin update 插件名@市场名
```

---

## 12. 后续开发流程

### 12.1 新增技能

```bash
# 1. 从 GitHub 拉取最新技能（如果有独立仓库）
git clone https://github.com/作者/技能仓库.git skills/新技能名
rm -rf skills/新技能名/.git

# 或从本地复制
cp -r ~/.claude/skills/新技能名 skills/新技能名/

# 2. 更新 plugin.json 的描述和关键词
# 3. 更新 README.md
# 4. 提交
git add skills/新技能名/
git commit -m "feat: add 新技能名 skill"
```

### 12.2 更新技能内容

```bash
# 1. 删除旧版本
rm -rf skills/技能名

# 2. 拉取新版本
git clone https://github.com/作者/技能仓库.git skills/技能名
rm -rf skills/技能名/.git

# 3. 验证内容完整性
# 4. 递增版本号
# 5. 提交
```

### 12.3 新增 Hook

```bash
# 1. 将脚本放到 hooks/ 目录
cp 你的脚本 hooks/新脚本.sh

# 2. 在 README 中说明配置方式
# 3. 在 config-templates/ 中添加对应配置示例
# 4. 提交
```

### 12.4 新增配置模板

```bash
# 1. 在 config-templates/ 下创建模板文件
# 2. 确保是纯 JSON，不含注释
# 3. 敏感信息用 <占位符> 替代
# 4. 更新 config-templates/README.md
# 5. 提交
```

### 12.5 修复 setup.ps1

修改后测试：

```powershell
# 模拟测试：用临时文件测试 JSON 操作
$testSettings = @"
{
  "language": "Chinese",
  "statusLine": {
    "command": "bash /old/path/statusline.sh",
    "type": "command"
  },
  "env": {
    "EXISTING_KEY": "old_value"
  }
}
"@
# 用此测试数据验证脚本的冲突检测和替换逻辑
```

---

## 13. 版本管理

### 13.1 语义化版本号

| 版本 | 变更类型 | 示例 |
|------|---------|------|
| **patch** | bug 修复、文档更新 | 1.0.0 → 1.0.1 |
| **minor** | 新增技能/功能 | 1.0.0 → 1.1.0 |
| **major** | 破坏性变更 | 1.0.0 → 2.0.0 |

### 13.2 版本号同步位置

更新版本时必须修改以下三个文件：

1. `.claude-plugin/plugin.json` — `version` 字段
2. `.claude-plugin/marketplace.json` — `plugins[0].version` 字段
3. `package.json` — `version` 字段

### 13.3 发布新版本流程

```bash
# 1. 更新所有版本号
# 2. 提交变更
git add .
git commit -m "chore: bump version to 1.1.0"

# 3. 打标签
git tag v1.1.0

# 4. 推送
git push origin main
git push origin v1.1.0

# 5. 在 GitHub 创建 Release
# 填写变更日志（Changelog）
```

### 13.4 变更日志建议

每次 Release 的变更内容参考：

```markdown
## v1.1.0

### Added
- 新增 xxx 技能
- 新增 xxx hook

### Changed
- 更新 xxx 到最新版本

### Fixed
- 修复 xxx 问题
```

---

## 14. 常见问题

### Q: 插件安装后看不到？

检查 `~/.claude/settings.json` 的 `enabledPlugins` 中是否有对应条目：
```json
"enabledPlugins": {
  "你的插件名@你的市场名": true
}
```

如果没有，手动添加后执行 `/reload-plugins`。

### Q: 更新技能后用户那边没变？

用户需执行 `/plugin update 你的插件名@你的市场名` 来拉取新版本。如果是重大更新，建议在 GitHub Release 中说明。

### Q: 技能路径引用在插件模式下出问题？

SKILL.md 中引用的相对路径（如 `.claude/agents/`）在插件安装模式下会被解析为用户当前工作目录下的路径，而非技能目录下的路径。

**解决方案**：
- 使用 `$CLAUDE_PLUGIN_ROOT` 环境变量定位插件内部文件
- 或在 SKILL.md 中设计首次使用时的初始化逻辑（自动复制文件到目标项目）

### Q: 如何批量安装到多台电脑？

将插件仓库 clone 到内部 Git 服务器，用户通过方式二（URL 方式）或方式三（手动复制）安装。也可以生成离线安装包，使用步骤如下：

```bash
# 1. 在联网电脑上打包
plugin-offline-packager 打包 你的插件名

# 2. 将离线包拷贝到目标电脑
# 3. 双击 install.bat 完成安装
```

### Q: Mac/Linux 下 setup.ps1 不能用？

PowerShell 在 Mac/Linux 下也可用（需要安装 `pwsh`），但更推荐提供对应的 shell 脚本（`setup.sh`）。如果不提供，用户只需手动在 `settings.json` 中添加 statusLine 配置的 JSON 片段。

### Q: 如何让用户知道插件更新了？

- 在 GitHub Release 中写详细的 Changelog
- 在 README 中维护版本历史
- 用户执行 `/plugin update` 时 Claude Code 会自动拉取最新版本
