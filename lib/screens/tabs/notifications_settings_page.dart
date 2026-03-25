import 'package:flutter/material.dart';

/// UI-only notification toggles. State is local; no push or backend yet.
class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _emailDigest = true;
  bool _newContent = true;
  bool _reminders = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Control what you hear about. These switches are for layout only — nothing is saved yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 0,
            color: scheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.email_outlined, color: scheme.primary),
                  title: const Text('Email digest'),
                  subtitle: const Text('Weekly summary of your progress'),
                  value: _emailDigest,
                  onChanged: (v) => setState(() => _emailDigest = v),
                ),
                Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                SwitchListTile(
                  secondary: Icon(Icons.new_releases_outlined, color: scheme.primary),
                  title: const Text('New content'),
                  subtitle: const Text('When new lessons are available'),
                  value: _newContent,
                  onChanged: (v) => setState(() => _newContent = v),
                ),
                Divider(height: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
                SwitchListTile(
                  secondary: Icon(Icons.alarm_outlined, color: scheme.primary),
                  title: const Text('Study reminders'),
                  subtitle: const Text('Nudges to keep your streak'),
                  value: _reminders,
                  onChanged: (v) => setState(() => _reminders = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
