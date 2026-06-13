import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/pages/admin_home_page.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/unlock_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/providers/auth_state.dart';
import '../auth/user_role.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  // Espejo del AuthState que NO recrea el router. El router se construye una
  // sola vez; los cambios de auth solo disparan refreshListenable → redirect.
  final authListenable = ValueNotifier<AuthState>(const AuthState.initial());
  ref.listen<AuthState>(
    authProvider,
    (_, next) => authListenable.value = next,
    fireImmediately: true,
  );
  ref.onDispose(authListenable.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: authListenable,
    redirect: (context, state) {
      final auth = authListenable.value;
      final loc = state.matchedLocation;

      // En vuelo (biometrico / login): no mover al usuario.
      final isLoading = auth.maybeWhen(
        orElse: () => false,
        loading: () => true,
      );
      if (isLoading) return null;

      final target = auth.maybeWhen(
        authenticated: (user) => _homeFor(user),
        storedSession: (_, _) => '/unlock',
        unauthenticated: (_) => '/login',
        orElse: () => '/', // initial → splash
      );

      return loc == target ? null : target;
    },
    routes: [
      GoRoute(path: '/', builder: (context, _) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, _) => const LoginPage()),
      GoRoute(path: '/unlock', builder: (context, _) => const UnlockPage()),
      GoRoute(path: '/home', builder: (context, _) => const HomePage()),
      GoRoute(path: '/admin', builder: (context, _) => const AdminHomePage()),
    ],
  );
});

String _homeFor(User user) => user.isAdmin ? '/admin' : '/home';
