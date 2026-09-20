$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot

$Required = @(
  "SKILL.md",
  "README.md",
  "LICENSE",
  "examples/paper_brief.example.md",
  "examples/claim_evidence.example.md",
  "examples/research_log.example.md",
  "examples/review.example.md",
  "docs/workflow.md",
  "docs/gates.md",
  "docs/external-gpt-review.md",
  "tests/check-content-quality.ps1",
  "tests/check-skill-contract.ps1",
  "tests/check-workflows.ps1",
  "scripts/check-result-audit.ps1",
  "references/literature-workflow.md",
  "references/experiment-workflow.md",
  "references/section-writing/general.md",
  "references/section-writing/introduction.md",
  "references/section-writing/methodology.md",
  "references/section-writing/experiments.md",
  "references/section-writing/related-work.md",
  "references/review-workflow.md"
)

foreach ($rel in $Required) {
  $path = Join-Path $Root $rel
  if (-not (Test-Path $path)) {
    throw "Missing required file: $rel"
  }
}

$Skill = Get-Content -Raw (Join-Path $Root "SKILL.md")
$RequiredAnchors = @(
  "name: research-paper-writing-agent",
  "Select a Mode",
  "Citation integrity",
  "Result traceability",
  "Claim-scope integrity",
  "paper_brief.md",
  "claim_evidence.md",
  "research_log.md",
  "review.md"
)

foreach ($needle in $RequiredAnchors) {
  if ($Skill -notlike "*$needle*") {
    throw "SKILL.md missing anchor: $needle"
  }
}

$SensitivePatterns = @(
  'C:/Users/lenovo',
  'C:\\Users\\lenovo',
  'OPENAI_API_KEY\s*=',
  'ANTHROPIC_API_KEY\s*=',
  'SECRET_KEY\s*=',
  'ACCESS_TOKEN\s*=',
  'PASSWORD\s*='
)

$ScanFiles = Get-ChildItem $Root -Recurse -File |
  Where-Object {
    $_.FullName -notmatch "\\.git\\" -and
    $_.FullName -notmatch "\\tests\\check-open-source\.ps1$"
  }

$Matches = foreach ($pattern in $SensitivePatterns) {
  $ScanFiles | Select-String -Pattern $pattern -CaseSensitive:$false -ErrorAction SilentlyContinue
}

if ($Matches) {
  Write-Warning "Potential sensitive/local strings found:"
  $Matches | ForEach-Object { Write-Warning "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
  throw "Open-source package check found potential sensitive/local strings."
}

Write-Output "Open-source package check completed."
