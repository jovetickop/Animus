# 配置模板说明

本目录包含 animus 的配置模板文件。

## 使用方法

每个 `.template.json` 文件中的字段可手动合并到 `~/.claude/settings.json` 中。

### settings.template.json
通用 Claude Code 配置，包括：
- 中文语言
- 启用 Workflows
- 常用环境变量（effort 级别、禁用自动更新、启用工具搜索等）

### mcp.template.json
MCP 服务器配置示例框架。将 `<YOUR_MCP_PACKAGE>` 替换为你实际使用的 MCP 包名。

## 注意
- 合并时不要覆写已有的 `permissions`、`attribution` 等配置
- JSON 不支持注释，合并前请确保格式正确
