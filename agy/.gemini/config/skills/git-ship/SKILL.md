---
name: git-ship
description: >-
  Stages changes safely and creates clean, convention-compliant git commits,
  branch/PR summaries, or GitHub releases, offloading large diffs to
  `flash-coder`. Use when the user asks to draft a commit message, commit work,
  summarize a branch or PR, or cut a GitHub release. Don't use for deep
  bug-finding code reviews (use adversarial-review).
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
   - **Atomic Splits**: When uncommitted work spans multiple independent subsystems, split staging into separate logical commits rather than bundling everything into a single giant commit.
3. **Safety Guards**:
   - Never stage untracked files blindly (`git add .` and `git add -A` are forbidden; stage explicit paths).
   - Check for secrets, credentials, `.env` files, stray temporary files, and proprietary/copyrighted user data or generated caches (e.g., `gamedata/`, ROMs, `.exe`/`.bin` dumps) before committing; ensure data directories are covered by `.gitignore` before populating them.
   - **Local Commits Only**: Never run `git push` (or `gh pr create`) automatically after committing. Leave commits local and ask the user if they want to push to the remote.
4. **GitHub Actions & Release Hygiene**:
   - When a workflow uses `docker/build-push-action` alongside `actions/download-artifact`, always pass a `pattern:` filter (e.g. `*-bundle`) so internal `.dockerbuild` summary artifacts aren't downloaded or attached to releases.
   - On GitHub-hosted Ubuntu runners where both `podman` and `docker` may exist, pin `CONTAINER_ENGINE=docker` when reusing Docker Buildx-loaded images.
   - Before editing or uploading assets to a tagged release, run `gh release list` (or `gh api repos/<owner>/<repo>/releases`) to check for separate CI-created drafts vs. published releases on the same tag so assets and notes don't split across duplicates.
5. **Return Format**:
   Report concisely:
   - Commit hash and commit subject
   - List of committed files
   - Any remaining untracked or uncommitted files
