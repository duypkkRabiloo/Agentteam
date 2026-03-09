---
description: Daily Meeting Workflow
---

# Daily Meeting Workflow

This workflow is used to break down high-level objectives into specific tasks and update the project's task list.

## Steps

1.  **Define Objective**: The user provides high-level goals or topics for the day.
2.  **Scrum Breakdown**: The agent uses the `agile-scrum-master` skill to analyze and breakdown the requirements into specific sub-tasks.
3.  **Update Task List**:
    - The agent reads `.agent/knowledge/task_list.md`.
    - The agent appends the new tasks to the end of the file.
4.  **Log and Notify**:
    - The agent runs `d:\Workflow/.agent/skills/secretary/scripts/secretary.ps1` with the summary of the breakdown in English.
    - This triggers a Google Chat notification via the `history_watcher.ps1`.
5.  **Status Check**: The agent summarizes the current state of the global `task_list.md`.

## English Requirement
To maintain system stability and prevent encoding issues in the Google Chat notification, all task descriptions and logs **MUST** be written in English.
