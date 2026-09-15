import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.title, required this.description, required this.icon, required this.color, required this.onTap});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), foregroundColor: color, child: Icon(icon)),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(description),
              const SizedBox(height: 12),
              Row(children: [Text('Open', style: TextStyle(color: color, fontWeight: FontWeight.bold)), const Spacer(), Icon(Icons.arrow_forward, color: color)]),
            ]),
          ),
        ),
      );
}
