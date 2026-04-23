import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/core/routes/app_routes.dart';
import 'package:nexus/core/widgets/list_skeleton.dart';
import 'package:nexus/features/profile/data/riverpod/user_profile_provider.dart';
import 'package:nexus/features/auth/services/auth_service.dart';
import 'package:random_avatar/random_avatar.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final isSaving = useState(false);
    final selectedAvatarSeed = useState<String?>(null);
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.asData?.value;

    useEffect(() {
      if (profile != null) {
        if (nameController.text.isEmpty) {
          nameController.text = profile.name;
        }
        selectedAvatarSeed.value ??= profile.avatarSeed;
      }
      return null;
    }, [profile?.name, profile?.avatarSeed]);

    final avatarSeed = (selectedAvatarSeed.value?.trim().isNotEmpty ?? false)
        ? selectedAvatarSeed.value!
        : 'user_avatar';

    Future<void> saveProfile() async {
      if (!formKey.currentState!.validate()) return;

      isSaving.value = true;
      try {
        final avatarSeedToSave =
            (selectedAvatarSeed.value?.trim().isNotEmpty ?? false)
            ? selectedAvatarSeed.value
            : profile?.avatarSeed;

        await AuthService.updateProfile(
          name: nameController.text,
          avatarSeed: avatarSeedToSave,
        );
        if (!context.mounted) return;
        ref.invalidate(userProfileProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
      } finally {
        if (context.mounted) isSaving.value = false;
        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        loading: () => const ListSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: ClipOval(
                        child: RandomAvatar(
                          avatarSeed,
                          width: 92,
                          height: 92,
                          trBackground: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Current Avatar',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.alternate_email_rounded),
                      title: const Text('Email'),
                      subtitle: Text(profile.email),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final v = value?.trim() ?? '';
                      if (v.isEmpty) return 'Name cannot be empty';
                      if (v.length < 2) return 'Name is too short';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.face_retouching_natural_rounded,
                      ),
                      title: const Text('Avatar'),
                      subtitle: const Text('Choose from random avatars'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: RandomAvatar(
                              avatarSeed,
                              width: 30,
                              height: 30,
                              trBackground: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                      onTap: () async {
                        final selectedSeed = await AvatarPickerRoute(
                          currentSeed: avatarSeed,
                        ).push<String>(context);
                        if (!context.mounted) return;
                        if (selectedSeed != null &&
                            selectedSeed.trim().isNotEmpty) {
                          selectedAvatarSeed.value = selectedSeed;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Avatar selected, remember to save changes',
                                ),
                              ),
                            );
                          }
                        }
                        ref.invalidate(userProfileProvider);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSaving.value ? null : saveProfile,
                      icon: isSaving.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_rounded),
                      label: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
