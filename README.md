# animus-toolkit

jovetickop 的 Claude Code 个人工具包。包含 **22 个技能**（20 个 superpowers-zh 中文技能 + harness-cc 编码工作流引擎 + tdd-workflow），statusline 状态栏，以及配置模板。

## 包含的内容

### Skills

#### 核心工作流

| 技能 | 说明 | 路径 |
|------|------|------|
| **harness-cc** | 编码工作流引擎。输入 PRD+方案文档，自动拆解为可执行任务列表，按状态机逐个推进，验收后提交。支持 C++/Qt、Python、Node.js、Rust、Go。 | `skills/harness-cc/SKILL.md` |
| **tdd-workflow** | TDD 工作流子技能，通过 `/tdd-workflow` 显式调用。 | `skills/harness-cc/.claude/skills/tdd-workflow/SKILL.md` |
| **brainstorming** | 在实现之前先探索用户意图、需求和设计。 | `skills/superpowers-zh/brainstorming/SKILL.md` |
| **systematic-debugging** | 遇到任何 bug、测试失败或异常行为时系统化调试。 | `skills/superpowers-zh/systematic-debugging/SKILL.md` |
| **test-driven-development** | 在编写实现代码之前先编写测试，红-绿-重构循环。 | `skills/superpowers-zh/test-driven-development/SKILL.md` |
| **verification-before-completion** | 在宣称完成之前运行验证命令并确认输出。 | `skills/superpowers-zh/verification-before-completion/SKILL.md` |

#### 开发流程管理

| 技能 | 说明 | 路径 |
|------|------|------|
| **writing-plans** | 在动手写代码之前根据规格或需求创建实现计划。 | `skills/superpowers-zh/writing-plans/SKILL.md` |
| **executing-plans** | 在单独的会话中执行含审查检查点的实现计划。 | `skills/superpowers-zh/executing-plans/SKILL.md` |
| **subagent-driven-development** | 在当前会话中执行包含独立任务的实现计划。 | `skills/superpowers-zh/subagent-driven-development/SKILL.md` |
| **dispatching-parallel-agents** | 面对 2 个以上可独立并行执行的任务时使用。 | `skills/superpowers-zh/dispatching-parallel-agents/SKILL.md` |
| **finishing-a-development-branch** | 实现完成后的收尾工作：合并、PR 或清理。 | `skills/superpowers-zh/finishing-a-development-branch/SKILL.md` |
| **workflow-runner** | 在 Claude Code 中直接运行 YAML 工作流，无需 API key。 | `skills/superpowers-zh/workflow-runner/SKILL.md` |

#### 代码审查与协作

| 技能 | 说明 | 路径 |
|------|------|------|
| **requesting-code-review** | 完成任务或合并前请求代码审查。 | `skills/superpowers-zh/requesting-code-review/SKILL.md` |
| **receiving-code-review** | 收到审查反馈后，实施建议之前进行技术验证。 | `skills/superpowers-zh/receiving-code-review/SKILL.md` |
| **chinese-code-review** | 中文 Code Review 话术模板和分级标注。 | `skills/superpowers-zh/chinese-code-review/SKILL.md` |

#### 中文规范

| 技能 | 说明 | 路径 |
|------|------|------|
| **chinese-documentation** | 中文文档排版规范。 | `skills/superpowers-zh/chinese-documentation/SKILL.md` |
| **chinese-commit-conventions** | 中文 Commit 与 Changelog 配置参考。 | `skills/superpowers-zh/chinese-commit-conventions/SKILL.md` |
| **chinese-git-workflow** | 国内 Git 平台配置参考。 | `skills/superpowers-zh/chinese-git-workflow/SKILL.md` |

#### 工具与基础设施

| 技能 | 说明 | 路径 |
|------|------|------|
| **mcp-builder** | MCP 服务器构建方法论。 | `skills/superpowers-zh/mcp-builder/SKILL.md` |
| **using-git-worktrees** | 使用 git worktree 隔离工作区进行功能开发。 | `skills/superpowers-zh/using-git-worktrees/SKILL.md` |
| **using-superpowers** | 查找和使用技能的基础指引。 | `skills/superpowers-zh/using-superpowers/SKILL.md` |
| **writing-skills** | 创建、编辑和验证技能。 | `skills/superpowers-zh/writing-skills/SKILL.md` |

### Hooks

| 名称 | 说明 | 依赖 |
|------|------|------|
| **statusline** | 底部状态栏，显示 session 名称、模型名、工作目录、上下文余量百分比、Vim 模式。使用 grep/sed 解析 JSON，无需安装 jq。 | 无 |

### 配置模板

| 文件 | 说明 |
|------|------|
| `config-templates/settings.template.json` | Claude Code 通用配置模板（中文语言、Workflows、环境变量等） |
| `config-templates/mcp.template.json` | MCP 服务器配置示例框架 |
| `config-templates/README.md` | 配置模板使用说明 |

### 脚本

| 文件 | 说明 |
|------|------|
| `scripts/setup.ps1` | Windows 自动配置脚本。自动检测插件路径，写入 statusLine 配置到 settings.json。如已有配置，逐项询问是否覆盖。 |

## 开发者指南

详细的插件开发、发布、更新指南请参见 [docs/plugin-development-guide.md](docs/plugin-development-guide.md)。

## 安装指南

### 方式一：通过 GitHub 市场（推荐）

```bash
/plugin marketplace add jovetickop/Animus
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
    "url": "https://github.com/jovetickop/Animus.git"
  }
}
```

然后执行 `/plugin install animus-toolkit@animus-toolkit-marketplace`。

> ⚠️ 此方式未经充分测试。如果遇到问题请改用方式一。

## 状态栏配置

安装后运行自动配置脚本：

```bash
# Windows
# 路径中的 1.0.0 请替换为实际安装的版本号
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

列表中显示 `animus-toolkit@animus-toolkit-marketplace` 即为安装成功。如果未显示，请执行 `/reload-plugins` 或重启 Claude Code。

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
