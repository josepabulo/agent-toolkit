#!/usr/bin/env bash
input=$(cat)
prompt=$(jq -r '.prompt // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

[[ "$prompt" =~ ^/pickup([[:space:]]+([^[:space:]]+))?[[:space:]]*$ ]] || exit 0
arg="${BASH_REMATCH[2]}"
[ "$arg" = "list" ] && exit 0

dir="${cwd:-.}/.handoff"
if [ ! -d "$dir" ]; then
  root=$(git -C "${cwd:-.}" rev-parse --show-toplevel 2>/dev/null) || exit 0
  dir="$root/.handoff"
  [ -d "$dir" ] || exit 0
fi

# Same order as the skill: updated descending, ties by topic
active() {
  for f in "$dir"/*.md; do
    [ -f "$f" ] && grep -q '^status: active' "$f" || continue
    u=$(sed -n 's/^updated: *//p' "$f" | head -n 1)
    printf '%s|%s\n' "$u" "$(basename "$f" .md)"
  done | sort -t'|' -k1,1r -k2,2 | cut -d'|' -f2
}

if [ -z "$arg" ]; then
  topic=$(active | head -n 1)
elif [[ "$arg" =~ ^[0-9]+$ ]]; then
  topic=$(active | sed -n "${arg}p")
else
  topic="${arg%.md}"
  [ -f "$dir/$topic.md" ] || exit 0
fi
[ -n "$topic" ] || exit 0

msg="Session title already set to '$topic' by a hook; do not print the /rename line. The /pickup argument resolved to topic '$topic'."
jq -n --arg t "$topic" --arg m "$msg" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", sessionTitle: $t, additionalContext: $m}}'
