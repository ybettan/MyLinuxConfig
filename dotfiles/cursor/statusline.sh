#!/bin/bash
# Cursor CLI Status Line — mirrors the Claude Code statusline:
#   line 1: [model] repo | branch +staged ~modified
#   line 2: context bar + % + tokens | session $ / month $ | duration
#
# Cursor's statusline payload includes context_window but not cost. Session and
# billing-cycle spend are cached from cursor.com using the local CLI session.

input=$(cat)

model_name=$(printf '%s' "$input" | jq -r '.model.display_name // "Unknown"')
param_summary=$(printf '%s' "$input" | jq -r '.model.param_summary // empty')
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "."')
session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
context_pct=$(printf '%s' "$input" | jq -r '(.context_window.used_percentage // 0) | if . <= 1 and . > 0 then . * 100 else . end | floor')
used_tokens=$(printf '%s' "$input" | jq -r '(.context_window.total_input_tokens // 0) | floor')
window_tokens=$(printf '%s' "$input" | jq -r '(.context_window.context_window_size // 0) | floor')
payload_cost=$(printf '%s' "$input" | jq -r '.cost.total_cost_usd // empty')
payload_duration_ms=$(printf '%s' "$input" | jq -r '.cost.total_duration_ms // empty')

WHITE='\033[37m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
BLUE='\033[34m'
CYAN='\033[36m'
MAGENTA='\033[35m'
GRAY='\033[90m'
BOLD_GRAY='\033[1;90m'
RESET='\033[0m'

fmt_tokens() {
    local n="${1:-0}"
    [[ "$n" =~ ^[0-9]+$ ]] || { printf '?'; return; }
    if [ "$n" -ge 1000000 ]; then
        printf '%sM' "$((n / 1000000))"
    elif [ "$n" -ge 1000 ]; then
        printf '%sk' "$((n / 1000))"
    else
        printf '%s' "$n"
    fi
}

# Session start from chat metadata (createdAtMs), then transcript mtime.
session_start_ms=0
if [ -n "$session_id" ]; then
    for meta in "$HOME/.cursor/chats/"*"/$session_id/meta.json"; do
        if [ -f "$meta" ]; then
            session_start_ms=$(jq -r '.createdAtMs // 0' "$meta" 2>/dev/null || echo 0)
            break
        fi
    done
fi
[[ "$session_start_ms" =~ ^[0-9]+$ ]] || session_start_ms=0
if [ "$session_start_ms" -eq 0 ] && [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    session_start_ms=$(stat -c '%Y' "$transcript_path" 2>/dev/null || echo 0)
    session_start_ms=$((session_start_ms * 1000))
fi
[[ "$session_start_ms" =~ ^[0-9]+$ ]] || session_start_ms=0

now_ms=$(($(date +%s) * 1000))
if [[ "$payload_duration_ms" =~ ^[0-9]+$ ]]; then
    duration_ms="$payload_duration_ms"
elif [ "$session_start_ms" -gt 0 ]; then
    duration_ms=$((now_ms - session_start_ms))
    [ "$duration_ms" -lt 0 ] && duration_ms=0
else
    duration_ms=0
fi
duration_sec=$((duration_ms / 1000))
duration_formatted="$((duration_sec / 60))m $((duration_sec % 60))s"

# --- spend cache (dashboard API; refresh at most once a minute) ---
script_path="${BASH_SOURCE[0]}"
if command -v readlink >/dev/null 2>&1; then
    resolved=$(readlink -f "$script_path" 2>/dev/null || readlink "$script_path" 2>/dev/null || true)
    [ -n "$resolved" ] && script_path="$resolved"
fi
script_dir=$(cd "$(dirname "$script_path")" && pwd)
usage_py="$script_dir/statusline-usage.py"

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cursor-statusline"
cache_file="$cache_dir/usage.json"
lock_file="$cache_dir/usage.lock"
mkdir -p "$cache_dir"

refresh_usage() {
    python3 "$usage_py" "$cache_file" "$session_start_ms" "$session_id"
}

cache_stale=1
if [ -f "$cache_file" ]; then
    cache_age=$(( now_ms / 1000 - $(stat -c '%Y' "$cache_file" 2>/dev/null || echo 0) ))
    cached_sid=$(jq -r '.session_id // empty' "$cache_file" 2>/dev/null || true)
    [ "$cache_age" -lt 60 ] && [ "$cached_sid" = "$session_id" ] && cache_stale=0
fi

if [ "$cache_stale" -eq 1 ] && [ -f "$usage_py" ]; then
    if [ ! -f "$cache_file" ]; then
        refresh_usage >/dev/null 2>&1
    else
        # Detach so a slow refresh cannot stall or get killed with the statusline.
        if command -v flock >/dev/null 2>&1; then
            flock -n "$lock_file" python3 "$usage_py" "$cache_file" "$session_start_ms" "$session_id" >/dev/null 2>&1 &
        else
            (python3 "$usage_py" "$cache_file" "$session_start_ms" "$session_id") >/dev/null 2>&1 &
        fi
        disown 2>/dev/null || true
    fi
fi

fmt_usd() {
    local cents="$1"
    if [[ "$cents" == "null" || -z "$cents" ]]; then
        printf '$--'
        return
    fi
    awk -v c="$cents" 'BEGIN { printf "$%.2f", c / 100 }'
}

session_cost_formatted=""
cycle_cost_formatted='$--'
if [[ "$payload_cost" =~ ^[0-9.]+$ ]]; then
    session_cost_formatted=$(printf '$%.2f' "$payload_cost")
fi
if [ -f "$cache_file" ]; then
    cycle_cents=$(jq -r '.cycle_cents // empty' "$cache_file" 2>/dev/null || true)
    cached_sid=$(jq -r '.session_id // empty' "$cache_file" 2>/dev/null || true)
    [ -n "$cycle_cents" ] && cycle_cost_formatted=$(fmt_usd "$cycle_cents")
    if [ -z "$session_cost_formatted" ] && [ "$cached_sid" = "$session_id" ]; then
        session_cents=$(jq -r '.session_cents // empty' "$cache_file" 2>/dev/null || true)
        [ -n "$session_cents" ] && session_cost_formatted=$(fmt_usd "$session_cents")
    fi
fi
[ -z "$session_cost_formatted" ] && session_cost_formatted='$--'

# Git information
git_branch=""
staged_count=0
modified_count=0
remote_url=""
repo_name=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    staged_count=$(git -C "$cwd" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified_count=$(git -C "$cwd" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    remote_url=$(git -C "$cwd" config --get remote.origin.url 2>/dev/null)
    repo_name=$(basename "$cwd")
fi

github_url=""
if [[ "$remote_url" =~ ^git@github\.com:(.+)\.git$ ]]; then
    github_url="https://github.com/${BASH_REMATCH[1]}"
elif [[ "$remote_url" =~ ^git@github\.com:(.+)$ ]]; then
    github_url="https://github.com/${BASH_REMATCH[1]}"
elif [[ "$remote_url" =~ ^https://github\.com/(.+)\.git$ ]]; then
    github_url="https://github.com/${BASH_REMATCH[1]}"
elif [[ "$remote_url" =~ ^https://github\.com/(.+)$ ]]; then
    github_url="${remote_url}"
fi

if [ -n "$github_url" ] && [ -n "$repo_name" ]; then
    clickable_repo=$(printf '\033]8;;%s\a%s\033]8;;\a' "$github_url" "$repo_name")
else
    clickable_repo="$repo_name"
fi

git_status=""
if [ "$staged_count" -gt 0 ]; then
    git_status="${git_status}${GREEN}+${staged_count}${RESET}"
fi
if [ "$modified_count" -gt 0 ]; then
    [ -n "$git_status" ] && git_status="${git_status} "
    git_status="${git_status}${YELLOW}~${modified_count}${RESET}"
fi

bar_width=15
filled=$((context_pct * bar_width / 100))
[ "$filled" -gt "$bar_width" ] && filled=$bar_width
[ "$filled" -lt 0 ] && filled=0
empty=$((bar_width - filled))

if [ "$context_pct" -lt 50 ]; then
    bar_color="$GREEN"
elif [ "$context_pct" -lt 80 ]; then
    bar_color="$YELLOW"
else
    bar_color="$RED"
fi

bar=""
[ "$filled" -gt 0 ] && bar=$(printf "%${filled}s" | sed 's/ /▓/g')
[ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | sed 's/ /░/g')"

model_label="$model_name"
[ -n "$param_summary" ] && model_label="${model_name} ${param_summary}"

line1="${BOLD_GRAY}[${model_label}]${RESET} ${GRAY}${clickable_repo}${RESET}"
if [ -n "$git_branch" ]; then
    line1="${line1} ${GRAY}|${RESET} ${GRAY}${git_branch}${RESET}"
    if [ -n "$git_status" ]; then
        line1="${line1} ${git_status}"
    fi
fi

tokens_label="$(fmt_tokens "$used_tokens")/$(fmt_tokens "$window_tokens")"
line2="${bar_color}${bar}${RESET} ${context_pct}% ${GRAY}${tokens_label}${RESET} ${GRAY}|${RESET} ${GRAY}${session_cost_formatted}${RESET} ${GRAY}|${RESET} ${GRAY}${cycle_cost_formatted} mo${RESET} ${GRAY}|${RESET} ${GRAY}${duration_formatted}${RESET}"

printf '%b\n' "$line1"
printf '%b\n' "$line2"
