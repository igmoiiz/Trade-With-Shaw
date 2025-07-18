import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  /// The text to display on the button.
  final String buttontext;

  /// The callback to execute when the button is tapped.
  final VoidCallback onTap;

  /// Whether to display the loading indicator.
  final bool loading;

  const MyButton({
    super.key,
    required this.buttontext,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 12, left: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 60),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.primary,
          ),
          child:
              loading
                  ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .41,
                      vertical: MediaQuery.of(context).size.height * .015,
                    ),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                  : Center(
                    child: Text(
                      buttontext,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
        ),
      ),
    );
  }
}
