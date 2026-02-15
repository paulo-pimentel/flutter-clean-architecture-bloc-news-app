import 'package:equatable/equatable.dart';

/// Domain entity representing a news article.
///
/// This is the core business object used throughout the app.
/// It is independent of any data sources or external APIs.
class Article extends Equatable {
  const Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.author,
    required this.url,
    required this.sourceName,
  });

  /// The headline or title of the article.
  final String title;

  /// A description or snippet from the article.
  final String description;

  /// The URL to a relevant image for the article.
  final String imageUrl;

  /// The date and time that the article was published.
  final DateTime publishedAt;

  /// The author of the article.
  final String author;

  /// The direct URL to the full article.
  final String url;

  /// The name of the source this article came from.
  final String sourceName;

  /// Returns `true` if the article has a valid image URL.
  bool get hasImage => imageUrl.isNotEmpty;

  /// Returns `true` if the article has a valid URL for viewing.
  bool get hasValidUrl => url.isNotEmpty && Uri.tryParse(url) != null;

  @override
  List<Object> get props => [
    title,
    description,
    imageUrl,
    publishedAt,
    author,
    url,
    sourceName,
  ];
}
