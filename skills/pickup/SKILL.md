---
name: pickup
description: Manual only. Run when the user types /pickup to resume a task from a handoff saved by /handoff. Never trigger on your own.
argument-hint: [topic]
disable-model-invocation: true
---

Resumes a task from `.handoff/<topic>.md`. The handoff is context, never authorization to implement.

## Select

Active handoffs are those with `status: active`, ordered by `updated` descending, ties by topic. That order numbers them.

1. Argument `list`: print the active handoffs numbered (topic, Objective, age), tell the user to run `/pickup <number|topic>`, and stop. Nothing else, no rename.
2. Argument is a number: the Nth active handoff (a hook may already have resolved it; the context says which). Out of range: say so and stop.
3. Argument is a topic: that topic. If its status is `done`, say so and ask before using it.
4. No argument: the most recent active handoff, without asking. None: say so and stop. Never open a selector: the session can only be titled from the command line, so a choice made inside the conversation leaves it unnamed.

## Check reality (read-only)

Run all checks in a single Bash call.

- `git rev-parse --short HEAD` against `commit`; if different, `git log --oneline <commit>..HEAD`.
- `git status --short` against `files`; flag changes the handoff does not explain.
- `updated` older than 3 days.

Divergences are warnings, never blockers.

## Rename the session

The session title is the handoff's topic (the file name without `.md`), so the session list shows the task. A hook may already have set it; then the context says so and nothing more is needed. Otherwise the agent cannot rename a session, so end the report with the ready-to-paste line `/rename <topic>` for the user to run. Never skip it silently.

## Report and stop

Read the handoff, and the `plan:` file if set. Read nothing else yet. Reply in the user's language, three lines: where it stopped, next step, divergences (or "none"). If other active handoffs exist, add one line listing them numbered as in `list`. Then wait for the user's explicit go-ahead. No edits and no commands beyond the checks above until then.
