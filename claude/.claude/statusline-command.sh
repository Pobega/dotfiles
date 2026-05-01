#!/usr/bin/env bash
# Claude Code status line - mirrors ~/.bash_shell prompt style

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Rate limits: cache to disk, invalidate based on resets_at ---
RATE_CACHE="$HOME/.claude/cache/rate-limits.json"
mkdir -p "$(dirname "$RATE_CACHE")"

live_5h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
live_5h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
live_7d_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
live_7d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

if [ -n "$live_5h_pct" ] && [ -n "$live_7d_pct" ]; then
  jq -n \
    --argjson five_pct "$live_5h_pct" \
    --argjson five_resets "$live_5h_resets" \
    --argjson seven_pct "$live_7d_pct" \
    --argjson seven_resets "$live_7d_resets" \
    '{five_hour: {used_percentage: $five_pct, resets_at: $five_resets}, seven_day: {used_percentage: $seven_pct, resets_at: $seven_resets}}' \
    > "$RATE_CACHE"
fi

now=$(date +%s)
five_hour_pct=0
seven_day_pct=0

if [ -f "$RATE_CACHE" ]; then
  cached_5h_resets=$(jq -r '.five_hour.resets_at // 0' "$RATE_CACHE")
  cached_7d_resets=$(jq -r '.seven_day.resets_at // 0' "$RATE_CACHE")

  if [ "$now" -lt "$cached_5h_resets" ]; then
    five_hour_pct=$(jq -r '.five_hour.used_percentage' "$RATE_CACHE")
  fi
  if [ "$now" -lt "$cached_7d_resets" ]; then
    seven_day_pct=$(jq -r '.seven_day.used_percentage' "$RATE_CACHE")
  fi
fi

# --- Username / host-based color (mirrors MAIN_COLOR logic) ---
USERNAME=$(whoami)
HOSTNAME_SHORT=$(hostname -s)
CONTAINER="${container:-}"

if [ "$CONTAINER" = "oci" ]; then
  USERNAME="toolbx"
  MAIN_COLOR=136  # Yellow
elif [ "$HOSTNAME_SHORT" = "thelio" ]; then
  MAIN_COLOR=92   # Purple
elif [ "$HOSTNAME_SHORT" = "framework" ]; then
  MAIN_COLOR=26   # Blue
elif [ "$HOSTNAME_SHORT" = "icebox" ]; then
  MAIN_COLOR=22   # Green
else
  MAIN_COLOR=202  # Orange (default)
fi

if [ "$USERNAME" = "root" ]; then
  MAIN_COLOR=88
fi

# --- Shortened CWD (mirrors get_cwd logic) ---
HOME_DIR="$HOME"
if [ "$cwd" = "$HOME_DIR" ]; then
  CWD="~"
elif [ "$cwd" = "/" ]; then
  CWD="/"
else
  home_shortened="${cwd/$HOME_DIR/\~}"
  directory="${home_shortened%/*}"
  CWD="${directory##*/}/${cwd##*/}/"
fi

# --- Git branch + status (no locks, read-only) ---
GIT_STATUS=""
GIT_COLOR=46
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" describe --tags --exact-match 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    STATUS_OUT=$(git -C "$cwd" status --porcelain 2>/dev/null)
    bits=""
    echo "$STATUS_OUT" | grep -q "^R" && bits=">${bits}"
    git -C "$cwd" status 2>/dev/null | grep -q "Your branch is ahead" && bits="*${bits}"
    echo "$STATUS_OUT" | grep -q "^A" && bits="+${bits}"
    echo "$STATUS_OUT" | grep -q "^??" && bits="?${bits}"
    echo "$STATUS_OUT" | grep -q "^D" && bits="x${bits}"
    echo "$STATUS_OUT" | grep -q "^ M\|^M" && bits="!${bits}"

    if [ -n "$bits" ]; then
      case "$bits" in
        *\**) GIT_COLOR=39 ;;
        *+*)  GIT_COLOR=98 ;;
        *\!*) GIT_COLOR=226 ;;
        *)    GIT_COLOR=1 ;;
      esac
      GIT_STATUS="${BRANCH} ${bits}"
    else
      GIT_COLOR=46
      GIT_STATUS="${BRANCH}"
    fi
  fi
fi

# --- Context usage ---
CTX_PART=""
if [ -n "$used_pct" ]; then
  CTX_PART=" $(printf '%.0f' "$used_pct")%"
fi

# --- Assemble the status line ---
# user:dir [branch status] | Model  ctx%
printf "\e[38;5;${MAIN_COLOR}m%s\e[0m:\e[38;5;28m%s\e[0m" "$USERNAME" "$CWD"

if [ -n "$GIT_STATUS" ]; then
  printf " \e[38;5;${GIT_COLOR}m[%s]\e[0m" "$GIT_STATUS"
fi

if [ -n "$model" ]; then
  printf " \e[38;5;244m| %s%s\e[0m" "$model" "$CTX_PART"
fi

# --- Rate limits segment ---
printf " \e[38;5;244m| 5h:$(printf '%.0f' "$five_hour_pct")%% 7d:$(printf '%.0f' "$seven_day_pct")%%\e[0m"
