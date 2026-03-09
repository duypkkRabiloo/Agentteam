# Rule: Proactive Prompt Logging

All agents working in this workspace must follow this rule to ensure a complete project history.

## Policy
1.  **Summarize Every Request in English**: Whenever a user provides a prompt or request, the agent must summarize the core intent and the final outcome of that interaction. This summary MUST be written entirely in English to avoid Windows PowerShell encoding issues.
2.  **Log to History**: This summary must be appended to `.agent/knowledge/prompt_history.md` as soon as the task is complete.
3.  **Use the Tracking Script**: Use the existing `log_prompt_result.ps1` script to maintain consistency in formatting and timestamps.
4.  **No Manual Ask Needed**: The user does NOT need to ask for a log. It is the agent's responsibility.

## Exception
- Simple questions (e.g., "What time is it?") that do not affect the workspace or project state do not need to be logged.
- If the user explicitly asks not to log a specific session.
