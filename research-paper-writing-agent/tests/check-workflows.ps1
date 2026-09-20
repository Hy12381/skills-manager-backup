$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$TempRoot = Join-Path $env:TEMP "research-paper-writing-agent-workflow-tests"
Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $TempRoot | Out-Null

# Edit mode accepts supplied prose without project artifacts.
$EditRoot = Join-Path $TempRoot "edit"
New-Item -ItemType Directory -Force -Path $EditRoot | Out-Null
Set-Content -LiteralPath (Join-Path $EditRoot "draft.md") -Value "We improve clarity without changing the supplied claim."
$unexpectedEditArtifacts = @(Get-ChildItem -LiteralPath $EditRoot -File | Where-Object { $_.Name -ne "draft.md" })
if ($unexpectedEditArtifacts.Count -ne 0) {
  throw "Edit mode unexpectedly required workflow artifacts."
}

# A result that points at a missing source must be blocked locally.
$UnsupportedRoot = Join-Path $TempRoot "unsupported-result"
New-Item -ItemType Directory -Force -Path $UnsupportedRoot | Out-Null
Set-Content -LiteralPath (Join-Path $UnsupportedRoot "claim_evidence.md") -Value "# Claim Evidence`n`n| Claim ID | Evidence | Support |`n| --- | --- | --- |`n| C1 | results/missing.csv | supported |"
Set-Content -LiteralPath (Join-Path $UnsupportedRoot "result_ledger.jsonl") -Value '{"result_id":"R1","source_path":"results/missing.csv","reported_value":0.91,"metric":"F1","dataset":"demo","method":"ours","metric_direction":"higher_is_better","claim_ids":["C1"],"support_level":"supported","table_cell":"Table 1 / demo / F1"}'

$unsupportedBlocked = $false
try {
  & (Join-Path $Root "scripts\check-result-audit.ps1") -ProjectRoot $UnsupportedRoot | Out-Null
} catch {
  if ($_.Exception.Message -match "source_path does not exist") {
    $unsupportedBlocked = $true
  } else {
    throw
  }
}
if (-not $unsupportedBlocked) {
  throw "Expected a missing result source to block its result claim."
}

# Matching source data and ledger values pass without unrelated artifacts.
$SupportedRoot = Join-Path $TempRoot "supported-result"
New-Item -ItemType Directory -Force -Path (Join-Path $SupportedRoot "results") | Out-Null
Set-Content -LiteralPath (Join-Path $SupportedRoot "claim_evidence.md") -Value "# Claim Evidence`n`n| Claim ID | Evidence | Support |`n| --- | --- | --- |`n| C1 | results/main.csv | supported |"
Set-Content -LiteralPath (Join-Path $SupportedRoot "results\main.csv") -Value "result_id,value`nR1,0.91`nR2,0.82"
Set-Content -LiteralPath (Join-Path $SupportedRoot "result_audit.md") -Value "# Legacy Result Audit`n`n- Route status: kill`n"
@'
{"result_id":"R1","source_path":"results/main.csv","reported_value":0.91,"metric":"F1","dataset":"demo","method":"ours","metric_direction":"higher_is_better","claim_ids":["C1"],"support_level":"supported","rank":1,"best_marker":true,"table_cell":"Table 1 / demo / F1"}
{"result_id":"R2","source_path":"results/main.csv","reported_value":0.82,"metric":"F1","dataset":"demo","method":"base","metric_direction":"higher_is_better","claim_ids":[],"support_level":"context","rank":2,"table_cell":"Table 1 / demo / F1"}
'@ | Set-Content -LiteralPath (Join-Path $SupportedRoot "result_ledger.jsonl")
& (Join-Path $Root "scripts\check-result-audit.ps1") -ProjectRoot $SupportedRoot | Out-Null

# Legitimate method and bounded result prose is not subject to phrase bans.
$Prose = "We use batch size 32 and learning rate 0.001. The method remains competitive in this setting."
Set-Content -LiteralPath (Join-Path $SupportedRoot "manuscript.md") -Value $Prose

$ObsoleteScripts = @(
  "check-protocol-state.ps1",
  "check-writing-gate.ps1",
  "check-workflow-supervision.ps1",
  "check-role-boundaries.ps1",
  "check-manuscript-prose.ps1",
  "check-reference-routes.ps1",
  "check-experiment-license.ps1"
)
foreach ($script in $ObsoleteScripts) {
  if (Test-Path -LiteralPath (Join-Path $Root "scripts\$script")) {
    throw "Obsolete universal gate remains: $script"
  }
}

Write-Output "Workflow checks completed."
