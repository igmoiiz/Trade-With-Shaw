import 'package:flutter/material.dart';

class AnimatedImage extends StatelessWidget {
  final String imageUrl;
  const AnimatedImage({super.key, required this.imageUrl});

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
            if (progress == null) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: child,
              );
            }
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
