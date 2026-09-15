import 'package:flutter/material.dart';

class ActivityOneScreen extends StatefulWidget {
  const ActivityOneScreen({super.key});
  static const routeName = '/sample-check-in';
  @override
  State<ActivityOneScreen> createState() => _ActivityOneScreenState();
}

class _ActivityOneScreenState extends State<ActivityOneScreen> {
  final _sampleController = TextEditingController();
  final List<String> _samples = [];

  @override
  void dispose() { _sampleController.dispose(); super.dispose(); }

  void _addSample() {
    final sample = _sampleController.text.trim();
    if (sample.isNotEmpty) setState(() { _samples.add(sample); _sampleController.clear(); });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sample Check-in')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Register a sample', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 16),
        Row(children: [
          Expanded(child: TextField(controller: _sampleController, decoration: const InputDecoration(labelText: 'Sample ID', border: OutlineInputBorder()))),
          const SizedBox(width: 12), FilledButton.icon(onPressed: _addSample, icon: const Icon(Icons.add), label: const Text('Add')),
        ]),
        const SizedBox(height: 20),
        Expanded(child: _samples.isEmpty ? const Center(child: Text('No samples checked in yet.')) : ListView.separated(
          itemCount: _samples.length, separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => ListTile(leading: const Icon(Icons.science_outlined), title: Text(_samples[index]), subtitle: const Text('Ready for processing')),
        )),
      ]),
    ),
  );
}
