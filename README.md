# agent-toolkit

Agent skills for Claude Code and Antigravity. Each skill is a folder with a `SKILL.md` and works on its own.

Languages: English | [Português](README.pt-BR.md)

## Skills

| Skill | What it does |
|-------|--------------|
| [handoff](#handoff) | Saves where a task stands so a new session can pick it up |
| [pickup](#pickup) | Resumes a task from a handoff file, checked against git |

## Conventions

- A skill is plain markdown in `skills/<name>/SKILL.md`. There is no runtime.
- Skills run only when you call them. The agent never runs them on its own.
- A skill's output is context. It never authorizes work by itself.
- Facts that matter, such as commit hashes and changed files, come from the tools at run time, not from the agent's memory.

## Install

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp -R skills/* ~/.claude/skills/
```

To install only one skill, copy its folder instead, for example `cp -R skills/handoff ~/.claude/skills/`.

### Antigravity

Copy the skill folders into the skills folder of the tool. The location depends on the version, so check the tool's documentation.

## Skills detail

### handoff

When a session gets long, run `/handoff`. It saves where the task stands in `.handoff/<topic>.md`: the objective, the decisions and why they were made, the paths discarded and why, what is done, the next step, and the pitfalls. The file is rewritten on each run and kept under 40 lines.

Two rules keep it reliable:

- The commit hash and the changed files come from git at run time, not from the agent's memory.
- A handoff is context. It never triggers work on its own.

See a real file in [examples/handoff-example.md](examples/handoff-example.md). The hash, test counts and names in it are made up.

#### Usage

- `/handoff` before `/clear` or before switching tools.
- `/handoff <topic>` to name the file.
- `/handoff done` after the task is finished and you have confirmed it.

#### Limits

- One task per session. With two tasks in the same repo, the `files` list mixes their changes.
- The rule against writing secrets into the file is a prompt instruction, not a guarantee. Read the file before you share it.
- When to hand off (context size, number of turns) is up to you. Set your own threshold.

#### Keep handoffs out of git

`/handoff` adds `.handoff/` to the project's `.gitignore` if it is missing. To ignore it everywhere instead, run this once:

```bash
echo ".handoff/" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

### pickup

In a new session, `/pickup` reads the handoff file, checks it against git, and tells you where things stopped. It does not start any work until you confirm.

#### Usage

- `/pickup` in the new session. With one active handoff it loads that one. With several, it asks which.

## License

MIT. See [LICENSE](LICENSE).
