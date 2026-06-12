import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/has_id.dart';
import 'grid_form.dart';

abstract class GridFormState<T extends HasId>
    extends ConsumerState<GridForm<T>> {
  bool _saving = false;
  String? _errorMessage;

  String get formTitle;
  Widget buildFormFields(BuildContext context, T? item);
  Map<String, dynamic> collectFormData();
  void hydrate(T? item) {}

  Dio get _dio => DioClient.instance;

  Future<void> _submit() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      final data = collectFormData();
      final response = widget.item == null
          ? await _dio.post(widget.endpoint, data: data)
          : await _dio.put(widget.endpoint, data: data);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      if (kDebugMode) {
        debugPrint('GridForm save ok: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _extractDioMessage(e);
        _saving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'No se pudo guardar. Intenta de nuevo.';
        _saving = false;
      });
    }
  }

  String _extractDioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    switch (e.response?.statusCode) {
      case 401:
        return 'No autorizado.';
      case 422:
        return 'Datos invalidos. Verifica los campos.';
      case 500:
        return 'Error del servidor. Intenta mas tarde.';
      default:
        return 'Error de conexion. Verifica tu internet.';
    }
  }

  @override
  void initState() {
    super.initState();
    hydrate(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = !widget.readOnly;

    return Scaffold(
      appBar: AppBar(
        title: Text(formTitle),
        actions: [
          if (canSave)
            TextButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: widget.readOnly,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildFormFields(context, widget.item),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
