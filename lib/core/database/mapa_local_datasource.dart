import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import '../../../features/mapa/domain/entities/mapa_canvas_response.dart';
import '../../../features/mapa/domain/entities/mapa_style.dart';
import 'app_database.dart';

class MapaLocalDatasource {
  MapaLocalDatasource(this._db);

  final AppDatabase _db;

  static const int _singleRowId = 1;

  Future<void> save(MapaCanvasResponse response) async {
    await _db
        .into(_db.mapaCache)
        .insertOnConflictUpdate(
          MapaCacheCompanion.insert(
            id: const Value(_singleRowId),
            payload: jsonEncode(_encode(response)),
            cachedAt: DateTime.now(),
          ),
        );
  }

  Future<MapaCanvasResponse?> get() async {
    final row =
        await (_db.select(_db.mapaCache)
              ..where((t) => t.id.equals(_singleRowId))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    try {
      final decoded = jsonDecode(row.payload) as Map<String, dynamic>;
      return MapaCanvasResponse.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> cachedAt() async {
    final row =
        await (_db.select(_db.mapaCache)
              ..where((t) => t.id.equals(_singleRowId))
              ..limit(1))
            .getSingleOrNull();
    return row?.cachedAt;
  }

  Future<void> clear() async {
    await (_db.delete(
      _db.mapaCache,
    )..where((t) => t.id.equals(_singleRowId))).go();
  }

  Map<String, dynamic> _encode(MapaCanvasResponse response) {
    return {
      'canvas': {
        'width': response.canvas.width,
        'height': response.canvas.height,
        'background': response.canvas.background,
        'padding': response.canvas.padding,
      },
      'elements': [
        for (final e in response.elements)
          {
            'type': e.type.name,
            if (e.rect != null)
              'rect': {
                'x': e.rect!.x,
                'y': e.rect!.y,
                'w': e.rect!.w,
                'h': e.rect!.h,
              },
            if (e.point != null) 'point': {'x': e.point!.x, 'y': e.point!.y},
            if (e.label != null) 'label': e.label,
            if (e.text != null) 'text': e.text,
            if (e.styleOverride != null) 'style': e.styleOverride,
            if (e.edificioNumero != null) 'edificio_numero': e.edificioNumero,
            'tappable': e.tappable,
          },
      ],
      'style': _encodeStyle(response.style),
    };
  }

  Map<String, dynamic> _encodeStyle(MapaStyle s) {
    Map<String, dynamic> encodeElementStyle(MapaElementStyle e) {
      return {
        if (e.fill != null) 'fill': e.fill,
        if (e.stroke != null) 'stroke': e.stroke,
        if (e.strokeWidth != null) 'stroke_width': e.strokeWidth,
        if (e.cornerRadius != null) 'corner_radius': e.cornerRadius,
        if (e.textSize != null ||
            e.textWeight != null ||
            e.textColor != null ||
            e.textAlign != null)
          'text': {
            if (e.textSize != null) 'size': e.textSize,
            if (e.textWeight != null) 'weight': e.textWeight,
            if (e.textColor != null) 'color': e.textColor,
            if (e.textAlign != null) 'align': e.textAlign,
          },
        if (e.paddingH != null) 'padding_h': e.paddingH,
        if (e.paddingV != null) 'padding_v': e.paddingV,
        if (e.radius != null) 'radius': e.radius,
      };
    }

    return {
      'building': encodeElementStyle(s.building),
      'zone': encodeElementStyle(s.zone),
      'wall': encodeElementStyle(s.wall),
      'tag': {
        if (s.tag.fill != null) 'fill': s.tag.fill,
        if (s.tag.textColor != null) 'text_color': s.tag.textColor,
        if (s.tag.textSize != null) 'text_size': s.tag.textSize,
        if (s.tag.paddingH != null) 'padding_h': s.tag.paddingH,
        if (s.tag.paddingV != null) 'padding_v': s.tag.paddingV,
        if (s.tag.cornerRadius != null) 'corner_radius': s.tag.cornerRadius,
      },
      'label': encodeElementStyle(s.label),
      'marker': {
        if (s.marker.fill != null) 'color': s.marker.fill,
        if (s.marker.radius != null) 'radius': s.marker.radius,
      },
      'highlight': {
        if (s.highlight.fill != null) 'fill': s.highlight.fill,
        if (s.highlight.stroke != null) 'stroke': s.highlight.stroke,
      },
    };
  }
}
