# StockChef 🍲

A fully-offline **Flutter** app for tracking your kitchen inventory and matching it to authentic Indian home recipes — prioritizing ingredients that are about to expire, and working around what you're missing with smart substitutions.

No servers. No paid APIs. Everything runs on-device.

---

## What it does

1. **Recipe library** — 126 hand-curated authentic Indian recipes (Tamil & Odia majority, plus Punjabi, Bengali, Gujarati, Keralite, Andhra, Maharashtrian), each with ordered steps, **gas-flame levels** (high/medium/low), prep techniques, parallel-step grouping, equipment, and approximate nutrition.
2. **Kitchen inventory** — track items per purchase batch with quantity/weight, purchase date, shelf-life and expiry.
3. **Auto restock list** — when an ingredient's total stock drops below a **par-level threshold**, it's added to your restock list automatically; low core staples surface in a daily reminder.
4. **Expiry-first recommendations** — the "Cook Now" tab ranks recipes you can make from what you own, pushing recipes that use **soon-to-expire** items to the top.
5. **Substitutions** — recipes still match if you own a valid substitute (e.g. masoor dal for toor dal); equipment substitutes are shown as footnotes (e.g. "no pressure cooker? use a deep pot").
6. **Portion scaling** — recipes are authored per-person and scale to any serving count with cooking-sensible rounding (eggs stay whole, "to taste" never multiplies).
7. **OCR bill scanning** — photograph a grocery bill (Google ML Kit, on-device), delimit the columns with commas, review a fuzzy-matched draft, then commit to inventory.
8. **Custom recipes** — author your own; they participate in matching exactly like bundled ones. Bundled recipes are read-only.
9. **Local reminders** — a daily digest of expiring/low items and per-item expiry reminders, refreshed on app resume (no background daemon).
10. **Dietary & goal filters** — filter recipes by Veg / Non-veg / Satvik (vegetarian with no onion/garlic) / High-protein / Light / Hearty, all derived from the vegetarian flag, ingredient list and per-serving nutrition (thresholds in `DietaryThresholds`).
11. **Guest kitchens** — a permanent Home kitchen plus a switchable Guest kitchen for travel/Airbnb: add the rental's stock, get recommendations, and "Clear guest kitchen" when you leave. Recipes and dictionaries are shared; only inventory + restock are scoped per kitchen (`kitchenId`).

---

## Architecture

### Stack & rationale

| Concern | Choice | Why |
|---|---|---|
| State management | **Riverpod** (`flutter_riverpod` 2.x, hand-written providers) | Cross-feature composition (matching reads inventory + recipes + substitutions together) without `BuildContext` coupling. Codegen was dropped to keep Drift as the only generator on this SDK. |
| Local database | **Drift** over SQLite (`drift`, `sqlite3_flutter_libs`) | The core feature — "recipes that use ingredients expiring soon" — is a relational join. Isar/Hive have no query engine for that. |
| Notifications | `flutter_local_notifications` + `timezone` | Offline, exact scheduling, no server. |
| OCR | `google_mlkit_text_recognition` | On-device, offline, free; bundled Latin recognizer (no first-run download). |
| Camera | `image_picker` + `permission_handler` | Simple single-shot capture. |
| Routing | `go_router` | Declarative; notification taps deep-link straight to a screen. |
| Codegen | Drift only (`build_runner`) | JSON seed parsing is hand-written; recipe/match models are plain classes. |

### Module layout (feature-first)

```
lib/
  core/
    database/        Drift tables, AppDatabase, enums, providers
    seeding/         JSON → DB seeder (version-gated) + DTOs
    routing/         go_router shell (bottom nav + sub-routes)
    theme/ widgets/ constants/ utils/
  features/
    recipes/         browse, detail, portion scaling, step timeline, add-recipe
    inventory/       per-batch CRUD, expiry UI, restock threshold evaluator
    restock/         restock list (auto + manual + OCR)
    matching/        RecipeMatcher (pure) + repository + recommendations UI
    ocr_scan/         ML Kit service, bill parser, capture→delimit→review→commit
    notifications/   service + coordinator (digest + expiry reminders)
    settings/        theme mode, reminder info
```

Each feature is layered `data / domain / presentation`. Features talk to each other only through `domain` interfaces and `presentation/providers` — never another feature's `data` internals — so a new feature is additive.

See **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** for a from-scratch walkthrough aimed at engineers new to Flutter/Dart, and **[PLAN.md](PLAN.md)** / **[IMPLEMENTATION.md](IMPLEMENTATION.md)** for the design and phase-by-phase build record.

### The bundled dataset

- `assets/data/ingredients.json` — 171 canonical ingredients (id, name, aliases, default unit, optional par-level & core flag).
- `assets/data/equipment.json` — 34 equipment items.
- `assets/data/recipes.json` — 126 recipes referencing only canonical ids.
- `assets/data/ingredient_substitutions.json` / `equipment_substitutions.json` — directional substitution maps with quality ratios.

The dictionaries were authored first so every recipe references consistent ids; `tool/validate_dataset.dart` enforces referential integrity (no unknown ids, valid units/flames, no duplicates) and reports the cuisine distribution. On first launch (and after a `datasetVersion` bump) `RecipeSeeder` upserts everything in one transaction, touching only `isUserCreated = false` rows so your own recipes survive dataset updates.

---

## Algorithms & the Blind 75 / Grind 169 mapping

The domain logic is deliberately built from classic interview-list patterns. Each is used where it genuinely fits — and where a heavier pattern was tempting but wrong, that's called out too.

| Pattern (Blind 75 / Grind 169) | Where it's used | File |
|---|---|---|
| **Hash map lookup / grouping** | Ingredient-ownership & substitution lookups during matching; ingredient-name/unit-alias lookup in OCR | `features/matching/domain/recipe_matcher.dart`, `features/ocr_scan/domain/bill_line_parser.dart` |
| **Greedy** | Pick the best-quality owned substitute per ingredient (no backtracking); restock hysteresis decisions | `recipe_matcher.dart`, `features/inventory/domain/services/restock_threshold_evaluator.dart` |
| **Sorting-based ranking** | Rank recipes within each match tier by score | `recipe_matcher.dart` (`rank`) |
| **Interval / rate-limiter scheduling** | Notification cooldown ("don't renotify within 24h"); M-day expiry lookahead window | `features/notifications/data/notification_coordinator.dart`, `notification_service.dart` |
| **Priority-queue / top-K** | Surface only the K most urgent soon-to-expire items as exact reminders | `notification_coordinator.dart` (`_topK`) |
| **Edit distance (DP) + token overlap** | Fuzzy-match noisy OCR text ("TOMATOE") to the ingredient dictionary | `bill_line_parser.dart` (`_levenshtein`, `_similarity`) |
| **Aggregation / summation over rows** | Sum stock across per-batch rows before the threshold decision | `features/inventory/data/inventory_repository.dart` (`_syncRestock`) |
| **Bipartite matching / backtracking** | *Considered and rejected* for recipe matching — matching is presence-based (own-it-or-a-substitute), not quantity-contended, so it collapses to independent hash lookups. Real matching would only be justified by a future "allocate one pantry across many recipes" meal-planner. | documented in `recipe_matcher.dart` header |

**Complexity of the recommendation pass:** building the inventory index is O(N); evaluating each recipe is O(ingredients × substitutes) ≈ 36 hash lookups; across 126 recipes ≈ 5–6k operations plus an O(R log R) sort — sub-millisecond on-device.

---

## Running it

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after any DB/model change
flutter run                                                 # Android or iOS device/emulator
```

Validate the dataset and run tests:

```bash
dart run tool/validate_dataset.dart
flutter analyze
flutter test
```

**Requirements:** Flutter 3.32 / Dart 3.8, Android SDK 23+ (core-library desugaring is enabled for `flutter_local_notifications`), or **iOS 15.5+** (required by the ML Kit text-recognition pod; set in the Podfile, `AppFrameworkInfo.plist`, and the Xcode deployment target). Camera/photo usage descriptions are already in `Info.plist`.

---

## Testing

37 tests cover the domain logic and repositories against an in-memory database:
- **Matcher** (`recipe_matcher_test.dart`) — tiers, substitution, empty inventory, expiry ranking, optional ingredients, expired-item handling.
- **Portion scaler** — linear/discrete/sub-linear/to-taste scaling and rounding.
- **Restock** — par-level thresholds, hysteresis, aggregation across batches, expired stock, bad-par fallback.
- **Inventory repository** — add/aggregate/resolve restock end-to-end.
- **Bill parser** — exact/fuzzy/alias matching, unit parsing, multi-line bills.
- **Seeder** — version-gating, upsert, preserving user recipes.
- **Recipe repository** — user-recipe save/delete + bundled read-only guard.

---

## Extensibility notes

Adding, say, meal planning is additive: a new `features/meal_planning/` module with its own `data/domain/presentation`, a `GoRoute` registered in `app_router.dart`, and providers that read existing repositories. No existing feature needs to change. That's also where a genuine bipartite-matching allocator would live (allocating one finite pantry across several planned recipes at once).
