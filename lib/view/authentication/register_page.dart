// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/input_controllers.dart';
import 'package:trade_with_shaw/utils/components/button.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';
import 'package:trade_with_shaw/utils/components/textfield.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trade_with_shaw/view/authentication/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  //  Instances for controllers, errors and secure storage
  final Controllers _controllers = Controllers();
  String? _error;
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _controllers.emailController.dispose();
    _controllers.passwordController.dispose();
    _controllers.confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _controllers.loading = true;
      _error = null;
    });
    if (_controllers.passwordController.text !=
        _controllers.confirmPasswordController.text) {
      setState(() {
        _error = 'Passwords do not match';
        _controllers.loading = false;
      });
      return;
    }
    try {
      final api = Provider.of<ApiProvider>(context, listen: false);
      await api.register(
        _controllers.emailController.text.trim(),
        _controllers.passwordController.text.trim(),
      );
      // Store JWT token if available
      final token = api.jwtToken;
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
      }
      if (api.user != null) {
        // Navigate to login page (replace with your login page route)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
    final theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
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
                      child: Icon(
                        Icons.visibility_sharp,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    labelText: 'Password',
                    obscure: true,
                    controller: _controllers.passwordController,
                  ),
                  MyTextfield(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Icon(
                        Icons.visibility_sharp,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    labelText: 'Confirm Password',
                    obscure: true,
                    controller: _controllers.confirmPasswordController,
                  ),
                  MyButton(
                    loading: _controllers.loading,
                    buttontext: 'Register',
                    onTap:
                        _controllers.loading
                            ? CircularProgressIndicator.adaptive
                            : _register,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
