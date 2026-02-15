part of 'article_bloc.dart';

/// Sealed class for article events.
///
/// Events trigger state changes in [ArticleBloc].
sealed class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch articles.
///
/// Dispatched for initial load or manual refresh requests.
/// This event will show a loading indicator while fetching.
final class FetchArticles extends ArticleEvent {
  const FetchArticles();
}

/// Event triggered by pull-to-refresh.
///
/// Unlike [FetchArticles], this event does not show a full-screen
/// loading indicator, allowing the current content to remain visible
/// during the refresh operation.
final class RefreshArticles extends ArticleEvent {
  const RefreshArticles();
}
