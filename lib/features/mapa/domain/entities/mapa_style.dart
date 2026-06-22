import 'mapa_element.dart';

class MapaElementStyle {
  const MapaElementStyle({
    this.fill,
    this.stroke,
    this.strokeWidth,
    this.cornerRadius,
    this.textSize,
    this.textWeight,
    this.textColor,
    this.textAlign,
    this.paddingH,
    this.paddingV,
    this.radius,
  });

  final String? fill;
  final String? stroke;
  final double? strokeWidth;
  final double? cornerRadius;
  final int? textSize;
  final String? textWeight;
  final String? textColor;
  final String? textAlign;
  final double? paddingH;
  final double? paddingV;
  final double? radius;

  static const MapaElementStyle empty = MapaElementStyle();

  factory MapaElementStyle.fromJson(Map<String, dynamic> json) {
    final rawText = json['text'];
    final text = rawText is Map<String, dynamic> ? rawText : null;
    return MapaElementStyle(
      fill: (json['fill'] as String?) ?? (json['color'] as String?),
      stroke: json['stroke'] as String?,
      strokeWidth: (json['stroke_width'] as num?)?.toDouble(),
      cornerRadius: (json['corner_radius'] as num?)?.toDouble(),
      textSize:
          (text?['size'] as num?)?.toInt() ??
          (json['text_size'] as num?)?.toInt(),
      textWeight: (text?['weight'] as String?) ?? (json['weight'] as String?),
      textColor: (text?['color'] as String?) ?? (json['text_color'] as String?),
      textAlign: (text?['align'] as String?) ?? (json['align'] as String?),
      paddingH: (json['padding_h'] as num?)?.toDouble(),
      paddingV: (json['padding_v'] as num?)?.toDouble(),
      radius: (json['radius'] as num?)?.toDouble(),
    );
  }
}

class MapaStyle {
  const MapaStyle({
    this.building = MapaElementStyle.empty,
    this.zone = MapaElementStyle.empty,
    this.wall = MapaElementStyle.empty,
    this.tag = MapaElementStyle.empty,
    this.label = MapaElementStyle.empty,
    this.marker = MapaElementStyle.empty,
    this.highlight = MapaElementStyle.empty,
  });

  final MapaElementStyle building;
  final MapaElementStyle zone;
  final MapaElementStyle wall;
  final MapaElementStyle tag;
  final MapaElementStyle label;
  final MapaElementStyle marker;
  final MapaElementStyle highlight;

  MapaElementStyle forType(MapaElementType type) {
    switch (type) {
      case MapaElementType.building:
        return building;
      case MapaElementType.zone:
        return zone;
      case MapaElementType.wall:
        return wall;
      case MapaElementType.tag:
        return tag;
      case MapaElementType.label:
        return label;
      case MapaElementType.marker:
        return marker;
      case MapaElementType.unknown:
        return MapaElementStyle.empty;
    }
  }

  factory MapaStyle.fromJson(Map<String, dynamic> json) {
    MapaElementStyle read(String key) {
      final raw = json[key];
      return raw is Map<String, dynamic>
          ? MapaElementStyle.fromJson(raw)
          : MapaElementStyle.empty;
    }

    return MapaStyle(
      building: read('building'),
      zone: read('zone'),
      wall: read('wall'),
      tag: read('tag'),
      label: read('label'),
      marker: read('marker'),
      highlight: read('highlight'),
    );
  }
}
