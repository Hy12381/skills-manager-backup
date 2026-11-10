# Runtime discovery and version-pair diagnostics

## First checks

Read the current project's automation settings and test scripts. Verify the intended AppID and source root. Discover the CLI HTTP port (for older Windows installations: LOCALAPPDATA/微信开发者工具/User Data/<profile>/Default/.ide). The automator WebSocket port is separately configured. Compare getAccountInfoSync().miniProgram.appId to the project's AppID before reusing a connection.

Use an absolute Node path and existing server entry in stdio MCP config. On Windows, Node 22 cannot reliably spawn a .bat as a direct executable; use the installed CLI's supported launcher or a correctly quoted native PowerShell invocation. Do not force a different HTTP port if the current IDE is already running.

## Verified observations from 2026-10-27 (examples, not universal requirements)

In E:/桌面图标/vx, Stable 2.01.2510280 with base library 3.17.5 answered App/Tool calls but Page.getData and element queries hung. A controlled test of the componentFramework setting did not fix it and was reverted. The cached library 3.15.3 restored page data, element queries and native screenshots. That pairing is a local compatibility baseline, not a recommended forever-version or a restriction on newer IDEs.

The local 3.16.2/3.17.5 packages no longer contained the old full WAAutoService/WAAutoWebview implementation; this is evidence for the local mismatch, not proof of incompatibility on every installation. After upgrading DevTools, re-test a modern base library before removing a working compatibility pin.

The weixin-devtools-mcp 0.6.0 network collector's mock hook made wx.request return {uniqueId} instead of the HTTP result in that pairing. The project wrapper disables that collector unless WEAPP_MCP_NETWORK_MONITOR=1; console/page/click/assertion/screenshot tools remain available. Verify network transparency before enabling it. Text locators in that pairing also attempted an invalid wx-* selector; use native CSS selectors and assert_text instead.

## vx project commands

- npm run test:mcp:connect: reads weapp.automation.json, discovers/reuses the matching logged-in project and probes real Page data.
- npm run test:mcp:flows: drives the maintained stdio MCP server and verifies a real simulator form/recommendation/details flow with screenshots.
- npm run test:weapp: backwards-compatible entry point for the same verified MCP regression; connection preparation still probes native automator Page data.
- npm run test:weapp-logic: mocked WeChat host; it is not simulator rendering evidence.

Use the project's current files as truth if paths or versions change. Do not copy these settings into unrelated projects.

## Official IDE update performed in this session

On 2026-10-27 the user explicitly authorized updates. Official Stable 2.02.2609240 was installed alongside the old IDE in D:/zjiusuanji/vxxiaochengx/vxweb-2026; signature and native window version verified. It includes wechatide.cmd and built-in skill0.3.11. Its first-run CLI service port is disabled. Do not report the new native automation flow as passed until the user enables the documented setting and the regression succeeds. The current project config restores library3.17.5 for the new IDE. See the current project's docs/WECHAT-AUTOMATION.md and weapp.automation.json; these paths are historical examples, not defaults.
