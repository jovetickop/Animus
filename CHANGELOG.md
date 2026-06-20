# 更新日志

## 1.6.0 (2026-06-20 16:44)

### 新增
- ponytail 代码精简（6个技能）：6 步懒惰阶梯（YAGNI→Stdlib→Platform→Installed Dep→One Line→Minimum），让 AI 只写必要代码
- ponytail hooks 系统：SessionStart 自动注入精简规则 + UserPromptSubmit 追踪模式切换

### 变更
- 更新元数据版本号至 1.6.0
- 技能总数更新至 31 个

---

## 1.5.0 (2026-06-20 15:36)

### 新增
- doc 技能：创建、编辑和审查 `.docx` 文档，支持 python-docx 编程化操作和视觉渲染验证
- pptx 技能：创建、编辑和审查 `.pptx` 演示文稿，支持模板编辑、pptxgenjs 创建、缩略图预览和视觉 QA

### 变更
- 更新元数据版本号至 1.5.0

---

## 1.3.0 (2026-06-20 14:00)

### 新增
- integrate-to-animus 技能：将新内容集成到 animus 插件包，从确认来源到更新文档的完整工作流
- docs/workflow-guide.md：开发工作流协作指南

### 变更
- 技能 integrate-to-plugin 更名为 integrate-to-animus
- 更新元数据版本号至 1.3.0

---

## 1.2.0 (2026-06-20 13:55)

### 新增
- planning-with-files 技能：Manus 风格的文件式计划管理，支持会话恢复
- workflow-guide.md：完整的开发工作流协作指南文档

### 文档
- 新增 plugin-development-guide.md 插件开发指南
- README 新增内容列表表格

---

## 1.1.0 (2026-06-20 13:48)

### 新增
- superpowers-zh 20 个中文技能集（brainstorming、writing-plans、test-driven-development 等）
- 来源声明文档，标注第三方内容许可证信息

### 变更
- README 全面更新，增加技能分类表格

---

## 1.0.0 (2026-06-20 13:40)

### 新增
- 初始发布
- harness-cc 编码工作流引擎（支持 C++/Qt、Python、Node.js、Rust、Go）
- tdd-workflow TDD 工作流子技能
- statusline.sh 状态栏钩子（grep/sed 实现，无 jq 依赖）
- settings.template.json 和 mcp.template.json 配置模板
- setup.ps1 Windows 自动配置脚本
- plugin-development-guide.md 插件开发指南
