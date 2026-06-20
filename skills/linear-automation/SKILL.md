---
name: linear-automation
description: Use when starting a new software project, when Linear project tracking is desired, during any development session where tasks/features should be tracked in Linear, or at the end of a development session to sync progress to Linear. Activates when creating issues, updating task status, or generating completion summaries for Linear.
version: "1.0.0"
license: MIT
metadata:
  hermes:
    tags: [linear, project-management, automation, tracking]
---

# Linear Automation

自动管理 Linear 项目和工单的生命周期。在开发过程中自动创建 Project、Issue，同步进度状态，在会话结束时生成总结并同步到 Linear。

## 架构

```
目标项目根目录/
  .claude/linear/
    config.json             -- Linear Project 映射信息（由 setup 创建）
    issue-map.json          -- 本地任务 ↔ Linear Issue 映射
    session-summary.json    -- Stop Hook 输出，下个会话消费（瞬态）
    mcp.json                -- Linear MCP 服务配置
```

## 工作流

### Step 1: Setup（一次性，新项目首次配置）

首次在当前项目使用时，执行初始化设置：

1. 确认 `LINEAR_API_KEY` 环境变量已配置
2. 读取 `.claude/linear/config.json`，如果不存在则提示设置
3. 调用 Linear MCP 的 `list_teams()` 获取团队列表
4. 选择目标团队后，调用 `save_project()` 创建 Linear Project
5. 在 `.claude/linear/config.json` 中写入 Project 映射信息
6. 复制 `mcp.json` 模板到 `.claude/linear/mcp.json`

**config.json 格式：**
```json
{
  "linear_project_id": "b0e1a2c3-...",
  "linear_project_name": "项目名称",
  "linear_team_id": "team-uuid",
  "git_repo": "owner/repo",
  "created_at": "2026-06-20T10:00:00Z",
  "session_count": 0
}
```

### Step 2: Session Start（每会话自动执行）

每次会话开始时：

1. 读取 `.claude/linear/config.json` 确认已配置
2. 读取 `.claude/linear/issue-map.json` 了解现有任务状态
3. 读取 `.claude/linear/session-summary.json`
4. 如果 `session-summary.json` 的 `synced_to_linear` 为 `false`：
   a. 调用 `save_status_update()` 在 Linear 中创建项目状态更新
   b. 对已完成/进行中的任务调用 `save_issue()` 更新状态
   c. 设置 `synced_to_linear: true`
5. 清理 session-summary.json（或备份）

### Step 3: Feature Tracking（新建任务时）

当开始开发新功能/任务时：

1. 调用 `save_issue()` 在 Linear 中创建 Issue
2. 在 `.claude/linear/issue-map.json` 中添加映射记录

**issue-map.json 格式：**
```json
{
  "config_version": 1,
  "last_updated": "2026-06-20T12:00:00Z",
  "tasks": [
    {
      "feature_id": "T001",
      "linear_issue_id": "LIN-123",
      "linear_issue_url": "https://linear.app/workspace/issue/LIN-123",
      "title": "实现登录模块",
      "status": "in_progress",
      "linear_status": "In Progress",
      "created_at": "2026-06-20T09:00:00Z",
      "updated_at": "2026-06-20T11:30:00Z"
    }
  ]
}
```

**状态映射关系：**

| 本地状态 | Linear 状态 | 触发时机 |
|---------|-------------|---------|
| pending | Backlog | Issue 已创建但未开始 |
| in_progress | In Progress | 任务开始开发 |
| passed | Done | 任务完成且已验证 |
| failed | Blocked | 任务遇到阻碍 |

### Step 4: Status Sync（任务状态变更时）

当任务状态发生变化时，同步更新 Linear：

- **任务开始**：`save_issue(id="LIN-123", state="In Progress")` + 更新 issue-map.json
- **任务完成**：`save_issue(id="LIN-123", state="Done")` + `save_comment(body="完成摘要")` + 更新 issue-map.json
- **任务阻塞**：`save_issue(id="LIN-123", state="Blocked")` + 更新 issue-map.json
- **多任务批量完成**：调用 `save_status_update()` 更新项目整体健康状态

### Step 5: Session End（自动触发）

会话结束时，Stop Hook 自动执行：

1. 读取 `.claude/linear/issue-map.json`
2. 统计各状态任务数量
3. 写入 `.claude/linear/session-summary.json`（`synced_to_linear: false`）
4. 静默退出（即使没有配置文件也正常退出）

**session-summary.json 格式：**
```json
{
  "session_id": "sess-1718889600",
  "ended_at": "2026-06-20T12:30:00Z",
  "tasks_total": 5,
  "tasks_done": 2,
  "tasks_in_progress": 2,
  "tasks_pending": 1,
  "in_progress_titles": "实现用户注册, 编写API文档",
  "done_titles": "实现登录模块, 数据库设计",
  "summary": "Session ended. Tasks: 5 total, 2 done, 2 in progress, 1 pending.",
  "synced_to_linear": false
}
```

### Step 6: Final Summary（项目完成时）

当项目整体完成或需要总结时：

1. 汇总 `issue-map.json` 中所有任务
2. 调用 `save_status_update(type="project", project="<project-id>", health="onTrack", body="<项目总结>")`
3. 对每个已完成 Issue 调用 `save_comment()` 添加最终备注

## 文件参考

| 路径 | 用途 | 生命周期 |
|------|------|---------|
| `.claude/linear/config.json` | Project 映射信息（由 setup 创建） | 持久 |
| `.claude/linear/issue-map.json` | 任务 ↔ Issue 映射 | 持久 |
| `.claude/linear/session-summary.json` | Stop Hook 输出，下个会话消费 | 瞬态 |
| `.claude/linear/mcp.json` | Linear MCP 服务配置 | 持久 |

## 前提条件

- Linear API Key 已配置为环境变量 `LINEAR_API_KEY`
- Linear MCP Server 已配置（模板见 `.claude/linear/mcp.json`）
- 当前项目为 Git 仓库（用于自动检测项目名称）

## 注意事项

- Stop Hook **不调用 Linear API**，只写 JSON 文件。真正的同步发生在下次会话
- 所有 Linear API 操作都需要 Claude 使用 MCP 工具执行
- 如果同一个会话中操作多个项目，Stop Hook 只写入当前工作目录的状态
- `synced_to_linear: false` 标记防止重复同步——Claude 处理完后会设为 `true`
- 没有 jq 的环境会写入最小格式的 summary，不影响功能
