# Changelog

## 0.2.0

- Replaced the universal research state machine with task-scoped `edit`,
  `evidence`, and `autonomous` modes.
- Reduced the runtime contract to three responsibilities, three hard integrity
  gates, and four cumulative artifacts.
- Recovered eight reference files affected by character-by-character quoting and
  mojibake, and added CI checks for recurrence.
- Removed protocol, writing, role-boundary, manuscript-phrase, experiment-license,
  reference-route, and workflow-supervision gate scripts.
- Retained deterministic result-ledger validation, now preferring
  `claim_evidence.md` while accepting `claim_evidence_map.md` as a compatibility
  alias.
- Added workflow fixtures proving light edits need no artifacts and numeric
  failures block only affected result claims.

## 0.1.6

- Added machine-readable `experiment_license.yaml`, `result_ledger.jsonl`, and `handoff_manifest.yaml` examples.
- Added hard checkers for experiment licenses, source-backed result ledgers, manuscript prose, role boundaries, and aggregate workflow supervision.
- Strengthened protocol and writing gates so result claims require a result ledger, and final integration requires manuscript-prose and role-boundary checks.
- Updated docs and tests for direct manuscript scanning, result recomputation, and Coordinator-only manuscript integration.

## 0.1.5

- Added first-call Remote Audit Window Intake for controllable GPT review windows.
- Added `External audit route` to protocol state with `remote-gpt` and `internal-only` modes.
- Updated protocol-state checks to block gated workflow actions until the audit route is answered.
- Updated examples and docs for internal-only fallback when no remote GPT window is available.

## 0.1.4

- Split long literature, experiment, section-writing, and review guidance out of the core `SKILL.md`.
- Added routed section-writing references for Introduction, Methodology, Experiments, and Related Work.
- Added `scripts/check-reference-routes.ps1` to verify routed references and prevent legacy phase manuals from returning to the core skill.
- Strengthened `scripts/check-writing-gate.ps1` so each section contract must record the required reference path.
- Removed stale AutoReason, human-evaluation, paper-type, and old experiment-pattern references from the package.

## 0.1.3

- Slimmed the core `SKILL.md` by removing obsolete Hermes/Windows adapter content.
- Removed post-acceptance and submission-preparation phases from the core runtime skill.
- Moved the core stance away from draft-first behavior toward protocol-bound autonomy.
- Removed old AutoReason, human-evaluation, paper-type, cron, and LaTeX tooling detail from the core skill path.

## 0.1.2

- Added Runtime Protocol Anchor near the top of `SKILL.md`.
- Added `protocol_state.example.md` as the long-running workflow state file.
- Added `scripts/check-protocol-state.ps1` for action-before-gate checks.
- Upgraded Workflow Supervisor guidance into a recurring protocol heartbeat.

## 0.1.1

- Added fail-closed writing entry gate for manuscript drafting and revision.
- Added `scripts/check-writing-gate.ps1` for required writing artifacts.
- Added section-contract and writing-gate report examples.

## 0.1.0

- Initial open-source package for `research-paper-writing-agent`.
- Added multi-agent workflow documentation.
- Added process-gate documentation.
- Added external GPT reviewer workflow and prompt guidance.
- Added example handoff files for intent, audits, failure diagnosis, section contracts, and defensive-writing checks.
- Added a lightweight open-source readiness check script.
