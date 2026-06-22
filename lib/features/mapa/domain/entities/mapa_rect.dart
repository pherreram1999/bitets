class MapaRect {
  const MapaRect({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  final double x;
  final double y;
  final double w;
  final double h;

  factory MapaRect.fromJson(Map<String, dynamic> json) {
    return MapaRect(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      w:
          (json['w'] as num?)?.toDouble() ??
          (json['width'] as num?)?.toDouble() ??
          0,
      h:
          (json['h'] as num?)?.toDouble() ??
          (json['height'] as num?)?.toDouble() ??
          0,
    );
  }
}
