---
name: weapp-mcp-testing
description: Connect to WeChat DevTools through MCP or the Mini Program automator, diagnose version and protocol mismatches, and run real page interactions, assertions, and screenshots. Use for WeChat Mini Program automation and MCP troubleshooting, not ordinary web testing.
---

# WeChat Mini Program MCP Testing

## Discover the actual environment

- Use the current project's AGENTS.md, project.config.json, project.private.config.json, package scripts and automation config. Old project paths and ports are examples, never defaults to copy into a new project.
- Inspect only the relevant MCP table in the active Codex config. Verify its executable and entry file exist; a table alone does not mean the MCP is running or visible to this chat.
- HTTP/CLI service ports and automator WebSocket ports are separate. Reuse a logged-in project and discover the actual HTTP port from the CLI or the user's DevTools data directory rather than restarting the IDE to force a guessed port.
- Prefer a project's already verified test entry points. Read their settings and use their bounded environment check before page tests. Do not install another server just because one is available.

## Verify beyond the handshake

Check, in order: login/project identity; Tool.getInfo and current page; page.data(); a real element query; screenshot; then the requested business flow. App.evaluate succeeding does not prove Page.* works.

Read [default-workflow.md](references/default-workflow.md) for version-pair triage and concrete known failures. If metadata succeeds but Page.* hangs, diagnose DevTools/base-library compatibility before changing application logic or buying/downloading unrelated tools. Any compatibility pin must be scoped to development and backed up; do not apply one project's version globally.

## Execute real tests

- Discover the server's actual tools/list schemas before constructing calls. Do not copy schemas from a different package release or GitHub main branch.
- Prefer selectors, IDs or data-testid. Resolve refs from a fresh snapshot; specify index for multiple matches. A tool's successful click is followed by a destination-page/element or data assertion.
- Wait for actual route/data changes, not fixed sleeps or the page object captured before navigation. Use explicit timeouts; reconnect once for a dropped session, not endless retries.
- Verify wx.request still returns real HTTP status/data after attaching monitoring. A recorder can break the app; disable a demonstrated-broken recorder rather than report an application failure. Do not mock model/network results during tests described as real integration.
- Use each application's actual roles and flows. Separate mocked-host logic tests, native simulator tests and real-device tests in reports.

## Report and persistence

Classify failures as not-connected, project-open-failed, automator-disconnected, protocol/base-library mismatch, page-transition-timeout, element-not-found, or assertion-failed. Distinguish connection readiness, page bridge readiness and application failures.

After configuration changes, re-read the MCP table and verify the server with an actual MCP client. If the current chat's tool catalog has not refreshed, explain that Codex must reload/restart before direct tool calls become available; continue independent verification through the test client. Do not claim the tools are already visible here.

Before updates, preserve the relevant config and source metadata. Update only the requested workflow and verify the new environment with the same business regression.
