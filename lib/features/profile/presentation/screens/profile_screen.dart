import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/core/routes/app_route_paths.dart';
import 'package:nexus/core/routes/app_routes.dart';
import 'package:nexus/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:nexus/features/auth/data/riverpod/auth_provider.dart';
import 'package:nexus/features/profile/data/riverpod/user_profile_provider.dart';
import 'package:nexus/features/profile/presentation/widgets/profile_about_card.dart';
import 'package:nexus/features/profile/presentation/widgets/profile_danger_zone_card.dart';
import 'package:nexus/features/profile/presentation/widgets/profile_header.dart';
import 'package:nexus/features/profile/presentation/widgets/profile_quick_stats_row.dart';
import 'package:nexus/features/progress/data/riverpod/progress_provider.dart';
import 'package:nexus/features/progress/data/models/weekly_subject_progress.dart';
import 'package:nexus/core/singleton.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  int _calculateStreak(List<WeeklySubjectProgress> entries) {
    final completedDays = entries
        .where((entry) => entry.lessonCount > 0 || entry.xpEarned > 0)
        .map((entry) => DateUtils.dateOnly(entry.dayBucket))
        .toSet();

    var streak = 0;
    var dayPointer = DateUtils.dateOnly(DateTime.now());

    while (completedDays.contains(dayPointer)) {
      streak += 1;
      dayPointer = dayPointer.subtract(const Duration(days: 1));
    }

    return streak;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final progressSummaryAsync = ref.watch(progressSummaryProvider);
    final weeklyProgressAsync = ref.watch(weeklySubjectProgressProvider);

    final email = user?.email ?? 'Unknown';
    final fallbackName = email.split('@').first;

    Future<void> handleLogout() async {
      try {
        await supabase.auth.signOut();
        if (context.mounted) {
          LoginRoute().go(context);
        }
        // AuthGate in main.dart will automatically navigate to LoginPage
      } catch (e) {
        logger.e('Logout error', error: e);
      }
    }

    return profileAsync.when(
      loading: () => const ProfileSkeleton(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (profile) {
        final displayName = profile?.name.trim().isNotEmpty == true
            ? profile!.name
            : fallbackName;
        final avatarSeed = profile?.avatarSeed.trim().isNotEmpty == true
            ? profile!.avatarSeed
            : 'guest_$fallbackName';
        final totalXp = progressSummaryAsync.maybeWhen(
          data: (summary) => summary.totalXp,
          orElse: () => profile?.totalXp ?? 0,
        );
        final completedTopics = progressSummaryAsync.maybeWhen(
          data: (summary) => summary.completedTopics,
          orElse: () => 0,
        );
        final streak = weeklyProgressAsync.maybeWhen(
          data: _calculateStreak,
          orElse: () => 0,
        );

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              ProfileHeader(
                displayName: displayName,
                email: profile?.email.isNotEmpty == true
                    ? profile!.email
                    : email,
                avatarSeed: avatarSeed,
                totalXp: totalXp,
              ),
              const SizedBox(height: 20),
              Text(
                'Quick Stats',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ProfileQuickStatsRow(
                totalXp: totalXp,
                streakDays: streak,
                completedTopics: completedTopics,
              ),
              const SizedBox(height: 24),
              ProfileAboutCard(
                email: profile?.email.isNotEmpty == true
                    ? profile!.email
                    : email,
              ),
              const SizedBox(height: 12),
              Text(
                'Settings',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Manage Profile'),
                      subtitle: const Text(
                        'Edit your name and choose a fun avatar',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        const EditProfileRoute().push(context);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: const Text('Notifications'),
                      subtitle: const Text('Manage your notifications'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push(AppRoutePaths.notificationsSettingsPath);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.brightness_6_outlined),
                      title: const Text('Theme'),
                      subtitle: const Text('Light / Dark / System'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.push(AppRoutePaths.themeSettingsPath);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ProfileDangerZoneCard(onLogout: handleLogout),
            ],
          ),
        );
      },
    );
  }
}
