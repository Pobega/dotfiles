---
name: tdd-loop
description: >-
  Enforces a strict Red-Green-Refactor test-driven development cycle inside a
  reused `flash-coder` subagent session. Use when implementing new testable
  logic, fixing reproducible bugs, or when the user asks for TDD. Don't use for
  static configuration edits, documentation, or pure log triage.
---

# Red-Green-Refactor TDD Workflow

Test-Driven Development (TDD) ensures verifiable correctness and tight change scopes while keeping execution inside a single warm `flash-coder` subagent session (avoiding 3 separate cold subagent spawns).

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
