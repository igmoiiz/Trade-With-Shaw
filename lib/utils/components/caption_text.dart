// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CaptionText extends StatefulWidget {
  final String caption;
  const CaptionText({super.key, required this.caption});

  @override
  State<CaptionText> createState() => _CaptionTextState();
}

class _CaptionTextState extends State<CaptionText> {
  bool expanded = false;
  static const int maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final text = widget.caption;
    final isLong = text.split(' ').length > 20 || text.length > 120;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Text(
            text,
            maxLines: expanded ? null : maxLines,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (isLong && !expanded)
          GestureDetector(
            onTap: () => setState(() => expanded = true),
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'See more',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
