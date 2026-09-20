# Contributing

Thank you for helping improve this skill.

## Scope

This repository is for improving the `research-paper-writing-agent` Codex skill, especially:

- research workflow gates;
- multi-agent handoff rules;
- manuscript writing contracts;
- result and claim auditing;
- figure/table and citation checks;
- external GPT reviewer prompts.

Please keep changes aligned with the central principle:

> Sub-agents expand search, create opposition, audit facts, and propose changes; the main agent preserves the paper thesis, evidence chain, and final manuscript integration.

## Development Checklist

Before opening a pull request:

1. Keep `SKILL.md` self-contained and executable as instructions.
2. Add or update examples when adding a required handoff.
3. Avoid local paths, credentials, private project names, and unpublished data.
4. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1
```

## Writing Style

- Prefer precise gates over vague advice.
- Define who may write, who may audit, and who may only advise.
- Block defensive manuscript prose instead of explaining failure away.
- Keep failed-result handling focused on diagnosis, optimization, and evidence limits.
