#!/usr/bin/env bash
input=$(cat)
prompt=$(jq -r '.prompt // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

[[ "$prompt" =~ ^/pickup([[:space:]]+([^[:space:]]+))?[[:space:]]*$ ]] || exit 0
arg="${BASH_REMATCH[2]}"

dir="${cwd:-.}/.handoff"
if [ ! -d "$dir" ]; then
  root=$(git -C "${cwd:-.}" rev-parse --show-toplevel 2>/dev/null) || exit 0
  dir="$root/.handoff"
  [ -d "$dir" ] || exit 0
fi

if [ -n "$arg" ]; then
  topic="${arg%.md}"
  [ -f "$dir/$topic.md" ] || exit 0
else
  active=()
  for f in "$dir"/*.md; do
    [ -f "$f" ] && grep -q '^status: active' "$f" && active+=("$f")
  done
  [ "${#active[@]}" -eq 1 ] || exit 0
  topic=$(basename "${active[0]}" .md)
fi

msg="Session title already set to '$topic' by a hook; do not print the /rename line."
jq -n --arg t "$topic" --arg m "$msg" '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", sessionTitle: $t, additionalContext: $m}}'
