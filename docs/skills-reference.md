# 技能列表

animus 包含 25 个技能，覆盖核心工作流、开发流程管理、代码审查与协作、中文规范、工具与基础设施。

## 核心工作流

| 技能 | 说明 | 路径 |
|------|------|------|
| **harness-cc** | 编码工作流引擎。输入 PRD+方案文档，自动拆解为可执行任务列表，按状态机逐个推进，验收后提交。支持 C++/Qt、Python、Node.js、Rust、Go。 | `skills/harness-cc/SKILL.md` |
| **tdd-workflow** | TDD 工作流子技能，通过 `/tdd-workflow` 显式调用。 | `skills/harness-cc/.claude/skills/tdd-workflow/SKILL.md` |
| **brainstorming** | 在实现之前先探索用户意图、需求和设计。 | `skills/brainstorming/SKILL.md` |
| **systematic-debugging** | 遇到任何 bug、测试失败或异常行为时系统化调试。 | `skills/systematic-debugging/SKILL.md` |
| **test-driven-development** | 在编写实现代码之前先编写测试，红-绿-重构循环。 | `skills/test-driven-development/SKILL.md` |
| **verification-before-completion** | 在宣称完成之前运行验证命令并确认输出。 | `skills/verification-before-completion/SKILL.md` |

## 开发流程管理

| 技能 | 说明 | 路径 |
|------|------|------|
| **planning-with-files** | Manus 风格的文件式计划管理。创建 task_plan.md、findings.md、progress.md 组织追踪任务进度。支持 /clear 后自动恢复会话。 | `skills/planning-with-files/SKILL.md` |
| **writing-plans** | 在动手写代码之前根据规格或需求创建实现计划。 | `skills/writing-plans/SKILL.md` |
| **executing-plans** | 在单独的会话中执行含审查检查点的实现计划。 | `skills/executing-plans/SKILL.md` |
| **subagent-driven-development** | 在当前会话中执行包含独立任务的实现计划。 | `skills/subagent-driven-development/SKILL.md` |
| **dispatching-parallel-agents** | 面对 2 个以上可独立并行执行的任务时使用。 | `skills/dispatching-parallel-agents/SKILL.md` |
| **finishing-a-development-branch** | 实现完成后的收尾工作：合并、PR 或清理。 | `skills/finishing-a-development-branch/SKILL.md` |
| **workflow-runner** | 在 Claude Code 中直接运行 YAML 工作流，无需 API key。 | `skills/workflow-runner/SKILL.md` |
| **integrate-to-animus** | 将新内容集成到 animus 插件包中。 | `skills/integrate-to-animus/SKILL.md` |

## 代码审查与协作

| 技能 | 说明 | 路径 |
|------|------|------|
| **requesting-code-review** | 完成任务或合并前请求代码审查。 | `skills/requesting-code-review/SKILL.md` |
| **receiving-code-review** | 收到审查反馈后，实施建议之前进行技术验证。 | `skills/receiving-code-review/SKILL.md` |
| **chinese-code-review** | 中文 Code Review 话术模板和分级标注。 | `skills/chinese-code-review/SKILL.md` |

## 中文规范

| 技能 | 说明 | 路径 |
|------|------|------|
| **chinese-documentation** | 中文文档排版规范。 | `skills/chinese-documentation/SKILL.md` |
| **chinese-commit-conventions** | 中文 Commit 与 Changelog 配置参考。 | `skills/chinese-commit-conventions/SKILL.md` |
| **chinese-git-workflow** | 国内 Git 平台配置参考。 | `skills/chinese-git-workflow/SKILL.md` |

## 工具与基础设施

| 技能 | 说明 | 路径 |
|------|------|------|
| **mcp-builder** | MCP 服务器构建方法论。 | `skills/mcp-builder/SKILL.md` |
| **using-git-worktrees** | 使用 git worktree 隔离工作区进行功能开发。 | `skills/using-git-worktrees/SKILL.md` |
| **using-superpowers** | 查找和使用技能的基础指引。 | `skills/using-superpowers/SKILL.md` |
| **writing-skills** | 创建、编辑和验证技能。 | `skills/writing-skills/SKILL.md` |

## 文档处理

| 技能 | 说明 | 路径 |
|------|------|------|
| **doc** | 创建、编辑和审查 `.docx` 文档，支持 python-docx 编程化操作和视觉渲染验证。 | `skills/doc/SKILL.md` |
| **pptx** | 创建、编辑和审查 `.pptx` 演示文稿，支持模板编辑、pptxgenjs 创建、缩略图预览和视觉 QA。 | `skills/pptx/SKILL.md` |
