import 'package:flutter/material.dart';

/// Placeholder for profile editing. No persistence or API calls yet.
class ManageProfilePage extends StatelessWidget {
  const ManageProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Update how you appear in the app. Saving will be available in a future update.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(
                    Icons.person_rounded,
                    size: 52,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                Material(
                  color: scheme.secondary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.camera_alt_outlined, size: 18, color: scheme.onSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Display name',
              hintText: 'Coming soon',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Bio',
              hintText: 'Tell others about yourself',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: null,
            child: const Text('Save changes'),
          ),
        ],
      ),
    );
  }
}
