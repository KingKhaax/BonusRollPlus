<p align="center"><img src="assets/logo.png" width="420" alt="BonusRoll Plus"></p>

<h1 align="center">BonusRoll Plus</h1>

<p align="center"><b>The WoW loot roll window, in frosted glass.</b><br>
An addon for World of Warcraft Forever that replaces the Need, Greed, Disenchant and Pass window with a translucent panel showing the item level, the gear slot and everyone's rolls right next to it.</p>

<p align="center"><img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="40" height="40" align="absmiddle"> <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="40" height="40" align="absmiddle"></p>

---

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> What it does

The game's own roll window is small and tells you almost nothing. With BonusRoll Plus, when an item drops in a group you see at a glance:

| | |
|---|---|
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_helmet_01.jpg" width="28" height="28" align="absmiddle"> | **The item name** in its quality colour, with **the item level in brackets** next to it |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_shoulder_01.jpg" width="28" height="28" align="absmiddle"> | **The slot it belongs to**, for example `Head · Plate` or `Shoulder · Mail` |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_dice_01.jpg" width="28" height="28" align="absmiddle"> | **Need**, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_coin_01.jpg" width="28" height="28" align="absmiddle"> **Greed**, <img src="https://wow.zamimg.com/images/wow/icons/large/inv_enchant_disenchant.jpg" width="28" height="28" align="absmiddle"> **Disenchant** and <img src="https://wow.zamimg.com/images/wow/icons/large/spell_chargenegative.jpg" width="28" height="28" align="absmiddle"> **Pass** as four labelled buttons. The ones you can't pick are dimmed and the tooltip says why |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_note_01.jpg" width="28" height="28" align="absmiddle"> | **A small side window with every player's roll**, in their class colour, with a crown on whoever is winning |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_gear_01.jpg" width="28" height="28" align="absmiddle"> | **A timer bar** that empties while you decide |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> | **Update notice**: if you meet someone with a newer version, the addon tells you |
| <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_bag_08.jpg" width="28" height="28" align="absmiddle"> | **Translated into the game's 11 languages**: Spanish (Spain and Mexico), English, German, French, Italian, Brazilian Portuguese, Russian, Korean and Chinese (Simplified and Traditional) |

If several items drop at once, the windows stack upwards above the action bar.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_letter_15.jpg" width="28" height="28" align="absmiddle"> Installation

1. Copy the **`BonusRollPlus`** folder from this repository (not the whole repository) into:
   ```
   World of Warcraft\_forever_\Interface\AddOns\
   ```
2. Start the game and, on the character screen, check that *BonusRoll Plus* appears under **AddOns**.
3. In game, type `/br test` to see it without waiting for loot.

If the game was already running, type `/reload` first.

## <img src="https://wow.zamimg.com/images/wow/icons/large/inv_misc_bag_08.jpg" width="28" height="28" align="absmiddle"> Commands

| Command | What it does |
|---|---|
| `/br open` | Opens the settings window: 10 designs with preview, size, opacity, visible windows and About |
| `/br test` | Shows three test windows using your equipped items |
| `/br scale 0.5-1.5` | Changes the size (default 1) |
| `/br rolls` | Shows or hides the rolls window |
| `/br lock` | Locks or unlocks the windows (same as the padlock) |
| `/br reset` | Puts the windows back in their default place |
| `/br history [n\|clear]` | Shows or clears your roll history |
| `/br version` | Shows the installed version |
| `/bonusroll` | Another name for `/br` |

Drag a window to move it. The padlock in its corner locks it; click again to unlock. The position is saved.

## Status

Version **0.6.0**. The default style is **Frosted Glass**, and there are 10 designs to choose from in `/br open`. The logic is tested with Lua and a simulation of the game, but **most of it has not yet been checked inside the client**. All the details, known limits and what is missing are in [`BonusRollPlus/README.md`](BonusRollPlus/README.md).

## What's in this repository

| Path | Contents |
|---|---|
| `BonusRollPlus/` | The addon, ready to copy into the game |
| `assets/` | The addon logo, icon and screenshots |
| `tests/` | Tests for message parsing and a full run against a simulation of the game |
| `tools/` | CurseForge upload script and the English changelog for the version |
| `docs/` | Latest CurseForge page description (HTML) |

<sub>The icons are from World of Warcraft and belong to Blizzard Entertainment. This project is not affiliated with Blizzard.</sub>

---

# Notes for whoever continues the work

This section sums up everything done up to 2026-11-13: how the addon is built, how it is tested and published, and what the author has decided. Read it all before changing anything.

## Resuming the work in a new session

Use this when you pick the project up on another PC or in a new working session.

1. **Get the code.** Clone the repository or update it:
   ```
   git clone https://github.com/KingKhaax/BonusRollPlus.git
   cd BonusRollPlus
   git pull --rebase
   ```
2. **Check the tools.** You need `git`, a Lua interpreter (`lua` 5.4 or `luajit`) and, to publish, PowerShell plus the user environment variable `CURSEFORGE_API_TOKEN`. Don't copy the token into the repo.
3. **Run the tests** before changing anything, so you know the starting point is clean:
   ```
   lua tests/core_tests.lua
   lua tests/smoke_test.lua
   ```
4. **Install the addon in the game.** Copy the `BonusRollPlus` folder to `World of Warcraft\_forever_\Interface\AddOns\`, replacing the old one (on Windows: `robocopy BonusRollPlus "<AddOns>\BonusRollPlus" /MIR`). Then `/reload` and `/br test` in game.
5. **Read the state.** Read this whole notes section, `CHANGELOG.md` and `git log --oneline -10`. The version in `BonusRollPlus/BonusRollPlus.toc` is the current one; "Current status" and "Pending" below say what is published and what is left.
6. **Brief the new session.** Start it with a message like this one (in Spanish, the author's language):
   > Retoma el addon BonusRoll Plus del repositorio KingKhaax/BonusRollPlus. Lee entero el README (sección «Notes for whoever continues the work»), el CHANGELOG y los últimos commits, pasa las pruebas, instala la carpeta BonusRollPlus en AddOns de WoW Forever y dime en qué estado está y qué queda pendiente antes de tocar nada.
7. **When you finish**, follow "How to publish a version", update "Current status" and "Pending" in this README, and push. That keeps the next session in sync.

## Current status

| Item | Status |
|---|---|
| **0.4.0** | First version, uploaded by hand by the author on 2026-11-12. |
| **0.5.0** | Published on CurseForge on 2026-11-13 (project **1800719**, file id 9589441). Commit `290c683`. |
| **0.6.0** | Published on CurseForge on 2026-11-13 (file id 9590891), at the author's request. Commit `11c610a`. Pending CurseForge review. |
| **0.7.0** | **In development, not published.** The `.toc` stays at 0.6.0 on purpose. It is implemented and tested only with the simulation; publish it only when the author asks (steps in "How to publish a version"). |
| In-game testing | **Almost nothing is verified in the client.** Everything is tested with a simulation (see "Tests"). Confirmed by hand by the author: the roll window, hiding the Blizzard window (after some fixes) and the rolls panel after several fixes. |

0.5.0 contents: settings window with 20 designs, profiles, `/br history`, item level difference, "you can't use this item" warning, compact rows, maximum visible windows, padlock, class icon, update notice between players, texts in 11 languages and a random fact in the settings footer.

0.6.0 contents (see `CHANGELOG.md` and `tools/changelog-en.md`): sale or auction value with a purple `*` for an uncollected appearance, History tab with statistics, per-specialization profiles, sound and flash alerts, setting for how many seconds the window stays after the winner (2 by default), designs cut from 20 to 10, previews loaded gradually, fix for missing windows when several items drop at once.

0.7.0 contents (pending, see `CHANGELOG.md` and `tools/changelog-en.md`): automatic rules (auto-pass downgrades, auto-greed cheap BoE; off by default, they say what they did in the chat and never roll Need), value line with vendor, auction (TSM `DBMarket`) and disenchant (TSM `Destroy`) values with their icons and the game's coin icons plus "Cannot be sold", a gold BiS tag read from `NaowhForever.BiS.Alerts` when that addon is installed, seconds left on the time bar, stack direction and gap, text size, always-compact rows, profiles by content type (raid, dungeon, open world), session summary, quality filter and text export in the History tab, and a settings tab organized in scrolling sections.

> **The repository has been public since 2026-11-13** (the screenshots in the description load from raw.githubusercontent.com and returned 404 while the repo was private). Never commit tokens, keys or personal data.

## Author's rules (mandatory)

- **Single client: WoW Forever.** The addon is exclusive to that client (game version 1.60.1 on CurseForge, id 17053). Retail and Classic don't need to be supported. The `.toc` still lists Retail interfaces (16001, 11601, 120107, 120105); only clean them up if the author asks.
- **Language:** always talk to the author in Spanish. Any message he is going to publish has its translation underneath.
- **Commits:** author and committer `sr.kitkat <180756772+KingKhaax@users.noreply.github.com>`. **No attribution lines** of any kind and no `Co-Authored-By` lines.
- **Versions:** one at a time. While one is unpublished, don't number another. If the author says he already uploaded one, the pending one becomes the next.
- **Changelog:** important changes only. No minor fixes or loose text tweaks.
- **New texts:** every new key goes into **all 11 languages** (esES, esMX, enUS, deDE, frFR, itIT, ptBR, ruRU, koKR, zhCN, zhTW), with the same `%s`/`%d` placeholders as English. A test checks this.
- **Don't touch unless asked:** other addons, game settings, the PC. *Reading* the author's addons to understand conflicts is allowed.
- **No windows on screen while testing** and no visible terminals: scheduled tasks use `conhost --headless`.
- **Code without comments** except where essential.

## File map (`BonusRollPlus/`)

Load order is the one in the `.toc`:

| File | Purpose |
|---|---|
| `Locales.lua` | Base texts for the window and the panel, in 11 languages. Creates `ns.L` and `ns.Strings`. |
| `LocalesSettings.lua` | Settings window texts, in 11 languages; rewrites the `/br` help. |
| `LocalesText.lua` | Design names and the About changelog in the 8 languages other than es/en. |
| `LocalesExtra.lua` | More texts (profiles, history, statistics, values, alerts) and release notes per language. |
| `LocalesV07.lua` | Texts of the 0.7.0 settings (sections, stack direction, text size, automatic rules, content profiles, history filter and export), in 11 languages. |
| `LocalesNotes07.lua` | 0.7.0 release notes for the About tab in the 8 languages other than es/en. |
| `Themes.lua` | The window designs (added to the ones in Core). Each design is a data table, not code. |
| `Core.lua` | The whole engine: message parsing, windows, layout, closing, live settings, commands and events. |
| `Facts.lua`, `FactsDEFR.lua`, `FactsITPT.lua`, `FactsRUKO.lua`, `FactsZH.lua` | 200 WoW facts; the first two languages are in `Facts.lua` (es, en) and the rest in tables aligned by position. |
| `Profiles.lua` | Profiles: save, load, export and import (`BRP1;…`), per character and per specialization. |
| `Settings.lua` | Settings window (5 tabs: Designs, Settings, Profiles, History, About) and the button in the AddOns options. |

Outside the addon: `tests/` (tests), `tools/` (upload script and English changelog), `assets/` (logo, icon and screenshots), `docs/` (CurseForge description).

## How a roll works (summary of `Core.lua`)

1. **`START_LOOT_ROLL`** → `OnStartRoll` hides the Blizzard windows, reads `GetLootRollItemInfo`, gets a window with `Acquire` and fills it with `Setup` (inside `pcall`: on failure it prints the error in red and sends it to the error handler).
2. **Windows:** reused from a pool per design (`pools`). `Release` is idempotent (marks `pooled`) and `Acquire` never returns a window still in `active`. This fixed the "an item drops and a window is missing" bug.
3. **Layout (`Layout`):** stacks up to `maxVisible` full windows; the rest wait hidden and, if `compact` is on, show as one-line rows (`BuildMini`).
4. **Rolls panel (side list):** fed by two sources, both valid at once:
   - the chat (`CHAT_MSG_LOOT`, patterns built from the client's global strings; in `esES` the rolls use positional placeholders);
   - the game's loot history (`C_LootHistory`, event `LOOT_HISTORY_UPDATE_DROP`), the source ForeverPlusPlus uses.
   Each message is matched to its window by item id and, failing that, by **item name** (`FindFrame`). Values may arrive "secret" (`issecretvalue`); they are skipped with `Readable`.
5. **Closing:** after choosing, the window stays until the winner is announced (`MarkWon`) or "everyone passed", and closes `closeDelay` seconds later (2 by default, 0 to 15). If the roll ends with no winner announced, it waits for the real roll time plus 10 s. Each roll has its own `token` so scheduled closes never close another roll.
6. **Need is never blocked.** If the game says you can't use the item, only the red `CANT_USE` warning and the game's reason in the tooltip are shown. The author requires this to sell BoE items.
7. **Blizzard windows:** `HideBlizzard` makes `GroupLootFrame1..4` and the container's frames invisible with `SetAlpha(0)` and no mouse, after `GroupLootContainer_AddFrame`/`_Update` via `hooksecurefunc` and a delay. **Don't use `HookScript` on those frames** and **don't walk `UIParent`** with `GetName()`: it causes "forbidden object / taint" errors. With the addon disabled they show again.
8. **Value and appearance:** `ValueInfo` uses the TradeSkillMaster price (`TSM_API.GetCustomPriceValue("DBMarket", "i:ID")`) if available, otherwise the vendor price. A purple `*` marks an uncollected appearance (`C_TransmogCollection`, guarded with `pcall`).
9. **Item level difference:** `UpgradeDelta` compares with what is equipped in the slot (rings and trinkets against the weaker one; weapons ignore empty slots).
10. **Statistics and history:** `db.history` (max 100) and `db.stats`. The History tab and `/br history` read them.

### Designs
`Themes.lua` defines each design with `Make(id, title, titleES, params)`. Button positions come from the `layout` (`grid`, `split`, `row`, `stack`, `ring`, `rail`). The default design, `glass`, lives in `Core.lua`. Design names per language are in `LocalesText.lua` (`ns.ThemeNames`, one array per language **aligned by position with `ns.ThemeList`**): adding or removing a design means touching all 11 arrays.

### Settings window (`Settings.lua`)
Flat dark style inspired by ElvUI defaults (`#1A1A1A`, black border, `#1784D1` accent, `ARIALN` font). The controls are custom (no Blizzard templates). Design previews are built with the same code as the real windows (`ns.BuildPreview`), 3 per frame. The footer shows a random fact.

### Update notice
The version is sent through **addon messages** (prefix `BRPLUS`, text `V:0.6.0`) to party, raid, instance and guild, at most every 20 s. It is not visible chat or a whisper. On receiving a higher version, the addon prints a notice in the player's chat (`VERSION_OUTDATED`, in 11 languages). **It does not query CurseForge** (an addon can't). Limitation: it only works if you meet someone who has the new version.
Open ideas (not decided by the author yet): remember the newest version seen and warn in later sessions, and also send it to Battle.net friends.

## Saved data (`BonusRollPlusDB`)

`scale`, `alpha`, `theme`, `maxVisible`, `showRolls`, `showUpgrade`, `compact`, `showValue`, `sound`, `flash`, `closeDelay`, `countdown`, `stackDir`, `stackGap`, `fontScale`, `ultra`, `autoPass`, `autoPassMin`, `autoGreed`, `autoGreedGold`, `locked`, `x`, `y`, `v`, `history`, `profiles`, `charProfile`, `specProfile`, `contentProfile`, `activeProfile`, `stats`, `sessionStart`. Defaults are in `DEFAULTS` (`Core.lua`); profiles save only the keys of `ORDER` in `Profiles.lua`.

Commands: `/br open`, `/br test`, `/br scale`, `/br rolls`, `/br lock`, `/br reset`, `/br history [n|clear]`, `/br version`, `/br debug` (prints what the addon reads from chat, the raw text and the open windows; useful for diagnosing the rolls panel).

## Tests

There is no WoW client in the development environment. Use a **Lua 5.4** or LuaJIT interpreter:

```
lua tests/core_tests.lua      # message parsing, version comparison
lua tests/smoke_test.lua      # full run against a simulation of the game
```

`smoke_test.lua` simulates the game with "wildcard" objects (any unknown function returns another wildcard). So **passing the tests doesn't prove something looks right in game**: only that there are no Lua errors on those paths. It also checks: 10 designs, design names and changelog in every language, new keys in every language, same `%s`/`%d`, profile round trip, out-of-range values, history and statistics.
Tips: run the test 40 times in a row to catch intermittent failures (there was one caused by iterating a table while modifying it); on Windows, `lua.exe` doesn't understand `/tmp` paths, use `C:/...` paths.

## How to publish a version

1. Bump the number in `BonusRollPlus/BonusRollPlus.toc`, `README.md`, `BonusRollPlus/README.md` and `CHANGELOG.md`; add the entry to `CHANGES` in `Settings.lua` and the per-language notes in `LocalesText.lua`/`LocalesExtra.lua`.
2. Write the English changelog in `tools/changelog-en.md` (sections New, Improvement, Fix).
3. Run the tests. Commit as `sr.kitkat`, with no attribution lines, and `git push origin main`.
4. Build the zip `Desktop\BonusRollPlus\BonusRollPlus-X.Y.Z.zip` with **one `BonusRollPlus` folder** inside, entries with `/` and **without** the `.omc` folder (it sometimes appears inside the addon; delete it first).
5. Upload with the API: `powershell -NoProfile -ExecutionPolicy Bypass -File tools/upload_curseforge.ps1 -ProjectId 1800719 [-Upload]` (without `-Upload` it is a dry run). The token is in the user environment variable `CURSEFORGE_API_TOKEN`; never write it into files or commit it.
6. The **page description is set by hand** on CurseForge. The latest is in `docs/descripcion-curseforge.html` (English, with the Spanish part underneath). The author adds the screenshots: pending, see below.

## Author's environment (don't break it)

- On the author's home PC the addon folder in the game may be a **junction** to `BonusRollPlus/` in this repo: what you change here shows in game after `/reload` (or a restart if you add new files). On other PCs it is a plain copy.
- He plays WoW Forever with many addons. **EllesmereUIBlizzardSkin** skins the Blizzard roll windows; **ForeverPlusPlus** (Loot Rolls module, off by default) repositions them. Neither creates roll windows of its own.
- Lua errors from the session show in BugSack; the data file is only written on reload or logout.
- There are scheduled tasks on his PC (watching another addon, backing up the WoW configuration and the Voidcore Advisor Reborn upload on 1 December). They don't belong to this repo; don't touch them.
- The sister project **VoidcoreAdvisor Reborn** (repo `KingKhaax/VoidcoreAdvisorReborn`, CurseForge 1757601) shares these rules.

## Known traps

- In PowerShell, `R` is an alias of `Invoke-History`: don't use it as a function name.
- Bash heredocs lose the backslashes in Lua strings: write scripts with a file tool, not with `cat <<EOF`.
- `string.format` with `%d` fails with decimals; control values are rounded first.
- Russian, Korean and Chinese texts need the client font (`STANDARD_TEXT_FONT`); the code already uses it.
- Don't use `HookScript` or explore Blizzard frames from "tainted" code (see "Blizzard windows").
- Removing a design requires touching `Themes.lua`, `ns.ThemeNames` (11 arrays) and the `smoke_test.lua` test.

## Pending

1. **Pending screenshots:** the Need button tooltip with the red warning (the pink cursor circle must be removed from the original capture) and a new history screenshot with item level. Save them in `assets/screenshots/` and link them from `docs/descripcion-curseforge.html`.
2. Wait for CurseForge to approve 0.6.0 and set the new description (`docs/descripcion-curseforge.html`, already with the screenshots from `assets/screenshots/`). The history screenshot (`07-history.png`) predates showing item level and the tooltip: it should be retaken.
3. Decide whether to improve the **update notice** (remembered version, Battle.net friends).
4. Verify in game what has only been tested with the simulation, especially: windows with several items at once, the rolls panel, the value and the appearance `*`, the compact rows and the History tab.
5. Decide whether to remove the Retail interfaces from the `.toc`.

Rejected by the author: **keyboard shortcuts** for rolling and **support for other clients**.
