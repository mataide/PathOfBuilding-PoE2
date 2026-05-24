# Project Overview — Path of Building 2 (Community)

Path of Building 2 (PoB2) is an offline build planner for **Path of Exile 2**, the community-maintained fork of the original Path of Building. It lets players design, simulate, and share character builds — passive trees, gear, skills, party play — and computes detailed offence/defence statistics including DPS, EHP, mana/life reservations, and per-mod breakdowns.

## Core capabilities
- Comprehensive offence + defence calculations (auras, charges, curses, resistances, minions, party play)
- Passive skill tree planner with jewel support, alternate path tracing, and trade-site/poeplanner imports
- Skill planner with full support/buff gem chains and socketed-gem modifier propagation
- Item planner with paste-from-game, crafting (prefix/suffix/master/essence), unique database, rare templates
- Build sharing via codes, automatic update system, character import

## Project type
Desktop application — Lua scripts running inside the native **SimpleGraphic** runtime (`runtime/Path{space}of{space}Building-PoE2.exe`). Headless mode is supported for tests via `src/HeadlessWrapper.lua`.

## Target users
Path of Exile 2 players (theorycrafters, build creators, streamers) and the community of contributors maintaining the calculator data and mechanics.

## Governance
Community fork at `PathOfBuildingCommunity/PathOfBuilding-PoE2`. Default working branch is `dev`; all PRs target `dev` and merge to `master` for releases. Current manifest version: **0.15.0**. License: MIT.
