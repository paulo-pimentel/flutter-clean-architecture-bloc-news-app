import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/article_bloc.dart';
import '../widgets/widgets.dart';

/// Main page displaying the list of articles.
///
/// Features:
/// - Pull-to-refresh functionality
/// - Loading, error, and success states
/// - Navigation to article detail page
///
/// Uses [BlocBuilder] to react to state changes from [ArticleBloc].
class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Business News'), centerTitle: true),
    body: BlocBuilder<ArticleBloc, ArticleState>(
      builder: (context, state) => switch (state) {
        ArticleInitial() => const SizedBox.shrink(),
        ArticleLoading() => const LoadingWidget(),
        ArticleError(:final message) => ErrorDisplayWidget(
          message: message,
          onRetry: () => context.read<ArticleBloc>().add(const FetchArticles()),
        ),
        ArticleLoaded(:final articles) => RefreshIndicator(
          onRefresh: () async {
            context.read<ArticleBloc>().add(const RefreshArticles());
            await context.read<ArticleBloc>().stream.first;
          },
          child: ArticleList(articles: articles),
        ),
      },
    ),
  );
}
