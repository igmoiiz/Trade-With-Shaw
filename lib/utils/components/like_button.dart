// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final VoidCallback onTap;
  const LikeButton({
    super.key,
    required this.liked,
    required this.count,
    required this.onTap,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.liked != oldWidget.liked) {
      if (widget.liked) {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        if (!widget.liked) {
          _controller.forward(from: 0);
        }
      },
      child: Row(
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 1, end: 1.2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
            ),
            child: Icon(
              widget.liked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: widget.liked ? Colors.redAccent : Colors.white70,
              size: 26,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.count.toString(),
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
