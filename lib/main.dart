import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
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
