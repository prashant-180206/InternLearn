import 'package:flutter/material.dart';
import 'package:nexus/features/leaderboard/data/models/leaderboard_entry.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardTile({
    super.key,
    required this.entry,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    Color bgColor;
    bool isEven = entry.rank % 2 == 0;

    if (entry.rank <= 3) {
      bgColor = isEven ? colors.primaryContainer : colors.secondaryContainer;
    } else if (entry.rank <= 10) {
      bgColor = isEven ? colors.secondaryContainer : colors.primaryContainer;
    } else if (entry.rank >= 33) {
      bgColor = isEven
          ? colors.errorContainer
          : colors.error.withValues(alpha: 0.2);
    } else {
      bgColor = isEven ? colors.surface : colors.surfaceContainerHighest;
    }

    if (isCurrentUser) {
      bgColor = colors.tertiaryContainer;
    }

    Widget rankDisplay;
    if (entry.rank == 1) {
      rankDisplay = const Text('🏆', style: TextStyle(fontSize: 18));
    } else if (entry.rank == 2) {
      rankDisplay = const Text('🥈', style: TextStyle(fontSize: 18));
    } else if (entry.rank == 3) {
      rankDisplay = const Text('🥉', style: TextStyle(fontSize: 18));
    } else {
      rankDisplay = Text(
        '${entry.rank}',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontSize: 14,
        ),
      );
    }

    String initial = entry.name.trim().isNotEmpty
        ? entry.name.trim()[0].toUpperCase()
        : '?';

    String displayName = entry.name.trim().isEmpty
        ? 'Unknown User'
        : entry.name;

    return Container(
      color: bgColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: SizedBox(
          width: 70,
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: rankDisplay)),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: colors.surfaceContainerHighest,
                backgroundImage:
                    entry.avatarUrl != null && entry.avatarUrl!.isNotEmpty
                    ? NetworkImage(entry.avatarUrl!)
                    : null,
                child: (entry.avatarUrl == null || entry.avatarUrl!.isEmpty)
                    ? Text(
                        initial,
                        style: TextStyle(fontSize: 14, color: colors.onSurface),
                      )
                    : null,
              ),
            ],
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
            color: colors.onSurface,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, color: colors.tertiary, size: 22),
            const SizedBox(width: 4),
            Text(
              '${entry.totalXp}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
