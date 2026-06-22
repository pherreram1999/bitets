import 'mapa_point.dart';
import 'mapa_rect.dart';

enum MapaElementType {
  wall,
  building,
  zone,
  tag,
  label,
  marker,
  unknown;

  static MapaElementType fromString(String? value) {
    switch (value) {
      case 'wall':
        return MapaElementType.wall;
      case 'building':
        return MapaElementType.building;
      case 'zone':
        return MapaElementType.zone;
      case 'tag':
        return MapaElementType.tag;
      case 'label':
        return MapaElementType.label;
      case 'marker':
        return MapaElementType.marker;
      default:
        return MapaElementType.unknown;
    }
  }
}

class MapaElement {
  const MapaElement({
    required this.type,
    this.rect,
    this.point,
    this.label,
    this.text,
    this.styleOverride,
    this.edificioNumero,
    this.tappable = false,
  });

  final MapaElementType type;
  final MapaRect? rect;
  final MapaPoint? point;
  final String? label;
  final String? text;
  final String? styleOverride;
  final int? edificioNumero;
  final bool tappable;

  factory MapaElement.fromJson(Map<String, dynamic> json) {
    final rawRect = json['rect'];
    final rawPoint = json['point'];
    return MapaElement(
      type: MapaElementType.fromString(json['type'] as String?),
      rect: rawRect is Map<String, dynamic> ? MapaRect.fromJson(rawRect) : null,
      point: rawPoint is Map<String, dynamic>
          ? MapaPoint.fromJson(rawPoint)
          : null,
      label: json['label'] as String?,
      text: json['text'] as String?,
      styleOverride: json['style'] as String?,
      edificioNumero: (json['edificio_numero'] as num?)?.toInt(),
      tappable: (json['tappable'] as bool?) ?? false,
    );
  }
}
