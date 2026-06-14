class ChartData {
  const ChartData({required this.labels, required this.values});

  final List<String> labels;
  final List<int> values;

  bool get isEmpty => labels.isEmpty && values.isEmpty;

  int get total => values.fold(0, (acc, v) => acc + v);

  factory ChartData.fromJson(Map<String, dynamic> json) {
    final rawLabels = json['labels'];
    final rawValues = json['values'];

    final labels = <String>[];
    if (rawLabels is List) {
      for (final item in rawLabels) {
        if (item == null) continue;
        labels.add(item.toString());
      }
    }

    final values = <int>[];
    if (rawValues is List) {
      for (final item in rawValues) {
        if (item is int) {
          values.add(item);
        } else if (item is num) {
          values.add(item.toInt());
        } else if (item is String) {
          values.add(int.tryParse(item) ?? 0);
        }
      }
    }

    return ChartData(labels: labels, values: values);
  }
}
