import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trade_with_shaw/view/authentication/login_page.dart';
import 'package:trade_with_shaw/view/home_page.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _storage.read(key: 'jwt_token');
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Optional: for splash effect
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      // Set token in ApiProvider for session management
      Provider.of<ApiProvider>(context, listen: false).setToken(token);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: LogoImage()),
          Text(
            "Please Wait While We are Loading the Session..",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
