import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile>
    with SingleTickerProviderStateMixin {
  String _currentTab = "ABOUT"; // Initial tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
        ),
        actions: const [Icon(Icons.more_vert)],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/person.JPG'),
            ),
            const Text(
              'Admin\n0512345678  \nadmin@gmail.com',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_calendar_outlined, color: Colors.blue),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFFFF),
                  side: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.blue),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Add Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
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
              ? Colors.blue
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
              child: const Divider(
                color: Colors.blue,
                indent: 2,
                endIndent: 4,
              ),
            ),
          ),
          const Text(
            "Enjoy your favorite dishe and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. ...Read More",
            style: TextStyle(fontSize: 16),
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
                child: const Divider(
                  color: Colors.blue,
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
            color: Colors.blue,
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
              height: 20,
            ),

            //if (subtitle.isNotEmpty) Text(subtitle),
          ],
        ),
        //trailing: const Icon(Icons.favorite_border),
      ),
    );
  }
}
