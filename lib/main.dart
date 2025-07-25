import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_with_shaw/consts.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:trade_with_shaw/utils/theme/theme.dart';
import 'package:trade_with_shaw/view/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Supabase Initialization
  await Supabase.initialize(url: supabase_url, anonKey: supabase_anon_key);

  //  Run the application
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ApiProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TWS',
      debugShowCheckedModeBanner: false,
      theme: applicationTheme,
      home: const HomePage(),
    );
  }
}
