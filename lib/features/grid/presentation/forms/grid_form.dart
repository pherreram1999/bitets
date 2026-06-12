import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/has_id.dart';

abstract class GridForm<T extends HasId> extends ConsumerStatefulWidget {
  const GridForm({
    super.key,
    required this.endpoint,
    this.item,
    this.readOnly = false,
  });

  final String endpoint;
  final T? item;
  final bool readOnly;

  @override
  ConsumerState<GridForm<T>> createState();
}
