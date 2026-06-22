import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mapa_canvas_response.dart';
import '../../domain/entities/mapa_element.dart';
import '../providers/mapa_providers.dart';
import '../widgets/edificio_salones_sheet.dart';
import '../widgets/mapa_canvas_painter.dart';

class MapaInstitucionPage extends ConsumerStatefulWidget {
  const MapaInstitucionPage({super.key});

  @override
  ConsumerState<MapaInstitucionPage> createState() =>
      _MapaInstitucionPageState();
}

class _MapaInstitucionPageState extends ConsumerState<MapaInstitucionPage> {
  final TransformationController _controller = TransformationController();
  int? _selectedEdificioNumero;
  bool _isOffline = false;
  bool _didFit = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkOffline() async {
    final offline = await ref.read(mapaRepositoryProvider).isOffline();
    if (!mounted) return;
    setState(() => _isOffline = offline);
  }

  void _onTapUp(TapUpDetails details, MapaCanvasResponse response) {
    final pos = details.localPosition;
    for (final element in response.elements) {
      if (element.type != MapaElementType.building) continue;
      if (!element.tappable || element.edificioNumero == null) continue;
      final rect = element.rect;
      if (rect == null) continue;
      if (Rect.fromLTWH(rect.x, rect.y, rect.w, rect.h).contains(pos)) {
        _showSalones(element.edificioNumero!, element.label ?? 'Edificio');
        return;
      }
    }
  }

  void _showSalones(int edificioNumero, String label) {
    setState(() => _selectedEdificioNumero = edificioNumero);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          EdificioSalonesSheet(edificioNumero: edificioNumero, label: label),
    ).whenComplete(() {
      if (mounted) setState(() => _selectedEdificioNumero = null);
    });
  }

  Future<void> _refresh() async {
    setState(() => _didFit = false);
    await ref.read(mapaCanvasProvider.notifier).refresh();
    await _checkOffline();
  }

  void _fitToViewport(double canvasW, double canvasH, BoxConstraints c) {
    if (_didFit) return;
    final scale = (c.maxWidth / canvasW).clamp(0.1, 1.0);
    final offsetY = (c.maxHeight - canvasH * scale) / 2;
    final offsetX = (c.maxWidth - canvasW * scale) / 2;
    _controller.value = Matrix4(
      scale,
      0,
      0,
      0,
      0,
      scale,
      0,
      0,
      0,
      0,
      1,
      0,
      offsetX,
      offsetY,
      0,
      1,
    );
    _didFit = true;
    _checkOffline();
  }

  @override
  Widget build(BuildContext context) {
    final canvasAsync = ref.watch(mapaCanvasProvider);
    final examenesAsync = ref.watch(examenesPorEdificioNumeroProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar mapa',
            onPressed: _refresh,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            canvasAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error al cargar el mapa: $error',
                    style: TextStyle(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (response) {
                final edificiosConExamen = examenesAsync.maybeWhen(
                  data: (m) => m.keys.toSet(),
                  orElse: () => const <int>{},
                );
                final info = response.canvas;
                final canvasW = info.width.toDouble();
                final canvasH = info.height.toDouble();
                return LayoutBuilder(
                  builder: (context, constraints) {
                    _fitToViewport(canvasW, canvasH, constraints);
                    return InteractiveViewer(
                      transformationController: _controller,
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: GestureDetector(
                        onTapUp: (details) => _onTapUp(details, response),
                        child: SizedBox(
                          width: canvasW,
                          height: canvasH,
                          child: CustomPaint(
                            size: Size(canvasW, canvasH),
                            painter: MapaCanvasPainter(
                              response: response,
                              selectedEdificioNumero: _selectedEdificioNumero,
                              edificiosConExamen: edificiosConExamen,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            if (_isOffline)
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 16,
                          color: colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Sin conexion · mapa cacheado',
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
