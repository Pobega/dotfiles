---
name: log-triage
description: >-
  Delegates noisy test suite execution, verbose build output analysis, and
  service log inspection to lightweight `flash_lite` or `flash` subagents so
  large stdout/stderr dumps never flood primary context. Use when running
  verbose builds/tests or diagnosing multi-hundred-line service/container logs.
  Don't use for single-step commands producing <50 lines of output.
---

# Log Triage & Build Diagnosis Workflow

Verbose build systems and test suites generate massive stdout/stderr logs that quickly overwhelm primary model context windows. Always isolate noisy (`>50` lines) outputs inside lightweight subagents.

## Core Rules

1. **Keep Primary Context Lean**: Never execute verbose test runners or dump large log files directly in the primary orchestrator (only quick `<50`-line checks stay on the direct fast-path).
2. **Subagent Delegation**:
   - For read-only log analysis (e.g., inspecting existing log files or build artifact logs): invoke `research` with `Model: "flash_lite"` (escalate to `Model: "flash"` only if deep cross-file synthesis is needed).
   - For executing noisy test/build commands (e.g., `pytest -v`, `cargo test`, `npm test`, `journalctl`, `podman logs`): invoke `flash-coder` with `Model: "flash"` (or message an existing `flash-coder` instance via `send_message`).
3. **Mandatory Return Contract**:
   Instruct the subagent to filter noise and return strictly:
   - Command exit status and pass/fail summary counts
   - Exact failing test or service name
   - Minimal root cause stack trace / error snippet
   - Clickable `file:///path#Lstart-Lend` pointers to relevant code lines
   - Word limit: `<150` words
