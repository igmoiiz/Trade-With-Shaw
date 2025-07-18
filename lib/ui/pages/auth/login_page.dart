import 'package:flutter/material.dart';
import 'package:trade_with_shaw/ui/components/button.dart';
import 'package:trade_with_shaw/ui/components/logo_image.dart';
import 'package:trade_with_shaw/ui/components/textfield.dart';
import 'package:trade_with_shaw/ui/pages/auth/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const LogoImage(),
            Column(
              children: [
                Column(
                  children: [
                    MyTextfield(
                      suffixIcon: null,
                      labelText: 'Email',
                      obscure: false,
                      controller: TextEditingController(),
                    ),
                    MyTextfield(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Icon(Icons.visibility_sharp),
                      ),
                      labelText: 'Password',
                      obscure: false,
                      controller: TextEditingController(),
                    ),
                  ],
                ),
                MyButton(loading: false, buttontext: 'Login', onTap: () {}),
                Padding(
                  padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Do Not Have A Account?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white)),
                    ],
                  ),
                ),
                MyButton(
                  loading: false,
                  buttontext: 'Register',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
