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
          (_) => _CommentsSheet(
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
                  child: _FeedPostCard(
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

class _FeedPostCard extends StatelessWidget {
  final String time;
  final String image;
  final String caption;
  final int likes;
  final bool liked;
  final int commentsCount;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const _FeedPostCard({
    required this.time,
    required this.image,
    required this.caption,
    required this.likes,
    required this.liked,
    required this.commentsCount,
    required this.onLike,
    required this.onComment,
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
                        backgroundImage: AssetImage('assets/TWS.png'),
                        radius: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trade with Shaw',
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
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: _CaptionText(caption: caption),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      _LikeButton(liked: liked, count: likes, onTap: onLike),
                      const SizedBox(width: 18),
                      _CommentButton(count: commentsCount, onTap: onComment),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LikeButton extends StatefulWidget {
  final bool liked;
  final int count;
  final VoidCallback onTap;
  const _LikeButton({
    required this.liked,
    required this.count,
    required this.onTap,
  });

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(_LikeButton oldWidget) {
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
      lowerBound: 0.8,
      upperBound: 1.2,
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

class _CommentButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _CommentButton({required this.count, required this.onTap});

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

class _CommentsSheet extends StatefulWidget {
  final List<Map<String, String>> comments;
  final ValueChanged<String> onAdd;
  const _CommentsSheet({required this.comments, required this.onAdd});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  late List<Map<String, String>> _comments;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comments = List<Map<String, String>>.from(widget.comments);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _comments.add({'user': 'You', 'text': text});
      });
      widget.onAdd(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.18),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final c = _comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              c['user']![0].toUpperCase(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          title: Text(
                            c['user']!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            c['text']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.92),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white54,
                              ),
                              filled: true,
                              fillColor: Colors.white10,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _addComment(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _addComment,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
