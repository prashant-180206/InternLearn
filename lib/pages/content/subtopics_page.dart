import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/chapter.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/models/topic.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/content/widgets/subtopic_card.dart';

class SubtopicsPage extends ConsumerWidget {
  final Subject subject;
  final Chapter chapter;
  final Topic topic;
  const SubtopicsPage({
    super.key,
    required this.subject,
    required this.chapter,
    required this.topic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtopicsAsync = ref.watch(subtopicProvider(topic.id));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.title),
            Text(
              '${subject.name} › ${chapter.name}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: subtopicsAsync.when(
        data: (subtopics) {
          if (subtopics.isEmpty) {
            return const Center(child: Text('No subtopics found.'));
          }
          // Sort by order if available
          final sorted = [...subtopics]
            ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                SubtopicCard(subtopic: sorted[index], index: index),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

