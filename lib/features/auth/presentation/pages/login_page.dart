import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';
import '../widgets/biometric_setup_dialog.dart';

/// Pagina de autenticacion con tabs para login y registro.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _maybeShowBiometricDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authNotifier = ref.read(authProvider.notifier);
      final needsSetup = await authNotifier.needsBiometricSetup();

      if (needsSetup && mounted) {
        final activate = await BiometricSetupDialog.show(context);
        if (activate == true && mounted) {
          await authNotifier.enableBiometrics();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Si el estado cambia a authenticated, preguntar por biometria
    ref.listen(authProvider, (prev, next) {
      final wasAuthenticated = next.maybeWhen(
        orElse: () => false,
        authenticated: (_) => true,
      );
      if (wasAuthenticated) {
        _maybeShowBiometricDialog();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'bitets',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 32),
                  TabBar(
                    controller: _tabCtrl,
                    tabs: const [
                      Tab(text: 'Iniciar sesion'),
                      Tab(text: 'Crear cuenta'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: authState.maybeWhen(
                      orElse: () => 350,
                      loading: () => 280,
                    ),
                    child: TabBarView(
                      controller: _tabCtrl,
                      children: const [
                        LoginForm(),
                        RegisterForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
