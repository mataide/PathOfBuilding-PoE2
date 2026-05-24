# CLAUDE.md - Path of Building 2 Development Guide

This file provides guidance to Claude Code when working in this repository.

## Core Project Instructions
@.serena/memories/project_overview.md
@.serena/memories/tech_stack.md
@.serena/memories/project_structure.md
@.serena/memories/architecture.md
@.serena/memories/development.md
@.serena/memories/code_style.md
@.serena/memories/integrations.md
@.serena/memories/configuration.md

## Important Reminders
# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.

## Project-specific guardrails
- All PRs target the `dev` branch, never `master`.
- Code must remain compatible with **Lua 5.1 / LuaJIT** — no Lua 5.2+ syntax.
- Files in `src/Data/` carrying the auto-generated header are **regenerated**, never hand-edited. Modify the corresponding script in `src/Export/` (or reload PoB with `Ctrl+F5` for `ModCache.lua`) and commit both sides of the change.
- The `runtime/` directory is a binary dependency built elsewhere; do not edit its contents directly.
- Tests run headless via `busted` using `src/HeadlessWrapper.lua` — keep pure-logic modules free of hard SimpleGraphic dependencies so they stay testable.
