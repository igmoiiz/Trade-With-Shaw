import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> feed = [
    {
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
      'username': 'shawtrader',
      'time': '2 min ago',
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'caption':
          '🚀 EUR/USD breakout! Watch for the retest at 1.0850. This is a great opportunity for a quick scalp. Remember to manage your risk and stick to your plan. #forex #trading #signals',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
      'username': 'forexqueen',
      'time': '10 min ago',
      'image':
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=800&q=80',
      'caption':
          'GBP/USD is showing strong bullish momentum after the London open. Expecting a move towards 1.2750. Patience is key! 📈\n\nHere is a longer caption to test how the UI handles large text. The market is volatile, so always use a stop loss and never risk more than you can afford to lose. Stay disciplined and keep learning every day. #traderlife',
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/65.jpg',
      'username': 'pipmaster',
      'time': '1 hour ago',
      'image':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80',
      'caption':
          'New premium signal: Buy XAU/USD at 2320, TP: 2335, SL: 2312. Only for premium members! 🔒',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16,
                ),
                child: Text(
                  'Feed & News',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = feed[index];
                return FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        0.1 * index,
                        0.6 + 0.2 * index,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: _FeedPostCard(
                    avatar: post['avatar'],
                    username: post['username'],
                    time: post['time'],
                    image: post['image'],
                    caption: post['caption'],
                  ),
                );
              }, childCount: feed.length),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final String avatar;
  final String username;
  final String time;
  final String image;
  final String caption;

  const _FeedPostCard({
    required this.avatar,
    required this.username,
    required this.time,
    required this.image,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 22.0, left: 12, right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(avatar),
                        radius: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              time,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _AnimatedImage(imageUrl: image),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: _CaptionText(caption: caption),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedImage extends StatelessWidget {
  final String imageUrl;
  const _AnimatedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null)
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: child,
              );
            return Center(
              child: CircularProgressIndicator(
                value:
                    progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            (progress.expectedTotalBytes ?? 1)
                        : null,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CaptionText extends StatefulWidget {
  final String caption;
  const _CaptionText({required this.caption});

  @override
  State<_CaptionText> createState() => _CaptionTextState();
}

class _CaptionTextState extends State<_CaptionText> {
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
