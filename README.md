# animus-toolkit

JiangJie 的 Claude Code 个人工具包。

## 包含的内容

### Skills

| 技能 | 说明 | 路径 |
|------|------|------|
| **harness-cc** | 编码工作流引擎。输入 PRD+方案文档，自动拆解为可执行任务列表，按状态机逐个推进，验收后提交。支持 C++/Qt、Python、Node.js、Rust、Go。 | `skills/harness-cc/SKILL.md` |
| **tdd-workflow** | TDD 工作流子技能，通过 `/tdd-workflow` 显式调用。 | `skills/harness-cc/.claude/skills/tdd-workflow/SKILL.md` |

### Hooks

| 名称 | 说明 | 依赖 |
|------|------|------|
| **statusline** | 底部状态栏，显示 session 名称、模型名、工作目录、上下文余量百分比、Vim 模式。使用 grep/sed 解析 JSON，无需安装 jq。 | 无 |

### 配置模板

| 文件 | 说明 |
|------|------|
| `config-templates/settings.template.json` | Claude Code 通用配置模板（中文语言、Workflows、环境变量等） |
| `config-templates/mcp.template.json` | MCP 服务器配置示例框架 |

### 脚本

| 文件 | 说明 |
|------|------|
| `scripts/setup.ps1` | Windows 自动配置脚本。自动检测插件路径，写入 statusLine 配置到 settings.json。如已有配置，逐项询问是否覆盖。 |

## 开发者指南

详细的插件开发、发布、更新指南请参见 [docs/plugin-development-guide.md](docs/plugin-development-guide.md)。

## 安装指南

### 方式一：通过 GitHub 市场（推荐）

```bash
/plugin marketplace add JiangJie/animus-toolkit
/plugin install animus-toolkit@animus-toolkit-marketplace
```

编辑 `~/.claude/settings.json`，在 `enabledPlugins` 中添加：

```json
"animus-toolkit@animus-toolkit-marketplace": true
```

执行 `/reload-plugins` 或重启 Claude Code。

### 方式二：通过 Git URL（适用于 Gitee/GitLab/Phabricator 等平台）

在 `~/.claude/settings.json` 的 `extraKnownMarketplaces` 中添加：

```json
"animus-toolkit": {
  "source": {
    "source": "url",
    "url": "https://github.com/JiangJie/animus-toolkit.git"
  }
}
```

然后执行 `/plugin install animus-toolkit@animus-toolkit-marketplace`。

> ⚠️ 此方式未经充分测试。如果遇到问题请改用方式一。

## 状态栏配置

安装后运行自动配置脚本：

```bash
# Windows
powershell -File ~/.claude/plugins/cache/animus-toolkit-marketplace/animus-toolkit/1.0.0/scripts/setup.ps1
```

脚本会自动检测插件路径并写入配置到 `settings.json`。如果已有 statusLine、环境变量等配置，会逐项询问是否覆盖。

> Mac/Linux 用户：请手动在 `~/.claude/settings.json` 中添加以下配置：
> ```json
> "statusLine": {
>   "command": "bash ~/.claude/plugins/cache/animus-toolkit-marketplace/animus-toolkit/1.0.0/hooks/statusline.sh",
>   "type": "command"
> }
> ```
> 将路径中的 `1.0.0` 替换为实际安装的版本号。

## 验证安装

```bash
/plugin list
```

列表中显示 `animus-toolkit@animus-toolkit-marketplace` 即为安装成功。

## 更新

```bash
/plugin update animus-toolkit@animus-toolkit-marketplace
```

## 故障排除

| 问题 | 可能原因 | 解决方法 |
|------|---------|---------|
| `/plugin list` 看不到插件 | 未启用 | 检查 `enabledPlugins` |
| statusline 不显示 | 未配置或路径不对 | 运行 `setup.ps1` 自动配置 |

## 许可证

MIT
