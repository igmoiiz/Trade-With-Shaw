// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const CommentButton({super.key, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(Icons.mode_comment_outlined, color: Colors.white70, size: 24),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
