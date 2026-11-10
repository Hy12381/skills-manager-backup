---
name: vx-miniprogram-dev
description: 仅在 E:/桌面图标/vx 项目进行微信小程序开发、修改、调试、测试、预览发布或小程序 AI Skills 接入时自动使用。按当前任务读取本地下载的开发、AI Skill、支付及业务示例。其他项目和本项目中的无关写作、问答、文档或系统维护不触发。
---

# vx 微信小程序开发

## 适用范围与读取方式

- 项目根目录：E:/桌面图标/vx。先结合用户目标和实际目标文件判断任务；路径在该项目内且工作实质属于微信小程序开发时才启用。
- 非小程序任务直接退出本入口，不读取下面任何上游技能或资料。只有当前技能的简短元数据用于发现；不要预读整个资料库。
- 源码资料库：C:/Users/86132/.skills-manager/skill-sources/vx-miniprogram/repos。目录均为完整 Git 仓库，保留了依赖、脚本和参考文件；不在全局技能扫描目录中。
- 根据下表选择一个主流程，再补充任务确实需要的技能。开始使用时说明选用了什么。先完整读取所选 SKILL.md，参考文件按其要求读取，避免一次加载全部技能。
- 上游说明中的项目、端口和账户示例不等于本项目配置。先检查实际文件；用户已明确给出的范围、事实、授权与更高优先级指令优先。

## 任务路由

下表路径相对于资料库根目录，均指向 SKILL.md：

| 当前任务 | 主入口 |
| --- | --- |
| 页面、组件、WXML/WXSS、项目配置、路由、调试、预览、上传 | cloudbase-skills/skills/miniprogram-development/SKILL.md |
| 小程序 AI 模式、原子接口/组件、mcp.json、业务 Skill 规范 | mp-skills/skills/wxa-ai-mode-dev/SKILL.md |
| 搜索并接入现有小程序 AI 业务 Skill | mp-skills/skills/wxa-find-skills/SKILL.md |
| 从零创建一个带 AI Skill 的新小程序 | mp-skills/skills/wxa-create-ai-miniprogram/SKILL.md |
| 在现有项目中创建或迭代自定义小程序 AI Skill | mp-skills/skills/wxa-create-mp-skill/SKILL.md |
| 从现有源码提取业务，按微信官方流程生成 AI Skill | ai-mode-skills/wxa-skills-generate/SKILL.md |
| 检查、执行和渲染验证小程序 AI Skill | ai-mode-skills/wxa-skills-validate/SKILL.md |
| 微信支付产品选择、接入、回调、退款及排错 | wechatpay-skills/wechatpay-payment-integration/SKILL.md |
| 用户需要完整的新手引导、阶段规划或上线流程 | launch-wechat-miniprogram/SKILL.md |

- 普通开发优先使用 miniprogram-development；不因在小程序项目里就启动完整新手流程、支付流程或 AI 改造。
- AI Skill 开发按任务选择 CLI 创建流程或官方源码提取流程，避免两个生成流程重复改写同一功能。改动完成后使用 wxa-skills-validate 做适用的验证。
- wxa-ai-mode-dev 对生成/校验/评测的短路径引用，应解析到上表 ai-mode-skills 仓库内的对应入口，不假设它们是 mp-skills 的同级目录。
- 业务示例位于 awesome-miniprogram-skills/skills/<业务名>/。仅在需要该业务时读取对应 README.md 和 SKILL.md，再按需检查代码；不要把业务 Skill 当成编程助手的全局指令。
- 可用业务包括 todolist-skill、order-skill、queue-skill、shopping-skill、payment-skill、text-gen-skill、image-gen-skill、image-edit-skill、hospital-skill、taxi-skill、travel-skill、bill-skill、party-skill、water-tracker。
- 下载示例不等于授权安装其云端资源或执行业务。只有用户要求实现相应功能时，才修改 app.json、安装依赖或运行初始化脚本。

## 按需补充

- 只有项目确实使用 CloudBase 时，才从 cloudbase-skills/skills/ 加载 auth-wechat-miniprogram、cloudbase-document-database-in-wechat-miniprogram、cloud-functions、ai-model-wechat 或 cloudbase-wechat-integration 等对应技能。
- CloudBase 技能的同级依赖和协议从同一仓库相对解析；所需文件已经随完整仓库下载。
- 开发者工具 MCP 连接、页面交互和业务回归，使用已经存在的 C:/Users/86132/.agents/skills/weapp-mcp-testing/SKILL.md；使用本项目实际路径，不照搬旧默认项目路径。
- 需要查看完整下载清单、仓库来源和版本时读取 [references/catalog.json](references/catalog.json)。不要每次开发都读取清单。

## 可用性与验证

- ai-mode-skills/wxa-skills-eval/SKILL.md 当前为暂不开放的提示，已下载留档；不要运行它或声称评测通过。需要评测时核验当前微信官方文档和开发者工具的支持状态。
- Nightly、基础库、客户端、内测资格、提审限制、支付和发布规则以执行时的官方资料与本机实际状态核验；不要把下载文档中的版本说明当作永久事实。
- 按具体改动验证配置、编译、页面交互或业务流程，清楚说明实际执行了哪些验证。
- skills 和 AGENTS.md 是开发工具资料，不能加入 app.json 的 agent.skills；只有明确接入的运行时业务 Skill 才加入。
