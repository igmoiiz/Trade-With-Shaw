import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 20,
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
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
