import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../services/calendar_export.dart';

class CalendarExportButtons extends StatefulWidget {
  const CalendarExportButtons({super.key});

  @override
  State<CalendarExportButtons> createState() => _CalendarExportButtonsState();
}

class _CalendarExportButtonsState extends State<CalendarExportButtons> {
  bool _busyPdf = false;
  bool _busyIcal = false;

  Widget _busyOrIcon(IconData icon, bool busy) {
    if (!busy) return Icon(icon);
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: _busyOrIcon(Icons.picture_as_pdf_outlined, _busyPdf),
          tooltip: 'Descargar PDF',
          onPressed: _busyPdf
              ? null
              : () => downloadAndShareCalendarFile(
                  context: context,
                  endpoint: ApiConstants.misExamenesPdf,
                  filename: 'calendario-examenes.pdf',
                  mimeType: 'application/pdf',
                  label: 'Calendario PDF',
                  setBusy: (v) => setState(() => _busyPdf = v),
                ),
        ),
        IconButton(
          icon: _busyOrIcon(Icons.event_note_outlined, _busyIcal),
          tooltip: 'Añadir a calendario',
          onPressed: _busyIcal
              ? null
              : () => downloadAndShareCalendarFile(
                  context: context,
                  endpoint: ApiConstants.misExamenesIcal,
                  filename: 'calendario-examenes.ics',
                  mimeType: 'text/calendar',
                  label: 'Calendario iCal',
                  setBusy: (v) => setState(() => _busyIcal = v),
                ),
        ),
      ],
    );
  }
}
