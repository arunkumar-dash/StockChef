# StockChef — In-Depth Implementation Plan

> Companion to [PLAN.md](PLAN.md) (architecture) and [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) (zero-Flutter-knowledge walkthrough).
> This file is the execution playbook: exact order, files, commands, platform gotchas, and acceptance criteria per phase, plus the gap analysis that revised several PLAN.md decisions.

---

## Part A — Gap Analysis & Revised Decisions

Re-examining the plan before writing code surfaced eight issues. Decisions changed where marked **REVISED**.

### A1. Restock threshold: "% of what?" — **REVISED**
**Gap:** PLAN.md computed `percent = quantityOnHand / originalPurchaseQuantity`. This breaks with per-batch inventory. Example: buy 1 kg rice (batch A), consume to 50 g → 5% of batch A → restock triggers. Then buy another 1 kg (batch B). Total on hand is now 1.05 kg but batch A is still "5%". Per-batch percentage is meaningless for "should I rebuy this ingredient."

**Decision:** Threshold is evaluated on the **aggregate quantity of an ingredient** against a per-ingredient **par level** (reorder point), the standard inventory-management model.
- Add `IngredientStockPolicy` table: `ingredientId PK, parQuantity, unit, thresholdPercent (default 10), isCore`.
- `restockNeeded(ingredientId)` = `SUM(quantityOnHand across non-expired batches) < thresholdPercent/100 * parQuantity`.
- `parQuantity` defaults from a seeded sensible value per core ingredient (e.g. rice 2 kg, salt 1 kg) and is user-editable.
- Drop `originalPurchaseQuantity` from the threshold path (keep it optional on `InventoryItems` only as informational "how much did this batch start at").

This cleanly separates the two concerns that were fighting: **per-batch rows** (needed for FIFO/expiry) vs **aggregate-vs-par** (needed for restock).

### A2. iOS pending-notification cap — **REVISED**
**Gap:** iOS silently caps pending local notifications at **64**. PLAN.md's "schedule one expiry notification per inventory item at write time" overflows immediately with 150 items — the oldest/newest get dropped unpredictably.

**Decision:** Do **not** schedule one notification per item. Instead:
- Schedule a small fixed set of **recurring daily digest** notifications (e.g. one at 09:00) via `zonedSchedule` + `matchDateTimeComponents: DateTimeComponents.time`.
- The digest content ("3 items expire in 2 days; 2 core ingredients low") is computed **on app resume** and also cached so the notification body can be refreshed each time the app runs.
- Optionally schedule per-item exact notifications only for the **top-K most urgent** (K ≤ 20), well under the 64 cap, and cancel/reschedule them on the app-resume recompute.

This keeps us within platform limits and still delivers timely reminders without a background daemon.

### A3. Matching is presence-based, not quantity-sufficient — **CONFIRMED as v1 scope, documented**
**Gap:** Matching checks "do you own ingredient X at all," not "do you have ≥ the required amount." A user with 1 g of salt "matches" a recipe needing 50 g.

**Decision:** Keep presence-based for v1 (it's why we don't need bipartite matching — see PLAN.md Algorithm 1). Add an explicit `sufficientQuantity` boolean per matched ingredient (cheap: compare aggregated on-hand vs scaled requirement) surfaced as a soft UI hint ("low: salt"), **not** as a match gate. Full quantity-contended allocation across multiple recipes remains the documented bipartite-matching future extension.

### A4. Ingredient/equipment ID consistency across authoring — **REVISED (process)**
**Gap:** PLAN.md said "derive the ingredient master list from the recipes." If recipes are authored in parallel batches, agents will invent divergent ids for the same thing (`tomato` / `tomatoes` / `tamatar`), and the substitution maps won't line up.

**Decision:** Reverse the order. Author **canonical dictionaries first**:
1. `assets/data/ingredients.json` — canonical `{id, name, aliases[], category, defaultUnit}` for ~200–300 Indian cooking ingredients.
2. `assets/data/equipment.json` — canonical `{id, name, aliases[]}`.
Then all recipe-authoring references **only existing ids**; a new ingredient must be added to the dictionary first. A validation script rejects any recipe referencing an unknown id. The two substitution maps are validated against this same dictionary.

### A5. Recipe content is a large, quality-sensitive effort — **flagged**
150 authentic recipes with ordered steps, gas levels, parallel-step grouping, and nutrition facts is the single biggest and riskiest deliverable. Nutrition values will be **approximate estimates** (no nutrition API), and must be labeled as such in-app. Mitigation: fixed JSON schema + a validation script (Part C) run after every authoring batch; author in slices of 15–20 by cuisine; keep a running id registry.

### A6. ML Kit offline model bundling — **flagged (build config)**
`google_mlkit_text_recognition` on Android can use either the **bundled** model (ships in APK, works offline immediately) or the Play-Services model (downloaded on first use — needs network once). For a "fully offline" guarantee, use the bundled dependency and verify no first-run network fetch. iOS bundles via CocoaPods automatically. Confirmed as a Phase 7 acceptance check.

### A7. Cold-start notification deep-linking — **flagged**
Tapping a notification when the app is **terminated** (cold start) is handled differently from when it's running. Must read `getNotificationAppLaunchDetails()` at startup and route accordingly via `go_router`, in addition to the foreground/background stream listener.

### A8. Two code generators (freezed + drift) — **flagged (workflow)**
`build_runner` drives both `freezed`/`json_serializable` and `drift_dev`. They coexist but every schema/model change requires re-running codegen. Standardize on `dart run build_runner build --delete-conflicting-outputs` and document it prominently (it's the #1 beginner stumbling block). Commit generated files? No — add `*.g.dart`/`*.freezed.dart` to `.gitignore` is optional; recommend **committing them** for a solo/教学 project so the repo builds without a codegen step first. Decision: commit generated files.

### A9. baseServings simplification — **minor**
Recipes store "quantity for one person," so `baseServings = 1` universally. Portion scaling is just `qtyPerPerson * desiredServings` before rounding — no division needed. Keep `baseServings` column for future flexibility but default it to 1.

---

## Part B — Phase-by-Phase Implementation

Each phase lists: **Goal · Prereqs · Steps · Key files · Pitfalls · Acceptance · Dev-guide additions.**
Do phases in order; each ends in a compiling, runnable app.

### Phase 0 — Environment & tooling verification
**Goal:** Confirm the machine can build/run Flutter before writing anything.
**Steps:**
1. `flutter --version` (expect 3.32.x / Dart 3.8.x per PLAN.md), `flutter doctor -v` — resolve any red items for Android toolchain + at least one iOS or Android device/emulator.
2. Confirm an Android emulator boots (`flutter emulators`, `flutter emulators --launch <id>`) and/or a physical device is authorized.
**Acceptance:** `flutter doctor` shows no blocking errors for the Android (and iOS if on macOS with Xcode) toolchains.
**Pitfalls:** Android licenses (`flutter doctor --android-licenses`); CocoaPods install for iOS.
**Dev-guide:** what Flutter/Dart/the SDK are; what `flutter doctor` checks.

### Phase 1 — Project scaffold, theme, navigation shell
**Goal:** A running app with Material 3 theming and a bottom-nav shell (empty screens).
**Steps:**
1. `flutter create --org com.stockchef --platforms=android,ios stockchef` at the project root (or in-place; adjust so the code lands under `/Users/arun-13757/Documents/StockChef`).
2. Add dependencies (use `flutter pub add`, then pin the resolved versions — do **not** hand-invent version numbers):
   - runtime: `flutter_riverpod riverpod_annotation drift sqlite3_flutter_libs path_provider path flutter_local_notifications timezone flutter_timezone google_mlkit_text_recognition image_picker permission_handler go_router uuid intl`
   - dev: `build_runner riverpod_generator drift_dev freezed json_serializable freezed_annotation json_annotation flutter_lints mocktail`
3. Create the folder skeleton from PLAN.md under `lib/`. Add empty `assets/data/` and register `assets/` in `pubspec.yaml`.
4. `lib/core/theme/app_theme.dart`: `ColorScheme.fromSeed` light + dark, `useMaterial3: true`.
5. `lib/core/routing/app_router.dart`: `GoRouter` with a `StatefulShellRoute.indexedStack` bottom nav → tabs: Recipes, Inventory, Restock, Scan, Settings (placeholder screens).
6. `lib/app.dart`: `MaterialApp.router` wrapped in `ProviderScope`. `main.dart`: `runApp(const ProviderScope(child: StockChefApp()))`.
**Key files:** `main.dart`, `app.dart`, `core/theme/app_theme.dart`, `core/routing/app_router.dart`, `pubspec.yaml`.
**Pitfalls:** `assets:` indentation in `pubspec.yaml`; each feature exposing a `GoRoute` list to merge (keep routing modular from day one).
**Acceptance:** `flutter run` shows a themed app; tabs switch; light/dark follows system.
**Dev-guide:** widgets vs. the widget tree; `StatelessWidget` vs `StatefulWidget`; what `ProviderScope`/`MaterialApp.router` do; `pubspec.yaml` = the manifest.

### Phase 2 — Database, models, seeding pipeline
**Goal:** All Drift tables defined, `AppDatabase` opens, freezed seed DTOs parse JSON, `RecipeSeeder` populates on first run.
**Steps:**
1. Define enums in `core/database/converters/enum_converters.dart` with Drift `TypeConverter`s (store enums as text/int).
2. Create every table file under `core/database/tables/` per PLAN.md **plus the revised additions**: `ingredient_stock_policy_table.dart` (A1), keep `cook_events`, `notification_debounce`, drop `originalPurchaseQuantity` from threshold logic (leave column optional/informational).
3. `core/database/app_database.dart`: `@DriftDatabase(tables: [...])`, `schemaVersion = 1`, open via `NativeDatabase` in a `path_provider` app-documents path; use `LazyDatabase`.
4. `core/seeding/recipe_seed_dto.dart`: freezed + json_serializable DTOs mirroring `recipes.json`, `ingredients.json`, `equipment.json`, and the two substitution maps.
5. `core/seeding/recipe_seeder.dart`: read `SeedMetadata['dataset_version']`; if stale, in **one transaction**: load canonical ingredients/equipment → upsert `Ingredients`/`Equipment` + `IngredientStockPolicy` defaults → parse recipes → upsert only `isUserCreated=false` rows → load substitution maps. Wrap in `db.transaction(() async {...})` (thousands of inserts must be batched, not per-row).
6. Run codegen: `dart run build_runner build --delete-conflicting-outputs`. Commit generated `*.g.dart`/`*.drift.dart`/`*.freezed.dart` (A8).
7. Call `RecipeSeeder.seed(db)` once at startup (after DB open, before first UI read) — a Riverpod `FutureProvider` gates the UI on seed completion with a splash/loading state.
**Key files:** all of `core/database/**`, `core/seeding/**`.
**Pitfalls:** codegen must run after *every* table/DTO change; Drift `TypeConverter` for enums; not wrapping seeding in a transaction (slow); reading the DB before seeding finishes (race).
**Acceptance:** Unit test with `NativeDatabase.memory()` seeds a small fixture and asserts row counts; app launches, seeds, and a debug screen shows recipe count.
**Dev-guide:** what an ORM/Drift is; tables → generated Dart classes; async/`Future`/`await`; what codegen/`build_runner` does and why.

### Phase 3 — Canonical dictionaries + recipe dataset + browsing UI
**Goal:** Real data seeded; browse and view recipes with scaling, flame levels, parallel-step grouping, equipment footnotes.
**Steps:**
1. **Content (A4 order):** author `ingredients.json` + `equipment.json` canonical dictionaries first. Then `recipes.json` in cuisine slices (~60 Tamil, ~60 Odia, ~30 other) referencing only existing ids. Then the two substitution maps. Run the validation script (Part C) after each batch.
2. `features/recipes/` data layer: `RecipeDao` (joined reads: recipe + ingredients + steps + equipment), `RecipeRepository(Impl)`, `recipe_providers.dart`.
3. `RecipeListScreen` (search, cuisine filter), `RecipeDetailScreen`.
4. `PortionScaler` (Algorithm 2) + `ServingSizeSelector` — live re-scale on serving change.
5. `StepTimeline` widget: group steps by `stepGroupId` (parallel), render flame-level icons (high/med/low), show prep detail.
6. `EquipmentFootnote` widget (Algorithm 6): informational substitutes.
**Key files:** `features/recipes/**`, `features/recipes/domain/services/portion_scaler.dart`.
**Pitfalls:** N+1 queries — fetch a recipe's children with joins/`.get()` batched, not per-ingredient; rounding rules (eggs whole, pinch sub-linear).
**Acceptance:** Browse ~150 recipes; open one, change servings 1→4 and see sensible rounding; parallel steps visually grouped; flame levels shown; equipment footnote appears.
**Dev-guide:** `ListView.builder`; `ConsumerWidget`/`ref.watch`; how a provider feeds a screen; stateless rebuild model.

### Phase 4 — Inventory CRUD + stock policy + expiry UI
**Goal:** Add/edit/delete inventory batches with purchase/expiry/shelf-life; expiry visualized; restock-threshold hook fires on writes.
**Steps:**
1. `InventoryDao`/`InventoryRepository`: per-batch rows; aggregate-by-ingredient query for policy checks (A1).
2. `AddEditInventoryItemScreen`: ingredient autocomplete against `Ingredients`, quantity+unit, purchase date, shelf-life (auto-computes expiry) or explicit expiry.
3. `InventoryListScreen` grouped by ingredient, showing total on-hand + soonest expiry; `ExpiryProgressBar` / `expiry_badge`.
4. `RestockThresholdEvaluator` (Algorithm 3, revised A1): on every write, recompute aggregate vs `parQuantity*threshold%`; upsert/resolve `RestockListItems` with hysteresis.
**Key files:** `features/inventory/**`, `restock_threshold_evaluator.dart`, `ingredient_stock_policy` handling.
**Pitfalls:** timezone/date-only handling for expiry (store dates at local midnight); hysteresis to avoid restock flapping; expiry in the past = valid data (bad-date guard).
**Acceptance:** Add item, reduce quantity below par-threshold → appears on restock list; raise above threshold+hysteresis → resolves; expired batch flagged distinctly.
**Dev-guide:** forms & `TextEditingController`; date pickers; how a repository write triggers derived state.

### Phase 5 — Restock list + notifications
**Goal:** Restock screen; daily digest notifications; expiry/idle reminders within platform limits; app-resume recompute; deep-linking.
**Steps:**
1. `RestockListScreen` (add/edit/delete/manual add, mark resolved), `restock_providers.dart`.
2. `NotificationService`: init `flutter_local_notifications`, timezone setup (`flutter_timezone`+`timezone`), request permissions (iOS + Android 13+ `POST_NOTIFICATIONS`).
3. `RestockNotificationScheduler` (Algorithm 4): daily digest via `zonedSchedule` + `matchDateTimeComponents`; debounce via `NotificationDebounce`.
4. `ExpiryNotificationScheduler` (Algorithm 5, revised A2): top-K urgent per-item exact notifications (K≤20) + the daily digest; heap-ranked.
5. App-root `AppLifecycleListener`: on resume → `recomputeLowStockAndExpiring()` (rebuild restock list, refresh badges, reschedule).
6. Deep-linking (A7): foreground stream + cold-start `getNotificationAppLaunchDetails()` → route via `go_router`.
**Key files:** `features/notifications/**`, `features/restock/**`.
**Pitfalls:** iOS 64-notification cap (A2); Android 13 runtime notification permission; exact-alarm permission on Android 12+ if using exact scheduling; timezone init before scheduling; cold-start routing.
**Acceptance:** Force an item near expiry → digest fires next scheduled time / appears on resume; tapping it deep-links to the right screen from both warm and cold start; low core ingredient shows in digest without re-spamming within cooldown.
**Dev-guide:** app lifecycle (resume/pause); what a notification channel/permission is; why no true background code runs.

### Phase 6 — Recipe matching & recommendations
**Goal:** Rank recipes by inventory + expiry + substitutions; recommendations screen with tiers.
**Steps:**
1. `RecipeMatchingService` interface (PLAN.md §4) + impl (Algorithm 1): build owned-set/aggregate index, per-recipe score, tiering, `sufficientQuantity` soft hint (A3), sort per tier.
2. `matching_providers.dart` depending on recipe/inventory/substitution providers.
3. `RecommendationsScreen`: tier sections (Makeable Now / With Substitution / With Many Subs / Partial), each card shows matched/substituted/missing + "uses expiring: X".
**Key files:** `features/matching/**`.
**Pitfalls:** rebuild index once per pass, not per recipe; normalize expiry-urgency so it can't dominate completeness pathologically; empty-inventory → all PARTIAL, never empty screen.
**Acceptance:** Unit tests for the six edge cases (empty inventory, all-substitutable-none-owned, zero matchable, expired/bad date, duplicate rows, expiry-priority ordering); UI shows expiring-ingredient recipes first within a tier.
**Dev-guide:** how services compose providers; pure-function domain logic vs UI.

### Phase 7 — OCR grocery-bill scan flow
**Goal:** Photograph bill → recognize text → user comma-delimits → editable draft → commit to inventory.
**Steps:**
1. `TextRecognitionService` wrapping `google_mlkit_text_recognition` (bundled model, A6); `image_picker` camera capture + `permission_handler`.
2. `OcrScanController` (Riverpod `Notifier`) state machine: Idle→Capturing→Recognizing→Delimiting→DraftReady→Committing→Error.
3. Screens: `ScanCaptureScreen`, `DelimiterScreen` (editable lines, user inserts commas, live re-parse), `DraftReviewScreen` (add/edit/delete rows, ingredient autocomplete).
4. `BillLineParser` (Algorithm 7): comma split → qty/unit regex + alias map → fuzzy match (token overlap + Levenshtein) → confidence buckets.
5. Commit: create/update `InventoryItems` (prompt for expiry/shelf-life where unknown), resolve matching restock items.
**Key files:** `features/ocr_scan/**`.
**Pitfalls:** verify **no network** on first OCR (offline guarantee, A6); camera permission denial path; garbled OCR → mark manual, never crash; duplicate receipt lines flagged not silently merged.
**Acceptance:** Real photographed bill → recognized → comma-delimit → draft with fuzzy-matched names + confidence → edit/delete a row → commit → items appear in inventory; airplane-mode run still works.
**Dev-guide:** what a state-machine notifier is; permissions; async image pipeline.

### Phase 8 — Custom recipes + polish
**Goal:** Users author recipes into the same tables; bundled recipes read-only; UI/accessibility polish; notification settings.
**Steps:**
1. `AddEditRecipeScreen`: dynamic ingredient/step lists, flame-level pickers, `stepGroupId` assignment, nutrition entry; writes `isUserCreated=true`.
2. Repository enforces read-only on `isUserCreated=false` (reject mutations).
3. Confirm custom recipes flow into matching automatically (no special-casing).
4. `NotificationSettingsScreen` (digest time, cooldown, lead days), theme toggle; empty states, loading states, accessibility labels, large-text/contrast pass.
**Key files:** `features/recipes/presentation/screens/add_edit_recipe_screen.dart`, `features/settings/**`.
**Pitfalls:** validating user recipe input (ingredient ids exist / allow free-text custom name); not letting bundled edits slip through the repo guard.
**Acceptance:** Create a custom recipe → appears in browse + recommendations like a bundled one; editing a bundled recipe is blocked; settings changes take effect.
**Dev-guide:** dynamic form lists; the read-only guard pattern.

### Phase 9 — Tests, README, developer guide finalization
**Goal:** Test suite green; documentation complete.
**Steps:**
1. Unit: the 6 domain algorithms against fixtures/edge cases; repositories against `NativeDatabase.memory()`.
2. Widget: inventory list, recipe detail scaling, OCR draft add/edit/delete.
3. Integration: seeding produces ~150 recipes with ~60/60/30 split; OCR pipeline with fixture recognized-text strings.
4. Write `README.md` per PLAN.md §8 outline incl. the **populated Blind75/Grind169 table with real file references**.
5. Finalize `DEVELOPER_GUIDE.md`: replace conceptual placeholders with actual file walkthroughs written during phases 1–8.
**Acceptance:** `flutter analyze` clean; `flutter test` green; README + dev guide reviewed end-to-end; manual verification checklist (PLAN.md Verification) passes on a device.

---

## Part C — Dataset validation script (used from Phase 3 on)
A small Dart script (`tool/validate_dataset.dart`, run with `dart run`) that fails CI/local build if:
- any recipe references an ingredient/equipment id absent from the canonical dictionaries;
- any substitution-map key/value id is absent from the dictionaries;
- required fields missing (steps, quantities, units, at least one flame level where a stove step exists);
- duplicate recipe/ingredient ids;
- cuisine distribution outside expected bounds (warns if not ~60/60/30).
Run it after every authoring batch (A5) — this is the guardrail that keeps 150 hand-authored recipes internally consistent.

---

## Part D — Cross-cutting pitfalls checklist (keep visible during all phases)
- Re-run `dart run build_runner build --delete-conflicting-outputs` after any table/DTO/provider-annotation change.
- Every DB bulk operation in a transaction.
- Dates stored at local midnight; guard past/invalid expiry everywhere they're read.
- iOS ≤64 pending notifications; Android 13+ notification + Android 12+ exact-alarm permissions.
- Verify OCR runs with no network (bundled ML Kit model).
- Cold-start vs warm notification routing both handled.
- Presence-based matching is a documented v1 limitation; quantity-sufficiency is a soft hint only.
- Commit generated code so the repo builds without a codegen step first.
