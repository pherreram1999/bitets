import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/network/dio_client.dart';

class CalendarShareResult {
  const CalendarShareResult._({required this.success, this.error});
  factory CalendarShareResult.success() =>
      const CalendarShareResult._(success: true);
  factory CalendarShareResult.failure(Object error) =>
      CalendarShareResult._(success: false, error: error);

  final bool success;
  final Object? error;
}

Future<CalendarShareResult> downloadAndShareCalendarFile({
  required BuildContext context,
  required String endpoint,
  required String filename,
  required String mimeType,
  required String label,
  ValueChanged<bool>? setBusy,
}) async {
  setBusy?.call(true);
  try {
    final response = await DioClient.instance.get<List<int>>(
      endpoint,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': mimeType},
      ),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Respuesta vacia del servidor.');
    }
    final file = XFile.fromData(
      Uint8List.fromList(bytes),
      name: filename,
      mimeType: mimeType,
    );
    await SharePlus.instance.share(
      ShareParams(files: [file], subject: label, fileNameOverrides: [filename]),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label listo para compartir.')));
    }
    return CalendarShareResult.success();
  } on DioException catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo descargar: ${e.message ?? e.type.name}'),
        ),
      );
    }
    return CalendarShareResult.failure(e);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo descargar: $e')));
    }
    return CalendarShareResult.failure(e);
  } finally {
    setBusy?.call(false);
  }
}
