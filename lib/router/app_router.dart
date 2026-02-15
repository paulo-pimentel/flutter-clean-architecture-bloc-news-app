import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/articles/domain/entities/article.dart';
import '../features/articles/presentation/pages/article_detail_page.dart';
import '../features/articles/presentation/pages/article_list_page.dart';

/// App router configuration using go_router.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Article list page (home)
    GoRoute(
      path: '/',
      name: 'articleList',
      builder: (context, state) => const ArticleListPage(),
    ),
    // Article detail page (WebView)
    GoRoute(
      path: '/article',
      name: 'articleDetail',
      builder: (context, state) {
        // Get article from extra parameter
        final article = state.extra;
        if (article is! Article) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Invalid article data')),
          );
        }

        return ArticleDetailPage(article: article);
      },
    ),
  ],
);
