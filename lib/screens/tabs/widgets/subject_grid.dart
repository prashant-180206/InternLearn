import 'package:flutter/material.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/screens/content/chapters_screen.dart';

class SubjectGrid extends StatelessWidget {
  final List<Subject> subjects;
  const SubjectGrid({super.key,required this.subjects});

  static const List<Color> _palette = [
    Color(0xFF1565C0), // deep blue
    Color(0xFF2E7D32), // deep green
    Color(0xFFE65100), // deep orange
    Color(0xFF6A1B9A), // deep purple
    Color(0xFF00695C), // teal
    Color(0xFFC62828), // deep red
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final color = _palette[index % _palette.length];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChaptersPage(subject: subject)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Text(
                    subject.name[0].toUpperCase(),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  subject.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subject.description != null)
                  Text(
                    subject.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


