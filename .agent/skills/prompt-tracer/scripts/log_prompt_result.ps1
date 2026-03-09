param (
    [Parameter(Mandatory = $true)]
    [string]$Prompt,
    [Parameter(Mandatory = $true)]
    [string]$Result,
    [string]$ConfigPath = "d:\Workflow\.agent\rules\config.json"
)

$Config = Get-Content $ConfigPath | ConvertFrom-Json
$HistoryFile = $Config.prompt_history_path

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Prepare the history entry
$Entry = @"
`n---
### [$Timestamp] Prompt Execution
**Prompt**:
> $Prompt

**Result**:
$Result
"@

# Initialize history if it doesn't exist
if (-not (Test-Path $HistoryFile)) {
    "# Prompt Results History`n`nChronological log of prompt interactions and their outcomes.`n" | Out-File -FilePath $HistoryFile -Encoding utf8
}

# Append the entry
$Entry | Out-File -FilePath $HistoryFile -Append -Encoding utf8

Write-Host "Prompt result logged successfully in $HistoryFile"
