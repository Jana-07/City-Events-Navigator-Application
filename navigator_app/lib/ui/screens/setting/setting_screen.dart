import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/category_data.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/auth_controller.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';

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
      final bool isOrganizer = user.role == 'organizer';
      final bool isRegularUser = user.role == 'user';

      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            // Account Section - Show for all users but with different options
            _buildSectionHeader(context, 'Account'),

            // Profile Information - Show for all users
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Information'),
              subtitle: Text(isGuest ? 'Guest' : user.userName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // For guests, redirect to sign in
                if (isGuest) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sign In Required'),
                      content: const Text(
                          'You need to sign in or register to access your profile.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //Navigator.of(context).pop(); // close dialog
                            context.go(Routes.splash); // navigate to sign in
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    ),
                  );
                  //context.go(Routes.splash);
                } else {
                  // Navigate to profile edit screen for registered users
                }
              },
            ),
            const Divider(),

            // Language settings - Show for all users
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Preferred Language'),
              subtitle: Text(isGuest ? 'English' : user.preferredLanguage),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // For guests, show language selector but don't save
                if (isGuest) {
                  _showGuestLanguageSelector(context);
                } else {
                  _showLanguageSelector(
                      context, ref, user.uid, user.preferredLanguage);
                }
              },
            ),
            const Divider(),

            // Organizer settings - Only show for organizers
            if (isOrganizer)
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Event Management'),
                subtitle: const Text('Manage your events'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to event management screen
                },
              ),
            if (isOrganizer) const Divider(),

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

            // Notifications Section - Show for registered users only
            if (!isGuest) ...[
              _buildSectionHeader(context, 'Notifications'),
              SwitchListTile(
                title: const Text('Event Reminders'),
                subtitle: const Text('Get notified about upcoming events'),
                value: true,
                onChanged: (value) {
                  // Update notification settings
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('New Events'),
                subtitle:
                    const Text('Get notified about new events in your area'),
                value: false, // This should be stored in user preferences
                onChanged: (value) {
                  // Update notification settings
                },
              ),
              const Divider(),
            ],

            // App Settings Section - Show for all users
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

            // Additional button for organizers to switch to user view
            if (isOrganizer)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.primaryColor),
                  ),
                  onPressed: () {
                    // Switch to user view temporarily
                    _showSwitchViewDialog(context, ref, user.uid);
                  },
                  child: const Text('Switch to User View'),
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

  void _showLanguageSelector(BuildContext context, WidgetRef ref, String userId,
      String currentLanguage) {
    final languages = [
      {'code': 'en', 'name': 'English'},
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
                    ref
                        .read(userControllerProvider.notifier)
                        .updatePreferredLanguage(value);

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

  // Special language selector for guests that doesn't save preferences
  void _showGuestLanguageSelector(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'ar', 'name': 'Arabic'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign in to save your language preference',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    return RadioListTile<String>(
                      title: Text(language['name']!),
                      value: language['code']!,
                      groupValue: 'en', // Default to English for guests
                      onChanged: (value) {
                        if (value != null) {
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                {Navigator.of(context).pop(), context.push('/signin')},
            child: const Text('Sign In'),
          ),
        ],
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

  // Prompt for guests to sign in
  void _showSignInPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text(
          'You need to sign in to save your preferences and access all features.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/signin');
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  // Dialog for organizers to switch to user view
  void _showSwitchViewDialog(
      BuildContext context, WidgetRef ref, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch View'),
        content: const Text(
          'You can temporarily switch to user view to see how regular users experience the app. This does not change your actual role.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement view switching logic here
              // This could be a temporary UI state change or a special flag
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Switched to user view')),
              );
            },
            child: const Text('Switch View'),
          ),
        ],
      ),
    );
  }
}
