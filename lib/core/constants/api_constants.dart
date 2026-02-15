/// Constants for API configuration.
///
/// Centralizes all API-related configuration values
/// for easy maintenance and testing.
abstract class ApiConstants {
  ApiConstants._();

  /// Base URL for the NewsAPI.
  static const String baseUrl = 'https://newsapi.org/v2';

  /// Country code for fetching news (US business news).
  static const String country = 'us';

  /// Category for fetching news.
  static const String category = 'business';

  /// HTTP header key for API authentication.
  static const String apiKeyHeader = 'X-Api-Key';

  /// Content-Type header value.
  static const String contentType = 'application/json';
}
