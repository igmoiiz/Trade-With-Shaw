import 'package:flutter/material.dart';
import 'package:trade_with_shaw/utils/theme/theme.dart';
import 'package:trade_with_shaw/view/interface/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: applicationTheme,
      title: 'Trade With Shaw',
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
