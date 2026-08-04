# Default WeChat DevTools MCP Workflow

## Default baseline

- MCP service: `weixin-devtools-mcp`
- Default project: `E:\dcl`
- Default CLI: `D:\zjiusuanji\vxxiaochengx\vxweb\cli.bat`
- Default HTTP port: `9420`
- Default automator port: `9430`
- Global config: `C:\Users\86132\.codex\config.toml`

If the user provides different values for a new project, switch to those values and state the override explicitly.

## Preferred source of truth

When both of these exist:

- a repo-local adapter such as `tools/weixin-devtools-mcp-modern/`
- a public MCP package or npm install hint

prefer the repo-local adapter if the project already uses it successfully. Do not switch to a public package unless the user explicitly wants to replace the adapter.

## Validation order

1. Verify `config.toml` points `weixin-devtools-mcp` at the intended server.
2. Verify the CLI path exists.
3. Verify the project path exists.
4. Verify WeChat DevTools is logged in and service-port related settings are enabled.
5. Run connection checks:
   - `connect_devtools`
   - `get_connection_status`
   - `get_current_page`
6. Run page smoke checks:
   - `get_page_snapshot`
   - element lookup
   - `input_text`
   - `click`
   - `waitFor`
   - `assert_*`
7. Run role-based flows:
   - student
   - manager
   - admin

## Failure triage

### `not-connected`

- MCP server not loaded
- config points to the wrong server path
- current client session has stale tools after a config change

Action:
- verify `config.toml`
- restart the client if config changed

### `project-open-failed`

- wrong CLI path
- wrong project path
- DevTools rejected or could not open the project

Action:
- verify path existence
- verify DevTools login
- verify the project can be opened by the current CLI

### `automator-disconnected`

- bridge session dropped
- automator port changed or is unavailable

Action:
- reconnect once in a controlled way
- then re-run `get_current_page` and a minimal page smoke step

### `page-transition-timeout`

- route jump never completed
- current page is blocked by a modal or login state

Action:
- verify current route
- verify whether the last action actually succeeded
- prefer reopening the expected page instead of chaining more clicks blindly

### `element-not-found`

- snapshot is stale
- wrong page
- selector assumptions do not match the rendered tree

Action:
- refresh page snapshot
- inspect visible nodes first

### `assertion-failed`

- page data or UI did not reach expected state
- could be a product bug, not an MCP bug

Action:
- distinguish whether the action failed to fire, or the business state is wrong after a successful action

## Recommended response pattern

When reporting results, structure them as:

1. connection status
2. page-level status
3. business-flow status
4. concrete failing step, if any

This keeps MCP issues separate from mini program defects.
