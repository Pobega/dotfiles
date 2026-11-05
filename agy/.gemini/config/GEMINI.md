# Global Token-Saving Subagent Policy

- Whenever a task involves codebase exploration, multi-file reading, writing boilerplate, unit tests, or scoped code implementation, activate the `flash-offload` skill.
- The user explicitly authorizes and prefers `Model: "flash"` (and `Model: "flash_lite"` for simple read-only lookups) in `invoke_subagent` calls instead of `Model: "inherit"` to conserve primary model tokens.
