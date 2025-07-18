import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/utils/components/button.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';
import 'package:trade_with_shaw/utils/components/textfield.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  String? _error;
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    if (_passwordController.text != _confirmController.text) {
      setState(() {
        _error = 'Passwords do not match';
        _loading = false;
      });
      return;
    }
    try {
      final api = Provider.of<ApiProvider>(context, listen: false);
      await api.register(_emailController.text, _passwordController.text);
      // Store JWT token if available
      final token = api.jwtToken;
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
      }
      if (api.user != null) {
        // Navigate to login page (replace with your login page route)
        Navigator.of(context).pushReplacementNamed('/login');
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
        _loading = false;
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                    controller: _confirmController,
                  ),
                  MyButton(
                    loading: _loading,
                    buttontext: 'Register',
                    onTap: _loading ? () {} : _register,
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
