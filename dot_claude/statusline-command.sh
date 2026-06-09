#!/bin/bash
# Claude Code status line: current folder + rate limit progress bars w/ reset times

input=$(cat)

# ── colors (truecolor ANSI) ────────────────────────────────────────────────
FOLDER_BADGE=$'\033[1m\033[38;2;217;119;87m\033[7m'  # bold, fg=Claude clay, reverse video -> clay bg + terminal bg as text (transparent text)
CLAUDE=$'\033[38;2;217;119;87m'   # #d97757 — Claude clay — progress bars
RESET=$'\033[0m'

# ── helper: epoch seconds → local HH:MM (empty if no/invalid input) ─────────
fmt_time() {
  local epoch="$1"
  [ -z "$epoch" ] && return
  date -r "$epoch" +%H:%M 2>/dev/null
}

# ── helper: render a compact progress bar w/ reset time ────────────────────
# usage: make_bar <label> <pct> <reset_epoch>
make_bar() {
  local label="$1"
  local pct="$2"
  local reset_epoch="$3"
  local total=10
  local filled
  # round to nearest block, but show >=1 block for any non-zero usage so low
  # percentages are still visible instead of an all-empty bar
  filled=$(echo "$pct $total" | awk '{f=int($1*$2/100 + 0.5); if ($1>0 && f<1) f=1; if (f>$2) f=$2; print f}')
  local empty=$(( total - filled ))
  local bar="" i
  for (( i=0; i<filled; i++ )); do bar="${bar}█"; done
  for (( i=0; i<empty;  i++ )); do bar="${bar}░"; done
  local rt
  rt=$(fmt_time "$reset_epoch")
  local tail=""
  [ -n "$rt" ] && tail=" ↻${rt}"
  printf '%s%s [%s] %s%%%s%s' "$CLAUDE" "$label" "$bar" "$(printf '%.0f' "$pct")" "$tail" "$RESET"
}

# ── current folder name ────────────────────────────────────────────────────
cur_dir=$(echo "$input" | jq -r '.workspace.current_dir // empty')
folder="${cur_dir##*/}"

# ── rate limits ────────────────────────────────────────────────────────────
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

parts=()
[ -n "$folder" ] && parts+=("${FOLDER_BADGE} ${folder} ${RESET}")
[ -n "$five" ] && parts+=("$(make_bar '5h' "$five" "$five_reset")")

if [ ${#parts[@]} -gt 0 ]; then
  out="${parts[0]}"
  for (( i=1; i<${#parts[@]}; i++ )); do
    out="${out}  ${parts[i]}"
  done
  printf '%s' "$out"
fi
