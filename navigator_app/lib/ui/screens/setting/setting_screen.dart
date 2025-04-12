import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_app/providers/firebase_rivrpod_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Please sign in to access settings'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          body: ListView(
            children: [
              // Account Section
              _buildSectionHeader(context, 'Account'),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile Information'),
                subtitle: Text(user.userName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to profile edit screen
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Preferred Language'),
                subtitle: Text(user.preferredLanguage),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showLanguageSelector(context, ref, user.uid, user.preferredLanguage);
                },
              ),
              const Divider(),

              // Preferences Section
              _buildSectionHeader(context, 'Preferences'),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Event Categories'),
                subtitle: Text(user.preferences.isEmpty 
                    ? 'No preferences set' 
                    : user.preferences.join(', ')),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showCategorySelector(context, ref, user.uid, user.preferences);
                },
              ),
              const Divider(),

              // Notifications Section
              _buildSectionHeader(context, 'Notifications'),
              SwitchListTile(
                title: const Text('Event Reminders'),
                subtitle: const Text('Get notified about upcoming events'),
                value: true, // This should be stored in user preferences
                onChanged: (value) {
                  // Update notification settings
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('New Events'),
                subtitle: const Text('Get notified about new events in your area'),
                value: false, // This should be stored in user preferences
                onChanged: (value) {
                  // Update notification settings
                },
              ),
              const Divider(),

              // App Settings Section
              _buildSectionHeader(context, 'App Settings'),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme'),
                subtitle: const Text('Light'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Show theme selector
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Clear Cache'),
                subtitle: const Text('Free up storage space'),
                onTap: () {
                  // Clear app cache
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                },
              ),
              const Divider(),

              // About Section
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

              // Sign Out
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Sign out
                    ref.read(authRepositoryProvider).signOut();
                  },
                  child: const Text('Sign Out'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
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

  void _showLanguageSelector(BuildContext context, WidgetRef ref, String userId, String currentLanguage) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'ar', 'name': 'Arabic'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return RadioListTile<String>(
                title: Text(language['name']!),
                value: language['code']!,
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(userRepositoryProvider).updateUserPreferredLanguage(userId, value);
                    Navigator.of(context).pop();
                  }
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
        ],
      ),
    );
  }

  void _showCategorySelector(BuildContext context, WidgetRef ref, String userId, List<String> currentPreferences) {
    final categories = [
      'Music',
      'Sports',
      'Food',
      'Art',
      'Technology',
      'Business',
      'Health',
      'Education',
      'Entertainment',
      'Travel',
    ];

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
                  title: Text(category),
                  value: selectedCategories.contains(category),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        if (!selectedCategories.contains(category)) {
                          selectedCategories.add(category);
                        }
                      } else {
                        selectedCategories.remove(category);
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
                ref.read(userRepositoryProvider).updateUserPreferences(userId, selectedCategories);
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
