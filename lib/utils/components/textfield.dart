// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';

/// A custom text field widget with a label, optional suffix icon, and validation.
class MyTextfield extends StatelessWidget {
  /// The label text to display above the text field.
  final String labelText;

  /// Whether the text field should obscure the input (e.g., for passwords).
  final bool obscure;

  /// The text editing controller for the text field.
  final TextEditingController controller;

  /// An optional suffix icon to display at the end of the text field.
  var suffixIcon;

  /// Creates a new instance of [MyTextfield].
  MyTextfield({
    super.key,
    required this.labelText,
    required this.obscure,
    required this.controller,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'This Field can\'t be empty';
          } else {
            return null;
          }
        },
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          suffix: suffixIcon,
          labelText: labelText,
          filled: true,
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ), // Default border color
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ), // Border color when focused
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
