import '../../domain/entities/article.dart';

/// Data model for article with JSON serialization.
///
/// Extends [Article] entity and adds JSON conversion capabilities.
/// This class handles the mapping between JSON data from the API
/// and the domain entity.
class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.publishedAt,
    required super.author,
    required super.url,
    required super.sourceName,
  });

  /// Creates an [ArticleModel] from a JSON map.
  ///
  /// Handles null values by providing sensible defaults:
  /// - String fields default to empty string
  /// - Dates default to Unix epoch (1970-01-01) if invalid
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as Map<String, dynamic>?;
    final sourceName = source?['name'] as String? ?? '';

    return ArticleModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['urlToImage'] as String? ?? '',
      publishedAt: _parseDateTime(json['publishedAt'] as String?),
      author: json['author'] as String? ?? '',
      url: json['url'] as String? ?? '',
      sourceName: sourceName,
    );
  }

  /// Parses a date string to [DateTime].
  ///
  /// Returns Unix epoch (1970-01-01) if the string is null,
  /// empty, or cannot be parsed.
  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return DateTime.tryParse(dateString) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  /// Converts the model to a JSON map.
  ///
  /// Used for caching articles locally.
  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'urlToImage': imageUrl,
    'publishedAt': publishedAt.toIso8601String(),
    'author': author,
    'url': url,
    'source': {'name': sourceName},
  };
}
