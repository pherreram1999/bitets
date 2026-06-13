import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
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

    final data = Uint8List.fromList(bytes);
    final canOpenInPlace =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

    if (canOpenInPlace) {
      final opened = await _openCalendarFile(
        data: data,
        filename: filename,
        mimeType: mimeType,
      );
      if (opened) {
        return CalendarShareResult.success();
      }
    }

    final file = XFile.fromData(data, name: filename, mimeType: mimeType);
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

Future<bool> _openCalendarFile({
  required Uint8List data,
  required String filename,
  required String mimeType,
}) async {
  try {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);
    await file.writeAsBytes(data, flush: true);

    final result = await OpenFilex.open(path, type: mimeType);
    if (result.type == ResultType.done) {
      return true;
    }
    if (kDebugMode) {
      debugPrint(
        'OpenFilex no abrio el archivo: ${result.type} - ${result.message}',
      );
    }
    return false;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error abriendo archivo de calendario: $e');
    }
    return false;
  }
}
