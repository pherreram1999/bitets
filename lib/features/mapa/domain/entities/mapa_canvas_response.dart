import 'mapa_element.dart';
import 'mapa_style.dart';

class MapaCanvasInfo {
  const MapaCanvasInfo({
    required this.width,
    required this.height,
    required this.background,
    required this.padding,
  });

  final int width;
  final int height;
  final String background;
  final int padding;

  factory MapaCanvasInfo.fromJson(Map<String, dynamic> json) {
    return MapaCanvasInfo(
      width: (json['width'] as num?)?.toInt() ?? 1024,
      height: (json['height'] as num?)?.toInt() ?? 560,
      background: (json['background'] as String?) ?? '#F5F5F5',
      padding: (json['padding'] as num?)?.toInt() ?? 0,
    );
  }
}

class MapaCanvasResponse {
  const MapaCanvasResponse({
    required this.canvas,
    required this.elements,
    required this.style,
  });

  final MapaCanvasInfo canvas;
  final List<MapaElement> elements;
  final MapaStyle style;

  factory MapaCanvasResponse.fromJson(Map<String, dynamic> json) {
    final rawCanvas = json['canvas'];
    final rawElements = json['elements'];
    final rawStyle = json['style'];
    return MapaCanvasResponse(
      canvas: rawCanvas is Map<String, dynamic>
          ? MapaCanvasInfo.fromJson(rawCanvas)
          : const MapaCanvasInfo(
              width: 1024,
              height: 560,
              background: '#F5F5F5',
              padding: 0,
            ),
      elements: rawElements is List
          ? rawElements
                .whereType<Map<String, dynamic>>()
                .map(MapaElement.fromJson)
                .toList(growable: false)
          : const <MapaElement>[],
      style: rawStyle is Map<String, dynamic>
          ? MapaStyle.fromJson(rawStyle)
          : const MapaStyle(),
    );
  }
}
