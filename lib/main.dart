import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'styles/styles.dart';
import 'service_locator.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';

void main() async {
  // WAJIB: Tambah ini sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // WAJIB: Panggil setupServiceLocator
  await setupServiceLocator();
  
  // Initialize auth to restore session from SharedPreferences
  final authProvider = getIt<AuthProvider>();
  await authProvider.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // WAJIB: Wrap dengan MultiProvider untuk global providers
    return MultiProvider(
      providers: [
        // AuthProvider = GLOBAL (dibutuhkan di banyak screen)
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        // DashboardProvider = GLOBAL (dibutuhkan di home & search)
        ChangeNotifierProvider(create: (_) => getIt<DashboardProvider>()),
      ],
      child: MaterialApp.router(
        title: 'Lentera Karir',
        theme: AppTheme.lightTheme.copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: NoTransitionsBuilder(),
              TargetPlatform.iOS: NoTransitionsBuilder(),
            },
          ),
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
