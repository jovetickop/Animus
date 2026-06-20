# 来源

此插件来自 [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)（MIT 协议）。

- 原始版本：4.7.0
- 许可证：MIT
- 版权：Copyright (c) Dietrich Gebert

## 集成说明

Ponytail 以子插件形式集成到 animus 中：
- `plugins/ponytail/hooks/` — 钩子系统（SessionStart 注入 + UserPromptSubmit 模式追踪）
- `skills/ponytail*/` — 6 个技能（保持根级 `skills/` 目录以确保可发现性）

各个技能的单独来源声明见各自的 `SOURCE.md` 文件。
