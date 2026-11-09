---
name: flash-offload
description: >-
  Offloads multi-step coding, refactoring, test generation, and broad codebase
  exploration to lightweight Flash (`flash` or `flash_lite`) subagents to
  conserve primary model tokens and context window. Use when implementing
  larger multi-file changes (`4+` files or `>80` lines), running iterative
  test/build loops, or doing broad read-only codebase research. Don't use for
  single-step low-output commands or scoped edits across `<=3` known files
  requiring `<=4` tool calls.
---

# Flash Subagent Offloading Workflow

Use **`flash`** (or **`flash_lite`**) subagents to minimize token consumption on the primary orchestrator model. Act as a lightweight **Orchestrator & Reviewer** and delegate volume work to Flash subagents.

## 1. Model & Subagent Selection Rules

Override the default `Model: "inherit"` behavior when calling `invoke_subagent`:

| Task Type | Subagent `TypeName` | `Model` Argument | `Workspace` | When to Use |
| :--- | :--- | :--- | :--- | :--- |
| **Single-Step / Localized Fast-Path** | *(Primary Agent)* | *(Primary Model)* | *(Primary)* | Single low-output commands (`<50` lines, e.g. `git status`, `git diff --stat`), reading a few small files, or scoped edits across `<=3` known files (`<=4` tool calls, `<80` lines changed, no noisy test runs). Avoids the 2-turn subagent dispatch/wakeup overhead. |
| **Read-Only Lookups / Broad Search** | `research` | `flash_lite` or `flash` | `inherit` | Scanning multiple unfamiliar files, grepping logs, or summarizing modules when **no code edits are planned**. |
| **Boilerplate / Scoped Code Edits** | `flash-coder` | `flash` | `inherit` | Implementing `4+` file changes, `>80`-line boilerplate, unit tests, migrations, or tasks requiring build/test verification loops. |
| **Parallel / Isolated Features** | `flash-coder` | `flash` | `share` or `branch` | Implementing independent modules in parallel where file conflicts might occur. |
| **Complex Architecture / Review** | *(Primary Agent)* | *(Primary Model)* | *(Primary)* | High-level system design, requirement clarification, and final diff verification. |

## 2. Offloading Workflow

### Step 1: Avoid Double Subagent Hops (`research` vs. `flash-coder`)
- Avoid sweeping directories or reading large files directly in the primary agent.
- **Read-only questions**: Spawn `research` with `Model: "flash_lite"` (or `"flash"`) to inspect target files and return a concise summary (file paths, line numbers, function signatures, and key constraints).
- **Tasks that will modify code**: Skip `research` and dispatch `flash-coder` (`Model: "flash"`) directly so a single subagent performs both the file lookup and the edits without paying a second cold-start hop or reading the same files twice.

### Step 2: Reuse the Static `flash-coder` Subagent
`flash-coder` is statically registered in `~/.gemini/config/agents/flash-coder.md` (`model: flash`, write tools enabled, subagent recursion and MCP disabled, inheriting `<user_rules>` automatically—do **not** call `define_subagent` at runtime):
- On the first coding subtask, spawn `TypeName: "flash-coder"` (`Model: "flash"`).
- On sequential follow-up subtasks in the same area (e.g., fixing a failing test or iterating on the same module), **reuse that subagent's `conversationId` via `send_message`** so its warm file context is preserved without paying cold-start prefill costs.

### Step 3: Write Self-Contained Subagent Prompts
Flash models perform best with explicit specifications. Every `invoke_subagent` or `send_message` brief should specify:
1. **Target paths**: Exact file paths to read or modify.
2. **Concrete spec**: Function signatures, data structures, edge cases, and expected behavior.
3. **Verification**: Exact command to run (e.g., `pytest`, `npm test`, `cargo check`).
4. **Concise return format**: Ask for a short summary (`<150` words) of changes and test output rather than full code dumps.

### Step 4: Parallelize & Escalate Only When Needed
- Launch multiple `flash-coder` subagents in a single turn (`Workspace: "share"` or `"branch"` if editing overlapping areas) when tasks touch independent modules, then end your turn and wait for reactive wakeup.
- If `flash-coder` fails twice on a subtle bug or complex algorithm, handle that block directly in the primary agent or escalate to `Model: "pro"`.
