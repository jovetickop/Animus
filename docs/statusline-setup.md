# 状态栏配置

## 概述

animus 通过 claude-hud 插件提供实时状态栏 HUD，显示模型名、上下文健康度、工具活动、Agent 追踪、待办进度。

## 自动配置

安装 animus 插件后，状态栏已自动配置。如果未显示，运行：

```
/claude-hud:setup
```

## 手动配置

在 `~/.claude/settings.json` 中添加：

```json
"statusLine": {
  "command": "node \"$CLAUDE_PLUGIN_ROOT/plugins/claude-hud/dist/index.js\"",
  "type": "command"
}
```

## 自定义

运行 `/claude-hud:configure` 查看可配置选项，包括显示/隐藏工具行、Agent 行、待办行等。

## 故障排除

| 问题 | 解决方法 |
|------|---------|
| 底部不显示状态栏 | 运行 `/claude-hud:setup` |
| 需要自定义显示内容 | 运行 `/claude-hud:configure` |
