class MapaPoint {
  const MapaPoint({required this.x, required this.y});

  final double x;
  final double y;

  factory MapaPoint.fromJson(Map<String, dynamic> json) {
    return MapaPoint(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
    );
  }
}
