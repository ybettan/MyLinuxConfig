#!/bin/bash
  # Claude Code Status Line - Multi-line with git status, context, cost, duration, and clickable links

  # Read JSON input from stdin
  input=$(cat)

  # Extract values from JSON using jq
  model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
  cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
  context_pct=$(echo "$input" | jq -r '(.context_window.used_percentage // 0) | if . <= 1 and . > 0 then . * 100 else . end | floor')
  cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
  duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

  # Colors
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

  # Format cost (2 decimal places)
  cost_formatted=$(printf '$%.2f' "$cost_usd")

  # Format duration
  duration_sec=$((duration_ms / 1000))
  duration_min=$((duration_sec / 60))
  duration_sec_rem=$((duration_sec % 60))
  duration_formatted="${duration_min}m ${duration_sec_rem}s"

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

  # Convert remote URL to GitHub HTTPS URL
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

  # Create clickable repo name using OSC 8 escape sequences
  if [ -n "$github_url" ] && [ -n "$repo_name" ]; then
      # OSC 8 format: ESC ] 8 ; ; URL BEL text ESC ] 8 ; ; BEL
      clickable_repo=$(printf '\033]8;;%s\a%s\033]8;;\a' "$github_url" "$repo_name")
  else
      clickable_repo="$repo_name"
  fi

  # Build git status with colors
  git_status=""
  if [ "$staged_count" -gt 0 ]; then
      git_status="${git_status}${GREEN}+${staged_count}${RESET}"
  fi
  if [ "$modified_count" -gt 0 ]; then
      [ -n "$git_status" ] && git_status="${git_status} "
      git_status="${git_status}${YELLOW}~${modified_count}${RESET}"
  fi

  # Build progress bar for context window (15 chars)
  bar_width=15
  filled=$((context_pct * bar_width / 100))
  [ "$filled" -gt "$bar_width" ] && filled=$bar_width
  empty=$((bar_width - filled))

  # Choose bar color based on usage
  if [ "$context_pct" -lt 50 ]; then
      bar_color="$GREEN"
  elif [ "$context_pct" -lt 80 ]; then
      bar_color="$YELLOW"
  else
      bar_color="$RED"
  fi

  # Build the progress bar with checkered/diagonal pattern
  bar=""
  [ "$filled" -gt 0 ] && bar=$(printf "%${filled}s" | sed 's/ /▓/g')
  [ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | sed 's/ /░/g')"

  # Short directory name
  dir_name="${cwd##*/}"

  # === LINE 1: Model, folder icon, directory, branch icon, git branch with colored status ===
  line1="${BOLD_GRAY}[${model_name}]${RESET} ${GRAY}${clickable_repo}${RESET}"
  if [ -n "$git_branch" ]; then
      line1="${line1} ${GRAY}|${RESET} ${GRAY}${git_branch}${RESET}"
      if [ -n "$git_status" ]; then
          line1="${line1} ${git_status}"
      fi
  fi

  # === LINE 2: Context bar, percentage, cost, clock icon, duration ===
  line2="${bar_color}${bar}${RESET} ${context_pct}% ${GRAY}|${RESET} ${GRAY}${cost_formatted}${RESET} ${GRAY}|${RESET} ${GRAY}${duration_formatted}${RESET}"

  # Output both lines
  printf '%b\n' "$line1"
  printf '%b\n' "$line2"

