import 'package:flutter/material.dart';

/// Pantalla mientras se resuelve el estado de autenticacion inicial
/// (lectura de token en secure storage). Evita rebotes a /login.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/AM_InicioSesion.webp',
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, _) => Icon(
                Icons.school,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
