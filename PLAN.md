# StockChef — Kitchen Inventory & Recipe Matching App

## Context

The user wants a fully local, offline Flutter app ("StockChef") that (1) ships with a hand-curated dataset of ~150 authentic Indian home recipes (Tamil & Odia as the mandatory majority), (2) tracks fridge/kitchen inventory with expiry/shelf-life, (3) auto-builds a restock list and reminds the user about low core ingredients, (4) recommends recipes that prioritize soon-to-expire stock and account for ingredient/equipment substitutions, (5) scales portions, (6) lets the user OCR-scan a grocery bill into a draft inventory import, (7) reminds about idle soon-to-expire items, (8) lets users add their own recipes, and (9) documents the architecture plus an honest mapping of classic DSA patterns (Blind 75 / Grind 169) to the logic actually used. The project directory started empty — this is a from-scratch build.

Clarified with the user up front:
- OCR via **Google ML Kit** (on-device, offline, free) — satisfies "no paid APIs."
- README's algorithmic section maps to the **Blind 75 / Grind 169** LeetCode lists.
- Target platforms: **Android & iOS only**.
- Recipe mix: **~60 Tamil, ~60 Odia, ~30 other Indian regional cuisines** (~150 total), hand-researched (not live-scraped, since this environment can't scrape live sites) and written as static JSON assets.

## Tech Stack

| Concern | Choice | Why |
|---|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation`/`riverpod_generator` | Cross-feature reads (matching needs inventory+recipes+substitutions+expiry together) without BuildContext coupling or Bloc's event/state ceremony. |
| Local DB | `drift` + `sqlite3_flutter_libs` | Requirement needs real relational joins (ingredients-expiring JOIN recipes-containing-ingredient); Isar/Hive have no query engine for this. |
| Notifications | `flutter_local_notifications` + `timezone` + `flutter_timezone` | Offline, exact-time zonedSchedule for expiry/restock reminders, no background daemon needed. |
| OCR | `google_mlkit_text_recognition` | On-device, offline, free. |
| Camera capture | `image_picker` + `permission_handler` | Simplest path for "photograph a bill," no live preview needed. |
| JSON seeding | `freezed` + `json_serializable` for one-shot DTOs; Drift row classes as the actual runtime domain entities | Avoids parallel freezed+Drift model hierarchies — one source of truth per persisted concept. |
| Routing | `go_router` | Declarative, supports deep-linking a notification tap into the restock/expiry screen. |
| Misc | `uuid`, `intl`, `mocktail`, `flutter_test`, Drift's `NativeDatabase.memory()` for tests | Standard. |

## Folder Structure (feature-first, layered `data/domain/presentation`)

```
stockchef/
  assets/data/
    recipes.json
    ingredient_substitutions.json
    equipment_substitutions.json
  lib/
    main.dart
    app.dart
    core/
      theme/app_theme.dart
      routing/app_router.dart
      database/
        app_database.dart
        tables/  (ingredients, equipment, recipes, recipe_ingredients, recipe_equipment,
                   recipe_steps, recipe_step_parallel_links, ingredient_substitutions,
                   equipment_substitutions, inventory_items, restock_list_items,
                   scheduled_reminders, cook_events, notification_debounce, seed_metadata)
      seeding/recipe_seed_dto.dart, recipe_seeder.dart
      constants/thresholds.dart, asset_paths.dart
      utils/quantity_unit_converter.dart, date_utils.dart
      widgets/expiry_badge.dart, empty_state.dart
    features/
      recipes/         (browsing, detail, add/edit, portion scaling, step timeline w/ gas-level + parallel groups)
      inventory/        (CRUD, expiry UI, restock-threshold hook)
      substitutions/    (repository over the two JSON-derived tables, consumed by matching + footnotes)
      restock/          (restock list screen/provider)
      matching/          (RecipeMatchingService interface+impl, recommendations screen)
      ocr_scan/          (capture -> delimiter -> draft review -> commit pipeline)
      notifications/     (scheduling services, debounce tracking, settings)
      settings/
  test/  (unit/widget/integration mirroring lib/)
```

Cross-feature access only through a feature's `domain/` interface or `presentation/providers` — never another feature's `data/` internals.

## Data Model (Drift tables + reconciled schema additions)

> **Revised — see [IMPLEMENTATION.md](IMPLEMENTATION.md) Part A (gap analysis) for the reasoning behind the changes below.**

Base schema as designed, **plus these additions surfaced by the algorithm design**:
- **`IngredientStockPolicy` table** (`ingredientId PK, parQuantity, unit, thresholdPercent, isCore`) — restock threshold is evaluated against an ingredient's **par level** (reorder point), NOT "% of last purchase," which is meaningless with per-batch rows. `originalPurchaseQuantity` remains only as optional informational data on a batch. (Gap A1.)
- `InventoryItems` stays **per-batch** (not ingredient-aggregated) — so FIFO/near-expiry batches surface individually in the expiry-idle queue even when the same ingredient has multiple purchase batches with different expiry dates. Restock checks aggregate across batches; expiry checks stay per-batch.
- `IngredientSubstitutions.qualityRatio` (REAL, default 1.0) — lets the matcher prefer a closer substitute and score a small penalty for using any substitute.
- `EquipmentSubstitutions` / `RecipeEquipment.commonlySubstituted` (bool) — drives whether to show an equipment footnote when equipment-ownership tracking is off.
- `CookEvents` table (id, recipeId, cookedAt, ingredientIds) — logs what was cooked, feeding the "idle ingredient" check.
- `NotificationDebounce` table (ingredientId PK, lastNotifiedAt) — separate from `ScheduledReminders` (exact per-item expiry-time notifications); rate-limits the recurring "core ingredient low" digest.

Enums: `GasFlameLevel{high,medium,low,none}`, `MeasurementUnit{...}`, `CuisineRegion{tamil,odia,...,other}`, `MealType{...}`, `RestockReason{lowStock,manual,ocrImport}`.

`RecipeSteps.stepGroupId` (shared value = parallel-doable) covers "parallel work if possible" cheaply; `RecipeStepParallelLinks` covers arbitrary pairwise overrides. `flameLevel` is nullable per step (only stove steps set it).

Bundled dataset seeding: `RecipeSeeder` is version-gated via `SeedMetadata['dataset_version']`, upserts only rows where `isUserCreated = false`, so user-added recipes are never touched by dataset updates. `Ingredients`/`Equipment` master rows are derived at seed time by unioning every name referenced across `recipes.json` and the two substitution JSONs, slugified into stable ids.

## Core Domain Algorithms

### 1. Recipe matching/ranking against inventory (with expiry priority & substitutions)

**Setup, once per matching pass — O(N):** build `ownedIngredientIds` (hash set) and `inventoryByIngredientId` (ingredientId → aggregated item, summing quantity and keeping the *earliest* expiry across duplicate batches — FIFO) from the user's inventory, N ≈ 50–150 items. The ingredient/equipment substitution maps load once at app start as `ingredientId → [{altId, qualityRatio}]` (O(1) lookups).

**Per recipe (R ≈ 150 recipes, I_r ≈ 8–15 ingredients each):**
- Required ingredient owned directly → match; if that item's expiry is within a lookahead window (e.g. ≤3 days) → add `1/daysLeft` to an expiry-urgency accumulator, so soonest-to-expire items dominate the score.
- Not owned → look up its ≤2–4 substitutes, pick the one owned with best `qualityRatio`; none owned → mark missing (with the substitute list attached, so UI can say "missing X, but Z would work").
- `score = w1·completeness + w2·normalizedExpiryUrgency − w3·substitutionPenalty`, where completeness = matched/total ingredients, substitutionPenalty grows with how many/weak the substitutes used were.
- Recipes bucket into tiers — `MAKEABLE_NOW` / `MAKEABLE_WITH_SUBSTITUTION` / `MAKEABLE_WITH_MANY_SUBS` / `PARTIAL` — each tier sorted by score.

**Complexity:** index build O(N); per-recipe eval O(I_r·S) ≈ 12×3 = 36 hash ops; across all recipes O(R·I_r·S) ≈ 150×36 ≈ 5,400 ops; final sort O(R log R) ≈ 150×log(150) ≈ 1,000. Total ~6,500 ops per full recommendation pass — sub-millisecond on-device.

**Why not bipartite matching:** true matching (Hopcroft–Karp/Kuhn's) earns its cost when a resource is *contended* — one unit of stock can only satisfy one requirement, so assigning it to recipe A blocks recipe B. This app checks "do you own it (or a sub), yes/no" for one recipe at a time — no contention to resolve, so it collapses to independent hash lookups. Real bipartite matching is a documented *future* extension only if a "weekly meal plan" feature needs to allocate one finite pantry across multiple recipes simultaneously.

### 2. Portion scaling
Unit-metadata-driven dispatch: `FIXED` (to-taste, unscaled), `COUNT_DISCRETE` (eggs, round to whole, min 1), `SUBLINEAR_DISCRETE` (pinch, steps per N servings), `LINEAR` (grams/ml/tsp, multiply then round to a sensible increment). Compute in base units; humanize only at display time. O(I_r) per recipe, O(1) per ingredient.

### 3. Restock threshold (revised — see IMPLEMENTATION.md A1)
Event-driven on every quantity write: `percent = SUM(quantityOnHand across non-expired batches) / parQuantity` (par level from `IngredientStockPolicy`, not "% of last purchase"); cross below `thresholdPercent` → insert into restock list; hysteresis margin (~5%) on the way back up to avoid flapping. O(1) per write (aggregate is a single indexed query).

### 4. Core-ingredient digest
Daily sweep over core ingredients below threshold, debounced via `NotificationDebounce` (default 24h cooldown), batched into one notification. O(C) where C = core ingredient count (small subset of N).

### 5. Expiry + idle reminder queue
Per-batch scan (not ingredient-aggregated) filtered to `daysUntilExpiry <= M`; urgency = `1/daysLeft` (dominant constant if already expired), multiplied up if idle (`lastCookedWith` from `CookEvents` older than K days). Bounded top-K min-heap, not a full sort. O(N log K). **Scheduling (revised — IMPLEMENTATION.md A2):** iOS caps pending notifications at 64, so we do NOT schedule one per item — a recurring daily digest (content recomputed on app resume) plus at most top-K≤20 exact per-item notifications.

### 6. Equipment footnote
Informational — substitutes shown regardless of whether the user owns them (unlike ingredient substitution, this isn't a matchability gate). Falls back to the `commonlySubstituted` flag when equipment-ownership tracking is off. O(E_r) per recipe render.

### 7. OCR draft parsing
User-inserted commas split columns (delegates ambiguity to the human, not fragile auto-detection); quantity/unit extracted via regex + unit-alias map; ingredient name fuzzy-matched via combined token-overlap + Levenshtein score against the ~150–300 entry ingredient dictionary, bucketed into auto-confirm (≥0.75) / confirm-flagged (0.5–0.75) / manual (<0.5). Per line: O(D·L), D≈150-300 candidates, L≈10-15 chars → ~50-70k ops/line; a 20-line receipt ≈ 1-1.4M ops, still comfortably sub-100ms on-device.

All six include explicit edge-case handling (empty inventory, no substitutes owned, expired/bad dates, duplicate rows) carried directly from design into implementation.

## Blind 75 / Grind 169 Pattern Mapping (for README)

| Pattern | Where used | Why it fits |
|---|---|---|
| **Hash map lookup/grouping** | Ingredient-ownership checks & substitution lookups in matching; notification-debounce map; OCR ingredient-name/unit-alias lookup | O(1) replaces nested loops over 150–300 ingredients — the app's workhorse pattern |
| **Priority queue / heap top-K** | Soon-to-expire + idle-item notification queue (only top ~10 surfaced) | Genuine top-K-of-a-stream problem; heap is O(N log K) vs sorting everything |
| **Greedy algorithm** | Picking the best available substitute per ingredient (no backtracking needed); restock hysteresis decisions | Each local choice doesn't need revisiting — no scenario where an earlier greedy pick invalidates later ones |
| **Interval / rate-limiter scheduling** | Notification cooldown ("don't re-notify within 24h" = classic logger-rate-limiter shape); M-day expiry lookahead window | Same shape as meeting-room/interval-overlap problems — checking if "now" falls inside a forbidden window since the last event |
| **Sorting-based ranking** | Final recipe ranking within each match tier; draining the expiry heap in order | Once scores exist, ordering is a plain sort/ranking problem |
| **Edit distance / string similarity** | OCR-scanned item name → known ingredient fuzzy match (Levenshtein + token overlap) | Genuinely a DP edit-distance problem — needed because OCR text won't exactly match dataset names |
| **Two-pointer (partial/optional)** | FIFO consumption across multiple expiry-dated batches of the same ingredient | Honest caveat — only the batch-consumption-order piece fits; the expiry-window check itself is just an O(1) comparison, not a sliding window |
| **Bipartite matching / backtracking** | *Considered, explicitly rejected* for recipe matching | Documented as a rejected approach (see Algorithm 1) — called out so the README doesn't overclaim a pattern that isn't actually needed |

## Recipe Dataset Creation

Separate content-authoring effort, not code. **Order revised (IMPLEMENTATION.md A4): author canonical dictionaries first, then recipes reference only existing ids.**
- **First:** `assets/data/ingredients.json` (`{id, name, aliases[], category, defaultUnit}`, ~200–300 canonical Indian cooking ingredients) and `assets/data/equipment.json` (`{id, name, aliases[]}`). This prevents divergent ids (`tomato`/`tomatoes`/`tamatar`) across parallel authoring batches.
- **Then** `recipes.json`: id, name, cuisine region, ingredients (**referencing existing ingredient ids**, qty-for-1-person, unit, optional, prep note), equipment, ordered steps (each with gas-flame level where relevant, chopping/prep detail, optional `stepGroupId` for parallelizable steps), nutrition facts (**approximate estimates — labeled as such in-app, no nutrition API**), mealType.
- **Then** `ingredient_substitutions.json` (ingredientId → [{alternativeIngredientId, qualityRatio, note}]) and `equipment_substitutions.json` (equipmentId → [{alternativeEquipmentId, note}]) — validated against the dictionaries.
- Distribution: ~60 Tamil, ~60 Odia, ~30 spread across other authentic Indian regional home-cooking (Punjabi, Bengali, Gujarati, Keralite, etc.) — researched via web search for authenticity, not fabricated.
- Author in cuisine slices of 15–20, running `tool/validate_dataset.dart` (IMPLEMENTATION.md Part C) after each batch to enforce id consistency, schema conformance, and substitution-map completeness.

## Phased Build Order

> **Full, in-depth per-phase playbook (goal · steps · files · pitfalls · acceptance criteria) is in [IMPLEMENTATION.md](IMPLEMENTATION.md) Part B.** Summary below.

0. Environment & tooling verification (`flutter doctor`, emulator/device).
1. Scaffold: `flutter create`, dependencies, folder skeleton, Material 3 theme, `go_router` shell.
2. Data models + DB: freezed seed DTOs, all Drift tables (incl. the reconciled additions above), `RecipeSeeder`.
3. Canonical dictionaries + recipe dataset authoring + recipe browsing/detail screens (portion scaling, step timeline, equipment footnote).
4. Inventory feature: CRUD, expiry UI, restock-threshold hook wired to writes.
5. Restock list + notifications: scheduling services, debounce table, app-resume recompute.
6. Matching integration: `RecipeMatchingService` + recommendations screen.
7. OCR flow: capture → delimiter → draft review (add/edit/delete) → commit to inventory.
8. Custom recipes: add/edit screen writing into the same tables with `isUserCreated=true`; bundled rows enforced read-only at the repository layer.
9. Tests + docs: `README.md` (architecture rationale, folder walkthrough, data model, dataset provenance, feature walkthroughs, the Blind75/Grind169 mapping table above with real file references, setup/run/testing instructions) **and finalize [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** — a zero-Flutter-knowledge onboarding guide (Dart/Flutter/Riverpod/Drift concepts + a requirement→file map), whose conceptual sections are already drafted and get real file references filled in per phase.

## Documentation Deliverables
- **[PLAN.md](PLAN.md)** (this file) — architecture & algorithm design.
- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** — gap analysis, revised decisions, in-depth phase playbook, dataset validation script, cross-cutting pitfalls checklist.
- **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** — zero-Flutter-knowledge developer onboarding.
- **README.md** — produced in Phase 9 (public-facing construction/architecture write-up + Blind75/Grind169 table).

## Verification Plan

- `flutter analyze` and `flutter test` (unit tests for the 6 domain algorithms against fixed fixtures/edge cases; widget tests for inventory/recipe-detail/OCR-draft screens; `NativeDatabase.memory()` for repository tests).
- Run the app on an Android emulator/device via `flutter run` and manually exercise: add an inventory item, reduce its quantity below threshold and confirm it lands on the restock list; set an item's expiry date near-term and confirm it's prioritized in recipe recommendations with the correct tier/badge; open a recipe and change serving size, confirm sensible rounding (eggs stay whole, pinches don't multiply literally); open a recipe missing equipment and confirm the substitution footnote appears; run the OCR flow with a real photographed bill, insert delimiter commas, confirm the draft list and fuzzy-matched ingredient names, edit/delete a row, commit to inventory; add a custom recipe and confirm it appears in recommendations like a bundled one.
- Confirm the seeded dataset loads with the expected ~150 count and roughly the 60/60/30 cuisine split via a quick DB query or debug screen.
