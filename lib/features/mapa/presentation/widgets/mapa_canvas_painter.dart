import 'package:flutter/material.dart';
import '../../domain/entities/mapa_canvas_response.dart';
import '../../domain/entities/mapa_element.dart';
import '../../domain/entities/mapa_point.dart';
import '../../domain/entities/mapa_rect.dart';
import '../../domain/entities/mapa_style.dart';

class MapaCanvasPainter extends CustomPainter {
  MapaCanvasPainter({
    required this.response,
    this.selectedEdificioNumero,
    this.edificiosConExamen = const {},
  });

  final MapaCanvasResponse response;
  final int? selectedEdificioNumero;
  final Set<int> edificiosConExamen;

  @override
  void paint(Canvas canvas, Size size) {
    final info = response.canvas;
    final bgColor = _parseColor(info.background);
    if (bgColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, info.width.toDouble(), info.height.toDouble()),
        Paint()..color = bgColor,
      );
    }

    for (final element in response.elements) {
      _paintElement(canvas, element, response.style);
    }
  }

  void _paintElement(Canvas canvas, MapaElement element, MapaStyle style) {
    switch (element.type) {
      case MapaElementType.wall:
        _paintRectElement(canvas, element, style.wall);
      case MapaElementType.building:
        final isSelected =
            selectedEdificioNumero != null &&
            element.edificioNumero == selectedEdificioNumero;
        final s = isSelected ? style.highlight : style.building;
        _paintRectElement(
          canvas,
          element,
          s,
          defaultFill: style.building.fill,
          defaultStroke: style.building.stroke,
          defaultStrokeWidth: style.building.strokeWidth ?? 2,
          defaultCornerRadius: style.building.cornerRadius ?? 4,
          drawLabel: true,
        );
        if (element.edificioNumero != null &&
            edificiosConExamen.contains(element.edificioNumero)) {
          _paintExamBadge(canvas, element);
        }
      case MapaElementType.zone:
        if (element.styleOverride == 'label-only') {
          _paintTextAtRect(canvas, element, style.zone, defaultTextSize: 11);
        } else {
          _paintRectElement(
            canvas,
            element,
            style.zone,
            defaultFill: '#EFEFEF',
            defaultStroke: '#1A1A1A',
            defaultStrokeWidth: 1.5,
            defaultCornerRadius: 3,
            drawLabel: true,
          );
        }
      case MapaElementType.tag:
        _paintTag(canvas, element, style.tag);
      case MapaElementType.label:
        _paintTextAtPoint(
          canvas,
          element.text ?? element.label ?? '',
          element.point,
          style.label,
          defaultTextSize: 11,
        );
      case MapaElementType.marker:
        break;
      case MapaElementType.unknown:
        break;
    }
  }

  void _paintRectElement(
    Canvas canvas,
    MapaElement element,
    MapaElementStyle s, {
    String? defaultFill,
    String? defaultStroke,
    double defaultStrokeWidth = 1.5,
    double defaultCornerRadius = 0,
    bool drawLabel = false,
  }) {
    final rect = element.rect;
    if (rect == null) return;
    final rrect = _toRRect(rect, s.cornerRadius ?? defaultCornerRadius);
    final fillColor = _parseColor(s.fill ?? defaultFill);
    if (fillColor != null) {
      canvas.drawRRect(rrect, Paint()..color = fillColor);
    }
    final strokeColor = _parseColor(s.stroke ?? defaultStroke);
    if (strokeColor != null) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = strokeColor
          ..strokeWidth = s.strokeWidth ?? defaultStrokeWidth,
      );
    }
    if (drawLabel) {
      _paintTextAtRect(canvas, element, s, defaultTextSize: 14);
    }
  }

  void _paintTextAtRect(
    Canvas canvas,
    MapaElement element,
    MapaElementStyle s, {
    int defaultTextSize = 14,
  }) {
    final rect = element.rect;
    final text = element.label ?? element.text;
    if (rect == null || text == null || text.isEmpty) return;
    final tp = _buildTextPainter(text, s, defaultTextSize: defaultTextSize);
    if (tp == null) return;
    final cx = rect.x + rect.w / 2;
    final cy = rect.y + rect.h / 2;
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  void _paintTextAtPoint(
    Canvas canvas,
    String text,
    MapaPoint? point,
    MapaElementStyle s, {
    int defaultTextSize = 11,
  }) {
    if (point == null || text.isEmpty) return;
    final tp = _buildTextPainter(text, s, defaultTextSize: defaultTextSize);
    if (tp == null) return;
    tp.paint(canvas, Offset(point.x - tp.width / 2, point.y - tp.height / 2));
  }

  void _paintTag(Canvas canvas, MapaElement element, MapaElementStyle s) {
    final point = element.point;
    final text = element.text ?? element.label;
    if (point == null || text == null || text.isEmpty) return;
    final tp = _buildTextPainter(
      text,
      MapaElementStyle(
        textSize: s.textSize ?? 9,
        textColor: s.textColor ?? '#FFFFFF',
        textWeight: s.textWeight ?? 'normal',
      ),
      defaultTextSize: 9,
    );
    if (tp == null) return;
    final padH = s.paddingH ?? 6;
    final padV = s.paddingV ?? 3;
    final pillWidth = tp.width + padH * 2;
    final pillHeight = tp.height + padV * 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(point.x, point.y, pillWidth, pillHeight),
      Radius.circular(s.cornerRadius ?? 2),
    );
    final fillColor = _parseColor(s.fill ?? '#7A1F3D');
    if (fillColor != null) {
      canvas.drawRRect(rrect, Paint()..color = fillColor);
    }
    tp.paint(canvas, Offset(point.x + padH, point.y + padV));
  }

  TextPainter? _buildTextPainter(
    String text,
    MapaElementStyle s, {
    int defaultTextSize = 14,
  }) {
    final color = _parseColor(s.textColor ?? '#1A1A1A');
    if (color == null) return null;
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: (s.textSize ?? defaultTextSize).toDouble(),
          fontWeight: s.textWeight == 'bold'
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    tp.layout();
    return tp;
  }

  RRect _toRRect(MapaRect rect, double cornerRadius) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h),
      Radius.circular(cornerRadius),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty || hex == 'transparent') return null;
    var clean = hex.replaceAll('#', '');
    if (clean.length == 6) clean = 'FF$clean';
    if (clean.length != 8) return null;
    final value = int.tryParse(clean, radix: 16);
    if (value == null) return null;
    return Color(value);
  }

  void _paintExamBadge(Canvas canvas, MapaElement element) {
    final rect = element.rect;
    if (rect == null) return;
    const badgeRadius = 8.0;
    final cx = rect.x + rect.w - badgeRadius - 2;
    final cy = rect.y + badgeRadius + 2;
    canvas.drawCircle(
      Offset(cx, cy),
      badgeRadius,
      Paint()..color = const Color(0xFFD96704),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      badgeRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 1.5,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: '!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    tp.layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant MapaCanvasPainter oldDelegate) {
    return oldDelegate.selectedEdificioNumero != selectedEdificioNumero ||
        oldDelegate.edificiosConExamen.length != edificiosConExamen.length ||
        !identical(oldDelegate.response, response);
  }
}
