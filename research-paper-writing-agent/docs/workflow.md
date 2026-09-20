# Workflow Overview

The skill applies the smallest workflow that preserves scientific integrity.

## Mode Selection

### Edit

Use for supplied-text translation, polishing, shortening, restructuring, and
local revision. Preserve meaning, identify substantive changes, and do not create
project artifacts. Escalate only if the requested output needs a new citation,
result, factual statement, or scientific conclusion.

### Evidence

Use for literature synthesis, citation work, result prose, full scientific
sections, or manuscript review. Identify the affected claims, record their source
or result support in `claim_evidence.md` or an equivalent file, and apply only the
relevant hard gates.

### Autonomous

Use when Codex manages literature, experiments, analysis, writing, and review.
Maintain:

1. `paper_brief.md` for the thesis and scope;
2. `claim_evidence.md` for support and allowed wording;
3. `research_log.md` for decisions, commands, failures, and output paths;
4. `review.md` for independent findings and final gate verdicts.

## Core Loop

1. Select the task mode.
2. Define the claims the output will make.
3. Gather only the evidence needed for those claims.
4. Design experiments around decisions and stop criteria.
5. Draft with wording bounded by support.
6. Review citation, result, and claim-scope integrity.
7. Repair the failed boundary and report unresolved uncertainty.

Experiments should serve claims. A failed experiment is first classified as an
execution, evaluation, tuning, or scientific failure. Run bounded repair tests;
then support, weaken, redesign, or remove the claim. Changing the central thesis
or paper type requires author approval.

## Responsibilities

The Lead integrates the paper, Research/Experiment gathers evidence, and the
Reviewer challenges it independently. These responsibilities may be performed by
one agent. Multi-agent execution is optional and should not add ceremony to a
bounded task.

## Completion

An edit completes when the requested revision is accurate and adds no unsupported
content. Evidence work completes when affected citations, numbers, and claims pass
their gates or remain explicit local blockers. Autonomous work completes when all
four artifacts are current and no central blocker remains.
