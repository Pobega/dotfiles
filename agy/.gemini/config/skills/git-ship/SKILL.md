---
name: git-ship
description: >-
  Stages changes safely and creates clean, convention-compliant git commits or
  branch/PR summaries, offloading large diffs to `flash-coder`. Use when the
  user asks to draft a commit message, commit work, or summarize a branch or PR.
  Don't use for deep bug-finding code reviews (use adversarial-review).
---

# Git Shipping & Commit Workflow

Keep large diffs and git logs out of primary context while avoiding subagent dispatch overhead on tiny commits.

## Workflow

1. **Fast-Path vs. Subagent Offloading**:
   - **Small Diff Fast-Path (`<30` changed lines across `<=2` files)**: Run `git status -s && git diff` and commit directly in the primary agent (avoids the 2-turn subagent wakeup cost).
   - **Large / Multi-File Diffs**: Delegate to `flash-coder` (`Model: "flash"`, reusing an active `flash-coder` `conversationId` via `send_message` if one just implemented the changes) to run `git status -s`, `git diff --stat`, `git diff`, and `git log -n 10 --oneline`.
2. **Commit Conventions**:
   - Inspect existing git history to match repo style.
   - For `dotfiles`: default to `<package>: <imperative summary>` in lowercase (e.g., `agy: add flash-offload skill`, `nvim: update lsp keymaps`).
   - For application repos: adhere to Conventional Commits (e.g., `feat(api): ...`, `fix(auth): ...`) if present.
3. **Safety Guards**:
   - Never stage untracked files blindly (`git add .` and `git add -A` are forbidden; stage explicit paths).
   - Check for secrets, credentials, `.env` files, or stray temporary files before committing.
4. **Return Format**:
   Report concisely:
   - Commit hash and commit subject
   - List of committed files
   - Any remaining untracked or uncommitted files
