import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/article.dart';
import '../repositories/article_repository.dart';

/// Use case for fetching articles.
///
/// This class encapsulates the business logic for retrieving news articles.
class GetArticles {
  const GetArticles(this.repository);

  final ArticleRepository repository;

  /// Executes the use case to fetch articles.
  ///
  /// Returns [Either] with:
  /// - [Left<Failure>]: On error (server, cache, or API key issues)
  /// - [Right<List<Article>>]: On success with the list of articles
  Future<Either<Failure, List<Article>>> call() => repository.getArticles();
}
