import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Widget for displaying article images with error handling.
///
/// Shows a "NO IMAGE" placeholder when:
/// - Image URL is empty
/// - Image fails to load
///
/// Uses [CachedNetworkImage] for efficient image loading and caching.
class ArticleImage extends StatelessWidget {
  const ArticleImage({required this.imageUrl, this.height = 200, super.key});

  final String imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    // If URL is empty, show placeholder immediately
    if (imageUrl.isEmpty) {
      return _NoImagePlaceholder(height: height);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => _NoImagePlaceholder(height: height),
    );
  }
}

/// Placeholder widget displayed when image is unavailable.
class _NoImagePlaceholder extends StatelessWidget {
  const _NoImagePlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Text(
          'NO IMAGE',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
