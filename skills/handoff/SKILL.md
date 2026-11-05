---
name: handoff
description: Manual only. Run when the user types /handoff to save the current task state to .handoff/ before /clear or before switching tool. Never trigger on your own.
argument-hint: [topic | done]
disable-model-invocation: true
---

Saves the state of the current task so a fresh session, in this or the other tool, continues with `/pickup`. State, not history: one file per task, overwritten on every run.

## Location

- `.handoff/` in the project root. Create it if missing.
- It must be git-ignored. If `git check-ignore -q .handoff/` fails, append `.handoff/` to the project's `.gitignore` (create the file if missing).

## Language

Write the content in the language the project uses (its `CLAUDE.md` or `AGENTS.md` decides). If it does not say, use the language of the user's messages. Headings stay in English.

## Topic (file name)

1. Argument given and not `done`: it is the topic.
2. An `active` handoff in the folder clearly covers this session's task: reuse that file. Never rename it, even if the objective wording changed.
3. Otherwise derive it from the Objective sentence: kebab-case, verb first, at most 5 words, no accents. A different task with the same slug gets `-2`.

## Facts come from commands, not memory

- `git rev-parse --short HEAD` -> `commit`
- `git status --short` -> `files` (paths changed or untracked that belong to this task)
- `date +%Y-%m-%dT%H:%M` -> `updated`

## Format (headings fixed in English, content in the project language)

```markdown
---
commit: <short hash>
updated: <timestamp>
status: active
files: [path/a, path/b]
plan: <path to the plan file for this task, if any>
---

# Objective
One specific sentence. It names the file and labels the /pickup list.

# Decisions
- What was chosen and why.

# Discarded
- Paths tried or rejected, each with the reason.

# State
- Done and verified:
- Half-done:

# Next step
One concrete action.

# Pitfalls
- What failed and why.
```

`plan:` only when a plan file for this task exists. Terse bullets. No transcript, no event log, no secrets or tokens.

Rewrite the whole file on every run, never append. Drop resolved pitfalls and finished half-done items; keep in Decisions only the non-obvious why. Keep every Discarded entry until `done`, even when the path looks settled, so the next session does not retry it. Aim for at most 40 lines.

## Status

- Argument `done`: write `status: done`.
- Otherwise `active`. When acceptance criteria are met, verification passed and the work is committed, ask the user whether the task is done and wait; only the user's yes sets `done`.

## Close

Show the written content, say whether the file was created or updated and its path. Do not commit, do not run `/clear`. Reply in the user's language.
