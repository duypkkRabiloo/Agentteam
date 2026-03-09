---
description: Track and catalog your prompts at this workspace
---

# Track Prompt Workflow

Use this workflow to save high-quality prompts to your workspace library.

## Steps

1. **Submit Prompt**
// turbo
```powershell
# Edit these variables to match your prompt
$YourPrompt = "Your prompt content here..."
$YourPurpose = "Summarizing code changes"
$YourTags = "Productivity, Summary"

powershell -ExecutionPolicy Bypass -File "d:\Workflow\.agent\skills\prompt-tracer\scripts\track_prompt.ps1" -Prompt $YourPrompt -Purpose $YourPurpose -Tags $YourTags
```

2. **Verify Library**
```powershell
Get-Content "d:\Workflow\.agent\knowledge\prompt_library.md" -Tail 15
```
