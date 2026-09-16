import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings.dart';
import '../widgets/dashboard_card.dart';
import 'activity_one_screen.dart';
import 'activity_two_screen.dart';
import 'network_monitor_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 850 ? 3 : width >= 560 ? 2 : 1;
    final name = context.watch<AppSettings>().profileName;
    final cards = [
      DashboardCard(title: 'Sample Check-in', description: 'Log and track incoming specimens.', icon: Icons.biotech_outlined, color: Colors.teal, onTap: () => Navigator.pushNamed(context, ActivityOneScreen.routeName)),
      DashboardCard(title: 'Results Review', description: 'Review the latest analysis results.', icon: Icons.analytics_outlined, color: Colors.deepOrange, onTap: () => Navigator.pushNamed(context, ActivityTwoScreen.routeName)),
      DashboardCard(title: 'Settings', description: 'Personalize your workspace.', icon: Icons.tune_outlined, color: Colors.indigo, onTap: () => Navigator.pushNamed(context, SettingsScreen.routeName)),
      DashboardCard(title: 'Network Monitor', description: 'Monitor handovers and recover queued requests.', icon: Icons.network_check_outlined, color: Colors.blue, onTap: () => Navigator.pushNamed(context, NetworkMonitorScreen.routeName)),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Lab Dashboard'), actions: [IconButton(tooltip: 'Settings', onPressed: () => Navigator.pushNamed(context, SettingsScreen.routeName), icon: const Icon(Icons.settings_outlined))]),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome back, $name', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6), Text('Choose an activity to continue your work.', style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 20),
          Expanded(child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: columns == 1 ? 2.2 : 1.05),
            itemCount: cards.length, itemBuilder: (_, index) => cards[index],
          )),
        ]),
      )),
    );
  }
}
