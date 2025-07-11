// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:trade_with_shaw/utils/components/comments_sheet.dart';

import 'package:trade_with_shaw/utils/components/feed_post_card.dart';

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
      'time': '2 min ago',
      'image':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'caption':
          '🚀 EUR/USD breakout! Watch for the retest at 1.0850. This is a great opportunity for a quick scalp. Remember to manage your risk and stick to your plan. #forex #trading #signals',
      'likes': 12,
      'comments': [
        {'user': 'Alice', 'text': 'Great call!'},
        {'user': 'Bob', 'text': 'Thanks for the update!'},
      ],
    },
    {
      'time': '10 min ago',
      'image':
          'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=800&q=80',
      'caption':
          'GBP/USD is showing strong bullish momentum after the London open. Expecting a move towards 1.2750. Patience is key! 📈\n\nHere is a longer caption to test how the UI handles large text. The market is volatile, so always use a stop loss and never risk more than you can afford to lose. Stay disciplined and keep learning every day. #traderlife',
      'likes': 8,
      'comments': [
        {'user': 'Charlie', 'text': 'Very helpful!'},
      ],
    },
    {
      'time': '1 hour ago',
      'image':
          'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80',
      'caption':
          'New premium signal: Buy XAU/USD at 2320, TP: 2335, SL: 2312. Only for premium members! 🔒',
      'likes': 20,
      'comments': [],
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

  void _toggleLike(int index) {
    setState(() {
      feed[index]['liked'] = !(feed[index]['liked'] ?? false);
      if (feed[index]['liked']) {
        feed[index]['likes']++;
      } else {
        feed[index]['likes']--;
      }
    });
  }

  void _showComments(BuildContext context, int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => CommentsSheet(
            comments: List<Map<String, String>>.from(feed[index]['comments']),
            onAdd: (String text) {
              setState(() {
                feed[index]['comments'].add({'user': 'You', 'text': text});
              });
            },
          ),
    );
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
                  child: FeedPostCard(
                    time: post['time'],
                    image: post['image'],
                    caption: post['caption'],
                    likes: post['likes'],
                    liked: post['liked'] ?? false,
                    commentsCount: post['comments'].length,
                    onLike: () => _toggleLike(index),
                    onComment: () => _showComments(context, index),
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
