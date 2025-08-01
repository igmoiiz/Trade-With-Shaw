import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trade_with_shaw/utils/components/glass_bottom_nav.dart';
import 'package:trade_with_shaw/view/interface/about_page.dart';
import 'package:trade_with_shaw/view/interface/interface_page.dart';
import 'package:trade_with_shaw/view/interface/notifications_page.dart';
import 'package:trade_with_shaw/view/interface/signals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _twsPages = const [
    InterfacePage(),
    SignalsPage(),
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
    log("$_selectedIndex");
    return Scaffold(
      extendBody: true,
      body: _twsPages[_selectedIndex],
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
