---
trigger: always_on
description: "Human-maintainable coding standards: named helpers over magic math, simplicity, externalized large assets, and zero LLM comment smells."
---

# Human-Maintainable Coding Standards

Follow these principles whenever writing, modifying, or reviewing code:

1. **Self-Documenting Code Over Magic Math**:
   - Replace unexplained magic numbers with named constants, enum variants, or externalized config fields.
   - Extract inline math formulas, coordinate projections, color manipulations, and compound boolean conditions into small, descriptively named helper functions so call sites read clearly.
2. **Simplicity Over Cleverness**:
   - Prefer straightforward, human-readable control flow and data structures over dense, "cute", or overly clever code, even if it costs a tiny bit of performance.
   - Keep functions and modules small and single-responsibility. Decompose monolithic functions into focused helpers.
3. **Human Maintainability First**:
   - Avoid hardcoding large runtime data blobs (such as levels, tracks, palettes, or bulky tuning tables) inside source code when they belong in external data/config files (`.json`, `.toml`, `.png`). Small compile-time lookup tables (`const` / `constexpr`) and focused unit-test fixtures are fine inline.
4. **No LLM Code Smells**:
   - Do not add numbered section banner comments (e.g., `// --- 1. ... ---` or `// === ... ===`).
   - Do not write promotional or exclamation-mark comments (`!`) or fictional docstrings claiming unimplemented features.
   - Do not over-comment or restate what the code already says. Comment succinctly and only when explaining *why* a non-obvious decision exists.
