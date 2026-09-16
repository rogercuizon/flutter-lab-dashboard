import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_settings.dart';
import 'screens/activity_one_screen.dart';
import 'screens/activity_two_screen.dart';
import 'screens/home_screen.dart';
import 'screens/network_monitor_screen.dart';
import 'screens/settings_screen.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => AppSettings(), child: const LaboratoryApp()));

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab Dashboard',
      themeMode: settings.themeMode,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        ActivityOneScreen.routeName: (_) => const ActivityOneScreen(),
        ActivityTwoScreen.routeName: (_) => const ActivityTwoScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        NetworkMonitorScreen.routeName: (_) => const NetworkMonitorScreen(),
      },
    );
  }

  ThemeData _theme(Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006D77), brightness: brightness),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      );
}
