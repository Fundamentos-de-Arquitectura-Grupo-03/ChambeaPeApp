import 'package:chambeape/config/routes/app_routes.dart';
import 'package:chambeape/presentation/providers/theme_provider.dart';
import 'package:chambeape/services/login/session_service.dart';
import 'package:chambeape/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool hasSession = await SessionService().loadSession();

  tz.initializeTimeZones();
  runApp(ProviderScope(
    child: MyApp(hasSession: hasSession),
  ));
}

class MyApp extends ConsumerWidget {
  final bool hasSession;

  const MyApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ChambeaPe',
      theme: appTheme.getTheme(),
      routerConfig: hasSession ? appRouterLogged : appRouterNotLogged,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES')],
    );
  }
}
