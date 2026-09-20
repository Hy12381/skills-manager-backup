# Tiered Research Paper Skill Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the universal research-governance state machine with a tiered writing workflow while preserving citation, result, and claim-scope integrity.

**Architecture:** `SKILL.md` becomes a compact router for `edit`, `evidence`, and `autonomous` modes. Detailed guidance remains in one-level references, four cumulative artifacts replace role/gate-specific files, and deterministic scripts check repository integrity and source-backed numeric results without policing prose style.

**Tech Stack:** Markdown, PowerShell 5.1+, GitHub Actions on `windows-latest`, JSONL/CSV for optional result validation.

---

## File Map

- `SKILL.md`: mode selection, three hard gates, four artifact contracts, core loop, and reference routing.
- `references/literature-workflow.md`: verified literature search and synthesis only.
- `references/experiment-workflow.md`: claim-serving experiment planning, execution logging, and result interpretation.
- `references/review-workflow.md`: independent scientific review and final integrity verdict.
- `references/section-writing/general.md`: general drafting guidance shared across sections.
- `references/section-writing/{introduction,methodology,experiments,related-work}.md`: section-specific guidance with no duplicated controller rules.
- `examples/{paper_brief,claim_evidence,research_log,review}.example.md`: the complete artifact model.
- `scripts/check-result-audit.ps1`: optional deterministic numeric traceability check using `claim_evidence.md` and a JSONL ledger when present.
- `tests/check-content-quality.ps1`: encoding, quoted-character, Markdown-heading, and fence checks.
- `tests/check-skill-contract.ps1`: static contract checks for modes, roles, gates, artifacts, routing, and line budget.
- `tests/check-workflows.ps1`: behavior fixtures for light editing and evidence/result workflows.
- `README.md`, `docs/workflow.md`, `docs/gates.md`, `docs/external-gpt-review.md`: user-facing description of the tiered workflow.
- `.github/workflows/check.yml`: execute all repository checks.

### Task 1: Add Failing Repository-Quality Tests

**Files:**
- Create: `tests/check-content-quality.ps1`
- Modify: `.github/workflows/check.yml`
- Test: `tests/check-content-quality.ps1`

- [ ] **Step 1: Create the corruption test**

Implement a PowerShell test that scans repository Markdown as UTF-8, computes
`single_quote_count / character_count`, and throws when the ratio is `>= 0.05`.
It must also reject U+922B, U+FFFD, missing readable headings in routed references,
and unbalanced triple-backtick fences.

```powershell
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$markdown = Get-ChildItem $Root -Recurse -File -Filter "*.md" |
  Where-Object { $_.FullName -notmatch "\\.git\\" }

foreach ($file in $markdown) {
  $text = [System.IO.File]::ReadAllText($file.FullName, [Text.UTF8Encoding]::new($false, $true))
  if ($text.Length -gt 0) {
    $ratio = ([regex]::Matches($text, "'").Count / [double]$text.Length)
    if ($ratio -ge 0.05) { throw "Quoted-character corruption in $($file.FullName): $ratio" }
  }
  if ($text.Contains([char]0x922b) -or $text.Contains([char]0xfffd)) {
    throw "Mojibake or replacement character in $($file.FullName)"
  }
  if (([regex]::Matches($text, '(?m)^```').Count % 2) -ne 0) {
    throw "Unbalanced code fences in $($file.FullName)"
  }
}

$routed = @(
  "references/literature-workflow.md",
  "references/experiment-workflow.md",
  "references/review-workflow.md",
  "references/section-writing/general.md"
)
foreach ($relative in $routed) {
  $text = Get-Content -Raw -LiteralPath (Join-Path $Root $relative)
  if ($text -notmatch '(?m)^##\s+\S') { throw "No readable section headings in $relative" }
}
Write-Output "Content quality checks completed."
```

- [ ] **Step 2: Run the test and verify RED**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
```

Expected: FAIL naming `references/literature-workflow.md` as quoted-character corruption. Confirm the existing `tests/check-open-source.ps1` still passes, proving the old CI missed the defect.

- [ ] **Step 3: Add the failing check to CI**

Add a `Run content quality checks` step to `.github/workflows/check.yml` immediately after checkout using the command above.

- [ ] **Step 4: Commit the RED test**

```powershell
git add tests/check-content-quality.ps1 .github/workflows/check.yml
git commit -m "test: detect corrupted skill references"
```

### Task 2: Recover the Eight Corrupted References

**Files:**
- Modify: `references/literature-workflow.md`
- Modify: `references/experiment-workflow.md`
- Modify: `references/review-workflow.md`
- Modify: `references/section-writing/general.md`
- Modify: `references/section-writing/introduction.md`
- Modify: `references/section-writing/methodology.md`
- Modify: `references/section-writing/experiments.md`
- Modify: `references/section-writing/related-work.md`
- Test: `tests/check-content-quality.ps1`

- [ ] **Step 1: Reverse the mechanical quoting transformation**

For each damaged line in all eight files, remove the single-character wrapper quotes and the spaces
between wrappers. Preserve blank lines and the already-readable first heading.
Because commit `7279689` introduced all eight files already damaged, do not claim
a clean historical source exists. Treat contractions, possessives, and quoted
examples as manual-review points after mechanical recovery.

- [ ] **Step 2: Repair mojibake and Markdown structure**

Replace the U+922B damaged arrow token with `->`, restore apostrophes where grammar
requires them, normalize headings/lists/tables/code fences, and keep only domain
guidance. Delete controller material that duplicates modes, roles, artifacts, or
gates from the new `SKILL.md` contract.

- [ ] **Step 3: Run content-quality GREEN checks**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
```

Expected: `Content quality checks completed.`

- [ ] **Step 4: Inspect the recovered references**

Run:

```powershell
rg -n "^#{1,4} |'#'#|'P'h'a's'e" references/literature-workflow.md references/experiment-workflow.md references/review-workflow.md references/section-writing
```

Expected: readable headings only; none of the corruption patterns.

- [ ] **Step 5: Commit recovery**

```powershell
git add references/literature-workflow.md references/experiment-workflow.md references/review-workflow.md references/section-writing
git commit -m "fix: recover corrupted workflow references"
```

### Task 3: Define and Test the Slim Skill Contract

**Files:**
- Create: `tests/check-skill-contract.ps1`
- Modify: `SKILL.md`
- Test: `tests/check-skill-contract.ps1`

- [ ] **Step 1: Write static contract tests**

The test must require 180-250 lines, exactly the three mode headings/labels,
exactly the three role names, exactly four artifact paths, the three hard-gate
names, and direct routes to every workflow reference. It must reject legacy
controller terms in `SKILL.md`: `Workflow Supervisor`, `protocol_state.md`,
`permission boundaries`, `Remote Audit Window Intake`, and `Phase State Machine`.

```powershell
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$path = Join-Path $Root "SKILL.md"
$text = Get-Content -Raw -LiteralPath $path
$lines = (Get-Content -LiteralPath $path).Count
if ($lines -lt 180 -or $lines -gt 250) { throw "SKILL.md line budget violated: $lines" }

foreach ($needle in @("edit", "evidence", "autonomous", "Lead", "Research/Experiment", "Reviewer",
  "Citation integrity", "Result traceability", "Claim-scope integrity",
  "paper_brief.md", "claim_evidence.md", "research_log.md", "review.md")) {
  if ($text -notmatch [regex]::Escape($needle)) { throw "Missing skill contract item: $needle" }
}
foreach ($legacy in @("Workflow Supervisor", "protocol_state.md", "permission boundaries", "Remote Audit Window Intake", "Phase State Machine")) {
  if ($text -match [regex]::Escape($legacy)) { throw "Legacy controller remains: $legacy" }
}
Write-Output "Skill contract checks completed."
```

- [ ] **Step 2: Run the test and verify RED**

Run `powershell -ExecutionPolicy Bypass -File .\tests\check-skill-contract.ps1`.
Expected: FAIL with `SKILL.md line budget violated: 906`.

- [ ] **Step 3: Rewrite `SKILL.md` to the approved architecture**

Use imperative language. Keep only frontmatter, core principle, mode table,
escalation rules, three gates, four artifacts, the claim-evidence-work-review
loop, direct reference routing, and completion checks. State explicitly that
`edit` mode creates no artifacts and that a failed gate blocks only the affected
claim or result unless it invalidates the paper thesis.

- [ ] **Step 4: Run contract and content tests**

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-skill-contract.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
```

Expected: both commands complete successfully.

- [ ] **Step 5: Commit the slim controller**

```powershell
git add SKILL.md tests/check-skill-contract.ps1
git commit -m "refactor: introduce tiered paper workflow"
```

### Task 4: Replace Governance Artifacts With Four Cumulative Examples

**Files:**
- Create: `examples/paper_brief.example.md`
- Create: `examples/claim_evidence.example.md`
- Create: `examples/research_log.example.md`
- Create: `examples/review.example.md`
- Delete: legacy files under `examples/` except the four new examples
- Modify: `tests/check-open-source.ps1`

- [ ] **Step 1: Update the package test first**

Require exactly the four new example files. Remove requirements for protocol
state, external reviewer, experiment license, handoff manifest, result audit,
section contracts, workflow supervision, defensive-writing audit, failure
diagnosis, and writing-gate report.

- [ ] **Step 2: Run the package test and verify RED**

Run `powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1`.
Expected: FAIL with `Missing required file: examples/paper_brief.example.md`.

- [ ] **Step 3: Create complete examples**

Use concrete sample content. `claim_evidence.example.md` must include claim ID,
wording, evidence path/URL, support status, and boundary. `research_log.example.md`
must include a literature decision and an experiment entry with hypothesis,
metric, baseline, command, raw output path, outcome, and next decision.
`review.example.md` must record the three gate verdicts and unresolved blockers.

- [ ] **Step 4: Delete legacy examples and run tests**

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
```

Expected: both commands complete successfully.

- [ ] **Step 5: Commit the artifact model**

```powershell
git add examples tests/check-open-source.ps1
git commit -m "refactor: consolidate research artifacts"
```

### Task 5: Replace Universal Gates With Scoped Workflow Tests

**Files:**
- Create: `tests/check-workflows.ps1`
- Modify: `scripts/check-result-audit.ps1`
- Delete: `scripts/check-protocol-state.ps1`
- Delete: `scripts/check-writing-gate.ps1`
- Delete: `scripts/check-workflow-supervision.ps1`
- Delete: `scripts/check-role-boundaries.ps1`
- Delete: `scripts/check-manuscript-prose.ps1`
- Delete: `scripts/check-reference-routes.ps1`
- Delete: `scripts/check-experiment-license.ps1`
- Delete: `tests/check-gates.ps1`

- [ ] **Step 1: Write workflow fixtures before deleting old gates**

The test creates three temporary projects:

- `edit`: supplied prose only; verifies no artifact or gate script is needed.
- `unsupported-result`: `claim_evidence.md` points to a missing result source;
  verifies result validation fails on that claim.
- `supported-result`: CSV plus JSONL ledger contains matching values; verifies
  result validation passes.

Also verify that legitimate prose containing `batch size 32`, `learning rate
0.001`, and `remains competitive` is not scanned or rejected.

- [ ] **Step 2: Run the workflow test and verify RED**

Run `powershell -ExecutionPolicy Bypass -File .\tests\check-workflows.ps1`.
Expected: FAIL because the result checker still expects legacy
`claim_evidence_map.md` and the old prose/gate surface still exists.

- [ ] **Step 3: Scope the result checker**

Change `check-result-audit.ps1` to prefer `claim_evidence.md`, accept legacy
`claim_evidence_map.md` as a compatibility alias, and validate numeric entries
only when a result ledger is supplied. It must never inspect manuscript prose or
require unrelated writing artifacts.

- [ ] **Step 4: Remove obsolete blocking scripts and tests**

Delete the seven universal governance scripts and `tests/check-gates.ps1`.
Update all repository references in the same task so no documented command
points at a deleted file.

- [ ] **Step 5: Run scoped workflow tests**

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-workflows.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1
```

Expected: the edit and supported-result fixtures pass; the test internally
confirms the unsupported-result fixture is blocked for the expected missing
source reason.

- [ ] **Step 6: Commit scoped validation**

```powershell
git add scripts tests
git commit -m "refactor: scope gates to research evidence"
```

### Task 6: Align References and Documentation

**Files:**
- Modify: `references/section-writing/introduction.md`
- Modify: `references/section-writing/methodology.md`
- Modify: `references/section-writing/experiments.md`
- Modify: `references/section-writing/related-work.md`
- Modify: `README.md`
- Modify: `docs/workflow.md`
- Modify: `docs/gates.md`
- Modify: `docs/external-gpt-review.md`
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Remove duplicated controller instructions from section references**

Keep section-specific rhetorical and evidence guidance. Replace mandatory phase,
role, section-contract, and protocol-state language with links back to the
single mode/gate definitions in `SKILL.md`.

- [ ] **Step 2: Rewrite user documentation**

Document the three modes, three roles, three gates, and four artifacts once.
Include a legacy mapping table. Describe external GPT review as optional and
advisory. Remove startup intake and permission-system claims.

- [ ] **Step 3: Add a changelog entry**

Record the breaking removal of universal gate scripts, the compatibility alias
for `claim_evidence_map.md`, and the restored references.

- [ ] **Step 4: Scan for stale runtime concepts**

```powershell
rg -n "protocol_state|Workflow Supervisor|permission boundaries|Remote Audit Window Intake|check-writing-gate|check-role-boundaries|check-manuscript-prose" SKILL.md README.md docs references
```

Expected: no active instruction uses these concepts; any occurrence is confined
to an explicitly labeled legacy-migration note.

- [ ] **Step 5: Commit documentation alignment**

```powershell
git add README.md CHANGELOG.md docs references/section-writing
git commit -m "docs: align guidance with tiered workflow"
```

### Task 7: Final Verification

**Files:**
- Modify: `.github/workflows/check.yml`
- Test: all scripts under `tests/`

- [ ] **Step 1: Ensure CI runs the final test suite**

The workflow must invoke, in order:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\check-content-quality.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-skill-contract.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-workflows.ps1
powershell -ExecutionPolicy Bypass -File .\tests\check-open-source.ps1
```

- [ ] **Step 2: Run every test locally**

Run the four commands above. Expected: all complete successfully with no warning
or error output.

- [ ] **Step 3: Run structural and diff checks**

```powershell
(Get-Content .\SKILL.md).Count
git diff --check main...HEAD
git status --short
```

Expected: line count 180-250; no whitespace errors; only intentional uncommitted
changes, preferably none.

- [ ] **Step 4: Validate the skill package**

Run the available `quick_validate.py` from the installed `skill-creator` skill
against this repository. Expected: valid YAML frontmatter and skill naming.

- [ ] **Step 5: Commit final CI wiring if changed**

```powershell
git add .github/workflows/check.yml
git commit -m "ci: verify tiered skill contract"
```

- [ ] **Step 6: Review commit history and summarize compatibility**

Run `git log --oneline main..HEAD` and report the line-count reduction, deleted
gate surface, retained deterministic result validation, test commands, and any
intentional breaking changes.
