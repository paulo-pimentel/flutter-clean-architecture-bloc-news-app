import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

/// Key for storing cached articles in SharedPreferences.
const String cachedArticlesKey = 'CACHED_ARTICLES';

/// Key for storing cache timestamp in SharedPreferences.
const String cachedTimestampKey = 'CACHED_TIMESTAMP';

/// Abstract interface for local article data source.
///
/// Handles caching articles locally for offline access.
abstract interface class ArticleLocalDataSource {
  /// Gets the last cached articles.
  ///
  /// Throws [CacheException] if no cached data exists.
  Future<List<ArticleModel>> getLastArticles();

  /// Caches articles with current timestamp.
  ///
  /// This will overwrite any previously cached articles.
  Future<void> cacheArticles(List<ArticleModel> articles);

  /// Gets the timestamp when articles were last cached.
  ///
  /// Returns `null` if no cache exists.
  Future<DateTime?> getCachedTimestamp();
}

/// Implementation of [ArticleLocalDataSource] using SharedPreferences.
///
/// Stores articles as JSON string and timestamp as milliseconds since epoch.
class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  const ArticleLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<List<ArticleModel>> getLastArticles() {
    final jsonString = sharedPreferences.getString(cachedArticlesKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final jsonList = json.decode(jsonString) as List<dynamic>;
        final articles = jsonList
            .map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return Future.value(articles);
      } catch (e) {
        throw CacheException('Failed to parse cached articles: $e');
      }
    } else {
      throw const CacheException('No cached articles found');
    }
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final jsonList = articles.map((article) => article.toJson()).toList();
    final jsonString = json.encode(jsonList);

    await sharedPreferences.setString(cachedArticlesKey, jsonString);
    await sharedPreferences.setInt(
      cachedTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<DateTime?> getCachedTimestamp() async {
    final timestamp = sharedPreferences.getInt(cachedTimestampKey);

    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
}
