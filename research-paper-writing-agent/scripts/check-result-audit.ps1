param(
  [string]$ProjectRoot = ".",
  [string]$LedgerPath = "",
  [double]$Tolerance = 0.000001
)

$ErrorActionPreference = "Stop"

$Root = (Resolve-Path $ProjectRoot).Path
$Invariant = [System.Globalization.CultureInfo]::InvariantCulture

function Find-Artifact {
  param([string[]]$Names)

  foreach ($name in $Names) {
    $candidates = @(
      (Join-Path $Root $name),
      (Join-Path $Root "paper\$name"),
      (Join-Path $Root "paper\handoffs\$name"),
      (Join-Path $Root "handoffs\$name")
    )

    foreach ($candidate in $candidates) {
      if (Test-Path -LiteralPath $candidate) {
        return (Resolve-Path -LiteralPath $candidate).Path
      }
    }
  }

  return $null
}

function Require-Property {
  param(
    [object]$Object,
    [string]$Name,
    [string]$ResultId
  )

  if ($Object.PSObject.Properties.Name -notcontains $Name) {
    throw "Result ledger entry '$ResultId' missing required field: $Name"
  }

  $value = $Object.$Name
  if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
    throw "Result ledger entry '$ResultId' has empty field: $Name"
  }

  return $value
}

function Convert-ToDouble {
  param(
    [object]$Value,
    [string]$Context
  )

  try {
    return [double]::Parse(([string]$Value), $Invariant)
  } catch {
    throw "Cannot parse numeric value for ${Context}: $Value"
  }
}

function Resolve-SourcePath {
  param([string]$SourcePath)

  $candidate = $SourcePath
  if (-not [System.IO.Path]::IsPathRooted($candidate)) {
    $candidate = Join-Path $Root $candidate
  }

  if (-not (Test-Path -LiteralPath $candidate)) {
    throw "Result ledger source_path does not exist: $SourcePath"
  }

  return (Resolve-Path -LiteralPath $candidate).Path
}

function Recompute-CsvValue {
  param([object]$Entry)

  $sourcePath = Resolve-SourcePath -SourcePath ([string]$Entry.source_path)
  if ([System.IO.Path]::GetExtension($sourcePath).ToLowerInvariant() -ne ".csv") {
    return $null
  }

  $rows = @(Import-Csv -LiteralPath $sourcePath)
  if ($rows.Count -eq 0) {
    throw "CSV source is empty for result '$($Entry.result_id)': $($Entry.source_path)"
  }

  $idColumn = "result_id"
  if ($Entry.PSObject.Properties.Name -contains "source_result_id_column" -and -not [string]::IsNullOrWhiteSpace([string]$Entry.source_result_id_column)) {
    $idColumn = [string]$Entry.source_result_id_column
  }

  $valueColumn = "value"
  if ($Entry.PSObject.Properties.Name -contains "source_value_column" -and -not [string]::IsNullOrWhiteSpace([string]$Entry.source_value_column)) {
    $valueColumn = [string]$Entry.source_value_column
  }

  if ($rows[0].PSObject.Properties.Name -notcontains $idColumn) {
    throw "CSV source for result '$($Entry.result_id)' missing id column '$idColumn'."
  }

  if ($rows[0].PSObject.Properties.Name -notcontains $valueColumn) {
    throw "CSV source for result '$($Entry.result_id)' missing value column '$valueColumn'."
  }

  $matchedRows = @($rows | Where-Object { [string]($_.$idColumn) -eq [string]$Entry.result_id })
  if ($matchedRows.Count -eq 0) {
    throw "CSV source for result '$($Entry.result_id)' has no matching row in column '$idColumn'."
  }

  $values = @()
  foreach ($row in $matchedRows) {
    $values += Convert-ToDouble -Value $row.$valueColumn -Context "CSV $($Entry.source_path) row $($Entry.result_id)"
  }

  $sum = 0.0
  foreach ($value in $values) {
    $sum += $value
  }

  return $sum / [double]$values.Count
}

if ([string]::IsNullOrWhiteSpace($LedgerPath)) {
  $LedgerPath = Find-Artifact -Names @("result_ledger.jsonl", "result-ledger.jsonl")
}

if (-not $LedgerPath) {
  throw "Missing result ledger: expected result_ledger.jsonl"
}

$LedgerPath = (Resolve-Path -LiteralPath $LedgerPath).Path
$ClaimMapPath = Find-Artifact -Names @("claim_evidence.md", "claim_evidence_map.md")

$ClaimMap = ""
if ($ClaimMapPath) {
  $ClaimMap = Get-Content -Raw -LiteralPath $ClaimMapPath
}

$entries = @()
$lineNumber = 0
foreach ($line in (Get-Content -LiteralPath $LedgerPath)) {
  $lineNumber += 1
  if ([string]::IsNullOrWhiteSpace($line)) {
    continue
  }

  try {
    $entry = $line | ConvertFrom-Json
  } catch {
    throw "Invalid JSON in result ledger at line $lineNumber."
  }

  $resultId = "line $lineNumber"
  if ($entry.PSObject.Properties.Name -contains "result_id") {
    $resultId = [string]$entry.result_id
  }

  foreach ($field in @("result_id", "source_path", "reported_value", "metric", "dataset", "method", "metric_direction", "support_level", "table_cell")) {
    Require-Property -Object $entry -Name $field -ResultId $resultId | Out-Null
  }

  $metricDirection = ([string]$entry.metric_direction).ToLowerInvariant()
  if ($metricDirection -notin @("higher_is_better", "lower_is_better")) {
    throw "Result ledger entry '$resultId' has invalid metric_direction: $metricDirection"
  }

  Resolve-SourcePath -SourcePath ([string]$entry.source_path) | Out-Null
  $reported = Convert-ToDouble -Value $entry.reported_value -Context "reported_value for result '$resultId'"
  $recomputed = Recompute-CsvValue -Entry $entry
  if ($null -ne $recomputed) {
    $delta = [System.Math]::Abs($reported - $recomputed)
    if ($delta -gt $Tolerance) {
      throw "reported value mismatch for result '$resultId': ledger=$reported source=$recomputed tolerance=$Tolerance"
    }
  }

  $supportLevel = ([string]$entry.support_level).ToLowerInvariant()
  if ($supportLevel -notin @("supported", "partial", "unsupported", "contradicted", "context")) {
    throw "Result ledger entry '$resultId' has invalid support_level: $supportLevel"
  }

  $claimIds = @()
  if ($entry.PSObject.Properties.Name -contains "claim_ids" -and $null -ne $entry.claim_ids) {
    $claimIds = @($entry.claim_ids)
  }

  foreach ($claimId in $claimIds) {
    if ([string]::IsNullOrWhiteSpace([string]$claimId)) {
      continue
    }

    if ($ClaimMap -and $ClaimMap -notmatch [regex]::Escape([string]$claimId)) {
      throw "Result ledger entry '$resultId' references claim '$claimId' but the claim-evidence artifact does not contain it."
    }

    if ($supportLevel -in @("unsupported", "contradicted")) {
      throw "Result ledger entry '$resultId' marks claim '$claimId' as $supportLevel; do not write a supported result claim."
    }
  }

  $entry | Add-Member -NotePropertyName "_reported_double" -NotePropertyValue $reported -Force
  $entries += $entry
}

if ($entries.Count -eq 0) {
  throw "result_ledger.jsonl contains no result entries."
}

$groups = $entries | Group-Object {
  if ($_.PSObject.Properties.Name -contains "table_group" -and -not [string]::IsNullOrWhiteSpace([string]$_.table_group)) {
    return [string]$_.table_group
  }

  return "$($_.dataset)|$($_.metric)"
}

foreach ($group in $groups) {
  $directions = @($group.Group | ForEach-Object { ([string]$_.metric_direction).ToLowerInvariant() } | Select-Object -Unique)
  if ($directions.Count -ne 1) {
    throw "Result ledger rank group '$($group.Name)' mixes metric directions."
  }

  $descending = $directions[0] -eq "higher_is_better"
  if ($descending) {
    $ranked = @($group.Group | Sort-Object -Property _reported_double -Descending)
  } else {
    $ranked = @($group.Group | Sort-Object -Property _reported_double)
  }

  for ($i = 0; $i -lt $ranked.Count; $i++) {
    $computedRank = $i + 1
    $entry = $ranked[$i]
    if ($entry.PSObject.Properties.Name -contains "rank" -and -not [string]::IsNullOrWhiteSpace([string]$entry.rank)) {
      $reportedRank = [int]$entry.rank
      if ($reportedRank -ne $computedRank) {
        throw "ranking mismatch for result '$($entry.result_id)': ledger rank=$reportedRank computed rank=$computedRank"
      }
    }

    if ($entry.PSObject.Properties.Name -contains "best_marker" -and [bool]$entry.best_marker -and $computedRank -ne 1) {
      throw "best-marker mismatch for result '$($entry.result_id)': marked best but computed rank is $computedRank"
    }
  }
}

Write-Output "Result audit check passed."
Write-Output "Project root: $Root"
Write-Output "Result ledger: $LedgerPath"
if ($ClaimMapPath) {
  Write-Output "Claim evidence map: $ClaimMapPath"
}
