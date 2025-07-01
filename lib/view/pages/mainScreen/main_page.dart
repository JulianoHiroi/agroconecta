import 'package:agroconecta/view/pages/mainScreen/pages.dart';
import 'package:agroconecta/view/pages/mainScreen/search/search_page.dart';
import 'package:agroconecta/view/pages/mainScreen/settings/settings_page.dart';
import 'package:agroconecta/view/widgets/navigation/custom_navigation_button.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    SearchMapPage(),
    MessagePage(),
    OrdersPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
        onItemTapped: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
