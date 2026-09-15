import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  @override
  void initState() { super.initState(); _nameController = TextEditingController(text: context.read<AppSettings>().profileName); }
  @override
  void dispose() { _nameController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Personalize your dashboard', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 20),
        TextField(controller: _nameController, textInputAction: TextInputAction.done, onSubmitted: settings.setProfileName, decoration: InputDecoration(
          labelText: 'Profile name', border: const OutlineInputBorder(),
          suffixIcon: IconButton(tooltip: 'Save name', icon: const Icon(Icons.save_outlined), onPressed: () => settings.setProfileName(_nameController.text)),
        )),
        const SizedBox(height: 16),
        Card(child: SwitchListTile(secondary: const Icon(Icons.dark_mode_outlined), title: const Text('Dark theme'), subtitle: const Text('Apply this theme throughout the app'), value: settings.isDarkMode, onChanged: settings.setDarkMode)),
      ]),
    );
  }
}
