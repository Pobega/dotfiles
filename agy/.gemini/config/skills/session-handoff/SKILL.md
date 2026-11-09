---
name: session-handoff
description: >-
  Generates a structured `HANDOFF.md` artifact for clean session transitions and
  audits live conversation context usage after the latest compaction checkpoint.
  Use ONLY when explicitly asked to check context usage, evaluate `/compact`, or
  prepare a `HANDOFF.md` summary (or when a session exceeds `>50` steps / `~95k`
  tokens). Don't read this skill for routine milestone pills (use the inline
  `awk` formula in `GEMINI.md`).
---

# Session Handoff & Context Compaction Workflow

Prevent token exhaustion, latency spikes, and degraded reasoning by actively monitoring conversation size and managing handoff milestones.

## Step 1: Measure Live Context Footprint

Run this single-line check directly on the compact transcript `<appDataDir>/brain/<conversation-id>/.system_generated/logs/transcript.jsonl` (which reflects truncated tool outputs actually sent to the model, unlike `transcript_full.jsonl`'s raw untruncated blobs), counting steps and bytes after the latest `"type":"CHECKPOINT"` (`/compact`) and adding `~20k` tokens for the base system prompt, rules, and tool declarations:

```bash
awk '/"type":"CHECKPOINT"/{b=0; s=0} {b+=length($0)+1; s++} END{printf "%d steps, %d bytes (~%.1fk tok)\n", s, b, (b/4000)+20}' <appDataDir>/brain/<conversation-id>/.system_generated/logs/transcript.jsonl
```

*(Note: `/tmp/agy-rate-limits-*.json` is written on the host `/tmp` by `statusline.sh` and is not visible inside private-`/tmp` terminal sandboxes.)*

## Step 2: Apply Action Thresholds

- **Green (`< 25 steps` & `< ~50k` estimated tokens)**:
  - Context is lean; proceed without compaction unless pivoting to an entirely unrelated task.
- **Yellow (`25–50 steps` or `~50k–95k` estimated tokens)**:
  - At task boundaries (e.g., right after committing code or concluding tests), recommend running `/compact` so upcoming tasks start with a compressed history.
- **Red (`> 50 steps` or `> ~95k` estimated tokens, or after deep debugging)**:
  - Context is saturated. Recommend generating a `HANDOFF.md` artifact and running `/compact` (or starting a fresh session) rather than repeatedly paying heavy prefill costs.

## Output Format Rule

To conserve vertical space and prevent response clutter:
- **Never** output multi-line headers, tables, or bullet lists for routine context checks, and do not include literal `[GREEN]` / `[YELLOW]` / `[RED]` text labels.
- **Always** format the context status as a single compact HTML pill one-liner at the end of the response using the zone's color:
  - **Green (`< 25 steps & < ~50k tok`)**:
    `<span style="background: rgba(46, 204, 113, 0.15); color: #2ecc71; padding: 2px 6px; border-radius: 4px; font-family: monospace;">Context: <steps> steps (~<tokens>k tok) — Safe to continue</span>`
  - **Yellow (`25–50 steps or ~50k–95k tok`)**:
    `<span style="background: rgba(241, 196, 15, 0.15); color: #f1c40f; padding: 2px 6px; border-radius: 4px; font-family: monospace;">Context: <steps> steps (~<tokens>k tok) — Run /compact before starting a new task</span>`
  - **Red (`> 50 steps or > ~95k tok`)**:
    `<span style="background: rgba(231, 76, 60, 0.15); color: #e74c3c; padding: 2px 6px; border-radius: 4px; font-family: monospace;">Context: <steps> steps (~<tokens>k tok) — Generate HANDOFF.md and /compact now</span>`

## Step 3: Generate `HANDOFF.md`

When transitioning sessions, create `<appDataDir>/brain/<conversation-id>/HANDOFF.md` containing:
1. **Completed & Verified**: Exact commit hashes, modified file paths, and test suite outcomes.
2. **Active State & Decisions**: Key architectural decisions, current git working tree status, and pending choices.
3. **Next Steps**: A copy-pasteable, self-contained starter prompt to paste directly into the new session.
