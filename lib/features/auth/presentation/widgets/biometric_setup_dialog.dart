import 'package:flutter/material.dart';

/// Dialogo mostrado tras el primer login exitoso para preguntar
/// si el usuario quiere activar el desbloqueo biometrico.
class BiometricSetupDialog extends StatelessWidget {
  const BiometricSetupDialog({super.key});

  /// Muestra el dialogo y retorna true si el usuario acepto configurar biometria.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const BiometricSetupDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.fingerprint,
        size: 48,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Acceso rapido'),
      content: const Text(
        'Quieres usar tu huella digital o reconocimiento facial '
        'para ingresar rapidamente la proxima vez?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Omitir'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Activar'),
        ),
      ],
    );
  }
}
