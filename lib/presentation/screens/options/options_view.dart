import 'package:chambeape/config/databases/db_helper.dart';
import 'package:chambeape/infrastructure/models/users.dart';
import 'package:chambeape/presentation/providers/theme_provider.dart';
import 'package:chambeape/presentation/screens/0_login/login_view.dart';
import 'package:chambeape/presentation/shared/widgets/user_card_widget.dart';
import 'package:chambeape/services/login/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OptionsView extends ConsumerStatefulWidget {
  static const String routeName = 'options_view';

  const OptionsView({super.key});

  @override
  createState() => _OptionsViewState();
}

class _OptionsViewState extends ConsumerState<OptionsView> {
  late Future<List<Users>> _userHistory;

  @override
  void initState() {
    super.initState();
    _userHistory = DbHelper().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    Future<void> handleLogout() async {
      await SessionService().logout();
      if (context.mounted) {
        context.goNamed(LoginView.routeName);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambia el tema de la aplicación'),
            value: isDarkMode,
            onChanged: (bool value) {
              ref.read(themeNotifierProvider.notifier).toggleDarkMode();
            },
          ),
          const Text(
            'Historial de actividad',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  FutureBuilder<List<Users>>(
                    future: _userHistory,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Error al cargar el historial de actividad'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No hay historial de actividad'));
                      } else {
                        return Column(
                          children: snapshot.data!.map((user) {
                            return UserCardWidget(worker: user.toWorker());
                          }).toList(),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10)
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FilledButton(
                onPressed: handleLogout,
                child: const Text('Cerrar sesión'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
