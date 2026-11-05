---
name: flash-offload
description: >-
  Offloads coding, refactoring, test generation, and codebase exploration tasks
  to lightweight Flash (`flash` or `flash_lite`) subagents to conserve primary
  model tokens and context window. Activate this skill whenever implementing
  code changes, writing tests, performing multi-file refactors, or doing broad
  codebase research.
---

# Flash Subagent Offloading Workflow

The user explicitly requests using **`flash`** (or **`flash_lite`**) subagents to minimize token consumption on the primary orchestrator model. When this skill is active, act as a lightweight **Orchestrator & Reviewer** and delegate token-heavy work to Flash subagents.

## 1. Model & Subagent Selection Rules

Override the default `Model: "inherit"` behavior when calling `invoke_subagent`:

| Task Type | Subagent `TypeName` | `Model` Argument | `Workspace` | When to Use |
| :--- | :--- | :--- | :--- | :--- |
| **Quick Lookups / Broad Search** | `research` | `flash_lite` or `flash` | `inherit` | Scanning multiple files, grepping logs, or summarizing unfamiliar modules without cluttering primary context. |
| **Boilerplate / Scoped Code Edits** | `self` or `flash-coder` | `flash` | `inherit` | Writing unit tests, data models, CRUD endpoints, migrations, docstrings, or straightforward features/fixes. |
| **Parallel / Isolated Features** | `self` or `flash-coder` | `flash` | `share` or `branch` | Implementing independent modules in parallel where file conflicts might occur. |
| **Complex Architecture / Review** | *(Primary Agent)* | *(Primary Model)* | *(Primary)* | High-level system design, requirement clarification, and final diff verification. |

## 2. Offloading Workflow

### Step 1: Keep Primary Context Lean
- Avoid reading large files or sweeping directories directly in the primary agent.
- Spawn a `research` subagent with `Model: "flash"` (or `"flash_lite"`) to inspect target files and return only a concise summary (file paths, line numbers, function signatures, and key constraints).

### Step 2: Define a Lean `flash-coder` Subagent (For Multi-Step Coding)
To prevent subagents from recursively spawning more subagents or loading unnecessary MCP tools, define a dedicated subagent once per session using `define_subagent`:
- `Name`: `"flash-coder"`
- `Description`: `"Lightweight Flash coding subagent for implementing scoped code changes and running tests."`
- `EnableWriteTools`: `true`
- `EnableSubagentTools`: `false`
- `EnableMCPTools`: `false`
- `SystemPrompt`:
  > You are a focused, token-efficient coding subagent. Read only the files relevant to your assigned task, implement the requested changes, and run the specified test/verification commands. Return a concise summary (<150 words) listing modified files, line ranges, and verification results. Do not paste full file contents in your reply.

### Step 3: Write Self-Contained Subagent Prompts
Flash models perform best with explicit specifications. Every `invoke_subagent` prompt should specify:
1. **Target paths**: Exact file paths to read or modify.
2. **Concrete spec**: Function signatures, data structures, edge cases, and expected behavior.
3. **Verification**: Exact command to run (e.g., `pytest`, `npm test`, `cargo check`).
4. **Concise return format**: Ask for a short summary of changes and test output rather than full code dumps.

### Step 4: Parallelize & Escalate Only When Needed
- Launch multiple `flash` subagents in a single turn when tasks touch independent files, then end your turn and wait for reactive wakeup.
- If a `flash` subagent fails twice on a subtle bug or complex algorithm, handle that block directly in the primary agent or escalate to `Model: "pro"`.
