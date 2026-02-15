import 'package:flutter_clean_architecture_bloc_news_app/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_bloc_news_app/features/articles/data/datasources/article_remote_data_source.dart';
import 'package:flutter_clean_architecture_bloc_news_app/features/articles/data/models/article_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ArticleRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() async {
    // Initialize dotenv with test values
    await dotenv.load(
      mergeWith: {'NEWS_API_KEY': 'test_api_key'},
      isOptional: true,
    );
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ArticleRemoteDataSourceImpl(client: mockHttpClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  void setUpMockHttpClientSuccess200() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('articles.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('Not Found', 404));
  }

  void setUpMockHttpClientErrorStatus() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async =>
          http.Response('{"status": "error", "message": "API error"}', 200),
    );
  }

  group('ArticleRemoteDataSourceImpl', () {
    group('getArticles', () {
      test('should perform a GET request with correct headers', () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        await dataSource.getArticles();

        // assert
        verify(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).called(1);
      });

      test('should return List<ArticleModel> when response is 200', () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        final result = await dataSource.getArticles();

        // assert
        expect(result, isA<List<ArticleModel>>());
        expect(result.length, 2);
        expect(result[0].title, 'Test Article Title');
      });

      test(
        'should throw ServerException when the response code is not 200',
        () async {
          // arrange
          setUpMockHttpClientFailure404();

          // act & assert
          expect(
            () => dataSource.getArticles(),
            throwsA(isA<ServerException>()),
          );
        },
      );

      test(
        'should throw ServerException when API returns error status',
        () async {
          // arrange
          setUpMockHttpClientErrorStatus();

          // act & assert
          expect(
            () => dataSource.getArticles(),
            throwsA(isA<ServerException>()),
          );
        },
      );
    });
  });
}
