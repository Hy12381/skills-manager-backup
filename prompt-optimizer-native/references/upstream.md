# 上游来源与本地适配

- 项目：https://github.com/linshenkx/prompt-optimizer
- 固定版本：v2.15.2
- 固定 commit：82e94e84d903471c3d1cb5551bde520c763823a6
- 本地源码：C:/Users/86132/.codex/tools/prompt-optimizer
- 上游许可证：AGPL-3.0-only，原许可证随本技能保留在 LICENSE.upstream。

本目录逐字保留两个上游 TypeScript 模板作为参考材料：

- user-prompt-basic.ts，原路径 packages/core/src/services/template/default-templates/user-optimize/user-prompt-basic.ts。
- context-user-prompt-basic.ts，原路径 packages/core/src/services/template/default-templates/user-optimize/context/context-user-prompt-basic.ts。

SKILL.md 和 agents/openai.yaml 为 2026-11-15 根据用户要求创建的本地 Codex 适配：使用当前会话模型，先显示完善后的需求，再继续用户已授权的任务。它不是上游官方发布的 Codex skill，不调用上游 MCP，也无需单独 API Key。
