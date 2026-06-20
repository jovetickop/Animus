# animus

jovetickop 的 Claude Code 个人工具包。包含 25 个技能，详见 README.md。

## 插件安装

见 README.md 的安装指南。

## 包含的技能

25 个技能，完整列表见 README.md。

---

# 开发者指南

完整的插件开发、发布、更新指南请参见 [docs/plugin-development-guide.md](docs/plugin-development-guide.md)。

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
