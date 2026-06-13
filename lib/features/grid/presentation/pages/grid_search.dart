import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/has_id.dart';

abstract class GridSearch<T extends HasId> extends ConsumerStatefulWidget {
  const GridSearch({super.key, this.initialValues});

  final Map<String, dynamic>? initialValues;

  String get searchTitle;

  @override
  ConsumerState<GridSearch<T>> createState();
}
