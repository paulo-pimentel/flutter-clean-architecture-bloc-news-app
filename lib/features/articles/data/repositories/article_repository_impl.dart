import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_local_data_source.dart';
import '../datasources/article_remote_data_source.dart';

/// Implementation of [ArticleRepository].
///
/// Handles the data fetching strategy:
/// - When online: Fetch from remote API, cache result, return data
/// - When offline: Return cached data if available
/// - API key errors are returned immediately without fallback to cache
class ArticleRepositoryImpl implements ArticleRepository {
  const ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Article>>> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getArticles();
        await localDataSource.cacheArticles(remoteArticles);
        return Right(remoteArticles);
      } on ApiKeyNotConfiguredException {
        // API key error takes priority - don't fall back to cache
        return const Left(ApiKeyNotConfiguredFailure());
      } on ServerException {
        // Server error - try to return cached data
        return _getCachedArticlesOrFail();
      }
    } else {
      // Offline - try to return cached data
      return _getCachedArticlesOrFail();
    }
  }

  Future<Either<Failure, List<Article>>> _getCachedArticlesOrFail() async {
    try {
      final localArticles = await localDataSource.getLastArticles();
      return Right(localArticles);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
