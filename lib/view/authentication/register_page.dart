import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:trade_with_shaw/utils/components/button.dart';
import 'package:trade_with_shaw/utils/components/logo_image.dart';
import 'package:trade_with_shaw/utils/components/textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  String? _error;

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
      await Provider.of<ApiProvider>(
        context,
        listen: false,
      ).register(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
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
    return Scaffold(
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: ListView(
            children: [
              const LogoImage(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
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
                      child: Icon(Icons.visibility_sharp),
                    ),
                    labelText: 'Password',
                    obscure: true,
                    controller: _passwordController,
                  ),
                  MyTextfield(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Icon(Icons.visibility_sharp),
                    ),
                    labelText: 'Confirm Password',
                    obscure: true,
                    controller: _confirmController,
                  ),
                  MyButton(
                    loading: _loading,
                    buttontext: 'Register',
                    onTap: _loading ? () {} : () => _register(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 12,
                      left: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [Text('Already have an account?')],
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyButton(
                    loading: false,
                    buttontext: 'Login',
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
