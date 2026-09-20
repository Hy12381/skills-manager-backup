$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$SkillPath = Join-Path $Root "SKILL.md"
$Text = Get-Content -Raw -LiteralPath $SkillPath
$LineCount = (Get-Content -LiteralPath $SkillPath).Count

if ($LineCount -lt 180 -or $LineCount -gt 250) {
  throw "SKILL.md line budget violated: $LineCount"
}

$RequiredItems = @(
  "edit",
  "evidence",
  "autonomous",
  "Lead",
  "Research/Experiment",
  "Reviewer",
  "Citation integrity",
  "Result traceability",
  "Claim-scope integrity",
  "paper_brief.md",
  "claim_evidence.md",
  "research_log.md",
  "review.md",
  "references/literature-workflow.md",
  "references/experiment-workflow.md",
  "references/review-workflow.md",
  "references/section-writing/general.md"
)

foreach ($item in $RequiredItems) {
  if ($Text -notmatch [regex]::Escape($item)) {
    throw "Missing skill contract item: $item"
  }
}

$LegacyControllerTerms = @(
  "Workflow Supervisor",
  "protocol_state.md",
  "permission boundaries",
  "Remote Audit Window Intake",
  "Phase State Machine"
)

foreach ($legacy in $LegacyControllerTerms) {
  if ($Text -match [regex]::Escape($legacy)) {
    throw "Legacy controller remains: $legacy"
  }
}

Write-Output "Skill contract checks completed."
