[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$InputDocx,
    [Parameter(Mandatory=$true)][string]$OutputPdf,
    [Parameter(Mandatory=$true)][string]$AuditPath
)
$ErrorActionPreference='Stop'
$inputFile=(Resolve-Path -LiteralPath $InputDocx).Path
$pdfFile=[System.IO.Path]::GetFullPath($OutputPdf)
$auditFile=[System.IO.Path]::GetFullPath($AuditPath)
if((Test-Path -LiteralPath $pdfFile) -or (Test-Path -LiteralPath $auditFile)){
    throw 'PDF or audit already exists. Choose new paths.'
}
if($inputFile -eq $pdfFile -or $inputFile -eq $auditFile -or $pdfFile -eq $auditFile){
    throw 'Input, PDF and audit paths must differ.'
}
New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($pdfFile)),([System.IO.Path]::GetDirectoryName($auditFile)) | Out-Null
$word=$null
$doc=$null
try {
    $word=New-Object -ComObject Word.Application
    $word.Visible=$false
    $word.DisplayAlerts=0
    $doc=$word.Documents.Open($inputFile,$false,$true)
    $doc.Repaginate()
    $doc.Activate()
    $checks=@()
    $skipped=@()
    for($index=1;$index -le $doc.Hyperlinks.Count;$index++){
        $link=$doc.Hyperlinks.Item($index)
        $anchor=[string]$link.SubAddress
        if(([string]$link.Address) -ne '' -or $anchor -eq ''){
            $skipped+=[pscustomobject]@{index=$index;text=$link.Range.Text;reason='external or non-anchor hyperlink'}
            continue
        }
        if(-not $doc.Bookmarks.Exists($anchor)){
            $checks+=[pscustomobject]@{index=$index;anchor=$anchor;passed=$false;reason='missing bookmark'}
            continue
        }
        $target=$doc.Bookmarks.Item($anchor).Range
        $expectedStart=$target.Start
        $expectedEnd=$target.End
        $doc.Range(0,0).Select()
        try {
            $link.Follow()
            $selectionStart=$word.Selection.Start
            $checks+=[pscustomobject]@{index=$index;text=$link.Range.Text;anchor=$anchor;
                expectedStart=$expectedStart;expectedEnd=$expectedEnd;selectionStart=$selectionStart;
                targetPage=$target.Information(3);targetText=$target.Text;
                passed=($selectionStart -eq $expectedStart)}
        } catch {
            $checks+=[pscustomobject]@{index=$index;anchor=$anchor;passed=$false;reason=$_.Exception.Message}
        }
    }
    $pageCount=$doc.ComputeStatistics(2)
    $doc.ExportAsFixedFormat($pdfFile,17)
    $failures=@($checks | Where-Object {-not $_.passed})
    $result=[pscustomobject]@{input=$inputFile;pdf=$pdfFile;pages=$pageCount;bookmarks=$doc.Bookmarks.Count;
        internalLinks=$checks.Count;allJumpsPassed=($checks.Count -gt 0 -and $failures.Count -eq 0);
        skipped=$skipped;checks=$checks;validationScope='Word bookmark and actual Follow; PDF destinations and visual pages need separate checks'}
    $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $auditFile -Encoding utf8
    $result | Select-Object pages,bookmarks,internalLinks,allJumpsPassed | ConvertTo-Json
    if(-not $result.allJumpsPassed){throw 'Some internal links failed, or no internal links were found. See audit.'}
} finally {
    if($null -ne $doc){$doc.Close(0)}
    if($null -ne $word){
        $word.Quit()
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null
    }
}
