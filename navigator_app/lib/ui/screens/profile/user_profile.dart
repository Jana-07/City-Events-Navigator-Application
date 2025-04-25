import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';
import 'package:navigator_app/ui/widgets/common/section_header.dart';
import 'package:navigator_app/ui/widgets/events/limited_favorite_events.dart';

class UserProfile extends StatelessWidget {
  final AppUser user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return UserControllerWidget(
      builder: (user) {
        return Scaffold(
          appBar: AppBar(
            title: TextButton.icon(
              onPressed: () {
                //Navigate to edit profile screen
              },
              label: Text(
                'Edit Profile',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                Icons.edit,
                color: colorScheme.primary,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profilePhotoURL,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Interests',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInterestsList(context, user.preferences),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  SectionHeader(
                    title: 'Favorite',
                    onTab: () => context.pushNamed(
                      Routes.eventListName,
                      queryParameters: {
                        'title': 'Favorite Events',
                        'filter': 'favorite',
                      },
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: LimitedFavoriteEventsList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestsList(BuildContext context, List<String> interests) {
    if (interests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('No interests added yet'),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: interests.map((interest) {
        return Chip(
          label: Text(interest),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        );
      }).toList(),
    );
  }
}
