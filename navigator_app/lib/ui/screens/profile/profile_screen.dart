import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/ui/controllers/user_controller.dart';
import 'package:navigator_app/ui/widgets/events/events_list.dart';
import 'package:navigator_app/ui/widgets/common/section_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          onPressed: () {
            //Navigte to edit profile screen
          },
          label: Text(
            'Edit Profile',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(
            Icons.edit_calendar_rounded,
            color: colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: UserControllerWidget(
            builder: (user) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      CircleAvatar(
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
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/person.jpg',
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
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
                    onTab: () => context.push('/event'),
                  ),
                  SizedBox(
                    //width: 400,
                    height: 300,
                    child: EventsList(filter: 'favorite'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
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
