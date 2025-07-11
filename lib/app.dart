import 'package:flutter/material.dart';
import 'ui/components/glass_bottom_nav.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/signals_page.dart';
import 'ui/pages/gains_page.dart';
import 'ui/pages/notifications_page.dart';
import 'ui/pages/about_page.dart';
import 'utils/theme/theme.dart';

class TradeWithShawApp extends StatelessWidget {
  const TradeWithShawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade With Shaw',
      debugShowCheckedModeBanner: false,
      theme: applicationTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SignalsPage(),
    GainsPage(),
    NotificationsPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
