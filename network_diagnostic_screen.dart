import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/network_health_provider.dart';

class NetworkDiagnosticScreen extends StatefulWidget {
  const NetworkDiagnosticScreen({super.key});
  static const routeName = '/network-diagnostics';

  @override
  State<NetworkDiagnosticScreen> createState() => _NetworkDiagnosticScreenState();
}

class _NetworkDiagnosticScreenState extends State<NetworkDiagnosticScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<NetworkHealthProvider>().startRegularDiagnostics());
  }

  @override
  Widget build(BuildContext context) {
    final diagnostic = context.watch<NetworkHealthProvider>();
    final color = diagnostic.healthColor(diagnostic.health);
    return Scaffold(
      appBar: AppBar(title: const Text('Network Diagnostic Dashboard')),
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
          CircleAvatar(radius: 30, foregroundColor: color, backgroundColor: color.withValues(alpha: .15), child: Icon(_healthIcon(diagnostic.health), size: 32)),
          const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(diagnostic.healthLabel(diagnostic.health), style: Theme.of(context).textTheme.headlineSmall),
            Text(diagnostic.isRunning ? 'Diagnostics running in the background' : 'Global connection health tier'),
          ])),
        ]))),
        const SizedBox(height: 18), Text('Three-step diagnostic', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 10),
        _step(context, 1, 'Idle ping', _value(diagnostic.idlePingMs, 'ms'), diagnostic.phase == DiagnosticPhase.idlePing),
        _step(context, 2, 'Download + ping', '${_rate(diagnostic.downloadMbps)} · ${_value(diagnostic.downloadPingMs, 'ms')}', diagnostic.phase == DiagnosticPhase.download),
        _step(context, 3, 'Upload + ping', '${_rate(diagnostic.uploadMbps)} · ${_value(diagnostic.uploadPingMs, 'ms')}', diagnostic.phase == DiagnosticPhase.upload),
        const SizedBox(height: 16),
        LinearProgressIndicator(value: _progress(diagnostic.phase), minHeight: 9, borderRadius: BorderRadius.circular(8)), const SizedBox(height: 12),
        Text(diagnostic.message), const SizedBox(height: 20),
        FilledButton.icon(onPressed: diagnostic.isRunning ? null : diagnostic.runDiagnostic, icon: const Icon(Icons.play_arrow), label: Text(diagnostic.isRunning ? 'Testing connection…' : 'Run diagnostics now')),
        const SizedBox(height: 24), Text('Health rules', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 6),
        const Text('Excellent: >10 Mbps and low latency\nFair: 2–10 Mbps\nPoor: below 2 Mbps\nDegraded: failed test or extreme latency'),
      ])),
    );
  }

  Widget _step(BuildContext context, int number, String title, String value, bool active) => Card(
    color: active ? Theme.of(context).colorScheme.secondaryContainer : null,
    child: ListTile(leading: CircleAvatar(child: Text('$number')), title: Text(title), subtitle: Text(value), trailing: active ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : null),
  );

  String _value(int? value, String unit) => value == null ? 'Waiting…' : '$value $unit';
  String _rate(double? value) => value == null ? 'Waiting…' : '${value.toStringAsFixed(2)} Mbps';
  double? _progress(DiagnosticPhase phase) => switch (phase) { DiagnosticPhase.idle => 0, DiagnosticPhase.idlePing => .2, DiagnosticPhase.download => .45, DiagnosticPhase.upload => .75, _ => 1 };
  IconData _healthIcon(NetworkHealth health) => switch (health) { NetworkHealth.excellent => Icons.rocket_launch_outlined, NetworkHealth.fair => Icons.thumb_up_outlined, NetworkHealth.poor => Icons.network_wifi_1_bar, NetworkHealth.degraded => Icons.warning_amber_outlined, NetworkHealth.unknown => Icons.speed_outlined };
}
