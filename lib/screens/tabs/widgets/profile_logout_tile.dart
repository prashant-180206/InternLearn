import 'package:flutter/material.dart';

class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.errorContainer.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.error.withValues(alpha: 0.25)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: scheme.error.withValues(alpha: 0.15),
          child: Icon(Icons.logout_rounded, color: scheme.error),
        ),
        title: Text(
          'Logout',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.error,
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          'Sign out of your account',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        onTap: onLogout,
      ),
    );
  }
}
