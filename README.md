# Mochi Hub 🎀

Soft Kitty Edition. The working Lua UI foundation, with a new pastel identity inspired by the supplied Mochi branding kit.

The navigation sidebar now opens expanded, with search above the tabs and a `/` shortcut. Live FPS, ping in milliseconds, and server population/capacity sit in the header. Feature and Settings sections use two columns of compact glass cards: small right-aligned toggles and value fields, full-width dropdowns beneath their labels, and subtle row dividers. Home keeps its welcome, favorites, keybind reminders, and Yes/No session restore. The existing hover-collapse option is still available in Settings.

```lua
getgenv().__MOCHI_UI_OPTIONS = {Theme = "Soft Kitty", Game = "My Game"}
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/mochiloader/ui-d/main/Loader.lua"))()
```

Current repository: [mochiloader/ui-d](https://github.com/mochiloader/ui-d). Replace references to the unavailable `Mochi-Hub-loader/Main-UI` repository in your own scripts with the URL above. `Loader.lua` returns the same UI API, tries the normal library download first, falls back to GitHub's public API when possible, and reports download and compilation errors clearly. The direct `UniversalUI.lua` and `universal ui` entry points also remain available.

If GitHub's raw host returns 404, use its public contents API instead (requires an executor HTTP request function):

```lua
local send = request or http_request or (syn and syn.request) or (http and http.request)
assert(type(send) == "function", "This loader needs an HTTP request function")
local response = send({Url = "https://api.github.com/repos/mochiloader/ui-d/contents/UniversalUI.lua", Method = "GET", Headers = {Accept = "application/vnd.github.raw+json"}})
assert(response.StatusCode == 200, "Mochi Hub download failed")
local UI = loadstring(response.Body)()
```

Artwork uses the same public API as a fallback when the raw host fails, then caches normally. No token or sign-in is required. Missing downloads retain the existing native visual fallback. The public API has rate limits, so keep local asset caching enabled.

The existing `universal ui` URL remains an identical entry point. Layout stays at 900 × 540 with the same responsive scaling, sidebar, tabs, controls, search, favorites, configuration manager and game adapters. Existing game modules can continue using the returned API. `UI.MochiAdapter` is also available.

Home now contains a compact welcome strip, favorite features, and live keybind reminders. Tap the star beside a feature (or right-click its row) to pin/unpin it. Favorites persist between launches. Favorite toggles operate the original controls directly; other favorites open the original feature's tab. Reminders show the menu key and assigned feature keys, updating when bindings change.

With **Remember last session** enabled in Settings → Window & navigation, feature settings checkpoint locally when they change, at most once every two seconds, and on normal UI unload. On a later launch, Home asks **“Restore your last session?”** with only **Yes** and **No**. Yes restores matching registered feature controls; No leaves the current launch's values untouched. The previous snapshot is not overwritten before an answer. The first launch records a session without showing an empty restore question. Session snapshots are isolated by game universe under `MochiHub/Saves/<script>/Session/<universe>-LastSession-v1.json`, separate from favorites and named configs. File support is required. Only values exposed by registered controls' Get/Set methods are remembered; opaque game logic is not serialized.

The default theme uses cream `#FFF8FC`, baby pink `#F8BBD5`, blush `#E88CB7` and soft black `#211B23`. Settings offers only Soft Kitty and the distinctly dark Moonlit Mochi. Duplicate palettes were removed; older saved choices migrate to one of these two. The standalone Mochi wordmark appears first; once initialization reaches 100%, the existing window expands from it and a transparent cat mark docks into the sidebar. There is no talking bubble. Modules can use `ManualReady`, `UI.FinishLoading()` and `UI.FailLoading(message)` as before.

Assets download from this repository and cache under `MochiHub/Assets`. Preferences and saves use `MochiHub`; existing saves and autoload settings are copied from legacy locations only when the Mochi destination does not exist. The old files are never changed. Without custom-asset/file support, native text, gradients, a letter mark and bow fallback remain usable; custom images and the paw cursor need those capabilities.

Reduced Motion is in Settings → Window & navigation. It uses a short fade instead of window growth, logo travel or sliding tabs. Opening, closing, tab switching, controls and notifications use bounded tweens with cancellation to prevent competing motion. The black-cat illustration is clearly visible through glass panels, whose opacity stays stable on hover. Typography uses native Gotham weights throughout. The sidebar and draggable reopen control use an unframed cat silhouette, without circular masks or a square backing. Tab and window-control icons use the included [Lucide set and license](assets/icons/lucide/README.md).

Validation: `luau-compile --null UniversalUI.lua` and `node tests/run-tests.cjs` with Luau on PATH (or `LUAU_BIN`). See [validation and remaining limits](VALIDATION.md), [change and removal report](REBRAND_REPORT.md), and [artwork provenance](assets/ARTWORK.md).
