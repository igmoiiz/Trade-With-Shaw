// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class GainsPage extends StatelessWidget {
  const GainsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Trading Gains',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              _GlassStatsCard(),
              const SizedBox(height: 24),
              Text(
                'Performance (Last 7 Days)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: _AnimatedBarChart()),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AnimatedCounter(label: 'Total Trades', value: 128),
              _AnimatedCounter(label: 'Wins', value: 97, badge: true),
              _AnimatedCounter(label: 'Losses', value: 31, badge: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCounter extends StatefulWidget {
  final String label;
  final int value;
  final bool badge;
  const _AnimatedCounter({
    required this.label,
    required this.value,
    this.badge = false,
  });

  @override
  State<_AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<_AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder:
                  (context, child) => Text(
                    _animation.value.toString(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: widget.badge ? Colors.greenAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
            ),
            if (widget.badge)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _AnimatedBarChart extends StatefulWidget {
  @override
  State<_AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<_AnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<double> data = [5, 7, 3, 8, 6, 9, 4];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(data, _animation),
      child: Container(),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> data;
  final Animation<double> animation;
  _BarChartPainter(this.data, this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (data.length * 2);
    final maxVal = data.reduce(max);
    final paint =
        Paint()
          ..color = const Color(0xFFF9A825).withOpacity(0.85)
          ..style = PaintingStyle.fill;
    final bgPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.07)
          ..style = PaintingStyle.fill;
    // Draw background bars
    for (int i = 0; i < data.length; i++) {
      final x = (i * 2 + 1) * barWidth;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 0, barWidth, size.height),
          const Radius.circular(8),
        ),
        bgPaint,
      );
    }
    // Draw animated bars
    for (int i = 0; i < data.length; i++) {
      final x = (i * 2 + 1) * barWidth;
      final barHeight = (data[i] / maxVal) * size.height * animation.value;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
          const Radius.circular(8),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) => true;
}
