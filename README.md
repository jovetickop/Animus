# animus

jovetickop 的 Claude Code 个人工具包。包含 **32 个技能**（harness-cc 编码工作流引擎含 tdd-workflow 子技能 + planning-with-files 计划管理 + doc 文档处理 + pptx 演示文稿 + ponytail 代码精简（6 个） + integrate-to-animus 集成工具 + 中文代码审查/提交/文档规范 + 调试/测试/TDD 工作流等），以及 superpowers-zh 中文技能集和配置模板。

## 架构

animus 将个人开发工具打包为标准 Claude Code 插件：

- **skills/** — 32 个技能，直接扫描识别，覆盖从需求探索到代码交付的完整开发生命周期
- **plugins/claude-hud/** — 实时状态栏 HUD（上下文健康度、工具活动、Agent 追踪、待办进度）
- **config-templates/** — settings.json 和 MCP 配置示例
- **scripts/** — Windows 自动配置脚本（setup.ps1）
- **.claude-plugin/** — 插件元数据（plugin.json + marketplace.json）

完整工作流指南参见 [开发工作流指南](./docs/workflow-guide.md)。

## 快速开始

```bash
/plugin marketplace add jovetickop/Animus
/plugin install animus@animus-marketplace
```

编辑 `~/.claude/settings.json`，在 `enabledPlugins` 中添加 `"animus@animus-marketplace": true`，然后执行 `/reload-plugins`。

> 备用安装方式（Git URL）见 [开发者指南](./docs/plugin-development-guide.md)。

## 内容索引

| 类别 | 内容 | 参考文档 |
|------|------|---------|
| 技能列表 | 32 个技能说明、触发方式、路径 | [技能参考](./docs/skills-reference.md) |
| 开发工作流 | 技能如何协作、完整流程说明 | [工作流指南](./docs/workflow-guide.md) |
| 状态栏 | 实时 HUD（模型/上下文/工具/Agent/待办） | [claude-hud 配置](./plugins/claude-hud/commands/setup.md) |
| 配置模板 | settings.json / MCP 配置示例 | [config-templates/](../config-templates/README.md) |
| 安装脚本 | Windows 自动配置脚本 | [scripts/setup.ps1](../scripts/setup.ps1) |
| 开发者指南 | 插件扩展、发布、更新 | [开发者指南](./docs/plugin-development-guide.md) |

## 来源声明

本插件包含以下第三方内容：

| 内容 | 来源 | 协议 | 版权 |
|------|------|------|------|
| **superpowers-zh**（20 个中文技能） | [jnMetaCode/superpowers-zh](https://github.com/jnMetaCode/superpowers-zh) | MIT | Copyright (c) 2026 jnMetaCode |
| **harness-cc**（含 tdd-workflow） | [jovetickop/Harness-CC](https://github.com/jovetickop/Harness-CC.git) | MIT | 见源仓库 LICENSE |
| **planning-with-files** | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files) | MIT | Copyright (c) 2026 OthmanAdi |
| **ponytail**（6 个技能） | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | MIT | Copyright (c) Dietrich Gebert |
| **doc** | Claude Code Skills Registry | Apache 2.0 | Anthropic |
| **pptx** | Claude Code Skills Registry | Proprietary | Anthropic |

各技能的完整许可证文件分别位于对应技能目录中。

## 许可证

MIT
