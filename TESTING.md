# StockChef — Manual Testing Checklist

Run through this on a real device/emulator before a release. Automated coverage
(`flutter test`, 37 tests) covers the domain logic; this checklist covers the
UI flows and platform integration that tests can't.

Setup: `flutter run` on an Android emulator/device. First launch seeds ~126
recipes (watch for the splash, then the Cook tab).

## Recipes
- [ ] Recipes tab lists recipes alphabetically; cuisine filter chips scroll and filter.
- [ ] Search narrows the list (e.g. "dal").
- [ ] **Diet filters** (veg / non-veg / satvik / high-protein / light / hearty) narrow the list; combining a cuisine + diet filter works.
- [ ] Open a recipe → header tags, description, ingredients, nutrition, equipment, method all render.
- [ ] Change servings (± stepper) → quantities rescale sensibly (eggs stay whole, "to taste" unchanged, grams round to 5s).
- [ ] Steps show flame-level chips (color-coded) and parallel-step groups ("Do these in parallel").
- [ ] Equipment footnote appears for equipment with substitutes ("No X? Try Y").

## Inventory
- [ ] Empty state shows "Add your first item".
- [ ] Add item: ingredient autocomplete works; quantity + unit; purchase date; shelf-life shortcut sets expiry; save.
- [ ] Item appears grouped by ingredient with an expiry badge (color reflects days left).
- [ ] Multiple batches of one ingredient roll up (expand to see batches); soonest expiry shown.
- [ ] Edit a batch → changes persist. Delete a batch → removed.
- [ ] Add a staple (e.g. Toor Dal) below 10% of its par (e.g. 50 g of 1000 g) → it appears on **Restock** as "Low".

## Restock
- [ ] Auto low-stock items show with the correct reason chip and suggested quantity.
- [ ] Add a manual item via the dialog.
- [ ] Check an item off (checkbox) → it resolves and leaves the active list.
- [ ] Swipe an item away → deleted.
- [ ] Top an auto-listed staple back up above threshold+hysteresis → it auto-resolves.

## Cook (recommendations)
- [ ] With empty inventory → "Add inventory" prompt (no crash).
- [ ] With stock → recipes appear in tiers (Make it now / With substitution / Almost).
- [ ] A recipe using a soon-to-expire item shows the orange "Uses expiring: X" flag and ranks above non-expiring peers in its tier.
- [ ] A recipe matched via a substitute shows "⇄ X for Y".
- [ ] Match ratio (e.g. 2/10) and progress bar reflect coverage; missing ingredients listed.
- [ ] Tapping a card opens the recipe detail.

## OCR scan
- [ ] Inventory/Restock scan icon → Scan Bill screen with Take photo / Pick from gallery / Enter manually.
- [ ] "Enter text manually" → type lines like `Tomato, 2, kg` → **Build draft list**.
- [ ] Draft shows a green check for confident matches and an orange "?" for noisy/unknown items (e.g. `TOMATOE`).
- [ ] Edit an item name/qty; add a row; delete a row.
- [ ] Commit → "Added N items" → items appear in inventory.
- [ ] (Physical device) Take a photo of a real bill → text is recognized offline (airplane mode) → draft builds.

## Custom recipes
- [ ] Recipes → "New recipe" FAB → form renders.
- [ ] Fill name, cuisine, meal, veg toggle; add an ingredient (dropdown + qty + unit); add a step (+ optional flame); save.
- [ ] New recipe appears in the list with the person (user-created) icon.
- [ ] Open it → detail renders; a "Delete recipe" button is present.
- [ ] Delete → removed from the list. Bundled recipes have no delete button.
- [ ] The custom recipe participates in Cook recommendations like a bundled one.

## Notifications & lifecycle
- [ ] First launch prompts for notification permission (Android 13+/iOS); Allow.
- [ ] Background the app and resume → no crash; restock/expiry state recomputes.
- [ ] (Optional, time-based) A daily digest notification fires at the scheduled time; tapping it deep-links to Restock.

## Settings & theme
- [ ] Settings → switch theme (System / Light / Dark) → app re-themes immediately.
- [ ] Dark mode is legible across all tabs (contrast, badges, chips).

## Persistence & offline
- [ ] Fully close and reopen the app → inventory, restock, custom recipes persist.
- [ ] Run entirely in airplane mode → every feature works (no network dependency).
