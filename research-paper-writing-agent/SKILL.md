---
name: research-paper-writing-agent
description: Use when writing, revising, analyzing, or preparing ML/AI research papers, including literature synthesis, experiment planning, result interpretation, citation work, manuscript review, and end-to-end autonomous research for major conferences.
---

# Research Paper Writing Agent

## Core Principle

Treat a paper as a claim-evidence-writing loop. Apply the least process needed for
the user's task, but never invent a citation, number, experiment, or conclusion.

## Select a Mode

Choose the lowest sufficient mode from the current request. Mode is task-scoped,
not repository-wide. A local edit inside a large research project remains an
`edit` task unless the requested change introduces or evaluates evidence.

| Mode | Use for | Required process |
| --- | --- | --- |
| `edit` | Translation, polishing, shortening, restructuring, or revising supplied text | Work directly from supplied material. Preserve meaning and flag unsupported additions. Create no workflow artifacts. |
| `evidence` | Literature synthesis, citations, result prose, full-section drafting, or manuscript review | Map affected claims to sources or results and apply the relevant hard gate. |
| `autonomous` | End-to-end literature, experiments, analysis, writing, and review | Maintain all four core artifacts and pass all three hard gates before claiming completion. |

Escalate from `edit` to `evidence` when the task requires a new factual claim,
external citation, reported result, or scientific conclusion. Escalate to
`autonomous` only when Codex is expected to manage the research loop rather than a
bounded writing or analysis task.

If the mode is ambiguous and the distinction changes scientific content, state a
bounded assumption or ask one concise question. Do not silently start a research
governance workflow for an ordinary paragraph edit.

Mode boundary examples:

- "Polish this abstract without changing claims" is `edit`.
- "Add recent citations and strengthen the motivation" is `evidence`.
- "Survey the field, run the experiments, and finish the paper" is `autonomous`.
- "Explain why this result is weak" is `evidence`, not automatically autonomous.

## Responsibilities

These are responsibilities, not a permission system. One agent may perform all
three. Use separate agents only when independent work improves the task and the
runtime supports it.

| Role | Responsibility |
| --- | --- |
| Lead | Interpret the request, choose the mode, maintain the thesis, and integrate final prose. |
| Research/Experiment | Verify literature, design claim-serving experiments, record execution, and trace results to raw evidence. |
| Reviewer | Independently challenge citation support, numerical accuracy, claim scope, and presentation. |

Never require multi-agent orchestration for `edit` mode.

## Hard Gates

Only these integrity conditions block evidence-bearing output. A failed gate blocks
the affected citation, result, or claim. It blocks the whole paper only when that
failure invalidates the central thesis.

### Citation integrity

Verify every external factual claim or citation introduced by Codex against a
primary or authoritative source. Confirm bibliographic metadata and read the
passage supporting the intended wording.

If verification fails, omit the claim or leave an explicit placeholder. Never
present remembered metadata, search snippets, or secondary summaries as verified.

### Result traceability

Trace every reported number, delta, comparison, rank, or table claim to raw output
or a reproducible transformation. Confirm metric direction, dataset, method, and
aggregation.

If a value is missing, contradictory, or unreproducible, stop that result claim
and repair or remove it. Continue unrelated writing when its evidence is sound.

### Claim-scope integrity

Use wording no stronger than the recorded evidence. Separate observation,
interpretation, implication, and speculation. State negative or mixed outcomes
directly; limitations clarify scope after the result rather than excusing it.

If evidence is partial, bound the setting. If unsupported, weaken or remove the
claim. Changing the paper's central thesis requires user approval.

## Core Artifacts

Use cumulative documents instead of one file per phase, gate, or role. Equivalent
existing project files may satisfy these contracts; do not duplicate or rename
trustworthy artifacts solely to match these filenames.

| Artifact | Contents | Required when |
| --- | --- | --- |
| `paper_brief.md` | Thesis, contribution, scope, audience, target venue, constraints | `autonomous` mode |
| `claim_evidence.md` | Claim ID, allowed wording, source/result link, support status, boundary | New factual, citation, or result claims |
| `research_log.md` | Literature decisions, experiment plans, commands, configurations, failures, raw-output paths | Autonomous experiments or substantial research |
| `review.md` | Three gate verdicts, prioritized findings, unresolved blockers | Autonomous completion or requested manuscript review |

Use the examples in `examples/` as starting structures, not mandatory bureaucracy.
In `edit` mode, create none of these unless the user explicitly asks for them.

## Core Loop

1. Define the task and select the mode.
2. Identify the claims the output will make.
3. Gather only the evidence needed for those claims.
4. For experiments, define the decision and stop criteria before expensive runs.
5. Draft with wording bounded by the available support.
6. Review the affected gates and repair only the failed boundary.
7. Report unresolved uncertainty; do not hide it with polished prose.

For autonomous work, keep the paper's thesis stable while evidence accumulates.
Experiments must serve a claim or decision. Failed results trigger diagnosis, a
bounded repair test, and then a decision to support, weaken, redesign, or remove
the claim. Do not convert the paper into a different paper type without approval.

## Reference Routing

Read only the references required for the current action. All routes are direct
from this file; do not load unrelated guides preemptively.

| Action | Read |
| --- | --- |
| Literature search, novelty boundary, citation-bearing synthesis | `references/literature-workflow.md` |
| Experiment planning, execution, failure diagnosis, result interpretation | `references/experiment-workflow.md` |
| Title, abstract, discussion, limitations, conclusion, appendix, general revision | `references/section-writing/general.md` |
| Introduction | `references/section-writing/introduction.md` |
| Methods or Methodology | `references/section-writing/methodology.md` |
| Experiments, Results, ablations, result tables or figures | `references/section-writing/experiments.md` and `references/experiment-workflow.md` |
| Related Work | `references/section-writing/related-work.md` and `references/literature-workflow.md` |
| Full-manuscript or pre-submission review | `references/review-workflow.md` |
| Detailed citation APIs or BibTeX handling | `references/citation-workflow.md` |
| Venue requirements | `references/checklists.md`; verify current official policy before relying on it |
| General writing craft | `references/writing-guide.md` |

External GPT review is optional. Use it only when the user requests it or an
additional independent perspective is useful. It is advisory, receives no secrets
or confidential material, and cannot override primary evidence or user intent.

## Working Rules

- Preserve the user's supplied meaning in `edit` mode. Flag substantive changes.
- Prefer primary papers, official venue policies, and raw experiment outputs.
- Do not reconstruct citations, results, or reviewer feedback from memory.
- Keep methods and configuration details when scientifically relevant. Do not ban
  legitimate prose through broad phrase matching.
- Distinguish missing evidence from negative evidence. Neither licenses a stronger
  claim.
- Use the project's native analysis code when it is more reliable than a bundled
  checker.
- Record commands and source paths for reproducible result claims.
- Treat venue policies and deadlines as time-sensitive; verify current sources.
- Never claim novelty, correctness, acceptance, or reproducibility merely because
  this workflow was followed.

## Completion Checks

For `edit` mode:

- The revision preserves intended meaning and scope.
- No unsupported fact, citation, result, or claim was added.
- The requested style, structure, or language change is complete.

For `evidence` mode:

- Every introduced citation is verified.
- Every reported number is traceable when results are involved.
- Claim wording matches the support recorded in `claim_evidence.md` or its
  trustworthy project equivalent.
- Unresolved items are explicit and localized.

For `autonomous` mode:

- `paper_brief.md`, `claim_evidence.md`, `research_log.md`, and `review.md` or
  equivalent artifacts are current.
- Citation integrity, Result traceability, and Claim-scope integrity each have an
  explicit verdict.
- No unresolved blocker remains.
- The final manuscript, figures, tables, and conclusion express the same thesis
  and evidence boundary.
