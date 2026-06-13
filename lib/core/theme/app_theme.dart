import 'package:flutter/material.dart';

/// Tema Material 3 centralizado de la aplicacion.
class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFFD96704);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      useMaterial3: true,
    );
  }
}
