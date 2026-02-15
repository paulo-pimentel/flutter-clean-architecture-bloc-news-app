import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/article.dart';
import 'article_card.dart';

/// Widget displaying a scrollable list of articles.
///
/// Supports navigation to article detail page on tap.
class ArticleList extends StatelessWidget {
  const ArticleList({required this.articles, super.key});

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return Center(
        child: Text(
          'No articles available',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < articles.length - 1 ? 16 : 0,
          ),
          child: ArticleCard(
            article: article,
            onTap: article.hasValidUrl
                ? () => _navigateToDetail(context, article)
                : null,
          ),
        );
      },
    );
  }

  /// Navigates to the article detail page.
  void _navigateToDetail(BuildContext context, Article article) {
    context.pushNamed('articleDetail', extra: article);
  }
}
