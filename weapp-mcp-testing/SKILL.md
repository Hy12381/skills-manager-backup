---
name: weapp-mcp-testing
description: Use when a user asks to connect Codex to WeChat DevTools, test a WeChat Mini Program through MCP, run page-level automation, debug weixin-devtools-mcp, or reuse the modern WeChat DevTools MCP workflow across projects.
---

# WeChat Mini Program MCP Testing

Use this skill when the task is about driving or testing a WeChat Mini Program through MCP and WeChat DevTools.

## What this skill assumes

- The MCP service name is `weixin-devtools-mcp`.
- The current default baseline is:
  - project path: `E:\dcl`
  - DevTools CLI: `D:\zjiusuanji\vxxiaochengx\vxweb\cli.bat`
  - HTTP port: `9420`
  - automator port: `9430`
  - global MCP config: `C:\Users\86132\.codex\config.toml`
- These are defaults, not hard requirements. If the user provides a different project path, CLI path, or port, use the user-provided values instead.

## First-pass workflow

1. Confirm the real project path from the user request, repo state, or current workspace.
2. Read `C:\Users\86132\.codex\config.toml` and verify the `weixin-devtools-mcp` entry exists and points to the intended server.
3. Check whether the repo has a custom adapter such as `tools/weixin-devtools-mcp-modern/`. If present, treat it as the source of truth over public npm packages.
4. Verify the WeChat DevTools baseline before running page tests:
   - logged in
   - security/service-port related options enabled
   - CLI path exists
   - chosen ports are consistent
5. Run checks in this order:
   - connection layer
   - page-level smoke
   - business flows

Do not assume MCP is ready just because the config file exists.

## Standard execution order

Use this order unless the user asks for something narrower:

1. `connect_devtools`
2. `get_connection_status`
3. `get_current_page`
4. `get_page_snapshot`
5. `click`, `input_text`, `waitFor`, `assert_text`, `assert_state`
6. role-based flows for student, manager, and admin

If the repo already includes scripts such as `npm run test:mcp:connect`, `npm run test:mcp:smoke`, or `npm run test:mcp:flows`, prefer those as the main regression entrypoints and use direct MCP tools for focused debugging.

## How to reason about failures

Always classify the failure explicitly before proposing a fix:

- `not-connected`
- `project-open-failed`
- `automator-disconnected`
- `page-transition-timeout`
- `element-not-found`
- `assertion-failed`

Also distinguish among these broader states in your reply:

- connection layer not working
- page-level bridge not working
- business flow bug in the mini program itself

Do not collapse these into a generic "MCP failed".

## Recovery rules

- If DevTools is already open on the correct project, prefer reusing the session instead of reopening the project.
- If `/v2/open` or a similar open-project step fails because the project is already open, treat that as a recoverable state and continue connection checks.
- If automator or the page bridge disconnects, prefer one controlled reconnect before declaring failure.
- If MCP config was changed in the current session and the new tools are not visible yet, tell the user a client restart is required.

## References

- Read `references/default-workflow.md` for the concrete baseline, validation order, and failure triage.
