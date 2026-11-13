## 0.5.0

### New
- **Settings window** (`/br open`, or "Open settings" in the game's AddOns options) with **20 window designs** and a live preview of each one. The default is still the frosted glass.
- **Profiles**: save your settings, switch between them, load one automatically on each character, and export or import them as text.
- **Item level difference** against what you wear (green `+12`, red `-5`) next to the armor slot.
- **Warning when you cannot use an item**. Need is never blocked, so you can still roll it to sell the item.
- **Roll history**: `/br history` lists your last rolls won, with item links.
- **Compact rows** for rolls waiting their turn when more items drop than windows are visible.
- A random World of Warcraft fact in the footer of the settings window, different every time you open it.

### Improvement
- Window size, opacity, number of visible windows (at most 3 by default), the rolls list and a lockable position: drag the test windows, lock them and they stay there for future loot.
- The rolls list reads the game's own loot history as well as the chat, so Need, Greed and Pass choices show up for everyone.
- The window stays open until the item is awarded and closes 5 seconds later.
- Blizzard's own roll windows are hidden while the addon is enabled, so only one window shows.
- Class icon next to each player's name, padlock on every window (`/br lock`), update notice between players and every text translated into the 11 languages of the game.

### Fix
- Spanish clients now read "Pasar" instead of the wrong "Clave" on the pass button.
