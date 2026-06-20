---
name: integrate-to-animus
description: 当用户要求将新的技能/工具/配置集成到 animus 插件包时使用。例如"把XXX集成到插件包中"、"添加YYY到插件"、"把ZZZ打包到工具包"
version: "1.0.0"
license: MIT
---

# Integrate to Plugin（集成到插件包）

## 概述

将新内容（技能、工具、配置等）自动化集成到 animus 插件包中，从确认来源到更新文档的完整工作流。

## 工作流程

### Step 1: 解析要集成的内容

从用户消息中提取目标名称（AA），确认用户期望集成的对象。

### Step 2: 确认来源（必须）

询问用户确认来源，提供以下选项：

1. **GitHub URL** — 从远程仓库拉取
2. **本地路径** — 从本地文件系统复制
3. **其他** — 用户自定义方式（如手动粘贴内容等）

> **重要：不得自行假设来源，必须询问用户确认。**

### Step 3: 获取内容

根据用户确认的来源执行获取操作：

- **GitHub URL**: `git clone <url> /tmp/<target>/`
- **本地路径**: `cp -r <path> /tmp/<target>/`
- **其他**: 按用户指定的方式获取

清理无关文件：删除 `.git/`、`node_modules/`、`target/`、`__pycache__/`、`.venv/` 等构建产物和版本控制目录。

### Step 4: 复制到插件结构

```
skills/<name>/
```

将处理后的内容放入 `skills/<name>/` 目录下。目录名使用 kebab-case 命名。

### Step 5: 更新元数据

**每条集成必须递增一个 minor 版本号**（如 `1.2.0` → `1.3.0`），同步更新以下三个文件：

- **`.claude-plugin/plugin.json`** — 更新 `description`、`keywords`、`version`
- **`.claude-plugin/marketplace.json`** — 更新 `description`、`version`
- **`package.json`** — 更新 `version`

> 三个文件的版本号必须保持一致。每个集成独立占一个版本号，不允许批量集成后只升一次版本。

### Step 6: 更新文档

- **`README.md`** — 技能表格中新增一行，更新技能总数
- **`CLAUDE.md`** — 更新技能计数等相关描述

### Step 6.5: 更新 CHANGELOG

在 `CHANGELOG.md` 顶部追加新版本记录：

```markdown
## <新版本号> (YYYY-MM-DD HH:mm)

### 新增
- <集成内容>：<简要说明>

### 变更
- 更新元数据版本号
```

> 时间以 `git commit` 时的实际时间为准，不要随意填写。

### Step 7: 协作说明（重点）

分析 AA 与插件包现有技能的协作方式，输出以下模板内容（可追加到技能 README 或独立协作文档）：

```
## [技能名] 与现有技能的协作

### 在工作流中的位置
[AA 插入到工作流的哪个环节]

### 与核心技能的协作
- **harness-cc**: [关系，如"作为前置/后置步骤"、"提供输入/消费输出"]
- **planning-with-files**: [关系]
- **superpowers-zh**: [关系]

### 典型组合用法
- [场景1]: [组合描述]
- [场景2]: [组合描述]
```

### Step 8: 提交（需人类确认）

**不要自动执行任何 git 操作**，每一步都需要询问用户：

1. **询问是否暂存并提交：**
   ```
   集成已完成。是否执行 git add + commit？（y/n）
   ```
   - 用户确认后执行：`git add . && git commit -m "feat: 集成 <AA> 到插件包 (v<新版本>)"`
   - 用户拒绝则跳过，提示用户后续可手动提交

2. **询问是否推送到远程：**
   ```
   是否推送到远程仓库？（y/n）
   ```
   - 用户确认后执行：`git push`
   - 用户拒绝则提示：本地已提交，可由用户自行推送

## 现有插件包结构参考（供协作分析使用）

**核心工作流引擎：**
- `harness-cc` — 编码工作流引擎，输入 PRD+方案，自动拆解任务列表，状态机推进，验收后提交
- `planning-with-files` — Manus 式文件计划管理，创建 task_plan.md/findings.md/progress.md

**开发流程链：**
brainstorming → writing-plans → (subagent-driven-development | executing-plans | harness-cc) → verification-before-completion → requesting-code-review → receiving-code-review → finishing-a-development-branch

**测试与调试：**
- `test-driven-development` — 红-绿-重构 TDD 循环
- `systematic-debugging` — 系统化调试

**中文规范：**
- `chinese-documentation`、`chinese-commit-conventions`、`chinese-git-workflow`、`chinese-code-review`

**工具类：**
- `mcp-builder`、`using-git-worktrees`、`writing-skills`、`workflow-runner`、`using-superpowers`、`dispatching-parallel-agents`

## 注意事项

1. **来源确认不可跳过** — 必须询问用户确认来源，不得自行假设
2. **版本号三文件同步** — `plugin.json`、`marketplace.json`、`package.json` 的版本号必须一致递增
3. **第三方内容标注** — 引入非自主开发的内容，必须在对应目录加入 `SOURCE.md` 标注来源 URL 和许可证信息
4. **目录名规范** — 使用 kebab-case 命名（小写字母 + 连字符）
5. **清理无关文件** — 确保不提交 `.git/`、`node_modules/`、`target/`、`__pycache__/`、`.venv/` 等目录
6. **不推送远程** — 只做本地 `git commit`，由用户自行推送
