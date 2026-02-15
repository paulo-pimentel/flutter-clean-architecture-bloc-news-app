import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/env_config.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/article_model.dart';

/// Abstract interface for remote article data source.
///
/// Defines the contract for fetching articles from the NewsAPI.
abstract interface class ArticleRemoteDataSource {
  /// Fetches top headlines from NewsAPI.
  ///
  /// Throws:
  /// - [ApiKeyNotConfiguredException]: If API key is not configured
  /// - [ServerException]: If the request fails or returns non-200 status
  Future<List<ArticleModel>> getArticles();
}

/// Implementation of [ArticleRemoteDataSource] using HTTP.
///
/// Fetches US business news from NewsAPI's top-headlines endpoint.
class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  const ArticleRemoteDataSourceImpl({required this.client});

  final http.Client client;

  @override
  Future<List<ArticleModel>> getArticles() async {
    // Check if API key is configured before making request
    if (!EnvConfig.isApiKeyConfigured) {
      throw const ApiKeyNotConfiguredException();
    }

    // Build the request URL with query parameters
    final uri = Uri.parse('${ApiConstants.baseUrl}/top-headlines').replace(
      queryParameters: {
        'country': ApiConstants.country,
        'category': ApiConstants.category,
      },
    );

    try {
      final response = await client.get(
        uri,
        headers: {
          ApiConstants.apiKeyHeader: EnvConfig.newsApiKey,
          'Content-Type': ApiConstants.contentType,
        },
      );

      // 401/403 means invalid API key
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const ApiKeyNotConfiguredException();
      }

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body) as Map<String, dynamic>;
        final status = jsonBody['status'] as String?;
        final code = jsonBody['code'] as String?;

        // Check for API key related errors in response
        if (code == 'apiKeyInvalid' || code == 'apiKeyDisabled') {
          throw const ApiKeyNotConfiguredException();
        }

        if (status != 'ok') {
          throw ServerException('API returned status: $status');
        }

        final articlesJson = jsonBody['articles'] as List<dynamic>? ?? [];
        return articlesJson
            .map(
              (article) =>
                  ArticleModel.fromJson(article as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } on ApiKeyNotConfiguredException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }
}
