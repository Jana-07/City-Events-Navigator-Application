import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/category_data.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/auth_controller.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return UserControllerWidget(builder: (user) {
      // Determine user role
      final bool isGuest = user.isGuest;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // Preferences Section - Show for registered users only
            if (!isGuest) ...[
              _buildSectionHeader(context, 'Preferences'),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Event Categories'),
                subtitle: Text(user.preferences.isEmpty
                    ? 'No preferences set'
                    : user.preferences.join(', ')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCategorySelector(
                      context, ref, user.uid, user.preferences);
                },
              ),
              const Divider(),
            ],

            // App Settings Section - Show for all users
            _buildSectionHeader(context, 'App Settings'),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              onTap: () async {
                // Clear app cache
                DefaultCacheManager().emptyCache();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared')),
                );
                try {
                  await DefaultCacheManager().emptyCache();
                } catch (e) {
                  print(e);
                }
              },
            ),
            const Divider(),

            // About Section - Show for all users
            _buildSectionHeader(context, 'About'),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms of Service'),
              onTap: () {
                // Show terms of service
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                // Show privacy policy
              },
            ),
            const Divider(),

            // Sign Out / Sign In - Conditional based on user status
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGuest ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (isGuest) {
                    // Navigate to sign in screen
                    context.push('/signin');
                  } else {
                    // Sign out
                    ref.read(authControllerProvider.notifier).signOut();
                    context.go(Routes.splash);
                  }
                },
                child: Text(isGuest ? 'Sign In' : 'Sign Out'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showCategorySelector(BuildContext context, WidgetRef ref, String userId,
      List<String> currentPreferences) {
    final selectedCategories = List<String>.from(currentPreferences);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select Categories'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CheckboxListTile(
                  title: Text(category.name),
                  value: selectedCategories.contains(category.name),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (!selectedCategories.contains(category.name)) {
                          selectedCategories.add(category.name);
                        }
                      } else {
                        selectedCategories.remove(category.name);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(userControllerProvider.notifier)
                    .updatePreferences(selectedCategories);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
