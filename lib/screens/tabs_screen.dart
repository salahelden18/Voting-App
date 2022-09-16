import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home_screen.dart';
import '../screens/user_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const UserScreen(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        selectedItemColor: forthColor,
        unselectedItemColor: secondaryColor,
        iconSize: 30,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: onTap,
        currentIndex: currentIndex,
      ),
      body: pages[currentIndex],
    );
  }
}
