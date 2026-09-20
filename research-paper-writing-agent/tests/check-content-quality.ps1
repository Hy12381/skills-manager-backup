$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)
$MojibakeMarker = [string][char]0x922b
$ReplacementCharacter = [string][char]0xfffd
$Markdown = Get-ChildItem $Root -Recurse -File -Filter "*.md" |
  Where-Object { $_.FullName -notmatch "\\.git\\" }

foreach ($file in $Markdown) {
  $text = [System.IO.File]::ReadAllText($file.FullName, $Utf8Strict)

  if ($text.Length -gt 0) {
    $quotedCharacterRatio = [regex]::Matches($text, "'").Count / [double]$text.Length
    if ($quotedCharacterRatio -ge 0.05) {
      throw "Quoted-character corruption in $($file.FullName): $quotedCharacterRatio"
    }
  }

  if ($text.Contains($MojibakeMarker) -or $text.Contains($ReplacementCharacter)) {
    throw "Mojibake or replacement character in $($file.FullName)"
  }

  if (([regex]::Matches($text, '(?m)^```').Count % 2) -ne 0) {
    throw "Unbalanced code fences in $($file.FullName)"
  }
}

$RoutedReferences = @(
  "references/literature-workflow.md",
  "references/experiment-workflow.md",
  "references/review-workflow.md",
  "references/section-writing/general.md"
)

foreach ($relative in $RoutedReferences) {
  $text = Get-Content -Raw -LiteralPath (Join-Path $Root $relative)
  if ($text -notmatch '(?m)^##\s+\S') {
    throw "No readable section headings in $relative"
  }
}

Write-Output "Content quality checks completed."
