import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../kitchens/presentation/kitchen_providers.dart';
import '../../domain/bill_line_parser.dart';
import '../ocr_scan_controller.dart';

/// Hosts the whole OCR scan flow, switching UI on the controller's state.
class ScanCaptureScreen extends ConsumerWidget {
  const ScanCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ocrScanControllerProvider);
    final controller = ref.read(ocrScanControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Bill')),
      body: switch (state) {
        OcrIdle() => _IdleView(controller: controller),
        OcrRecognizing() => const _Busy(label: 'Reading your bill…'),
        OcrDelimiting(:final text) =>
          _DelimitView(initialText: text, controller: controller),
        OcrDraftReady(:final entries) => _DraftView(
          entries: entries,
          controller: controller,
          kitchenId: ref.watch(activeKitchenProvider),
        ),
        OcrError(:final message) => _ErrorView(message: message, controller: controller),
        OcrCommitted(:final count) => _DoneView(count: count, controller: controller),
      },
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.controller});
  final OcrScanController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.document_scanner_outlined,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text('Scan a grocery bill',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Photograph your receipt, then add commas to separate the columns '
            '(name, quantity, unit). We\'ll build a draft you can edit before '
            'adding to your kitchen.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => controller.capture(),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take a photo'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => controller.capture(fromGallery: true),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Pick from gallery'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: controller.enterManual,
            icon: const Icon(Icons.keyboard),
            label: const Text('Enter text manually'),
          ),
        ],
      ),
    );
  }
}

class _Busy extends StatelessWidget {
  const _Busy({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(label),
          ],
        ),
      );
}

class _DelimitView extends StatefulWidget {
  const _DelimitView({required this.initialText, required this.controller});
  final String initialText;
  final OcrScanController controller;

  @override
  State<_DelimitView> createState() => _DelimitViewState();
}

class _DelimitViewState extends State<_DelimitView> {
  late final TextEditingController _text =
      TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add commas to separate each item into columns, e.g. '
            '"Tomato, 2, kg". One item per line.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _text,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Tomato, 2, kg\nToor Dal, 500, g',
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => widget.controller.buildDraft(_text.text),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Build draft list'),
          ),
        ],
      ),
    );
  }
}

class _DraftView extends StatelessWidget {
  const _DraftView({
    required this.entries,
    required this.controller,
    required this.kitchenId,
  });
  final List<DraftEntry> entries;
  final OcrScanController controller;
  final String kitchenId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: entries.isEmpty
              ? const Center(child: Text('No items — add one below.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: entries.length,
                  itemBuilder: (context, i) => _DraftRow(
                    entry: entries[i],
                    onChanged: (e) => controller.updateEntry(i, e),
                    onDelete: () => controller.removeEntry(i),
                  ),
                ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.addBlankEntry,
                    icon: const Icon(Icons.add),
                    label: const Text('Add row'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        controller.commit(entries, kitchenId: kitchenId),
                    icon: const Icon(Icons.check),
                    label: Text('Add ${entries.length}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DraftRow extends StatelessWidget {
  const _DraftRow({required this.entry, required this.onChanged, required this.onDelete});
  final DraftEntry entry;
  final ValueChanged<DraftEntry> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                initialValue: entry.nameGuess,
                decoration: InputDecoration(
                  labelText: 'Item',
                  isDense: true,
                  suffixIcon: entry.needsReview
                      ? const Icon(Icons.help_outline, size: 18, color: Color(0xFFEF6C00))
                      : const Icon(Icons.check_circle, size: 18, color: Color(0xFF2E7D32)),
                ),
                onChanged: (v) => onChanged(entry..nameGuess = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: entry.quantity?.toString() ?? '',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Qty', isDense: true),
                onChanged: (v) => onChanged(entry..quantity = double.tryParse(v)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.controller});
  final String message;
  final OcrScanController controller;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 56),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: controller.reset, child: const Text('Try again')),
            ],
          ),
        ),
      );
}

class _DoneView extends StatelessWidget {
  const _DoneView({required this.count, required this.controller});
  final int count;
  final OcrScanController controller;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle,
                  size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text('Added $count item${count == 1 ? '' : 's'} to your kitchen',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  controller.reset();
                  Navigator.of(context).maybePop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
}
