$ConfigFile = "d:\Workflow\.agent\rules\config.json"
$LogFile = "d:\Workflow\watcher_runtime.log"
"Watcher started at $(Get-Date)" | Out-File $LogFile

try {
    $Config = Get-Content $ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json
}
catch {
    "Failed to read config: $_" | Out-File $LogFile -Append
    exit 1
}

$WebhookUrl = $Config.google_chat_webhook_url
if (-not $WebhookUrl -or $WebhookUrl -eq "YOUR_GOOGLE_CHAT_WEBHOOK_URL_HERE") {
    "Webhook URL not set." | Out-File $LogFile -Append
    exit 1
}

$FilesToWatch = @(
    @{ Name = "Workspace Activity"; Icon = "[ACTIVITY]"; Path = $Config.activity_history_path },
    @{ Name = "Prompt Execution"; Icon = "[PROMPT]"; Path = $Config.prompt_history_path },
    @{ Name = "Task List"; Icon = "[TASK]"; Path = $Config.task_list_path }
)

foreach ($f in $FilesToWatch) {
    if (Test-Path $f.Path) { 
        $f.LastSize = (Get-Item $f.Path).Length 
        "Initial size for $($f.Name): $($f.LastSize)" | Out-File $LogFile -Append
    }
    else { 
        $f.LastSize = 0 
        "File not found: $($f.Path)" | Out-File $LogFile -Append
    }
}

while ($true) {
    foreach ($f in $FilesToWatch) {
        if (-not (Test-Path $f.Path)) { continue }
        try {
            $CurrentSize = (Get-Item $f.Path).Length
            if ($CurrentSize -gt $f.LastSize) {
                "Change detected in $($f.Name): $($f.LastSize) -> $CurrentSize" | Out-File $LogFile -Append
                
                # Read appended bytes
                $Stream = [System.IO.File]::Open($f.Path, 'Open', 'Read', 'ReadWrite')
                $Stream.Seek($f.LastSize, 'Begin') | Out-Null
                $Bytes = New-Object byte[] ($CurrentSize - $f.LastSize)
                $Stream.Read($Bytes, 0, $Bytes.Length) | Out-Null
                $Stream.Close()

                # Robust UTF-8 decode
                $NewContent = [System.Text.Encoding]::UTF8.GetString($Bytes)
                
                # Strip PowerShell BOMs (PS 5.1 compatible strings)
                $bom1 = [string][char]0xFEFF
                $bom2 = [string]("$([char]0xEF)$([char]0xBB)$([char]0xBF)")
                $NewContent = $NewContent.Replace($bom1, "").Replace($bom2, "").Trim()

                if ($NewContent) {
                    "Sending to Google Chat: $($NewContent.Substring(0, [Math]::Min(50, $NewContent.Length)))..." | Out-File $LogFile -Append
                    
                    # Manual JSON build
                    $SafeText = "$($f.Icon) **New $($f.Name) Detected:**\n\n$NewContent"
                    $SafeText = $SafeText.Replace("\", "\\").Replace("`"", "\`"").Replace("`n", "\n").Replace("`r", "")
                    
                    $PayloadString = "{ `"text`": `"$SafeText`" }"
                    $PayloadBytes = [System.Text.Encoding]::UTF8.GetBytes($PayloadString)

                    $Req = [System.Net.WebRequest]::Create($WebhookUrl)
                    $Req.Method = "POST"
                    $Req.ContentType = "application/json; charset=utf-8"
                    $Req.ContentLength = $PayloadBytes.Length
                    $ReqStream = $Req.GetRequestStream()
                    $ReqStream.Write($PayloadBytes, 0, $PayloadBytes.Length)
                    $ReqStream.Close()
                    
                    $Resp = $Req.GetResponse()
                    "Post success: $($Resp.StatusCode)" | Out-File $LogFile -Append
                    $Resp.Close()
                }
                $f.LastSize = $CurrentSize
            }
        }
        catch {
            "Error in loop: $_" | Out-File $LogFile -Append
            # Update LastSize anyway to prevent infinite error loop if it's a processing error
            $f.LastSize = $CurrentSize
        }
    }
    Start-Sleep -Seconds 3
}