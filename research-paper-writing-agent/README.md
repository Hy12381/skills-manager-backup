# Research Paper Writing Agent Skill

An open-source Codex skill for ML/AI paper editing, evidence-grounded writing,
experiment workflows, and autonomous research. It preserves the useful core of
the original project: claims must remain connected to citations, results, and
their actual evidence boundaries.

The skill uses progressive disclosure. Ordinary translation or polishing stays
lightweight; citation-bearing writing and result claims receive scoped checks;
full research projects maintain a compact set of shared artifacts.

## Three Modes

| Mode | Typical use | Artifacts |
| --- | --- | --- |
| `edit` | Translate, polish, shorten, restructure supplied text | None |
| `evidence` | Add citations, synthesize literature, draft result prose, review claims | `claim_evidence.md` or a project equivalent |
| `autonomous` | Manage literature, experiments, writing, and review end to end | All four core artifacts |

Mode is selected for the current task. A paragraph edit inside an autonomous
project does not re-enter the full research workflow.

## Integrity Model

Only three hard gates block evidence-bearing output:

- Citation integrity: introduced citations and external factual claims are
  verified against primary or authoritative sources.
- Result traceability: reported numbers and comparisons trace to raw output or a
  reproducible transformation.
- Claim-scope integrity: final wording does not exceed the available support.

A failed gate blocks the affected citation, result, or claim. It blocks the whole
paper only when the failure invalidates the central thesis.

Responsibilities are grouped as Lead, Research/Experiment, and Reviewer. One
agent may perform all three; multi-agent orchestration is optional.

## Core Artifacts

Use the examples under `examples/` when the selected mode needs them:

- `paper_brief.example.md`: thesis, contribution, scope, venue, constraints.
- `claim_evidence.example.md`: claim wording, evidence, support, boundary.
- `research_log.example.md`: literature decisions, experiments, failures, paths.
- `review.example.md`: gate verdicts, prioritized findings, unresolved blockers.

Equivalent existing project files are accepted. Do not duplicate reliable records
only to match these names.

## Repository Layout

```text
.
|-- SKILL.md
|-- references/
|   |-- literature-workflow.md
|   |-- experiment-workflow.md
|   |-- review-workflow.md
|   `-- section-writing/
|-- examples/
|-- scripts/
|   `-- check-result-audit.ps1
|-- templates/
|-- tests/
`-- README.md
```

The main skill is a compact router. Detailed instructions are loaded only for the
current literature, experiment, section-writing, or review task.

## Optional Result Validation

When a project has a compatible JSONL result ledger and CSV sources, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-result-audit.ps1 -ProjectRoot .
```

The script validates source paths, recomputes compatible CSV values, checks metric
direction, ranks, best markers, and claim references. It prefers
`claim_evidence.md` and accepts `claim_evidence_map.md` as a compatibility alias.
Projects with other result formats should use their native analysis code and
record the reproduction command.

## External Review

External GPT review is optional and advisory. Use it when the user requests an
additional perspective or when an independent review is useful. Do not share
secrets, credentials, private data, confidential reviewer material, or browser
storage. External feedback cannot override primary evidence or user intent.

See `docs/external-gpt-review.md`.

## Migration From 0.1.x

The following are legacy mappings, not active runtime requirements:

| 0.1.x concept | Current equivalent |
| --- | --- |
| `paper_intent.md` and project identity files | `paper_brief.md` |
| `claim_evidence_map.md` | `claim_evidence.md` (old name accepted by the numeric checker) |
| Experiment license, failure diagnosis, and execution handoffs | Entries in `research_log.md` |
| Result, defensive-writing, writing, and supervision reports | One prioritized `review.md` |
| Protocol state and phase permissions | Task-scoped mode selection in `SKILL.md` |
| Manuscript phrase scanner and role write barrier | Evidence review without broad phrase bans |

The universal gate scripts from 0.1.x were removed. Existing projects may keep
their artifacts as project records; they are no longer required for local edits.

## Installation

Copy the repository into the Codex skills directory and restart or reload skills:

```powershell
Copy-Item .\research-paper-writing-agent-skill "$env:USERPROFILE\.codex\skills\research-paper-writing-agent" -Recurse
```

## Development Checks

Run the release checks from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-skill-contract.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-workflows.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1
```

## Safety Notes

- This skill does not guarantee novelty, acceptance, correctness, or valid results.
- It does not replace scientific judgment or current venue-policy review.
- Verify generated citations and claim wording before submission.
- Venue templates may be subject to upstream terms; see `NOTICE.md`.

## License

MIT. See `LICENSE`.
