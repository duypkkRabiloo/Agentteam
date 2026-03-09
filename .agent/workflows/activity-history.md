---
description: Summarize workspace activity and log to history and Google Chat
---

# Activity History Workflow

This workflow summarizes recent changes in the workspace and logs them to the activity history.

## Steps

1. **Summarize and Log**
// turbo
```powershell
# Example usage of the secretary skill
# You can pass the activity data manually or via a script that captures changes
$Activity = "User created initial KWSR structure and implemented secretary skill."
powershell -ExecutionPolicy Bypass -File "d:\Workflow\.agent\skills\secretary\scripts\secretary.ps1" -ActivityData $Activity
```

2. **Verify History**
```powershell
Get-Content "d:\Workflow\.agent\knowledge\activity_history.md" -Tail 10
```
