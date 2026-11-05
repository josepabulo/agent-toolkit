# agent-toolkit

Agent skills for Claude Code and Antigravity. Right now it has one pair: `handoff` and `pickup`.

Languages: English | [Português](README.pt-BR.md)

## handoff and pickup

When a session gets long, run `/handoff`. It saves where the task stands in `.handoff/<topic>.md`: the objective, the decisions and why they were made, what is done, the next step, and the pitfalls. The file is rewritten on each run and kept under 40 lines.

In a new session, `/pickup` reads that file, checks it against git, and tells you where things stopped. It does not start any work until you confirm.

Two rules keep it reliable:

- The commit hash and the changed files come from git at run time, not from the agent's memory.
- A handoff is context. It never triggers work on its own.

See a real file in [examples/handoff-example.md](examples/handoff-example.md). The hash, test counts and names in it are made up.

## Install

### Claude Code

```bash
mkdir -p ~/.claude/skills
cp -R skills/handoff skills/pickup ~/.claude/skills/
```

### Antigravity

Copy the same two folders into your skills folder. The location depends on the version, so check the tool's documentation.

### Keep handoffs out of git

`/handoff` adds `.handoff/` to the project's `.gitignore` if it is missing. To ignore it everywhere instead, run this once:

```bash
echo ".handoff/" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```

## Usage

- `/handoff` before `/clear` or before switching tools.
- `/handoff <topic>` to name the file.
- `/handoff done` after the task is finished and you have confirmed it.
- `/pickup` in the new session. With one active handoff it loads that one. With several, it asks which.

Both commands are manual. The agent never runs them on its own.

## Limits

- One task per session. With two tasks in the same repo, the `files` list mixes their changes.
- The rule against writing secrets into the file is a prompt instruction, not a guarantee. Read the file before you share it.
- When to hand off (context size, number of turns) is up to you. Set your own threshold.

## License

MIT. See [LICENSE](LICENSE).
