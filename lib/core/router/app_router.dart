import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configurado con redirect basado en estado de autenticacion.
final goRouterProvider = Provider<GoRouter>((ref) {
  // Escucha cambios en el estado de auth. Al cambiar, se reconstruye
  // el GoRouter con un nuevo closure de redirect.
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        orElse: () => false,
        authenticated: (_) => true,
      );
      final isAuthRoute = state.matchedLocation.startsWith('/login');

      // No autenticado → forzar login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // Autenticado → no deberia ver login
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null; // sin redirect
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
