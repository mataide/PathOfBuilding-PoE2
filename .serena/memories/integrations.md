# External Integrations

## Path of Exile / GGG
- **PoE2 official trade site** — `TradeQuery*` classes (`TradeQuery.lua`, `TradeQueryGenerator.lua`, `TradeQueryHelpers.lua`) compose searches against the live trade API.
- **PoE Account API** — `PoEAPI.lua` handles OAuth-style auth flows; `TestPoEAPIAuth_spec.lua` covers this. Used for character/build/league imports.
- **Rate limiting** — `TradeQueryRateLimiter` honours GGG's API rate-limit headers; `TestTradeQueryRateLimiter_spec.lua` is the contract test.

## Third-party build hosts
- **pathofexile.com** passive tree links — accepted by the tree importer.
- **poeplanner.com** links — accepted.
- **PoEURL.com** shortened links — expanded automatically.
- **PoBArchivesProvider** — fetches archived/shared builds.
- **ExtBuildListProvider** — generic external build-list source.

## Updates / distribution
- Manifest-driven auto-updater fetching files from `raw.githubusercontent.com/PathOfBuildingCommunity/PathOfBuilding-PoE2/<branch>/` (see `manifest.xml`).
- GitHub Releases hosts installer + portable zip for end users.

## CI / GitHub
- GitHub Actions workflows in `.github/workflows/`: `test.yml` (busted), `installer.yml`, `release.yml`, `beta.yml`, `builddocker.yml`, `spellcheck.yml`, `backport.yml` + `backport_receive.yml`, `update-simple-graphic.yml`.

## Vendored libraries (in `runtime/lua/`)
- `dkjson.lua` — JSON
- `xml.lua` — XML parsing (used for build files)
- `socket.lua` — networking
- `base64.lua`, `sha1/`, `sha2.lua` — encoding/hashing for share codes and integrity
- `lua-profiler.lua` — built-in profiler (see CONTRIBUTING for usage)

## Dev-only
- **EmmyLua debugger** (1.7.1) provided via the Docker dev image for stepping through Lua under JetBrains/VSCode.
