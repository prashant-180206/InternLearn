import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import '../../data/riverpod/leaderboard_provider.dart';
import '../widgets/leaderboard_tile.dart';
import '../widgets/zone_divider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardState = ref.watch(leaderboardProvider);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildGem(Icons.code, colors.primaryContainer, colors.onPrimaryContainer),
                  _buildGem(Icons.code, colors.secondaryContainer, colors.onSecondaryContainer),
                  _buildGem(Icons.lock_outline, colors.surfaceContainerHighest, colors.onSurfaceVariant),
                  _buildGem(Icons.lock_outline, colors.surfaceContainerHighest, colors.onSurfaceVariant),
                  _buildGem(Icons.lock_outline, colors.surfaceContainerHighest, colors.onSurfaceVariant),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stone League',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const _LiveTimerText(),
                ],
              ),
            ),
          ),

          leaderboardState.when(
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (err, stack) => SliverFillRemaining(child: Center(child: Text('Error: $err'))),
            data: (entries) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final colors = Theme.of(context).colorScheme;

                    return Column(
                      children: [
                        LeaderboardTile(
                          entry: entries[index],
                          isCurrentUser: entries[index].name == 'Shubham Waghmode',
                        ),

                        if (index == 9)
                          ZoneDivider(
                            title: 'PROMOTION ZONE',
                            color: colors.primary,
                          ),

                        if (index == 31)
                          ZoneDivider(
                            title: 'DANGER ZONE',
                            color: colors.error,
                          ),
                      ],
                    );
                  },
                  childCount: entries.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGem(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 26),
    );
  }
}

class _LiveTimerText extends StatefulWidget {
  const _LiveTimerText();

  @override
  State<_LiveTimerText> createState() => _LiveTimerTextState();
}

class _LiveTimerTextState extends State<_LiveTimerText> {
  late Timer _timer;
  String _timeLeft = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    int daysUntilMonday = DateTime.monday - now.weekday;
    if (daysUntilMonday <= 0) daysUntilMonday += 7;
    final nextMonday = DateTime(now.year, now.month, now.day + daysUntilMonday);
    final diff = nextMonday.difference(now);

    setState(() {
      _timeLeft =
          '${diff.inDays}d ${diff.inHours % 24}h ${diff.inMinutes % 60}m ${diff.inSeconds % 60}s';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      _timeLeft,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.primary,
      ),
    );
  }
}