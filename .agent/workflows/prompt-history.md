---
description: Log the results of your prompt interactions
---

# Prompt History Workflow

Use this workflow to keep a record of what you asked and what the result was.

## Steps

1. **Log Result**
// turbo
```powershell
$PromptContent = "Identify the bug in this function..."
$ResultSummary = "The bug was a race condition in the async handler. Fixed by adding a mutex."

powershell -ExecutionPolicy Bypass -File "d:\Workflow\.agent\skills\prompt-tracer\scripts\log_prompt_result.ps1" -Prompt $PromptContent -Result $ResultSummary
```

2. **Review History**
```powershell
Get-Content "d:\Workflow\.agent\knowledge\prompt_history.md" -Tail 20
```
