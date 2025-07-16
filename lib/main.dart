import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_with_shaw/consts.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Supabase Initialization
  await Supabase.initialize(url: supabase_url, anonKey: supabase_anon_key);

  //  Run the Application
  runApp(
    MaterialApp(
      title: 'Trade With Shaw',
      debugShowCheckedModeBanner: false,
      home: const TradeWithShawApp(),
    ),
  );
}
