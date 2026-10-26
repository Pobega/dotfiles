#!/usr/bin/env bash
# SessionStart hook: one loud, user-visible banner when this session is not sandboxed.
# Silent when the posture is good, so it only ever speaks up when it matters.
#
# `systemMessage` is displayed to the user in the UI (supported on all hooks).

state=$(~/.claude/sandbox-probe.sh 2>/dev/null)

case "$state" in
  ok)
    exit 0
    ;;
  noprompt)
    msg="⚠ Sandbox is active but Bash permission prompts are OFF (autoAllowBashIfSandboxed). Commands run without review."
    ;;
  unsandboxed)
    msg="⚠ This session is UNSANDBOXED — sandbox.enabled is not set. Commands run with full host access."
    ;;
  broken:*)
    msg="⚠ SANDBOX BROKEN — ${state#broken:}. Commands may be running UNSANDBOXED (the sandbox fails open unless failIfUnavailable is set)."
    ;;
  *)
    exit 0
    ;;
esac

jq -n --arg m "$msg" '{systemMessage: $m}'
