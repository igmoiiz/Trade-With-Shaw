import 'dart:ui';
import 'package:flutter/material.dart';
import 'ui/components/glass_bottom_nav.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/signals_page.dart';
import 'ui/pages/gains_page.dart';
import 'ui/pages/notifications_page.dart';
import 'ui/pages/about_page.dart';

class TradeWithShawApp extends StatefulWidget {
  const TradeWithShawApp({Key? key}) : super(key: key);

  @override
  State<TradeWithShawApp> createState() => _TradeWithShawAppState();
}

class _TradeWithShawAppState extends State<TradeWithShawApp> {
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
