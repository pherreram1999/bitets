import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/has_id.dart';
import 'grid_search.dart';

abstract class GridSearchState<T extends HasId>
    extends ConsumerState<GridSearch<T>> {
  @override
  void initState() {
    super.initState();
    hydrate(widget.initialValues);
  }

  Widget buildSearchFields(BuildContext context);
  Map<String, dynamic> collectSearchValues();
  void resetSearchFields() {}
  void hydrate(Map<String, dynamic>? values) {}

  Map<String, dynamic> _cleanValues(Map<String, dynamic> values) {
    final out = <String, dynamic>{};
    values.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is String) {
        out[key] = value.trim();
      } else {
        out[key] = value;
      }
    });
    return out;
  }

  void submit() {
    Navigator.of(context).pop(_cleanValues(collectSearchValues()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildSearchFields(context),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.search),
            label: const Text('Aplicar'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
