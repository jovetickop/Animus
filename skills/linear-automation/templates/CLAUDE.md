## Linear Automation

本项目的 Linear 项目跟踪由 linear-automation 技能管理。

### 状态文件

- `.claude/linear/config.json` — Linear Project 映射信息（由 setup 创建）
- `.claude/linear/issue-map.json` — 本地任务 ↔ Linear Issue 映射
- `.claude/linear/session-summary.json` — 会话结束摘要（由 Stop Hook 写入，下次会话消费）

### 会话启动时

每次会话开始请执行：

```bash
cat .claude/linear/config.json 2>/dev/null
cat .claude/linear/issue-map.json 2>/dev/null
cat .claude/linear/session-summary.json 2>/dev/null
```v

如果 `session-summary.json` 的 `synced_to_linear` 为 `false`：
1. 调用 `save_status_update()` 在 Linear 中创建项目状态更新
2. 更新已完成/进行中任务的 Linear Issue 状态
3. 设置 `synced_to_linear: true`

### 任务跟踪

- 开始新功能时：创建 Linear Issue 并写入 `issue-map.json`
- 完成任务时：更新 Linear Issue 状态为 Done
- 项目完成时：发布最终状态更新

### Linear MCP 配置

Linear MCP 服务配置在 `.claude/linear/mcp.json` 中。
需要 `LINEAR_API_KEY` 环境变量。
