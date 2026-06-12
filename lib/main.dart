import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// Base URL del backend local segun la plataforma.
/// - Android (emulador o dispositivo fisico): 127.0.0.1 requiere
///   `adb reverse tcp:8000 tcp:8000` para alcanzar el host.
/// - iOS sim / desktop / web: 127.0.0.1 alcanza el host directamente.
/// Se puede sobreescribir globalmente con --dart-define=API_BASE_URL=...
String _resolveEndpoint() {
  const port = 8000;
  const path = '/api/v1';
  return 'http://127.0.0.1:$port$path';
}

void main() {
  DioClient.updateBaseUrl(_resolveEndpoint());
  runApp(const ProviderScope(child: BitetsApp()));
}

class BitetsApp extends ConsumerStatefulWidget {
  const BitetsApp({super.key});

  @override
  ConsumerState<BitetsApp> createState() => _BitetsAppState();
}

class _BitetsAppState extends ConsumerState<BitetsApp> {
  @override
  void initState() {
    super.initState();
    // Verificar si hay sesion guardada al iniciar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'bitets',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
