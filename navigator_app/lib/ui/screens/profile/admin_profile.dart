import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigator_app/data/models/app_user.dart';
import 'package:navigator_app/router/routes.dart';
import 'package:navigator_app/ui/widgets/events/events_list.dart';

class AdminProfile extends StatefulWidget {
  final AppUser user;

  const AdminProfile({super.key, required this.user});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile>
    with SingleTickerProviderStateMixin {
  String _currentTab = "About";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          onPressed: () {
            context.pushNamed(Routes.editProfileName);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage: widget.user.profilePhotoURL.isNotEmpty
            //       ? NetworkImage(widget.user.profilePhotoURL) as ImageProvider
            //       : const AssetImage('assets/person.jpg'),
            // ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
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
            const SizedBox(height: 10),
            Text(
              widget.user.userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: OutlinedButton(
                onPressed: () {
                  context.pushNamed(
                    Routes.createEventName,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: colorScheme.primary),
                    const SizedBox(width: 30),
                    Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabButton("About"),
                _buildTabButton("Hosted Events"),
              ],
            ),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabName) {
    return TextButton(
      onPressed: () {
        setState(() {
          _currentTab = tabName;
        });
      },
      child: Text(
        tabName,
        style: TextStyle(
          color: _currentTab == tabName
              ? Theme.of(context).colorScheme.primary
              : Colors.black, // Highlight selected tab
          fontWeight:
              _currentTab == tabName ? FontWeight.w900 : FontWeight.w800,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (_currentTab == "About") {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                indent: 2,
                endIndent: 4,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Enjoy your favorite dishes and a lovely time with your friends and family. Food from local food trucks will be available for purchase. ...Read More",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    } else if (_currentTab == "Hosted Events") {
      final mediaQuery = MediaQuery.of(context);
      final availableHeight = mediaQuery.size.height -
          mediaQuery.padding.top -
          kToolbarHeight -
          kBottomNavigationBarHeight;
      return Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                indent: 2,
                endIndent: 4,
              ),
            ),
          ),
          SizedBox(
            height: availableHeight,
            child: EventsList(filter: 'organizer'),
          ),
        ],
      );
    } else {
      return const Text("Invalid tab");
    }
  }
}
