param (
    [Parameter(Mandatory = $true)]
    [string]$Prompt,
    [Parameter(Mandatory = $true)]
    [string]$Purpose,
    [string]$Tags = "Uncategorized",
    [string]$LibraryFile = "d:\Workflow\.agent\knowledge\prompt_library.md"
)

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Prepare the library entry
$Entry = @"
`n## [$Timestamp] $Purpose
- **Prompt**: 
  ```text
  $Prompt
  ```
- **Tags**: $Tags
"@

# Initialize library if it doesn't exist
if (-not (Test-Path $LibraryFile)) {
    "# Prompt Library`n`nThis file contains a collection of useful prompts for the workspace.`n" | Out-File -FilePath $LibraryFile -Encoding utf8
}

# Append the entry
$Entry | Out-File -FilePath $LibraryFile -Append -Encoding utf8

Write-Host "Prompt tracked successfully in $LibraryFile"
