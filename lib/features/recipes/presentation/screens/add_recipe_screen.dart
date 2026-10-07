import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../inventory/presentation/inventory_providers.dart';
import '../../data/recipe_repository.dart';
import '../../domain/services/portion_scaler.dart' show MeasurementUnitLabel;
import '../recipe_labels.dart';
import '../recipe_providers.dart';

/// Lets a user author their own recipe. Saved with isUserCreated = true so it
/// participates in browsing and matching exactly like bundled recipes.
class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _calories = TextEditingController();
  CuisineRegion _cuisine = CuisineRegion.tamil;
  MealType _mealType = MealType.lunch;
  bool _veg = true;
  final _ingredients = <DraftRecipeIngredient>[];
  final _steps = <DraftRecipeStep>[DraftRecipeStep(instruction: '')];

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _calories.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Recipe name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<CuisineRegion>(
                    value: _cuisine,
                    decoration: const InputDecoration(labelText: 'Cuisine'),
                    items: [
                      for (final c in CuisineRegion.values)
                        DropdownMenuItem(value: c, child: Text(c.label)),
                    ],
                    onChanged: (v) => setState(() => _cuisine = v ?? _cuisine),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<MealType>(
                    value: _mealType,
                    decoration: const InputDecoration(labelText: 'Meal'),
                    items: [
                      for (final m in MealType.values)
                        DropdownMenuItem(value: m, child: Text(m.label)),
                    ],
                    onChanged: (v) => setState(() => _mealType = v ?? _mealType),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Vegetarian'),
              value: _veg,
              onChanged: (v) => setState(() => _veg = v),
            ),
            const Divider(),
            _SectionTitle('Ingredients (per serving)'),
            ingredientsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (all) => Column(
                children: [
                  for (var i = 0; i < _ingredients.length; i++)
                    _IngredientRow(
                      all: all,
                      draft: _ingredients[i],
                      onChanged: () => setState(() {}),
                      onRemove: () => setState(() => _ingredients.removeAt(i)),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _ingredients.add(
                            DraftRecipeIngredient(
                              ingredientId: all.isNotEmpty ? all.first.id : '',
                              quantity: 1,
                              unit: MeasurementUnit.grams,
                            ),
                          )),
                      icon: const Icon(Icons.add),
                      label: const Text('Add ingredient'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            _SectionTitle('Steps'),
            for (var i = 0; i < _steps.length; i++)
              _StepRow(
                index: i + 1,
                draft: _steps[i],
                onChanged: () => setState(() {}),
                onRemove: _steps.length > 1
                    ? () => setState(() => _steps.removeAt(i))
                    : null,
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () =>
                    setState(() => _steps.add(DraftRecipeStep(instruction: ''))),
                icon: const Icon(Icons.add),
                label: const Text('Add step'),
              ),
            ),
            const Divider(),
            TextFormField(
              controller: _calories,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Calories per serving (optional)'),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save recipe'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final validIngredients =
        _ingredients.where((i) => i.ingredientId.isNotEmpty).toList();
    final validSteps =
        _steps.where((s) => s.instruction.trim().isNotEmpty).toList();
    if (validIngredients.isEmpty || validSteps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Add at least one ingredient and one step.'),
      ));
      return;
    }

    await ref.read(recipeRepositoryProvider).saveUserRecipe(
          name: _name.text.trim(),
          description: _description.text.trim().isEmpty ? null : _description.text.trim(),
          cuisine: _cuisine,
          mealType: _mealType,
          isVegetarian: _veg,
          ingredients: validIngredients,
          steps: validSteps,
          calories: double.tryParse(_calories.text),
        );
    if (mounted) Navigator.of(context).pop();
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.all,
    required this.draft,
    required this.onChanged,
    required this.onRemove,
  });
  final List<Ingredient> all;
  final DraftRecipeIngredient draft;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final current = all.where((i) => i.id == draft.ingredientId).firstOrNull;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              value: current?.id,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Ingredient', isDense: true),
              items: [
                for (final i in all)
                  DropdownMenuItem(value: i.id, child: Text(i.name, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) {
                if (v != null) {
                  draft.ingredientId = v;
                  final ing = all.where((i) => i.id == v).firstOrNull;
                  if (ing != null) draft.unit = ing.defaultUnit;
                  onChanged();
                }
              },
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: draft.quantity == draft.quantity.roundToDouble()
                  ? draft.quantity.toStringAsFixed(0)
                  : '${draft.quantity}',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Qty', isDense: true),
              onChanged: (v) => draft.quantity = double.tryParse(v) ?? draft.quantity,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<MeasurementUnit>(
              value: draft.unit,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Unit', isDense: true),
              items: [
                for (final u in MeasurementUnit.values)
                  DropdownMenuItem(value: u, child: Text(u.label)),
              ],
              onChanged: (v) {
                if (v != null) {
                  draft.unit = v;
                  onChanged();
                }
              },
            ),
          ),
          IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onRemove),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.draft,
    required this.onChanged,
    this.onRemove,
  });
  final int index;
  final DraftRecipeStep draft;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CircleAvatar(radius: 12, child: Text('$index', style: const TextStyle(fontSize: 11))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: draft.instruction,
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Step', isDense: true),
              onChanged: (v) => draft.instruction = v,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 96,
            child: DropdownButtonFormField<GasFlameLevel?>(
              value: draft.flame,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Flame', isDense: true),
              items: const [
                DropdownMenuItem(value: null, child: Text('—')),
                DropdownMenuItem(value: GasFlameLevel.high, child: Text('High')),
                DropdownMenuItem(value: GasFlameLevel.medium, child: Text('Med')),
                DropdownMenuItem(value: GasFlameLevel.low, child: Text('Low')),
                DropdownMenuItem(value: GasFlameLevel.none, child: Text('None')),
              ],
              onChanged: (v) {
                draft.flame = v;
                onChanged();
              },
            ),
          ),
          if (onRemove != null)
            IconButton(icon: const Icon(Icons.close, size: 18), onPressed: onRemove)
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
      );
}
