---
name: adversarial-review
description: >-
  Spawns an independent, read-only `research` subagent (`pro`) to critically
  review uncommitted diffs and modified files for logic bugs, edge cases,
  security flaws, and missing test coverage. Use ONLY when explicitly asked for
  a code review/audit, before a release, or after a major high-risk refactor
  (5+ files or security/concurrency-critical logic). Don't run automatically
  after routine multi-file edits, bugfixes with passing tests, or normal commits
  (use git-ship).
---

# Adversarial Code Review Workflow

Author agents naturally carry confirmation bias. An independent, skeptical reviewer subagent uncovers edge cases, regressions, and security flaws when high-stakes changes warrant a deep audit.

## Gating Rules (When to Run)

- **Run ONLY when**:
  1. Explicitly requested by the user (e.g., *"review this"*, *"run an adversarial review"*, *"audit before releasing"*).
  2. Completing a major architectural refactor (`5+` files or `200+` lines of logic) or security/concurrency-critical changes (auth, crypto, sandboxing, race-sensitive state).
- **Skip for**: Routine 1–4 file features, bugfixes already covered by passing tests, configuration/dotfiles tweaks, or normal commits.

## Workflow

1. **Prepare Diff & Select Subagent**:
   - Dump the exact unified diff to `<appDataDir>/brain/<conversation-id>/scratch/review.diff` (`git diff HEAD > ...`) first so the read-only `research` subagent (which lacks `run_command`) can inspect **deleted lines and removed guards** alongside full post-edit files.
   - Default to invoking `research` with `Model: "pro"` for all code, logic, concurrency, and security reviews (avoiding correlated blind spots when reviewing code written by `flash-coder`). Use `Model: "flash"` only for purely mechanical config or documentation diffs.
2. **Reviewer Prompting**:
   - Pass `<appDataDir>/brain/<conversation-id>/scratch/review.diff` and the list of modified file paths.
   - Instruct the subagent to evaluate against:
     1. **Logic & Edge Cases**: Off-by-one errors, empty collections, `None`/`nil` handling, concurrency races, unhandled error returns.
     2. **Security & Sandbox**: Hardcoded secrets, injection vectors, improper file permissions, unvalidated inputs.
     3. **Hygiene**: Leftover print/debug code, dead code branches, stale comments/docstrings, LLM comment smells.
     4. **Test Completeness**: Missing negative tests and failure-path coverage.
3. **Evidence-Backed Output Contract**:
   - Categorize verified findings by severity with exact `file:///path#Lstart-Lend` references:
     - `[Blocking]`: Critical bugs, regressions, or vulnerabilities that must be fixed immediately.
     - `[Warning]`: Concrete edge cases, missing failure-path tests, or performance risks.
     - `[Nit]`: Minor style, naming, or cleanup items.
   - **Anti-Hallucination Rule**: Every `[Blocking]` or `[Warning]` item must state the concrete input, state, or execution sequence that triggers the flaw. If the diff is sound, return `LGTM — 0 blocking or warning issues found` rather than inventing speculative warnings.
