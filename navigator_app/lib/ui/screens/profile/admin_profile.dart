import 'package:flutter/material.dart';
import 'package:navigator_app/data/models/app_user.dart';

class AdminProfile extends StatefulWidget {
  final AppUser user;
  
  const AdminProfile({super.key, required this.user});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile>
    with SingleTickerProviderStateMixin {
  String _currentTab = "ABOUT"; // Initial tab

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.user.profilePhotoURL.isNotEmpty
                  ? NetworkImage(widget.user.profilePhotoURL) as ImageProvider
                  : const AssetImage('assets/person.jpg'),
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
                  // Navigate to edit profile
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
                    Icon(Icons.edit_calendar_outlined,
                        color: colorScheme.primary),
                    const SizedBox(width: 30),
                    Text(
                      'Edit Profile',
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
                _buildTabButton("ABOUT"),
                _buildTabButton("EVENT"),
              ],
            ),
            _buildTabContent(),
          ],
        ),
      ),
      floatingActionButton: _currentTab == "EVENT"
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: OutlinedButton(
                onPressed: () {
                  // Navigate to add event screen
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
    if (_currentTab == "ABOUT") {
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
    } else if (_currentTab == "EVENT") {
      return SingleChildScrollView(
        child: Column(
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
            _buildEventCard(
              "A virtual evening of smooth jazz",
              '1ST MAY-SAT-2:00 PM',
              'Al-Ula',
              'assets/w.JPG', // Replace with your image path
            ),
            _buildEventCard(
              "Jo malone london's mother's day",
              "1ST MAY-SAT-2:00 PM",
              'Jeddah',
              'assets/ww.JPG', // Replace with your image path
            ),
            _buildEventCard(
              "Women's leadership conference",
              "1ST MAY-SAT-2:00 PM",
              'Al-Ula',
              'assets/w.JPG', // Replace with your image path
            ),
          ],
        ),
      );
    } else {
      return const Text("Invalid tab");
    }
  }

  Widget _buildEventCard(
    String title,
    String time,
    String location,
    String image,
  ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.asset(
          image,
          width: 50, // Adjust size as needed
          height: 200,
          fit: BoxFit.fill,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(location),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
