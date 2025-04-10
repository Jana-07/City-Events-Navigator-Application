import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navigator_app/constant/tool_utilities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.edit_calendar_rounded,
            color: ToolsUtilites.buttonColor,
          ),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Noura  \n0512345678  \nemail@gmail.com',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/person.JPG'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Interest',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: <Widget>[
                _buildInterestChip('Conferences'),
                _buildInterestChip('Sport'),
                _buildInterestChip('Festivals'),
                _buildInterestChip('Art'),
                _buildInterestChip('Movie'),
                _buildInterestChip('Others'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildEventCard(
              'Winter at Tantora',
              '1ST MAY-SAT-2:00 PM',

              'Al-Ula',
              'assets/w.JPG', // Replace with your image path
            ),
            _buildEventCard(
              'Jeddah Season',
              '1ST MAY-SAT-2:00 PM',

              'Jeddah',

              'assets/ww.JPG', // Replace with your image path
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildEventCard(
              'Jeddah Season',
              '1ST MAY-SAT-2:00 PM',

              'Jeddah',

              'assets/ww.JPG', // Replace with your image path
            ),
            _buildEventCard(
              'Jeddah Season',
              '1ST MAY-SAT-2:00 PM',

              'Jeddah',
              'assets/ww.JPG', // Replace with your image path
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors
          .primaries[Random().nextInt(Colors.primaries.length)], // Random color
    );
  }

  Widget _buildEventCard(
    String time,
    String title,
    String subtitle,
    String image, {
    String? location,
    // Add image parameter
  }) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: Image.asset(
          image,
          width: 50, // Adjust size as needed
          height: 200,
          fit: BoxFit.fill,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.green,
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
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [const Icon(Icons.location_on), Text(subtitle)],
            ),
            //if (subtitle.isNotEmpty) Text(subtitle),
          ],
        ),
        trailing: const Icon(Icons.favorite_border),
      ),
    );
  }
}
