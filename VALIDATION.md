# Mochi validation

The current copy is in `mochiloader/ui-d`. Both aliases and all asset fallback URLs target this repository. `Loader.lua` compiles and passes six cases for primary success, API fallback, invalid primary content, both routes failing, invalid API content, and preservation of original runtime errors. These supplement the 80 existing behavior cases. Live Roblox/executor validation is still required. Earlier raw-host failures documented below refer to the previous `Mochi-Hub-loader/Main-UI` repository.

Validated on November 25, 2026 for the compact layout in `Mochi-Hub-loader/Main-UI`:

- All 68 previous behavior cases pass, plus twelve new cases using the actual extracted header, layout, metric and download helpers and original slider/dropdown constructors. The seven source-preservation hashes remain unchanged; the additional control-kind argument is normalized only as a presentation hint.
- New checks cover real ping readings and seconds-to-milliseconds fallback, unavailable data, live population/capacity changes, no header work while hidden/loading, `/` and compact-search focus guards, scaled search positioning, selected-tab highlight alignment, two-column section placement, Home ordering, section visibility/reset/cleanup, pin/value spacing, exact slider entry and touch dragging, and dropdown selection/refresh.
- The original 900 × 540 dimensions and 87 API fields remain. Both library aliases compile and match. The preserved game integration also compiles.
- Metrics share the existing half-second sampler; no additional frame connection, network poll, or animation loop was added. Missing ping/capacity is shown as `--`.
- A local layout simulation was inspected with the existing cat artwork and palettes. It checks presentation geometry and contrast; it is not a Roblox screenshot. The live validation limits below still apply.
- GitHub's raw host returned 404 for this public repository during final checks. The public contents API returned byte-identical code and all five PNGs with HTTP 200. README includes an alternate API loader; artwork now falls back to that API using an available executor request function. Two additional tests verify raw-first behavior, unauthenticated fallback and rejection of invalid/throttled responses. This does not establish executor-specific request support or remove public API rate limits.

The sections below record the prior revision's validation.

Validated on November 15, 2026:

- `UniversalUI.lua`, `universal ui`, and the preserved `test` integration compile with `luau-compile --null`.
- Both library entry points are byte-identical.
- 87 inherited API fields and the 900 × 540 window dimensions remain present.
- Seven inherited behavior blocks match the working source after normalizing only presentation (numeric background opacity, accent/main text color assignments, Back/Quint easing, visible brand text) and trailing whitespace: sliders, range sliders, textboxes, keybinds, color pickers, section reset registration, and the tab adapter.
- 20 launch lifecycle cases and seven inherited mouse/touch reopen cases pass using the actual extracted library methods. Launch cases cover the standalone logo, hidden initial window, real readiness gate, window expansion, sidebar docking, narrow viewports, missing images, reduced motion, failures, unload during expansion, and watchdog cleanup.
- Ten motion cases verify overlapping-tween cancellation, stale completion ownership, animation tree cleanup, reduced-motion timing, rapid tab changes, minimize/reopen races, interruption position drift and idempotent opening after a drag. A typography case checks native weights and readable fallback fonts.
- Save migration tests verify config/autoload copying, preservation of newer Mochi saves, exclusion of unrelated files, no writes to legacy locations, and repeat-run idempotency.
- Theme migration tests cover legacy/retired choices, the two remaining themes and invalid preferences. Four visual/icon cases verify the two distinct palettes, strong artwork contribution through glass rows, Lucide mappings/aliases, custom icons and unavailable-atlas fallback.
- Eight Home cases cover visible star pinning, stable saved keys, direct use of original toggle setters, live state reflection, navigation/unpinning, complex controls and changing/unbound key reminders. Sixteen session cases cover false/range/color/key values, unbound keys, separate storage, enum round-trips, invalid/deleted/missing controls, corrupt data, game isolation, Yes/No consent, late registration, write deduplication, disabled memory, Home-only prompting and unload/failure behavior.
- Five PNG assets have valid signatures and dimensions; all named Mochi runtime assets are present. The unframed mark was visually inspected and its outer corner alpha is zero. The icon atlas was visually inspected in the original rebrand.
- No legacy background/logo filenames or source-repository asset URLs remain in the runtime library. Background paw accents use no perpetual particle loop; the retired Winter Bow snowfall renderer was removed. Theme switching preserves the same artwork and logo while transitioning the palette.

There are 68 behavioral cases in this revision, plus API, asset and source-preservation gates. Existing input and migration tests remain. Tests execute real extracted handlers with mocked GUI, tween completion and executor files; they verify behavior and sequencing, not visual interpolation or GPU frame rate. A local 900 × 540 layout simulation was rendered in the prior revision for both themes using the actual illustration and chosen surface opacity; it is not a game screenshot.

## Live validation limits

No Roblox executor/game session was connected for this task. This suite mocks tween completion and GUI objects; it cannot establish actual frame rate, final Roblox font/image rendering, input hit testing, executor-specific HTTP/custom-asset support, or end-to-end game integrations. All tabs built by external game scripts inherit the common Mochi surfaces, but their game callbacks and any branding they supply dynamically need an in-game pass. The obfuscated `test` script was preserved with only its three clear-text diagnostic brand names changed; encoded content was not rewritten or audited.

In a fresh supported client, use the URL in README, watch the wordmark-to-window opening and cat-mark docking, check Home and Settings, rapidly switch game tabs, operate controls, save/reload, minimize and drag the reopen button, then reopen and try Reduced Motion. Unload any older copy before re-running. Repeat on each supported executor. These are remaining live checks, not claims of completed runtime testing.

For Home/session validation, register the usual game controls, pin a toggle and a slider, change a keybind, and confirm Home updates. Change feature values, unload normally, then relaunch and choose Yes; repeat with No and confirm no additional restore callbacks run. Named-config autoload remains independent. Snapshots may trail a hard disconnect by up to the checkpoint interval. Late modules restore only after their registration stack completes. Failed initialization never replaces the session. Executors without file support retain session-only favorites and cannot persist previous launches. These end-to-end executor checks remain untested here.
