import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:interactive_learn/core/models/slide_mcq.dart';

class McqSlideWidget extends HookWidget {
  final SlideMcq mcq;
  final VoidCallback onCompleted;

  const McqSlideWidget({
    super.key,
    required this.mcq,
    required this.onCompleted,
  });

  static const _optionKeys = ['a', 'b', 'c', 'd'];
  static const _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final selected = useState<String?>(null);
    final hasAnswered = useState(false);
    final theme = Theme.of(context);

    final options = [mcq.optionA, mcq.optionB, mcq.optionC, mcq.optionD];

    void selectOption(String key) {
      if (hasAnswered.value) return;
      selected.value = key;
      hasAnswered.value = true;
      onCompleted();
    }

    Color cardColor(String key) {
      if (!hasAnswered.value) return theme.colorScheme.surface;
      if (key == mcq.correctOption) return Colors.green.shade50;
      if (key == selected.value) return Colors.red.shade50;
      return theme.colorScheme.surface;
    }

    Color borderColor(String key) {
      if (!hasAnswered.value) {
        return selected.value == key ? theme.colorScheme.primary : theme.colorScheme.outlineVariant;
      }
      if (key == mcq.correctOption) return Colors.green;
      if (key == selected.value) return Colors.red;
      return theme.colorScheme.outlineVariant;
    }

    Widget? trailingIcon(String key) {
      if (!hasAnswered.value) return null;
      if (key == mcq.correctOption) {
        return const Icon(Icons.check_circle, color: Colors.green, size: 22);
      }
      if (key == selected.value) {
        return const Icon(Icons.cancel, color: Colors.red, size: 22);
      }
      return null;
    }

    final isCorrect = selected.value == mcq.correctOption;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Multiple Choice',
              style: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question card
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MarkdownBody(
                data: mcq.questionMd,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: theme.textTheme.titleMedium?.copyWith(height: 1.5),
                  code: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Select the best answer:',
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Options
          ...List.generate(4, (i) {
            final key = _optionKeys[i];
            final label = _optionLabels[i];
            final text = options[i];
            final trail = trailingIcon(key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => selectOption(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardColor(key),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor(key), width: 2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: borderColor(key).withValues(alpha: 0.15),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: borderColor(key),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(text, style: theme.textTheme.bodyLarge),
                      ),
                      ?trail,
                    ],
                  ),
                ),
              ),
            );
          }),

          // Explanation panel (animates in after answering)
          if (hasAnswered.value)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect ? Colors.green.shade400 : Colors.orange.shade400,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      isCorrect ? Icons.emoji_events : Icons.info_outline,
                      color: isCorrect ? Colors.green.shade700 : Colors.orange.shade700,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? 'Correct! 🎉' : 'Not quite!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        MarkdownBody(
                          data: mcq.explanationMd,
                          styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                            p: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
