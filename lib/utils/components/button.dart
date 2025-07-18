// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttontext;
  final VoidCallback onTap;
  final bool loading;

  const MyButton({
    super.key,
    required this.buttontext,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          constraints: const BoxConstraints(minWidth: 60),
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(color: Colors.white, width: 0.1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.098), // 🌟 Lighter shadow
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              loading
                  ? Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                  : Center(
                    child: Text(
                      buttontext,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
