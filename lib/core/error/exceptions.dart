/// Exception thrown when a server request fails.
class ServerException implements Exception {
  const ServerException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'ServerException: $message' : 'ServerException';
}

/// Exception thrown when cache operations fail.
class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;

  @override
  String toString() =>
      message != null ? 'CacheException: $message' : 'CacheException';
}

/// Exception thrown when the API key is not configured.
class ApiKeyNotConfiguredException implements Exception {
  const ApiKeyNotConfiguredException();

  @override
  String toString() => 'ApiKeyNotConfiguredException: NEWS_API_KEY is not set';
}
