import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/local_providers.dart';
import 'core/network/dio_client.dart';
import 'core/notifications/notifications_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/examen/data/repositories/alumno_examen_repository.dart';

String _resolveEndpoint() {
  return 'https://saets.nullpointer.us.kg/api/v1';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.updateBaseUrl(_resolveEndpoint());
  final container = ProviderContainer();
  final local = container.read(examenesLocalDatasourceProvider);
  final notifications = container.read(notificationsServiceProvider);
  AlumnoExamenRepository.configure(local: local, notifications: notifications);
  unawaited(notifications.initialize());
  unawaited(notifications.requestPermissions());
  unawaited(notifications.rescheduleAll());
  runApp(
    UncontrolledProviderScope(container: container, child: const BitetsApp()),
  );
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
