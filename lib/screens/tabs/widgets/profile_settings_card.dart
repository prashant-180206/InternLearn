import 'package:flutter/material.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.onManageProfile,
    required this.onNotifications,
    required this.onTheme,
  });

  final VoidCallback onManageProfile;
  final VoidCallback onNotifications;
  final VoidCallback onTheme;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Manage Profile',
            subtitle: 'Edit or update your profile',
            onTap: onManageProfile,
            showTopRadius: true,
          ),
          Divider(height: 1, indent: 72, color: scheme.outlineVariant.withValues(alpha: 0.4)),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
            onTap: onNotifications,
          ),
          Divider(height: 1, indent: 72, color: scheme.outlineVariant.withValues(alpha: 0.4)),
          _SettingsTile(
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            subtitle: 'Light / Dark mode',
            onTap: onTheme,
            showBottomRadius: true,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showTopRadius = false,
    this.showBottomRadius = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showTopRadius;
  final bool showBottomRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: showTopRadius ? const Radius.circular(16) : Radius.zero,
          bottom: showBottomRadius ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.65),
              child: Icon(icon, color: scheme.onSecondaryContainer, size: 22),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Text(subtitle),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
