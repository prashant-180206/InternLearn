import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:interactive_learn/core/models/slide_match.dart';

class MatchSlideWidget extends HookWidget {
  final SlideMatch match;
  final VoidCallback onCompleted;

  const MatchSlideWidget({
    super.key,
    required this.match,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Shuffle right items exactly once
    final shuffledRight = useMemoized(() {
      final list = [...match.rightItems];
      list.shuffle();
      return list;
    }, const []);

    // Build correct lookup: leftId → rightId
    final correctMap = useMemoized(
      () => {for (final p in match.correctPairs) p.leftId: p.rightId},
      const [],
    );

    final selectedLeft = useState<String?>(null);
    final matchedPairs = useState<Map<String, String>>({});   // leftId → rightId
    final wrongPair = useState<(String, String)?>(null);      // (leftId, rightId)
    final isCompleted = useState(false);

    // Timer ref so we can cancel if widget disposes
    final wrongTimer = useRef<Timer?>(null);
    useEffect(() => () => wrongTimer.value?.cancel(), const []);

    void selectLeft(String leftId) {
      if (matchedPairs.value.containsKey(leftId)) return;
      selectedLeft.value = selectedLeft.value == leftId ? null : leftId;
    }

    void selectRight(String rightId) {
      final left = selectedLeft.value;
      if (left == null) return;
      if (matchedPairs.value.values.contains(rightId)) return;

      if (correctMap[left] == rightId) {
        // Correct pair
        final updated = Map<String, String>.from(matchedPairs.value)..[left] = rightId;
        matchedPairs.value = updated;
        selectedLeft.value = null;

        if (updated.length == match.correctPairs.length) {
          isCompleted.value = true;
          onCompleted();
        }
      } else {
        // Wrong pair — flash red, then clear
        wrongPair.value = (left, rightId);
        selectedLeft.value = null;
        wrongTimer.value?.cancel();
        wrongTimer.value = Timer(const Duration(milliseconds: 700), () {
          wrongPair.value = null;
        });
      }
    }

    Color leftBorder(String leftId) {
      if (matchedPairs.value.containsKey(leftId)) return Colors.green;
      if (wrongPair.value?.$1 == leftId) return Colors.red;
      if (selectedLeft.value == leftId) return theme.colorScheme.primary;
      return theme.colorScheme.outlineVariant;
    }

    Color leftBg(String leftId) {
      if (matchedPairs.value.containsKey(leftId)) return Colors.green.shade50;
      if (wrongPair.value?.$1 == leftId) return Colors.red.shade50;
      if (selectedLeft.value == leftId) return theme.colorScheme.primaryContainer;
      return theme.colorScheme.surface;
    }

    Color rightBorder(String rightId) {
      if (matchedPairs.value.values.contains(rightId)) return Colors.green;
      if (wrongPair.value?.$2 == rightId) return Colors.red;
      return theme.colorScheme.outlineVariant;
    }

    Color rightBg(String rightId) {
      if (matchedPairs.value.values.contains(rightId)) return Colors.green.shade50;
      if (wrongPair.value?.$2 == rightId) return Colors.red.shade50;
      return theme.colorScheme.surface;
    }

    final allMatched = matchedPairs.value.length == match.correctPairs.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Match the Pairs',
              style: TextStyle(
                color: theme.colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(match.question, style: theme.textTheme.titleMedium),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            selectedLeft.value != null
                ? 'Now tap the matching item on the right →'
                : 'Tap a left item to select it, then tap its match.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: selectedLeft.value != null
                  ? theme.colorScheme.primary
                  : Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Pair columns
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    children: match.leftItems.map((item) {
                      final isMatched = matchedPairs.value.containsKey(item.id);
                      return GestureDetector(
                        onTap: () => selectLeft(item.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: leftBg(item.id),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: leftBorder(item.id),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.text,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isMatched ? FontWeight.w600 : null,
                                  ),
                                ),
                              ),
                              if (isMatched)
                                const Icon(Icons.check_circle,
                                    size: 16, color: Colors.green),
                              if (selectedLeft.value == item.id)
                                Icon(Icons.arrow_forward,
                                    size: 16,
                                    color: theme.colorScheme.primary),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Connector dots
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      match.leftItems.length,
                      (_) => const Icon(Icons.more_vert,
                          size: 18, color: Colors.grey),
                    ),
                  ),
                ),

                // Right column
                Expanded(
                  child: Column(
                    children: shuffledRight.map((item) {
                      final isMatched =
                          matchedPairs.value.values.contains(item.id);
                      return GestureDetector(
                        onTap: isMatched ? null : () => selectRight(item.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: rightBg(item.id),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: rightBorder(item.id),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (isMatched)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(Icons.check_circle,
                                      size: 16, color: Colors.green),
                                ),
                              Expanded(
                                child: Text(
                                  item.text,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isMatched ? FontWeight.w600 : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Completion banner
          if (allMatched) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.celebration, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'All pairs matched! Excellent work!',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Explanation (shown after completion)
          if (allMatched && match.explanationMd.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explanation',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: match.explanationMd,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
