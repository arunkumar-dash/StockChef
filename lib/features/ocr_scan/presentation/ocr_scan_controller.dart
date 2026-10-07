import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/database/enums.dart';
import '../data/text_recognition_service.dart';
import '../domain/bill_line_parser.dart';

/// State machine for the scan flow (PLAN.md §5).
sealed class OcrState {
  const OcrState();
}

class OcrIdle extends OcrState {
  const OcrIdle();
}

class OcrRecognizing extends OcrState {
  const OcrRecognizing();
}

/// The recognized (or manually entered) text, awaiting comma-delimiting.
class OcrDelimiting extends OcrState {
  const OcrDelimiting(this.text);
  final String text;
}

class OcrDraftReady extends OcrState {
  const OcrDraftReady(this.entries);
  final List<DraftEntry> entries;
}

class OcrError extends OcrState {
  const OcrError(this.message);
  final String message;
}

class OcrCommitted extends OcrState {
  const OcrCommitted(this.count);
  final int count;
}

class OcrScanController extends StateNotifier<OcrState> {
  OcrScanController(this._db, this._service) : super(const OcrIdle());

  final AppDatabase _db;
  final TextRecognitionService _service;
  final _uuid = const Uuid();
  BillLineParser? _parser;

  Future<BillLineParser> _ensureParser() async {
    if (_parser != null) return _parser!;
    final ingredients = await _db.select(_db.ingredients).get();
    _parser = BillLineParser([
      for (final i in ingredients)
        IngredientCandidate(
          id: i.id,
          name: i.name,
          defaultUnit: i.defaultUnit,
        ),
    ]);
    return _parser!;
  }

  Future<void> capture({bool fromGallery = false}) async {
    state = const OcrRecognizing();
    try {
      final text = fromGallery
          ? await _service.pickAndRecognize()
          : await _service.captureAndRecognize();
      if (text == null) {
        state = const OcrIdle();
        return;
      }
      state = OcrDelimiting(text);
    } catch (e) {
      state = OcrError('Could not scan: $e');
    }
  }

  /// Skip the camera and enter/paste text manually.
  void enterManual() => state = const OcrDelimiting('');

  void updateText(String text) => state = OcrDelimiting(text);

  Future<void> buildDraft(String text) async {
    final parser = await _ensureParser();
    state = OcrDraftReady(parser.parse(text));
  }

  void updateEntry(int index, DraftEntry entry) {
    final s = state;
    if (s is! OcrDraftReady) return;
    final list = [...s.entries];
    list[index] = entry;
    state = OcrDraftReady(list);
  }

  void removeEntry(int index) {
    final s = state;
    if (s is! OcrDraftReady) return;
    final list = [...s.entries]..removeAt(index);
    state = OcrDraftReady(list);
  }

  void addBlankEntry() {
    final s = state;
    if (s is! OcrDraftReady) return;
    state = OcrDraftReady([
      ...s.entries,
      DraftEntry(rawText: '', nameGuess: ''),
    ]);
  }

  /// Commits the reviewed draft entries into the given kitchen's inventory.
  Future<void> commit(List<DraftEntry> entries, {required String kitchenId}) async {
    final now = DateTime.now();
    var committed = 0;
    await _db.transaction(() async {
      for (final e in entries) {
        if (e.nameGuess.trim().isEmpty) continue;
        final unit = e.unit ?? MeasurementUnit.pieces;
        await _db.into(_db.inventoryItems).insert(
              InventoryItemsCompanion.insert(
                id: _uuid.v4(),
                kitchenId: Value(kitchenId),
                ingredientId: Value(e.matchedIngredientId),
                customName: Value(e.matchedIngredientId == null ? e.nameGuess.trim() : null),
                quantity: e.quantity ?? 1,
                unit: unit,
                purchaseDate: now,
                shelfLifeDays: const Value(7),
                expiryDate: now.add(const Duration(days: 7)),
                originalQuantity: Value(e.quantity ?? 1),
                createdAt: now,
                updatedAt: now,
              ),
            );
        committed++;
      }
    });
    state = OcrCommitted(committed);
  }

  void reset() => state = const OcrIdle();
}

final textRecognitionServiceProvider = Provider<TextRecognitionService>(
  (ref) => TextRecognitionService(),
);

final ocrScanControllerProvider =
    StateNotifierProvider<OcrScanController, OcrState>(
  (ref) => OcrScanController(
    ref.watch(databaseProvider),
    ref.watch(textRecognitionServiceProvider),
  ),
);
