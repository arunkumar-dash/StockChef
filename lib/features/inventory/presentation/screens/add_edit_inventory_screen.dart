import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../kitchens/presentation/kitchen_providers.dart';
import '../../../recipes/domain/services/portion_scaler.dart' show MeasurementUnitLabel;
import '../inventory_providers.dart';

/// Add a new inventory batch, or edit an existing one when [batchId] is given.
class AddEditInventoryScreen extends ConsumerStatefulWidget {
  const AddEditInventoryScreen({super.key, this.batchId});
  final String? batchId;

  @override
  ConsumerState<AddEditInventoryScreen> createState() =>
      _AddEditInventoryScreenState();
}

class _AddEditInventoryScreenState
    extends ConsumerState<AddEditInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  Ingredient? _ingredient;
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  MeasurementUnit _unit = MeasurementUnit.grams;
  DateTime _purchaseDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));
  bool _loadedExisting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    if (_loadedExisting || widget.batchId == null) return;
    _loadedExisting = true;
    final db = ref.read(inventoryRepositoryProvider);
    final ingredients = await db.getAllIngredients();
    final row = await db.getBatch(widget.batchId!);
    if (row == null || !mounted) return;
    setState(() {
      _ingredient = ingredients
          .where((i) => i.id == row.ingredientId)
          .cast<Ingredient?>()
          .firstOrNull;
      _nameController.text = _ingredient?.name ?? row.customName ?? '';
      _quantityController.text = _fmt(row.quantity);
      _unit = row.unit;
      _purchaseDate = row.purchaseDate;
      _expiryDate = row.expiryDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadExisting();
    final ingredientsAsync = ref.watch(ingredientsProvider);
    final isEdit = widget.batchId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit item' : 'Add item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Ingredient autocomplete (falls back to free-text custom name).
            ingredientsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
              data: (ingredients) => Autocomplete<Ingredient>(
                initialValue: TextEditingValue(text: _nameController.text),
                displayStringForOption: (i) => i.name,
                optionsBuilder: (value) {
                  final q = value.text.toLowerCase();
                  if (q.isEmpty) return ingredients.take(30);
                  return ingredients.where((i) =>
                      i.name.toLowerCase().contains(q) ||
                      i.id.contains(q));
                },
                onSelected: (i) {
                  setState(() {
                    _ingredient = i;
                    _nameController.text = i.name;
                    _unit = i.defaultUnit;
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, _) {
                  controller.text = _nameController.text;
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Ingredient',
                      hintText: 'Search or type a custom name',
                    ),
                    onChanged: (v) {
                      _nameController.text = v;
                      _ingredient = null;
                    },
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    validator: (v) {
                      final d = double.tryParse(v ?? '');
                      if (d == null || d <= 0) return 'Enter a number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<MeasurementUnit>(
                    value: _unit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: [
                      for (final u in MeasurementUnit.values)
                        DropdownMenuItem(value: u, child: Text(u.label)),
                    ],
                    onChanged: (u) => setState(() => _unit = u ?? _unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DateField(
              label: 'Purchase date',
              date: _purchaseDate,
              onPick: (d) => setState(() {
                _purchaseDate = d;
                if (_expiryDate.isBefore(d)) {
                  _expiryDate = d.add(const Duration(days: 7));
                }
              }),
            ),
            const SizedBox(height: 12),
            _ShelfLifeShortcuts(
              onPick: (days) => setState(
                () => _expiryDate = _purchaseDate.add(Duration(days: days)),
              ),
            ),
            const SizedBox(height: 12),
            _DateField(
              label: 'Expiry date',
              date: _expiryDate,
              onPick: (d) => setState(() => _expiryDate = d),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(isEdit ? 'Save changes' : 'Add to inventory'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final qty = double.parse(_quantityController.text);
    final shelfLife = _expiryDate.difference(_purchaseDate).inDays;
    final now = DateTime.now();

    final companion = InventoryItemsCompanion(
      id: Value(widget.batchId ?? _uuid.v4()),
      kitchenId: Value(ref.read(activeKitchenProvider)),
      ingredientId: Value(_ingredient?.id),
      customName: Value(_ingredient == null ? _nameController.text.trim() : null),
      quantity: Value(qty),
      unit: Value(_unit),
      purchaseDate: Value(_purchaseDate),
      shelfLifeDays: Value(shelfLife),
      expiryDate: Value(_expiryDate),
      originalQuantity: Value(qty),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await ref.read(inventoryRepositoryProvider).upsertBatch(companion);
    if (mounted) Navigator.of(context).pop();
  }

  String _fmt(double q) => q == q.roundToDouble() ? q.toStringAsFixed(0) : '$q';
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onPick});
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onPick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
        ),
      ),
    );
  }
}

class _ShelfLifeShortcuts extends StatelessWidget {
  const _ShelfLifeShortcuts({required this.onPick});
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    const options = {'3d': 3, '1w': 7, '2w': 14, '1m': 30, '3m': 90, '6m': 180};
    return Wrap(
      spacing: 8,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text('Shelf life:'),
        ),
        for (final e in options.entries)
          ActionChip(label: Text(e.key), onPressed: () => onPick(e.value)),
      ],
    );
  }
}
