---
name: pickup
description: Manual only. Run when the user types /pickup to resume a task from a handoff saved by /handoff. Never trigger on your own.
argument-hint: [topic]
disable-model-invocation: true
---

Resumes a task from `.handoff/<topic>.md`. The handoff is context, never authorization to implement.

## Select

1. Argument given: that topic. If its status is `done`, say so and ask before using it.
2. No argument: list the folder and keep handoffs with `status: active`.
   - none: say so and stop.
   - one: use it without asking.
   - two or more: ask which one with `AskUserQuestion` (4 most recent; label = topic, description = Objective + age). Without that tool, print a numbered list and wait for the number.

## Check reality (read-only)

Run all checks in a single Bash call.

- `git rev-parse --short HEAD` against `commit`; if different, `git log --oneline <commit>..HEAD`.
- `git status --short` against `files`; flag changes the handoff does not explain.
- `updated` older than 3 days.

Divergences are warnings, never blockers.

## Report and stop

Read the handoff, and the `plan:` file if set. Read nothing else yet. Reply in the user's language, three lines: where it stopped, next step, divergences (or "none"). Then wait for the user's explicit go-ahead. No edits and no commands beyond the checks above until then.
