param (
    [string]$ActivityData,
    [string]$ConfigPath = "d:\Workflow\.agent\rules\config.json"
)

$Config = Get-Content $ConfigPath | ConvertFrom-Json
$HistoryFile = $Config.activity_history_path

if (-not $ActivityData) {
    Write-Error "No activity data provided."
    exit 1
}

# 1. Summarize activity (In a real scenario, this might involve an LLM call, 
# but here we'll do a basic format/summary for the local script)
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Summary = @"
### Activity Report [$Timestamp]
$ActivityData
"@

# 2. Append to history file
if (-not (Test-Path $HistoryFile)) {
    "# Activity History`n`n" | Out-File -FilePath $HistoryFile -Encoding utf8
}
"`n$Summary`n" | Out-File -FilePath $HistoryFile -Append -Encoding utf8


Write-Host "Activity logged to $HistoryFile"
