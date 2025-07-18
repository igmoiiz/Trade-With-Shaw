// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'package:trade_with_shaw/utils/components/comments_sheet.dart';
import 'package:trade_with_shaw/utils/components/feed_post_card.dart';
import 'package:trade_with_shaw/model/feed.dart';

class InterfacePage extends StatefulWidget {
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = Provider.of<ApiProvider>(context, listen: false);
      api.fetchFeed();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showComments(BuildContext context, Feed post) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => CommentsSheet(
            comments:
                post.comments
                    .map((c) => {'user': c.user, 'text': c.text})
                    .toList(),
            onAdd: (String text) async {
              await Provider.of<ApiProvider>(
                context,
                listen: false,
              ).postComment(post.id, text);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiProvider>(context);
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
        child:
            api.loading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16,
                        ),
                        child: Text(
                          'Feed & News',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (api.error != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            api.error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = api.feed[index];
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
                            time: post.createdAt?.toLocal().toString() ?? '',
                            image: post.imageUrl,
                            caption: post.caption,
                            likes: post.likes.length,
                            liked: post.likes.contains(api.user?.id ?? ''),
                            commentsCount: post.comments.length,
                            onLike: () => api.likeFeed(post.id),
                            onComment: () => _showComments(context, post),
                          ),
                        );
                      }, childCount: api.feed.length),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
      ),
    );
  }
}
