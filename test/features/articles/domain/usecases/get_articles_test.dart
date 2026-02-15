import 'package:dartz/dartz.dart';
import 'package:flutter_news_portfolio/core/error/failures.dart';
import 'package:flutter_news_portfolio/features/articles/domain/entities/article.dart';
import 'package:flutter_news_portfolio/features/articles/domain/repositories/article_repository.dart';
import 'package:flutter_news_portfolio/features/articles/domain/usecases/get_articles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticles usecase;
  late MockArticleRepository mockRepository;

  setUp(() {
    mockRepository = MockArticleRepository();
    usecase = GetArticles(mockRepository);
  });

  final tArticles = [
    Article(
      title: 'Test Article',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      publishedAt: DateTime.parse('2025-02-14T10:00:00.000Z'),
      author: 'Test Author',
      url: 'https://example.com/article',
      sourceName: 'Test Source',
    ),
  ];

  group('GetArticles', () {
    test('should get articles from the repository', () async {
      // arrange
      when(
        () => mockRepository.getArticles(),
      ).thenAnswer((_) async => Right(tArticles));

      // act
      final result = await usecase();

      // assert
      expect(result, Right<Failure, List<Article>>(tArticles));
      verify(() => mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // arrange
      when(
        () => mockRepository.getArticles(),
      ).thenAnswer((_) async => const Left(ServerFailure()));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left<Failure, List<Article>>(ServerFailure()));
      verify(() => mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when no cached data available', () async {
      // arrange
      when(
        () => mockRepository.getArticles(),
      ).thenAnswer((_) async => const Left(CacheFailure()));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left<Failure, List<Article>>(CacheFailure()));
      verify(() => mockRepository.getArticles());
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return ApiKeyNotConfiguredFailure when API key is not set',
      () async {
        // arrange
        when(
          () => mockRepository.getArticles(),
        ).thenAnswer((_) async => const Left(ApiKeyNotConfiguredFailure()));

        // act
        final result = await usecase();

        // assert
        expect(
          result,
          const Left<Failure, List<Article>>(ApiKeyNotConfiguredFailure()),
        );
        verify(() => mockRepository.getArticles());
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
