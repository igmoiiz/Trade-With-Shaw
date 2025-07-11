// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trade_with_shaw/utils/components/animated_image.dart';
import 'package:trade_with_shaw/utils/components/caption_text.dart';
import 'package:trade_with_shaw/utils/components/comment_button.dart';
import 'package:trade_with_shaw/utils/components/like_button.dart';

class FeedPostCard extends StatelessWidget {
  final String time;
  final String image;
  final String caption;
  final int likes;
  final bool liked;
  final int commentsCount;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const FeedPostCard({
    super.key,
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
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        radius: 24,

                        child: Image.asset('assets/TWS.png', fit: BoxFit.cover),
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
                AnimatedImage(imageUrl: image),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: CaptionText(caption: caption),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      LikeButton(liked: liked, count: likes, onTap: onLike),
                      const SizedBox(width: 18),
                      CommentButton(count: commentsCount, onTap: onComment),
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
