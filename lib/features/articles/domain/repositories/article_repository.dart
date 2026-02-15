import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/article.dart';

/// Abstract repository contract for article operations.
///
/// Returns [Either] type for functional error handling:
/// - [Left]: Contains [Failure] when the operation fails
/// - [Right]: Contains [List<Article>] when the operation succeeds
abstract interface class ArticleRepository {
  /// Fetches the list of articles.
  ///
  /// Possible failures:
  /// - [ServerFailure]: When the API request fails
  /// - [CacheFailure]: When offline with no cached data
  /// - [ApiKeyNotConfiguredFailure]: When API key is not set
  Future<Either<Failure, List<Article>>> getArticles();
}
