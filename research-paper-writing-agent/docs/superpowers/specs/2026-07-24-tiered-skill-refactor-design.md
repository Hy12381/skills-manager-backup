# Tiered Research Paper Skill Refactor

## Objective

Refactor the skill from a mandatory research-governance state machine into a
progressively disclosed paper workflow. Preserve the claim-evidence discipline
that prevents fabricated citations, unsupported results, and overstated
conclusions while removing ceremony that does not improve those outcomes.

Success means:

- `SKILL.md` is 180-250 lines and contains routing plus core constraints only.
- Ordinary translation, polishing, and local revision do not create workflow
  artifacts or invoke research-project gates.
- Full autonomous research still has explicit evidence and review controls.
- The eight corrupted reference files are valid UTF-8 Markdown.
- The required workflow surface is reduced to three roles, three hard gates,
  and no more than four core artifacts.
- CI detects the known corruption patterns and validates both light and full
  workflows.

## Baseline Findings

The clean `main` revision at `803b24a` has a 906-line `SKILL.md`, eight gate
scripts, and thirteen example artifacts. Core controller concepts are repeated
in `references/experiment-workflow.md` and `references/review-workflow.md`.

Eight routed references, not only the two originally identified, contain
character-by-character single quoting:

- `references/literature-workflow.md`
- `references/experiment-workflow.md`
- `references/review-workflow.md`
- `references/section-writing/general.md`
- `references/section-writing/introduction.md`
- `references/section-writing/methodology.md`
- `references/section-writing/experiments.md`
- `references/section-writing/related-work.md`

Their quote counts are approximately half their total character counts. This
breaks headings, lists, tables, and code while wasting context. Existing CI does
not detect it.

The current hard-gate design also blocks prose based on broad phrases and
ordinary experimental details such as window size, batch size, and learning
rate. These checks confuse manuscript quality judgment with deterministic data
integrity and can reject legitimate Methods or Limitations text.

## Workflow Modes

Select the lowest sufficient mode from the user's actual request. Escalate only
when the task begins to depend on evidence or experiment execution.

| Mode | Typical requests | Required process |
| --- | --- | --- |
| `edit` | Translate, polish, shorten, restructure, or revise supplied text | Work directly from supplied material; preserve meaning and flag unsupported additions. No project artifacts. |
| `evidence` | Literature synthesis, citation work, results prose, full-section drafting, manuscript review | Use claim-evidence mapping for affected claims and run the relevant evidence check. |
| `autonomous` | End-to-end literature, experiment, analysis, writing, and review | Maintain the full four-artifact workspace and pass all three gates. |

Mode selection is task-scoped, not project-wide. A user may request a light edit
inside a larger research repository without re-entering the autonomous state
machine. When ambiguity affects scientific claims, ask or state a bounded
assumption; do not silently promote the task into a full workflow.

## Roles

Roles describe responsibility and may be performed by one agent. They do not
create a permission system.

| Role | Responsibility |
| --- | --- |
| Lead | Interpret the request, choose mode, maintain the paper's thesis, and integrate final prose. |
| Research/Experiment | Find and verify sources, design claim-serving experiments, record execution, and trace results to raw evidence. |
| Reviewer | Independently challenge claim scope, citation support, numerical accuracy, and presentation before completion. |

Use separate agents only when the task benefits from independent work and the
runtime supports it. Never require multi-agent orchestration for a local edit.

## Core Artifacts

Artifacts are cumulative documents rather than one file per gate or role:

1. `paper_brief.md`: thesis, contribution, scope, audience, constraints, and
   target venue. Required for autonomous mode; optional otherwise.
2. `claim_evidence.md`: claims, source/result links, support level, and allowed
   wording. Required when new factual, citation, or result claims are drafted.
3. `research_log.md`: literature decisions, experiment plans, commands,
   configurations, failures, and raw-output locations. Required for autonomous
   experiments; optional for writing-only work.
4. `review.md`: unresolved blockers and final reviewer verdict. Required only
   for autonomous completion or an explicitly requested manuscript review.

Existing projects may map equivalent files onto these concepts. The skill must
not force renaming or duplication when equivalent trustworthy artifacts exist.

## Hard Gates

Only three conditions block completion:

1. Citation integrity: every external factual claim or citation introduced by
   the agent is verified against a primary or authoritative source. Unverified
   items remain explicit placeholders and are not presented as facts.
2. Result traceability: every reported number, comparison, ranking, or table
   claim traces to raw output or a reproducible transformation. Contradictory or
   missing evidence blocks that result claim, not unrelated writing.
3. Claim-scope integrity: the final wording does not exceed the support recorded
   in `claim_evidence.md`; limitations and negative results are stated directly.

Formatting, role separation, phase status, reference-read records, stylistic
phrases, and optional external review are advisory checks. They may produce
warnings but must not block unrelated work.

## Skill Structure

`SKILL.md` will contain:

- trigger-oriented frontmatter;
- the core principle;
- mode selection and escalation rules;
- the three hard gates;
- the four-artifact contract;
- a compact claim-evidence-work-review loop;
- direct, one-level routing to references;
- a short completion checklist.

Detailed literature, experiment, section-writing, citation, and review guidance
will live only in their routed references. Templates, long role prompts,
state-machine phases, external-review intake, and repeated gate explanations
will be removed from the main file.

References longer than 100 lines will have a compact table of contents. Routing
will identify exactly when each file is needed so light tasks do not load
irrelevant context.

## Script Policy

Keep deterministic checks where machines are more reliable than prose:

- source/result path existence;
- JSONL/YAML parseability and required fields when those formats are used;
- reported-value recomputation when a supported source format permits it;
- repository encoding and corruption checks.

Remove or demote checks based on broad phrase bans, manuscript-role write
barriers, phase permissions, mandatory external-review intake, minimum byte
counts, or mandatory section-contract boilerplate. A warning must explain its
scope and cannot block unrelated sections.

Scripts will accept the new artifact names and, where inexpensive, recognize
legacy names for compatibility. Obsolete scripts may remain as deprecated
wrappers only when that avoids breaking existing documented commands; otherwise
their logic and references will be removed together.

## Corruption Recovery

Recover the eight damaged references by reversing only the mechanical quoting
transformation, then normalize the remaining mojibake manually. Verify the
result structurally rather than assuming quote removal is sufficient:

- recognized Markdown headings and lists;
- balanced code fences;
- readable arrows and punctuation;
- no replacement characters or known mojibake tokens;
- no accidental changes to code or citation identifiers.

Do not use the damaged files as the sole source when a clean historical version
exists in Git history. Prefer the last clean content, then integrate later
meaningful changes explicitly.

## Tests

Follow RED-GREEN-REFACTOR for the skill change.

Before implementation, add or run baselines demonstrating that `main`:

- passes CI despite the eight corrupted references;
- requires workflow artifacts for a simple writing task;
- rejects legitimate manuscript details or bounded phrases through broad regex;
- exposes more than the intended roles, hard gates, and core artifacts.

After implementation, verify:

- `SKILL.md` is within 180-250 lines;
- quoted-character ratio is below `0.05` for Markdown files;
- no file contains U+922B, U+FFFD, or equivalent known corruption markers;
- routed references have recognizable headings and balanced code fences;
- an `edit` scenario completes without artifacts;
- an `evidence` scenario blocks an unsupported citation or number only;
- an `autonomous` scenario requires the four-artifact set and all three gates;
- legacy result-ledger validation still detects source/value mismatches;
- repository open-source and routing checks pass.

## Compatibility And Documentation

Update README and workflow documentation to describe the three modes and remove
claims about mandatory multi-agent permissions or universal fail-closed state.
Update examples to the four-artifact model. Retain venue templates and unrelated
reference material without churn.

Record legacy-to-new mappings in the README rather than keeping duplicate
runtime instructions in `SKILL.md`. External GPT review remains an optional
review technique and never a startup question or hard dependency.

## Non-Goals

- Guaranteeing novelty, correctness, or acceptance.
- Replacing human scientific judgment.
- Rewriting venue templates or general citation/reference guides unrelated to
  the runtime simplification.
- Preserving every old command when doing so would retain the old governance
  model.

## Acceptance Criteria

The refactor is complete when all tests pass, the known encoding defects are
absent, light editing has no workflow ceremony, evidence-bearing claims remain
fail-closed at their own boundary, and the documentation consistently describes
one tiered workflow rather than two overlapping systems.
