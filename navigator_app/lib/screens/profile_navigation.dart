import 'package:flutter/material.dart';
import 'package:navigator_app/constant/tool_utilities.dart';
import 'package:navigator_app/screens/explore_screen.dart';
import 'package:navigator_app/screens/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> listScreen = [
    Container(),
    Container(),
    const ExploreScreen(),
    Container(),
    const ProfileScreen(),
  ];
  List<String> listName = [
    "Settings",
    "Events",
    "Explore",
    "Map",
    "Profile",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w900,
        ),
        selectedItemColor:
            ToolsUtilites.buttonColor, // Change this color for selected item
        unselectedItemColor: ToolsUtilites.blackColor,
        selectedIconTheme: const IconThemeData(
          color: ToolsUtilites.buttonColor,
        ),
        backgroundColor: ToolsUtilites.backGroundColor,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        onTap: _onItemTapped,
      ),
    );
  }
}
