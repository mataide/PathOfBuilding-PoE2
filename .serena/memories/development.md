# Development Commands & Setup

## Running the app (dev install)
From repo root, launch the native runtime directly:
```
./runtime/Path{space}of{space}Building-PoE2.exe
```
Running from the repo auto-enables **Dev Mode**, which exposes:
- `F5` — restart in place (same path as applied updates)
- `Ctrl + ~` — toggle console (US layout; may not bind on non-US keyboards)
- `ConPrintf(...)` — debug logging to console
- `Alt` (hold) — extra tooltips: internal mods on items/passives, unparsed mod fragments, passive node IDs/power.

## Running tests
Tests use **busted**, configured in `.busted`. Spec files live in `spec/System/`, and use `src/HeadlessWrapper.lua` as the harness helper.

Typical invocations (run from `src/` because `.busted` sets `directory = "src"`):
```
busted                              # run all specs except those tagged "builds"
busted spec/System/TestSkills_spec.lua
busted --tags=<tag>
```
Tag `builds` is excluded by default — opt in explicitly to run it.

## Docker dev environment
A full Lua/LuaJIT/LuaRocks/busted stack is provided:
```
docker compose up -d
docker compose exec <service> busted ...
```
The image (`Dockerfile`) installs Lua 5.1.5, LuaRocks 3.7.0, LuaJIT (pinned commit), the EmmyLua debugger 1.7.1, and rocks: `busted 2.2.0-1`, `cluacov 0.1.2-1`, `luacov-coveralls 0.2.3-1`, `luautf8 0.1.6-1`.

## Regenerating data files
- **ModCache.lua**: in a running PoB, press `Ctrl + F5` to reload — `src/Data/ModCache.lua` is rewritten. Commit the diff when mod parsing changes.
- **Other generated files in `src/Data/`**: do not hand-edit. Modify the corresponding script in `src/Export/` and re-run the exporter, then commit both the script and regenerated data.

## Git workflow
- **All PRs target `dev`.** `master` is the release branch.
- Keep a fork in sync per the recipe in `CONTRIBUTING.md`.

## Environment notes
- Primary platform is **Windows** (matches `runtime-win32.zip`); Linux supported with `chmod +x` on the runtime binary.
- No `.env` files — configuration lives in `manifest.xml` (version, sources), `.busted` (test config), and the per-user save directory the runtime chooses at launch.
