#!/usr/bin/env bash
# Shared sandbox posture probe, read by statusline-command.sh and hooks/sandbox-warn.sh
# so the two can never disagree.
#
# Prints exactly one token:
#   ok              sandbox enabled, supported, running, prompts retained
#   noprompt        running, but autoAllowBashIfSandboxed is on (no Bash prompts)
#   unsandboxed     sandbox not enabled at all
#   broken:<reason> enabled but it cannot start (e.g. socat missing). With
#                   failIfUnavailable set, Claude refuses to start instead, so this
#                   is only reachable if the dependency vanishes mid-session.
#
# Deliberately uncached: `claude sandbox status` costs ~144ms, but the answer also
# depends on cwd (project-local settings can disable the sandbox) and on --settings,
# which `sandbox status` cannot see. A cache keyed on user-settings mtime served a
# stale "ok" in a directory where the sandbox was off, which is the one failure this
# probe exists to prevent.
#
# Note: on Linux the JSON's .available/.reasons describe the *Windows* installer and
# are always false/noisy here. The Linux-relevant fields are .supported and
# .unavailableReason.

if ! command -v jq >/dev/null 2>&1; then
  echo "broken:jq not found"
  exit 0
fi

raw=$(claude sandbox status 2>/dev/null)
if [ -z "$raw" ] || ! jq -e . >/dev/null 2>&1 <<<"$raw"; then
  echo "broken:status unavailable"
  exit 0
fi

enabled=$(jq -r '.enabled // false'            <<<"$raw")
supported=$(jq -r '.supported // false'        <<<"$raw")
reason=$(jq -r '.unavailableReason // ""'      <<<"$raw")
autoallow=$(jq -r '.autoAllowBashIfSandboxed // false' <<<"$raw")

if   [ "$enabled"   != "true" ] && [ -z "$reason" ]; then state="unsandboxed"
elif [ "$supported" != "true" ]; then state="broken:platform unsupported"
elif [ -n "$reason" ];            then state="broken:${reason}"
elif [ "$autoallow" = "true" ];   then state="noprompt"
else                                   state="ok"
fi

echo "$state"
