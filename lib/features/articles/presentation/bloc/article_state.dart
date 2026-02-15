part of 'article_bloc.dart';

/// Sealed class for article states.
sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken.
///
/// This state is emitted when the BLoC is first created,
/// before any [FetchArticles] event is dispatched.
final class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

/// Loading state while fetching articles.
///
/// Emitted when [FetchArticles] is dispatched.
/// The UI should display a loading indicator.
final class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

/// Success state with loaded articles.
///
/// The UI should display the article list.
/// [loadTime] ensures each emission is unique for pull-to-refresh.
final class ArticleLoaded extends ArticleState {
  ArticleLoaded({required this.articles}) : loadTime = DateTime.now();

  final List<Article> articles;
  final DateTime loadTime;

  @override
  List<Object?> get props => [articles, loadTime];
}

/// Error state when fetching fails and no cache is available.
///
/// Contains a user-friendly error [message] to display.
final class ArticleError extends ArticleState {
  const ArticleError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
