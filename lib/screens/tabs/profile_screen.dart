import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/providers/auth_provider.dart';
import 'package:interactive_learn/core/providers/theme_provider.dart';
import 'package:interactive_learn/core/singleton.dart';
import 'package:interactive_learn/pages/tabs/manage_profile_page.dart';
import 'package:interactive_learn/pages/tabs/notifications_settings_page.dart';
import 'package:interactive_learn/pages/tabs/theme_settings_page.dart';
import 'package:interactive_learn/pages/tabs/widgets/profile_email_card.dart';
import 'package:interactive_learn/pages/tabs/widgets/profile_header.dart';
import 'package:interactive_learn/pages/tabs/widgets/profile_logout_tile.dart';
import 'package:interactive_learn/pages/tabs/widgets/profile_settings_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.read(appThemeProvider.notifier);
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? 'Unknown';
    final displayName = email.split('@').first;

    Future<void> handleLogout() async {
      try {
        await supabase.auth.signOut();
        // AuthGate in main.dart will automatically navigate to LoginPage
      } catch (e) {
        logger.e('Logout error', error: e);
      }
    }

    void pushManageProfile() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ManageProfilePage(),
        ),
      );
    }

    void pushNotifications() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const NotificationsSettingsPage(),
        ),
      );
    }

    void pushTheme() {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const ThemeSettingsPage(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(displayName: displayName, email: email),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileEmailCard(email: email),
                const SizedBox(height: 16),
                ProfileSettingsCard(
                  onManageProfile: pushManageProfile,
                  onNotifications: pushNotifications,
                  onTheme: pushTheme,
                ),
                const SizedBox(height: 16),
                ProfileLogoutTile(onLogout: handleLogout),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Manage Profile'),
                  subtitle: const Text('Edit or update your profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  subtitle: const Text('Manage your notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Theme'),
                  subtitle: const Text('Light / Dark mode'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    theme.toggleTheme();
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: handleLogout,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
