import 'package:flutter/material.dart';
import 'dart:ui';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  int? expandedIndex;

  final List<Map<String, dynamic>> plans = [
    {
      'title': 'TRADING KICKSTART',
      'price': ' 249',
      'oldPrice': ' 100',
      'duration': '1 Month',
      'features': [
        '10 Videos (5 Credit Hours)',
        'Goal: Teach students the essential trading concepts...',
        'Introduction to Forex Markets',
        'How Forex Trading Works',
        'Brokers & Trading Platforms',
        'Types of Orders in Forex Trading',
        'Trading Sessions & Market Timing',
        'Margin & Risk Management Basics',
        'Types of Traders',
        'Support & Resistance Basics',
      ],
      'highlight': true,
    },
    {
      'title': 'SMART MONEY',
      'price': ' 299',
      'oldPrice': ' 500',
      'duration': '2 Months',
      'features': [
        'Video-Based Learning with Limited Live Sessions',
        'Total Hours: 20+ Hours',
        'Advanced Technical Analysis',
        'Fundamental & Sentiment Analysis',
        'Liquidity & Stop Hunting',
        'Risk Management Mastery',
        'Backtesting & Strategy Development',
        'Advanced Indicators & Trading Tools',
        'Trading with Prop Firms & Funded Accounts',
        'Institutional Trading Concepts',
      ],
      'highlight': false,
    },
    {
      'title': 'DEEP DIVE PRO',
      'price': ' 999',
      'oldPrice': ' 1699',
      'duration': '3 Months',
      'features': [
        '1:1 Private Coaching + Live Sessions',
        'Total Hours: 40+ Hours',
        'Live Sessions: Personalized One-on-One Coaching',
        'Smart Money Concepts (SMC) & Institutional Trading',
        'Algorithmic Trading & Auto Trading Strategies',
        'Deep Risk Management & Psychology',
        'High-Level Market Manipulation & Stop Hunts',
        'Professional Strategy Development',
        'Pro-Level Trading Analytics',
        'Advanced Fundamental & Sentiment Analysis',
        'Prop Firm Trading & Large Capital Management',
      ],
      'highlight': true,
    },
  ];

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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          children: [
            _AnimatedIntro(),
            const SizedBox(height: 18),
            Text(
              'Subscription Plans',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              plans.length,
              (i) => _PlanCard(
                plan: plans[i],
                expanded: expandedIndex == i,
                onTap:
                    () => setState(
                      () => expandedIndex = expandedIndex == i ? null : i,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIntro extends StatefulWidget {
  @override
  State<_AnimatedIntro> createState() => _AnimatedIntroState();
}

class _AnimatedIntroState extends State<_AnimatedIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Trade With Shaw',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Trade With Shaw is dedicated to empowering traders with the best education, signals, and analytics. Choose a plan that fits your journey and unlock your trading potential!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final bool expanded;
  final VoidCallback onTap;
  const _PlanCard({
    required this.plan,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color:
                    plan['highlight']
                        ? Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.13)
                        : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      plan['highlight']
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.35)
                          : Colors.white10,
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        plan['highlight']
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.10)
                            : Colors.black.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan['title'],
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color:
                                  plan['highlight']
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (plan['highlight'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Best Value',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          plan['price'],
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          plan['oldPrice'],
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Colors.white38,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Icon(Icons.schedule, color: Colors.white38, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          plan['duration'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            plan['features'].length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      plan['features'][i],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    crossFadeState:
                        expanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 400),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text('Enroll Now'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
