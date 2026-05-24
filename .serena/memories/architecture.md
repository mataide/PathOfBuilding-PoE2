# Key Architecture Patterns

## High-level shape
PoB2 is a **single-process desktop app** where a native host (SimpleGraphic) loads and drives Lua scripts via its `LoadModule` / `PLoadModule` (protected) loader. `src/Launch.lua` is the entry point — it sets up the `launch` global, configures LuaJIT (`jit.opt.start('maxtrace=4000','maxmcode=8192')`, with a `--no-jit` CLI flag to disable), reads `manifest.xml`, then calls `PLoadModule("Modules/Main")`. From there `src/Modules/Main.lua` orchestrates the application loop, tabs, and persistence.

```
SimpleGraphic (native)
   └─> Launch.lua  (boot, manifest, JIT setup, update check)
         └─> Modules/Main.lua  (app frame, tab switching, persistence)
               ├─> Modules/Build.lua  (per-build state)
               │     ├─> PassiveSpec / PassiveTree  (skill tree)
               │     ├─> Item / ItemsTab            (gear)
               │     ├─> SkillsTab + Gems          (skill setups)
               │     ├─> ConfigTab                  (build config)
               │     └─> CalcsTab                   (read-only stat breakdown)
               └─> Modules/Calcs.lua  (central dispatcher — loads sub-modules into one `calcs` table)
                     ├─> CalcSetup       → ModDB / ModList / ModStore
                     ├─> CalcPerform     (orchestration / mode wrapper)
                     ├─> CalcActiveSkill (resolve which mods apply)
                     ├─> CalcDefence
                     ├─> CalcOffence
                     ├─> CalcTriggers
                     ├─> CalcMirages
                     └─> CalcBreakdown / CalcSections  (UI surface)
```
The load order in `Calcs.lua` is authoritative — match it when adding new calc modules.

## Modifier system (the engine of everything)
The core abstraction is the **modifier** — every passive node, item affix, gem stat, buff, debuff, config toggle, and aura contributes mods to a shared store.

- **`ModParser`** (`src/Modules/ModParser.lua`) turns the human-readable mod strings from `src/Data/Mod*.lua` and item text into structured mod descriptors.
- **`ModDB` / `ModList` / `ModStore`** (`src/Classes/`) accumulate, query, and combine those mods with tags (skill, slot, condition, multiplier).
- **`StatDescriber`** translates mods back to display strings.
- **`ModCache.lua`** (under `src/Data/`) is a regenerated cache of parsed mods — reload PoB with `Ctrl+F5` to refresh it after parser changes.

## Calc pipeline
`Modules/Calcs.lua` is the single entry into the calc system; it loads every `Calc*` sub-module into one shared `calcs` table (in the order listed in the diagram above) and exposes the result. Building a stat set is a deterministic pipeline over the modifier store:
1. **`CalcSetup`** — collect mods from tree, items, gems, config, party, minions.
2. **`CalcActiveSkill`** — resolve which mods apply to the active skill.
3. **`CalcOffence` / `CalcDefence` / `CalcMirages` / `CalcTriggers`** — produce stat outputs.
4. **`CalcPerform`** — orchestration / per-mode wrapper that drives the above.
5. **`CalcBreakdown` / `CalcSections`** — feed the calc tab UI with annotated breakdowns (`Calcs.lua` sets `calcs.breakdownModule = "Modules/CalcBreakdown"` so the breakdown can be loaded lazily by the UI).

## UI pattern
Hand-rolled retained-mode-ish system on top of SimpleGraphic. Each `*Control.lua` in `src/Classes/` is a widget (button, dropdown, list, scrollbar, edit, slider, tooltip). Tabs (`*Tab.lua`) compose controls. `ControlHost` / `TooltipHost` / `SearchHost` are mixins that controls inherit from.

## Persistence & sharing
- Builds are XML, parsed via `runtime/lua/xml.lua`.
- Share codes are base64 + zlib-style encoded build XML (`base64.lua`, `sha1/`, `sha2.lua` are vendored under `runtime/lua/`).
- `BuildSiteTools` / `PoBArchivesProvider` / `ExtBuildListProvider` handle remote build hosts.

## Updates
`UpdateCheck.lua` polls the manifest in `manifest.xml`, downloads diff'd files via the URLs there, and `UpdateApply.lua` swaps them in on next restart (`F5`).

## Testing architecture
`HeadlessWrapper.lua` provides a no-op SimpleGraphic surface so the calc pipeline can run under busted without a window. Specs live in `spec/System/` and exercise the calc/mod/item/trade subsystems end-to-end.
