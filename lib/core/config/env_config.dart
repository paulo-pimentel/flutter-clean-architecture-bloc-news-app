import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for environment variables.
///
/// Loads environment variables from a `.env` file in the project root.
///
/// ## Setup
///
/// 1. Create a `.env` file in the project root:
/// ```env
/// NEWS_API_KEY=your_api_key_here
/// ```
///
/// 2. Add `.env` to `.gitignore` to keep your API key private.
///
/// 3. The `.env` file must be loaded before accessing any values:
///
/// ## Getting an API Key
///
/// Register for a free API key at: https://newsapi.org/register
abstract class EnvConfig {
  EnvConfig._();

  /// NewsAPI key loaded from .env file.
  static String get newsApiKey {
    try {
      return dotenv.env['NEWS_API_KEY'] ?? '';
    } on Object {
      return '';
    }
  }

  /// Returns `true` if the API key is configured.
  static bool get isApiKeyConfigured => newsApiKey.isNotEmpty;
}
