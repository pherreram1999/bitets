import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../areas/presentation/pages/areas_grid_page.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../carrera/presentation/pages/carrera_grid_page.dart';
import '../../../edificio/presentation/pages/edificio_grid_page.dart';
import '../../../examen/presentation/pages/examen_grid_page.dart';
import '../../../plan_estudio/presentation/pages/plan_estudio_grid_page.dart';
import '../../../profesores/presentation/pages/profesores_grid_page.dart';
import '../../../salon/presentation/pages/salon_grid_page.dart';
import '../../../unidad_aprendizaje/presentation/pages/unidad_aprendizaje_grid_page.dart';
import 'admin_dashboard_page.dart';
import 'admin_reports_page.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    AdminDashboardPage(),
    AdminReportsPage(),
    AreasGridPage(),
    ProfesoresGridPage(),
    CarreraGridPage(),
    PlanesEstudioGridPage(),
    UnidadesAprendizajeGridPage(),
    EdificiosGridPage(),
    SalonesGridPage(),
    ExamenesGridPage(),
  ];

  static const List<_AdminDestination> _destinations = [
    _AdminDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Inicio',
    ),
    _AdminDestination(
      icon: Icons.assessment_outlined,
      selectedIcon: Icons.assessment,
      label: 'Reportes',
    ),
    _AdminDestination(
      icon: Icons.account_tree_outlined,
      selectedIcon: Icons.account_tree,
      label: 'Areas',
    ),
    _AdminDestination(
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
      label: 'Profesores',
    ),
    _AdminDestination(
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
      label: 'Carreras',
    ),
    _AdminDestination(
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book,
      label: 'Planes',
    ),
    _AdminDestination(
      icon: Icons.layers_outlined,
      selectedIcon: Icons.layers,
      label: 'Unidades',
    ),
    _AdminDestination(
      icon: Icons.apartment_outlined,
      selectedIcon: Icons.apartment,
      label: 'Edificios',
    ),
    _AdminDestination(
      icon: Icons.meeting_room_outlined,
      selectedIcon: Icons.meeting_room,
      label: 'Salones',
    ),
    _AdminDestination(
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: 'Examenes',
    ),
  ];

  void _openProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
  }

  void _selectPage(int index) {
    Navigator.of(context).pop();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      orElse: () => null,
      authenticated: (u) => u,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.webp',
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, _) => Icon(
                Icons.school,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text('bitets · Admin'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Perfil',
            onPressed: _openProfile,
          ),
        ],
      ),
      drawer: _AdminDrawer(
        user: user,
        destinations: _destinations,
        currentIndex: _currentIndex,
        onSelect: _selectPage,
      ),
      body: _pages[_currentIndex],
    );
  }
}

class _AdminDestination {
  const _AdminDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({
    required this.user,
    required this.destinations,
    required this.currentIndex,
    required this.onSelect,
  });

  final User? user;
  final List<_AdminDestination> destinations;
  final int currentIndex;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user != null && user!.name.isNotEmpty
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Administrador',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      user!.email,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < destinations.length; i++)
              ListTile(
                leading: Icon(
                  i == currentIndex
                      ? destinations[i].selectedIcon
                      : destinations[i].icon,
                ),
                title: Text(destinations[i].label),
                selected: i == currentIndex,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}
