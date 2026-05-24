# Project Structure

```
PathOfBuilding-PoE2/
├── src/                        # All Lua source
│   ├── Launch.lua              # Main entry point (called by SimpleGraphic)
│   ├── LaunchInstall.lua       # Installer entry
│   ├── LaunchServer.lua        # Server-side entry (build sharing, etc.)
│   ├── HeadlessWrapper.lua     # Test/CLI harness — shims SimpleGraphic APIs
│   ├── UpdateCheck.lua / UpdateApply.lua  # Auto-updater
│   ├── GameVersions.lua        # PoE2 patch/version metadata
│   ├── Classes/                # UI controls + domain classes (Item, ModDB, PassiveSpec, *Tab, *Control)
│   ├── Modules/                # Non-class subsystems
│   │   ├── Build.lua, BuildDisplayStats.lua, BuildList.lua, BuildSiteTools.lua
│   │   ├── Calcs.lua, CalcOffence.lua, CalcDefence.lua, CalcPerform.lua,
│   │   │   CalcActiveSkill.lua, CalcBreakdown.lua, CalcMirages.lua,
│   │   │   CalcSections.lua, CalcSetup.lua, CalcTools.lua, CalcTriggers.lua,
│   │   │   CalcFormat.lua
│   │   ├── ModParser.lua, ModTools.lua, ItemTools.lua, StatDescriber.lua
│   │   ├── ConfigOptions.lua, Common.lua, Data.lua, Main.lua
│   │   └── DataLegionLookUpTableHelper.lua
│   ├── Data/                   # Static + generated game data (gems, mods, bosses, ...)
│   │   └── ModCache.lua        # Auto-regenerated; commit when mod parsing changes
│   └── Export/                 # "Dat View" — a separate Lua app (its own Launch.lua + Main.lua)
│                               # that reads GGPK dumps and regenerates files in src/Data/.
│                               # Run independently from the main PoB app.
│
├── spec/System/                # busted specs (Test*_spec.lua)
│
├── runtime/                    # Pre-built native host + assets shipped in-repo
│   ├── Path{space}of{space}Building-PoE2.exe   # Windows launcher
│   ├── SimpleGraphic.dll                       # Native rendering/input host
│   ├── lua/                    # Vendored Lua libs (dkjson, sha1, sha2, socket, xml, base64, ...)
│   └── SimpleGraphic/Fonts/    # Bundled font atlases
├── runtime-win32.zip           # Packaged win32 runtime artifact
│
├── docs/                       # Internal developer docs
│   ├── addingMods.md, addingSkills.md
│   ├── calcOffence.md, modSyntax.md, rundown.md
│
├── .github/                    # Issue templates, PR template, workflows
│   └── workflows/              # test.yml, installer.yml, release.yml, beta.yml,
│                               # builddocker.yml, backport.yml, spellcheck.yml,
│                               # update-simple-graphic.yml
│
├── manifest.xml / manifest.cfg # Version + update source manifests
├── changelog.txt, CHANGELOG.md
├── Dockerfile, docker-compose.yml
├── .busted                     # busted test config
├── fix_ascendancy_positions.py # One-off Python helper
└── README.md, CONTRIBUTING.md, RELEASE.md, LICENSE.md
```
