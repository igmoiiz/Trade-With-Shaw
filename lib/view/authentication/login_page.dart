// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/input_controllers.dart';
import 'package:trade_with_shaw/utils/components/button.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';
import 'package:trade_with_shaw/utils/components/textfield.dart';
import 'package:trade_with_shaw/view/authentication/register_page.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trade_with_shaw/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //  Instance for input controllers, errors and secure storage
  final Controllers _controllers = Controllers();
  String? _error;
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _controllers.emailController.dispose();
    _controllers.passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _controllers.loading = true;
      _error = null;
    });
    try {
      final api = Provider.of<ApiProvider>(context, listen: false);
      await api.login(
        _controllers.emailController.text.trim(),
        _controllers.passwordController.text.trim(),
      );
      // Store JWT token if available
      final token = api.jwtToken;
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
      }
      if (api.user != null) {
        // Navigate to home page (replace with your home page route)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (api.error != null) {
        setState(() {
          _error = api.error;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _controllers.loading = false;
      });
    }
  }

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
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(_error!, style: TextStyle(color: Colors.red)),
                  ),
                MyTextfield(
                  suffixIcon: null,
                  labelText: 'Email',
                  obscure: false,
                  controller: _controllers.emailController,
                ),
                MyTextfield(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Icon(Icons.visibility_sharp),
                  ),
                  labelText: 'Password',
                  obscure: true,
                  controller: _controllers.passwordController,
                ),
                MyButton(
                  loading: _controllers.loading,
                  buttontext: 'Login',
                  onTap:
                      _controllers.loading
                          ? CircularProgressIndicator.adaptive
                          : _login,
                ),
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
                              'Do Not Have An Account?',
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
                        builder: (context) => const RegistrationPage(),
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
