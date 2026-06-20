# animus-toolkit

JiangJie 的 Claude Code 个人工具包。

## 插件安装

见 README.md 的安装指南。

## 包含的技能

### harness-cc

复杂任务编码工作流。当需要处理编码任务时，此技能会自动激活并引导你完成计划 → 实现 → 验收的完整流程。

---

# 开发者指南

## 新增技能

1. 将本地技能复制到仓库：`cp -r ~/.claude/skills/<name>/ skills/<name>/`
2. 更新 `plugin.json` 的 `description` 和 `keywords`
3. 更新 README

## 发布新版本

1. 更新 `plugin.json`、`marketplace.json`、`package.json` 中的 version
2. 提交并打 tag：`git tag v<版本号> && git push --tags`
3. GitHub 创建 Release

## 版本号规范

- patch：bug 修复、文档更新
- minor：新增技能/功能
- major：破坏性变更
