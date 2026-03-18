import 'package:flutter/material.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/pages/content/chapters_page.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  const SubjectCard({super.key, required this.subject});

  static const List<Color> _palette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[subject.id % _palette.length];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            subject.name[0].toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          subject.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subject.description != null
            ? Text(
                subject.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChaptersPage(subject: subject)),
        ),
      ),
    );
  }
}
