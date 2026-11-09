---
name: tdd-loop
description: >-
  Enforces a strict Red-Green-Refactor test-driven development cycle inside a
  reused `flash-coder` subagent session. Use ONLY when the user explicitly asks
  for TDD or when isolating a non-obvious regression bug that must be reproduced
  before patching. Don't use automatically for routine features with clear specs
  (write implementation + tests together and run tests once), static config
  edits, or documentation.
---

# Red-Green-Refactor TDD Workflow

Test-Driven Development (TDD) ensures verifiable correctness when isolating tricky regressions or when explicitly requested, keeping execution inside a single warm `flash-coder` subagent session (avoiding 3 separate cold subagent spawns).

## Gating Rule (3x vs. 1x Test Execution)

- **Use 3-Pass Red-Green-Refactor ONLY when**:
  1. Explicitly requested by the user (e.g., *"use TDD"*, *"write a failing test first"*).
  2. Isolating an ambiguous or subtle bug where proving the reproduction case first prevents a blind fix.
- **Skip for**: Straightforward features or obvious fixes where `flash-coder` can author the implementation and unit test together and run the test suite **once** at the end.

## Subagent Session Reuse

- Spawn `TypeName: "flash-coder"` (`Model: "flash"`) **once** and reuse its `conversationId` via `send_message` across phases—or, for self-contained bugfixes with a clear spec, have that single `flash-coder` invocation execute all three steps sequentially and report both the observed **Red** failure assertion and final **Green** pass count.

## 3-Step Cycle

### Step 1: Red (Failing Test First)
- Author the test case isolating the new requirement or reproducing the bug before touching production code.
- Run the test runner and confirm the test **fails** for the expected reason (not a syntax or import error). Record the exact failure message.

### Step 2: Green (Minimal Implementation)
- In the same `flash-coder` session, write the minimal production code required to satisfy the failing test.
- Run the test runner to confirm the new test and all existing tests pass (**green**).

### Step 3: Refactor (Clean & Verify)
- Clean up duplication, extract named helpers/constants per `<user_rules>`, and verify idiomatic structure without altering behavior.
- Re-run the test suite to guarantee zero regressions, then return a concise summary (`<150` words) quoting the initial Red failure, modified `file:///path#Lstart-Lend` ranges, and final pass counts.
