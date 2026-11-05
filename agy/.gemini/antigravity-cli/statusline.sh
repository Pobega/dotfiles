#!/usr/bin/env bash
# Antigravity CLI status line - stacked below default statusline
# Left:  user:dir ⛨ [branch status]
# Right:  5h%  7d% (eta)

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  printf "\e[38;5;196m[statusline: jq not found — install jq to enable statusline]\e[0m"
  exit 0
fi

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
sbx_enabled=$(echo "$input" | jq -r 'if .sandbox.enabled == null then "unknown" else (.sandbox.enabled | tostring) end')
term_width=$(echo "$input" | jq -r '.terminal_width // empty')

# --- Quota / Rate limits (auto-selects Gemini vs 3P quota buckets based on active model) ---
RATE_CACHE="/tmp/agy-rate-limits-${USER:-$(id -u)}.json"

IFS='|' read -r bucket live_5h_pct live_5h_eta live_7d_pct live_7d_eta <<< "$(echo "$input" | jq -r '
  def model_str: ((.model.id // .model.display_name // "") | ascii_downcase);
  def is_3p: (model_str != "" and (model_str | contains("gemini") | not));
  def q_5h: (
    if is_3p then (.quota["3p-5h"] // .quota["gemini-5h"])
    else (.quota["gemini-5h"] // .quota["3p-5h"])
    end // .quota["5h"] // .rate_limits.five_hour
  );
  def q_d7: (
    if is_3p then (.quota["3p-d7"] // .quota["3p-weekly"] // .quota["gemini-d7"] // .quota["gemini-weekly"])
    else (.quota["gemini-d7"] // .quota["gemini-weekly"] // .quota["3p-d7"] // .quota["3p-weekly"])
    end // .quota["d7"] // .quota["7d"] // .rate_limits.seven_day
  );
  [
    (if is_3p then "3p" else "gemini" end),
    (if (q_5h.remaining_fraction != null) then ((1 - q_5h.remaining_fraction) * 100)
     elif (q_5h.used_percentage != null) then q_5h.used_percentage
     else "" end),
    (if (q_5h.reset_in_seconds != null) then (q_5h.reset_in_seconds | floor)
     elif (q_5h.resets_at != null) then (q_5h.resets_at - now | floor)
     else "" end),
    (if (q_d7.remaining_fraction != null) then ((1 - q_d7.remaining_fraction) * 100)
     elif (q_d7.used_percentage != null) then q_d7.used_percentage
     else "" end),
    (if (q_d7.reset_in_seconds != null) then (q_d7.reset_in_seconds | floor)
     elif (q_d7.resets_at != null) then (q_d7.resets_at - now | floor)
     else "" end)
  ] | map(tostring) | join("|")
')"

bucket="${bucket:-gemini}"
now=$(date +%s)

if [ -n "$live_5h_pct" ] || [ -n "$live_7d_pct" ]; then
  resets_5h=0
  [ -n "$live_5h_eta" ] && resets_5h=$(( now + live_5h_eta ))
  resets_7d=0
  [ -n "$live_7d_eta" ] && resets_7d=$(( now + live_7d_eta ))
  existing_cache="{}"
  if [ -f "$RATE_CACHE" ]; then
    existing_cache=$(jq -c 'if type == "object" and (has("gemini") or has("3p")) then . else {} end' "$RATE_CACHE" 2>/dev/null || echo "{}")
  fi
  (
    umask 077
    jq -n \
      --argjson prev "$existing_cache" \
      --arg b "$bucket" \
      --argjson five_pct "${live_5h_pct:-0}" \
      --argjson five_resets "$resets_5h" \
      --argjson seven_pct "${live_7d_pct:-0}" \
      --argjson seven_resets "$resets_7d" \
      '$prev + {($b): {five_hour: {used_percentage: $five_pct, resets_at: $five_resets}, seven_day: {used_percentage: $seven_pct, resets_at: $seven_resets}}}' \
      > "${RATE_CACHE}.tmp" 2>/dev/null && mv -f "${RATE_CACHE}.tmp" "$RATE_CACHE" 2>/dev/null
  )
fi

five_hour_pct=0
seven_day_pct=0
cached_5h_resets=0

fmt_eta() {
  local secs=$1
  [ "$secs" -le 0 ] && return
  local h=$((secs / 3600))
  local m=$(( (secs % 3600) / 60 ))
  if   [ "$h" -ge 24 ]; then echo "$((h/24))d$((h%24))h"
  elif [ "$h" -gt 0 ];  then echo "${h}h${m}m"
  else                       echo "${m}m"
  fi
}

if [ -f "$RATE_CACHE" ]; then
  IFS='|' read -r cached_5h_pct cached_5h_resets cached_7d_pct cached_7d_resets <<< "$(
    jq -r --arg b "$bucket" '[
      (.[$b].five_hour.used_percentage // 0),
      (.[$b].five_hour.resets_at // 0),
      (.[$b].seven_day.used_percentage // 0),
      (.[$b].seven_day.resets_at // 0)
    ] | map(tostring) | join("|")' "$RATE_CACHE" 2>/dev/null
  )"
  if [ "${cached_5h_resets:-0}" -eq 0 ] || [ "$now" -lt "${cached_5h_resets:-0}" ]; then
    five_hour_pct="${cached_5h_pct:-0}"
  fi
  if [ "${cached_7d_resets:-0}" -eq 0 ] || [ "$now" -lt "${cached_7d_resets:-0}" ]; then
    seven_day_pct="${cached_7d_pct:-0}"
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
if [ -z "$cwd" ]; then
  cwd="$PWD"
fi
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
if git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks describe --tags --exact-match 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    STATUS_OUT=$(git -C "$cwd" --no-optional-locks status --porcelain=v1 -b 2>/dev/null)
    bits=""
    echo "$STATUS_OUT" | grep -q "^R" && bits=">${bits}"
    echo "$STATUS_OUT" | head -n1 | grep -q "\[ahead " && bits="*${bits}"
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

# --- Sandbox posture (from agy payload or settings.json fallback) ---
SBX_PART=""
if [ "$sbx_enabled" = "unknown" ] && [ -f "$HOME/.gemini/antigravity-cli/settings.json" ]; then
  sbx_enabled=$(jq -r 'if .enableTerminalSandbox != null then (.enableTerminalSandbox | tostring) elif .sandbox != null then (.sandbox | tostring) else "false" end' "$HOME/.gemini/antigravity-cli/settings.json" 2>/dev/null)
fi
case "$sbx_enabled" in
  true)  SBX_PART=$(printf "\e[38;5;46m\xe2\x9b\xa8\e[0m") ;;
  false) SBX_PART=$(printf "\e[1;48;5;196;38;5;231m \xe2\x9a\xa0 UNSANDBOXED \e[0m") ;;
esac

# --- Assemble Left Segment (user:dir ⛨ [branch status]) ---
LEFT_STR=$(printf "\e[38;5;${MAIN_COLOR}m%s\e[0m:\e[38;5;28m%s\e[0m" "$USERNAME" "$CWD")

if [ -n "$SBX_PART" ]; then
  LEFT_STR="${LEFT_STR} ${SBX_PART}"
fi

if [ -n "$GIT_STATUS" ]; then
  LEFT_STR="${LEFT_STR}"$(printf " \e[38;5;${GIT_COLOR}m[%s]\e[0m" "$GIT_STATUS")
fi

# --- Assemble Right Segment ( 5h%  7d% (eta)) ---
five_int=$(printf '%.0f' "$five_hour_pct")
seven_int=$(printf '%.0f' "$seven_day_pct")
five_eta=$(fmt_eta $((cached_5h_resets - now)))
[ -n "$five_eta" ] && five_eta=" ($five_eta)"
RIGHT_STR=$(printf "\e[38;5;244m %s%%  %s%%%s\e[0m" "$five_int" "$seven_int" "$five_eta")

# --- Calculate Padding & Right-Align ---
if [ -z "$term_width" ] || [ "$term_width" -le 0 ] 2>/dev/null; then
  term_width="${COLUMNS:-$(tput cols 2>/dev/null || echo 100)}"
fi

strip_ansi() {
  sed $'s/\e\\[[0-9;]*[a-zA-Z]//g'
}

left_plain=$(printf "%s" "$LEFT_STR" | strip_ansi)
right_plain=$(printf "%s" "$RIGHT_STR" | strip_ansi)
left_len=${#left_plain}
right_len=${#right_plain}

pad=$(( term_width - left_len - right_len - 1 ))
if [ "$pad" -lt 2 ]; then
  pad=2
fi

printf "%s%*s%s" "$LEFT_STR" "$pad" "" "$RIGHT_STR"
