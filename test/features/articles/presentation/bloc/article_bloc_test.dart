import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_news_portfolio/core/error/failures.dart';
import 'package:flutter_news_portfolio/features/articles/domain/entities/article.dart';
import 'package:flutter_news_portfolio/features/articles/domain/usecases/get_articles.dart';
import 'package:flutter_news_portfolio/features/articles/presentation/bloc/article_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetArticles extends Mock implements GetArticles {}

void main() {
  late ArticleBloc bloc;
  late MockGetArticles mockGetArticles;

  setUp(() {
    mockGetArticles = MockGetArticles();
    bloc = ArticleBloc(getArticles: mockGetArticles);
  });

  tearDown(() {
    bloc.close();
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

  group('ArticleBloc', () {
    test('initial state should be ArticleInitial', () {
      expect(bloc.state, const ArticleInitial());
    });

    group('FetchArticles', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleLoading, ArticleLoaded] when FetchArticles is successful',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => Right(tArticles));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchArticles()),
        expect: () => [
          const ArticleLoading(),
          isA<ArticleLoaded>().having((s) => s.articles, 'articles', tArticles),
        ],
        verify: (_) {
          verify(() => mockGetArticles());
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleLoading, ArticleError] when ServerFailure occurs',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchArticles()),
        expect: () => [
          const ArticleLoading(),
          const ArticleError(
            message: 'Failed to fetch articles. Please try again.',
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleLoading, ArticleError] when CacheFailure occurs',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => const Left(CacheFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchArticles()),
        expect: () => [
          const ArticleLoading(),
          const ArticleError(
            message:
                'No cached data available. Please connect to the internet.',
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleLoading, ArticleError] when ApiKeyNotConfiguredFailure occurs',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => const Left(ApiKeyNotConfiguredFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchArticles()),
        expect: () => [
          const ArticleLoading(),
          isA<ArticleError>().having(
            (s) => s.message.contains('API key'),
            'contains API key',
            true,
          ),
        ],
      );
    });

    group('RefreshArticles', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleLoaded] without loading state when RefreshArticles is successful',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => Right(tArticles));
          return bloc;
        },
        act: (bloc) => bloc.add(const RefreshArticles()),
        expect: () => [
          isA<ArticleLoaded>().having((s) => s.articles, 'articles', tArticles),
        ],
        verify: (_) {
          verify(() => mockGetArticles());
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [ArticleError] without loading state when RefreshArticles fails',
        build: () {
          when(
            () => mockGetArticles(),
          ).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const RefreshArticles()),
        expect: () => [
          const ArticleError(
            message: 'Failed to fetch articles. Please try again.',
          ),
        ],
      );
    });
  });
}
