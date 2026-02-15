import 'package:dartz/dartz.dart';
import 'package:flutter_news_portfolio/core/error/exceptions.dart';
import 'package:flutter_news_portfolio/core/error/failures.dart';
import 'package:flutter_news_portfolio/core/network/network_info.dart';
import 'package:flutter_news_portfolio/features/articles/data/datasources/article_local_data_source.dart';
import 'package:flutter_news_portfolio/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:flutter_news_portfolio/features/articles/data/models/article_model.dart';
import 'package:flutter_news_portfolio/features/articles/data/repositories/article_repository_impl.dart';
import 'package:flutter_news_portfolio/features/articles/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ArticleRemoteDataSource {}

class MockLocalDataSource extends Mock implements ArticleLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticleRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tArticleModels = [
    ArticleModel(
      title: 'Test Article',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2025-02-14T10:00:00.000Z'),
      author: 'Test Author',
      url: 'https://example.com/article',
      sourceName: 'Test Source',
    ),
  ];

  final List<Article> tArticles = tArticleModels;

  void runTestsOnline(void Function() body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(void Function() body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('ArticleRepositoryImpl', () {
    group('getArticles', () {
      test('should check if the device is online', () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getArticles(),
        ).thenAnswer((_) async => tArticleModels);
        when(
          () => mockLocalDataSource.cacheArticles(any()),
        ).thenAnswer((_) async {});

        // act
        await repository.getArticles();

        // assert
        verify(() => mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            // arrange
            when(
              () => mockRemoteDataSource.getArticles(),
            ).thenAnswer((_) async => tArticleModels);
            when(
              () => mockLocalDataSource.cacheArticles(any()),
            ).thenAnswer((_) async {});

            // act
            final result = await repository.getArticles();

            // assert
            verify(() => mockRemoteDataSource.getArticles());
            expect(result, Right<Failure, List<Article>>(tArticles));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            // arrange
            when(
              () => mockRemoteDataSource.getArticles(),
            ).thenAnswer((_) async => tArticleModels);
            when(
              () => mockLocalDataSource.cacheArticles(any()),
            ).thenAnswer((_) async {});

            // act
            await repository.getArticles();

            // assert
            verify(() => mockRemoteDataSource.getArticles());
            verify(() => mockLocalDataSource.cacheArticles(tArticleModels));
          },
        );

        test(
          'should return cached data when the call to remote data source fails with ServerException',
          () async {
            // arrange
            when(
              () => mockRemoteDataSource.getArticles(),
            ).thenThrow(const ServerException());
            when(
              () => mockLocalDataSource.getLastArticles(),
            ).thenAnswer((_) async => tArticleModels);

            // act
            final result = await repository.getArticles();

            // assert
            verify(() => mockRemoteDataSource.getArticles());
            verify(() => mockLocalDataSource.getLastArticles());
            expect(result, Right<Failure, List<Article>>(tArticles));
          },
        );

        test(
          'should return CacheFailure when remote fails and no cache exists',
          () async {
            // arrange
            when(
              () => mockRemoteDataSource.getArticles(),
            ).thenThrow(const ServerException());
            when(
              () => mockLocalDataSource.getLastArticles(),
            ).thenThrow(const CacheException());

            // act
            final result = await repository.getArticles();

            // assert
            verify(() => mockRemoteDataSource.getArticles());
            verify(() => mockLocalDataSource.getLastArticles());
            expect(result, const Left<Failure, List<Article>>(CacheFailure()));
          },
        );

        test(
          'should return ApiKeyNotConfiguredFailure when API key is not set',
          () async {
            // arrange
            when(
              () => mockRemoteDataSource.getArticles(),
            ).thenThrow(const ApiKeyNotConfiguredException());

            // act
            final result = await repository.getArticles();

            // assert
            verify(() => mockRemoteDataSource.getArticles());
            verifyZeroInteractions(mockLocalDataSource);
            expect(
              result,
              const Left<Failure, List<Article>>(ApiKeyNotConfiguredFailure()),
            );
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last cached data when device is offline and cache exists',
          () async {
            // arrange
            when(
              () => mockLocalDataSource.getLastArticles(),
            ).thenAnswer((_) async => tArticleModels);

            // act
            final result = await repository.getArticles();

            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastArticles());
            expect(result, Right<Failure, List<Article>>(tArticles));
          },
        );

        test(
          'should return CacheFailure when device is offline and no cache exists',
          () async {
            // arrange
            when(
              () => mockLocalDataSource.getLastArticles(),
            ).thenThrow(const CacheException());

            // act
            final result = await repository.getArticles();

            // assert
            verifyZeroInteractions(mockRemoteDataSource);
            verify(() => mockLocalDataSource.getLastArticles());
            expect(result, const Left<Failure, List<Article>>(CacheFailure()));
          },
        );
      });
    });
  });
}
