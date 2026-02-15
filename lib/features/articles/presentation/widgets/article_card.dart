import 'package:flutter/material.dart';

import '../../domain/entities/article.dart';
import 'article_date_label.dart';
import 'article_image.dart';

/// Card widget for displaying a single article.
///
/// Shows:
/// - Article image (or "NO IMAGE" placeholder)
/// - Title
/// - Description
/// - Source name and publication date
///
/// Tapping the card triggers the [onTap] callback.
class ArticleCard extends StatelessWidget {
  const ArticleCard({required this.article, this.onTap, super.key});

  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article image
            ArticleImage(imageUrl: article.imageUrl),
            // Article content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Description
                  if (article.description.isNotEmpty) ...[
                    Text(
                      article.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Footer: Source and date
                  Row(
                    children: [
                      // Source name
                      if (article.sourceName.isNotEmpty) ...[
                        Icon(
                          Icons.source_outlined,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            article.sourceName,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: colorScheme.primary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      // Date
                      ArticleDateLabel(publishedAt: article.publishedAt),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
