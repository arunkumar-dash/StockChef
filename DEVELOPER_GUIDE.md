# StockChef — Developer Guide for a Zero-Flutter-Knowledge Engineer

> **Who this is for:** an engineer who can program but has never touched Dart or Flutter. It explains the language, the framework, every library we chose, and how the StockChef codebase is organized — enough to read, run, and modify the app confidently.
>
> Read alongside [PLAN.md](PLAN.md) (what we're building & why) and [IMPLEMENTATION.md](IMPLEMENTATION.md) (build order).
>
> **Status:** conceptual sections are written now (they don't depend on code). Sections marked _(filled during implementation)_ get real file/line references as each phase lands.

---

## 1. The 10-minute mental model

- **Dart** is the programming language (think: TypeScript/Java-ish — typed, class-based, garbage-collected, `async`/`await`).
- **Flutter** is the UI framework. It does **not** use native OS buttons; it paints every pixel itself with its own widget library, so one codebase looks/behaves the same on Android and iOS.
- **Everything is a "widget."** A screen, a button, padding, even "center this" — all widgets. You build UI by **composing** widgets into a tree, not by editing HTML/XML templates.
- **The UI is a function of state.** You don't imperatively "set the label text." You change a piece of _state_, and Flutter _rebuilds_ the affected widgets from that state. (Same idea as React.)
- **We manage state with Riverpod**, store data in a local **SQLite** database via **Drift**, and generate a lot of boilerplate code with a tool called **build_runner**.

If you know React + an ORM, the analogy is: _Flutter ≈ React, widgets ≈ components, Riverpod ≈ Redux/Recoil, Drift ≈ Prisma, build_runner ≈ a codegen step like Prisma generate._

---

## 2. Dart in 5 minutes (only what you need here)

```dart
// Variables & types
final name = 'StockChef';     // final = assigned once, type inferred (String)
int count = 3;                 // explicit type
double qty = 1.5;
bool isCore = true;
List<String> ids = ['a', 'b']; // a list (array)
Map<String, int> counts = {'salt': 2}; // a map (dict)

// Null safety: a type can't be null unless you add `?`
String? maybeName;             // can be null
name!.length;                  // `!` asserts "not null" (throws if it is)
maybeName?.length;             // `?.` = call only if not null

// Functions
int add(int a, int b) => a + b;              // arrow (single expression)
void greet({required String who, int times = 1}) { ... } // named params, `required`, defaults
greet(who: 'world');                          // called by name

// Classes
class Recipe {
  final String id;
  final String name;
  Recipe({required this.id, required this.name}); // constructor
}

// Async: Future<T> is a promise; await unwraps it
Future<int> loadCount() async {
  final rows = await db.getAll();  // await = wait without blocking the UI thread
  return rows.length;
}
```
Key gotchas for newcomers:
- **`final` vs `const`:** `final` = set once at runtime; `const` = compile-time constant (fully known before running).
- **Named parameters in `{}` with `required`** are everywhere in Flutter widget constructors.
- **`async`/`await`** never blocks the screen; long work still needs care (see §7 isolates — we mostly don't need them here because our algorithms are tiny).

---

## 3. Flutter widgets — the part that feels new

```dart
class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});
  @override
  Widget build(BuildContext context) {   // build() returns the widget tree
    return Scaffold(                       // page skeleton (app bar + body)
      appBar: AppBar(title: const Text('Hello')),
      body: Center(
        child: Column(                     // vertical stack of children
          children: const [
            Text('StockChef'),
            SizedBox(height: 8),           // spacing is a widget
          ],
        ),
      ),
    );
  }
}
```
- **`StatelessWidget`** — no internal changing state; rebuilt only when its inputs change. Most of our screens are stateless because Riverpod holds the state _outside_ the widget.
- **`StatefulWidget`** — has its own mutable state (e.g. a text field controller). We use it sparingly.
- **`build(context)`** returns a fresh widget tree every time; Flutter diffs it efficiently. Never do slow work inside `build`.
- **Composition over inheritance:** you wrap widgets in widgets (`Padding(child: Center(child: Text(...)))`) rather than subclassing.
- **Common widgets you'll see constantly:** `Scaffold`, `AppBar`, `Column`/`Row`, `Text`, `Icon`, `ListView.builder` (lazy scrolling list), `Card`, `TextField`, `ElevatedButton`, `Padding`, `SizedBox`.

---

## 4. State management with Riverpod

Problem it solves: many screens need the same data (inventory, recipes, restock list) and need to react when it changes — without passing objects manually through every widget constructor.

Core ideas:
- A **provider** is a named, globally-accessible source of a value (data, a service, or a stream).
- A widget **watches** a provider with `ref.watch(...)`; when the provider's value changes, the widget rebuilds automatically.
- **`ProviderScope`** wraps the whole app (in `main.dart`) so providers exist.

```dart
// A provider exposing the recipe list from the repository:
final recipeListProvider = FutureProvider<List<Recipe>>((ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  return repo.getAll();
});

// A screen consuming it:
class RecipeListScreen extends ConsumerWidget {      // note: ConsumerWidget
  const RecipeListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) { // extra `ref` argument
    final recipesAsync = ref.watch(recipeListProvider);
    return recipesAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data: (recipes) => ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (_, i) => Text(recipes[i].name),
      ),
    );
  }
}
```
Provider types you'll meet:
- `Provider` — a plain value/service (e.g. a repository instance).
- `FutureProvider` — an async value (loads once, exposes loading/error/data).
- `StreamProvider` — a live stream (Drift can emit query results reactively).
- `NotifierProvider` — mutable state you change via methods (e.g. the OCR wizard's step-by-step state).

Why Riverpod over alternatives (short version): it doesn't need `BuildContext`, it's compile-time safe, and it makes "combine inventory + recipes + substitutions" trivial — see PLAN.md rationale.

---

## 5. The database: Drift over SQLite

- **SQLite** is a file-based relational database that lives on the phone — no server. Perfect for "fully local."
- **Drift** is a type-safe layer over SQLite: you declare **tables** in Dart, and Drift **generates** the query code and row classes. You get real SQL (joins, `WHERE expiry < ...`), reactive `.watch()` streams, and migrations.

```dart
// A table declaration:
class InventoryItems extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text().nullable()();
  RealColumn get quantity => real()();
  DateTimeColumn get expiryDate => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
```
After you run codegen (§6), Drift creates an `InventoryItem` data class and a DAO with query methods. We keep **one row per purchase batch** (so we can track different expiry dates for the same ingredient) and aggregate them when needed — see IMPLEMENTATION.md gap A1.

Why not Hive/Isar: they're key-value / object stores with no join engine, and our core feature ("recipes that use ingredients expiring soon") is fundamentally a join. PLAN.md has the full comparison.

---

## 6. Codegen: build_runner (the #1 thing that confuses newcomers)

Several libraries (Drift, Riverpod, freezed, json_serializable) work by **generating Dart code** from your annotations. Generated files end in `.g.dart` or `.freezed.dart`. **If you change a table, a model, or a provider annotation, you must regenerate**, or the app won't compile / will use stale code.

The one command to remember:
```bash
dart run build_runner build --delete-conflicting-outputs
```
Or watch mode while developing:
```bash
dart run build_runner watch --delete-conflicting-outputs
```
We **commit** the generated files in this project so the repo builds immediately after clone (IMPLEMENTATION.md A8). If you ever see "method not found" errors on a class you just changed — regenerate first before debugging anything else.

---

## 7. Threads, async, and why our algorithms are simple

- Flutter runs your Dart on a single **UI isolate**. Long synchronous work freezes the screen.
- **`async`/`await`** handles waiting (DB, camera, files) without freezing.
- Heavy CPU work would need a separate **isolate** (Dart's version of a worker thread). **We deliberately don't need isolates** — our matching (~6,500 operations) and OCR fuzzy-match (~1.4M ops) are far too small to block the UI (see PLAN.md complexity analysis). This is by design, not luck.

---

## 8. The libraries we use, one line each

| Library | What it does for us |
|---|---|
| `flutter_riverpod` / `riverpod_annotation` | App state & dependency wiring (§4) |
| `drift` / `sqlite3_flutter_libs` | Local relational DB (§5) |
| `freezed` / `json_serializable` | Immutable data classes + JSON parsing for the seed dataset |
| `go_router` | Screen navigation + deep-linking a tapped notification to a screen |
| `flutter_local_notifications` / `timezone` / `flutter_timezone` | Scheduling reminders locally, no server |
| `google_mlkit_text_recognition` | On-device OCR of grocery bills (offline) |
| `image_picker` / `permission_handler` | Camera capture + runtime permissions |
| `uuid` | Generating ids for user-created rows |
| `intl` | Date/number formatting |
| `mocktail` | Test doubles in unit tests |

---

## 9. How the codebase is organized (feature-first)

```
lib/
  core/     → shared plumbing: theme, routing, database, seeding, utils, shared widgets
  features/ → one folder per feature (recipes, inventory, restock, matching, ocr_scan, notifications, settings)
```
Inside each feature, three layers:
- **`data/`** — talks to the database (DAOs, repository implementations).
- **`domain/`** — pure logic & interfaces (e.g. the portion scaler, the matching algorithm, repository contracts). No Flutter imports here.
- **`presentation/`** — screens, widgets, and the Riverpod providers that feed them.

**Rule:** a feature may use another feature's `domain/` interface or `presentation/providers`, but never reach into its `data/` internals. This is what keeps the app modular and extensible (adding, say, meal-planning later touches only a new `features/meal_planning/` folder).

---

## 10. How to run it

```bash
flutter pub get                                        # install dependencies
dart run build_runner build --delete-conflicting-outputs  # generate code (after any model change)
flutter run                                            # launch on the connected device/emulator
flutter analyze                                        # static analysis (lint)
flutter test                                           # run the test suite
```
First launch seeds the ~150-recipe dataset into SQLite (one-time). Subsequent launches skip seeding unless the dataset version changed.

---

## 11. Where each requirement lives

| Requirement | Implemented in |
|---|---|
| Bundled recipe dataset (JSON) | `assets/data/*.json`, parsed by `lib/core/seeding/seed_dtos.dart`, loaded by `lib/core/seeding/recipe_seeder.dart` |
| Ingredients + substitution map | `assets/data/ingredients.json`, `ingredient_substitutions.json`; tables in `lib/core/database/tables/reference_tables.dart` |
| Equipment + substitution map | `assets/data/equipment.json`, `equipment_substitutions.json` |
| Steps with gas level / parallel / detail | `RecipeSteps` table (`recipe_tables.dart`), rendered by `features/recipes/presentation/widgets/step_timeline.dart` |
| Inventory with qty/weight, shelf-life, dates | `features/inventory/` (`InventoryItems` table, `add_edit_inventory_screen.dart`) |
| Restock at <threshold + reminders | `features/inventory/domain/services/restock_threshold_evaluator.dart`, `features/notifications/` |
| Expiry-prioritized recommendations | `features/matching/domain/recipe_matcher.dart` |
| Substitutions in matching | `recipe_matcher.dart` (ingredient), `features/recipes/.../equipment_footnote.dart` (equipment) |
| Portion scaling | `features/recipes/domain/services/portion_scaler.dart` |
| Equipment substitution footnote | `features/recipes/presentation/widgets/equipment_footnote.dart` |
| OCR bill scanning | `features/ocr_scan/` (`text_recognition_service.dart`, `bill_line_parser.dart`, `ocr_scan_controller.dart`) |
| Idle soon-to-expire reminders | `features/notifications/data/notification_coordinator.dart` |
| Add custom recipes | `features/recipes/presentation/screens/add_recipe_screen.dart`, `RecipeRepository.saveUserRecipe` |
| Modern UI | Material 3 in `lib/core/theme/app_theme.dart` |
| Extensible modular architecture | feature-first `lib/features/*`, shared `lib/core/*` |

## 12. Reading the algorithms

Each domain algorithm is a pure function (no Flutter, no I/O) so you can read and test it in isolation:

- **Recipe matching & ranking** — `features/matching/domain/recipe_matcher.dart`. Takes a `MatchingInput` (recipes, owned-ingredient expiry map, substitution map) and returns tiered, scored `RecipeMatchResult`s. Tests: `test/features/matching/recipe_matcher_test.dart`.
- **Portion scaling** — `features/recipes/domain/services/portion_scaler.dart`. Unit-class dispatch (linear/count/sub-linear/fixed). Tests: `test/features/recipes/portion_scaler_test.dart`.
- **Restock threshold** — `features/inventory/domain/services/restock_threshold_evaluator.dart`. Par-level + hysteresis. Tests: `test/features/inventory/restock_threshold_evaluator_test.dart`.
- **OCR fuzzy matching** — `features/ocr_scan/domain/bill_line_parser.dart`. Levenshtein + token overlap against the ingredient dictionary. Tests: `test/features/ocr_scan/bill_line_parser_test.dart`.

Cross-reference these with the Blind 75 / Grind 169 mapping table in [README.md](README.md).
