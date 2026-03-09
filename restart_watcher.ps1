$Processes = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%history_watcher.ps1%'"
foreach ($Proc in $Processes) {
    Stop-Process -Id $Proc.ProcessId -Force
}
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File d:\Workflow\.agent\skills\secretary\scripts\history_watcher.ps1"
