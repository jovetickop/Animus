# animus-toolkit

JiangJie 的 Claude Code 个人工具包。

## 包含的内容

### harness-cc — 编码工作流引擎
支持 C++/Qt、Python、Node.js、Rust 的完整开发闭环。自动拆解复杂任务为可执行步骤，按状态机逐个推进，验收后提交。

### statusline — 状态栏
显示当前 session、模型名、工作目录、上下文余量百分比、Vim 模式。无外部依赖，无需安装 jq。

### 配置模板
- `settings.template.json` — Claude Code 通用配置模板
- `mcp.template.json` — MCP 服务器配置示例

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

脚本会自动检测插件路径并写入配置到 `settings.json`。如果已有 statusLine 配置，会询问是否覆盖。

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
