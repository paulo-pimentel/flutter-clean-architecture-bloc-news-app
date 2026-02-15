import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/article.dart';
import '../../domain/usecases/get_articles.dart';

part 'article_event.dart';
part 'article_state.dart';

/// BLoC for managing article state.
///
/// Handles [FetchArticles] and [RefreshArticles] events,
/// coordinating with the use case to fetch articles.
///
/// ## State Transitions
///
/// - [FetchArticles] → [ArticleLoading] → [ArticleLoaded] | [ArticleError]
/// - [RefreshArticles] → [ArticleLoaded] | [ArticleError] (no loading state)
///
/// ## Error Handling
///
/// Maps domain [Failure] types to user-friendly error messages.
class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc({required this.getArticles}) : super(const ArticleInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<RefreshArticles>(_onRefreshArticles);
  }

  final GetArticles getArticles;

  /// Handles [FetchArticles] event.
  ///
  /// Shows loading state, then fetches and emits results.
  Future<void> _onFetchArticles(
    FetchArticles event,
    Emitter<ArticleState> emit,
  ) async {
    emit(const ArticleLoading());
    await _fetchAndEmit(emit);
  }

  /// Handles [RefreshArticles] event.
  ///
  /// Fetches without showing loading state to keep content visible.
  Future<void> _onRefreshArticles(
    RefreshArticles event,
    Emitter<ArticleState> emit,
  ) async {
    await _fetchAndEmit(emit);
  }

  /// Fetches articles and emits the appropriate state.
  Future<void> _fetchAndEmit(Emitter<ArticleState> emit) async {
    final result = await getArticles();

    result.fold(
      (failure) => emit(ArticleError(message: _mapFailureToMessage(failure))),
      (articles) => emit(ArticleLoaded(articles: articles)),
    );
  }

  /// Maps a [Failure] to a user-friendly error message.
  String _mapFailureToMessage(Failure failure) => switch (failure) {
    ServerFailure() => 'Failed to fetch articles. Please try again.',
    CacheFailure() =>
      'No cached data available. Please connect to the internet.',
    ApiKeyNotConfiguredFailure() =>
      '''
News API key is not configured.

Please create a .env file in the project root with:
NEWS_API_KEY=your_api_key

Get your free API key at: https://newsapi.org/register''',
  };
}
