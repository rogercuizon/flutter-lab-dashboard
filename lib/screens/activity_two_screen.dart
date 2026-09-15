import 'package:flutter/material.dart';

class ActivityTwoScreen extends StatefulWidget {
  const ActivityTwoScreen({super.key});
  static const routeName = '/results-review';
  @override
  State<ActivityTwoScreen> createState() => _ActivityTwoScreenState();
}

class _ActivityTwoScreenState extends State<ActivityTwoScreen> {
  final Set<String> _reviewed = {};
  final _results = const ['Culture A-102', 'Blood Panel B-214', 'Water Sample C-031'];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Results Review')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pending results', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8),
        Text('${_reviewed.length} of ${_results.length} results reviewed'), const SizedBox(height: 16),
        Expanded(child: ListView.separated(
          itemCount: _results.length, separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final result = _results[index]; final reviewed = _reviewed.contains(result);
            return Card(child: CheckboxListTile(
              value: reviewed, onChanged: (value) => setState(() => value == true ? _reviewed.add(result) : _reviewed.remove(result)),
              title: Text(result), subtitle: Text(reviewed ? 'Reviewed' : 'Awaiting review'),
              secondary: Icon(reviewed ? Icons.verified_outlined : Icons.pending_outlined),
            ));
          },
        )),
      ]),
    ),
  );
}
