import 'package:flutter/material.dart';
import 'package:trade_with_shaw/ui/components/button.dart';
import 'package:trade_with_shaw/ui/components/logo_image.dart';
import 'package:trade_with_shaw/ui/components/textfield.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

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
                          child: Icon(
                            Icons.visibility_sharp,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        labelText: 'Password',
                        obscure: false,
                        controller: TextEditingController(),
                      ),
                      MyTextfield(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Icon(
                            Icons.visibility_sharp,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        labelText: 'ConfirmPassword',
                        obscure: false,
                        controller: TextEditingController(),
                      ),
                    ],
                  ),
                  MyButton(
                    loading: false,
                    buttontext: 'Register',
                    onTap: () {},
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
