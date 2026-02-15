import 'dart:convert';

import 'package:flutter_news_portfolio/core/error/exceptions.dart';
import 'package:flutter_news_portfolio/features/articles/data/datasources/article_local_data_source.dart';
import 'package:flutter_news_portfolio/features/articles/data/models/article_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ArticleLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ArticleLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('ArticleLocalDataSourceImpl', () {
    group('getLastArticles', () {
      final tArticleModels =
          (json.decode(fixture('articles_cached.json')) as List<dynamic>)
              .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
              .toList();

      test(
        'should return List<ArticleModel> from SharedPreferences when there is cached data',
        () async {
          // arrange
          when(
            () => mockSharedPreferences.getString(any()),
          ).thenReturn(fixture('articles_cached.json'));

          // act
          final result = await dataSource.getLastArticles();

          // assert
          verify(() => mockSharedPreferences.getString(cachedArticlesKey));
          expect(result, isA<List<ArticleModel>>());
          expect(result.length, tArticleModels.length);
          expect(result[0].title, tArticleModels[0].title);
        },
      );

      test(
        'should throw CacheException when there is no cached data',
        () async {
          // arrange
          when(() => mockSharedPreferences.getString(any())).thenReturn(null);

          // act & assert
          expect(
            () => dataSource.getLastArticles(),
            throwsA(isA<CacheException>()),
          );
        },
      );

      test(
        'should throw CacheException when cached data is empty string',
        () async {
          // arrange
          when(() => mockSharedPreferences.getString(any())).thenReturn('');

          // act & assert
          expect(
            () => dataSource.getLastArticles(),
            throwsA(isA<CacheException>()),
          );
        },
      );

      test(
        'should throw CacheException when cached data is invalid JSON',
        () async {
          // arrange
          when(
            () => mockSharedPreferences.getString(any()),
          ).thenReturn('invalid json');

          // act & assert
          expect(
            () => dataSource.getLastArticles(),
            throwsA(isA<CacheException>()),
          );
        },
      );
    });

    group('cacheArticles', () {
      final tArticleModel = ArticleModel(
        title: 'Test Title',
        description: 'Test Description',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: DateTime.parse('2025-02-14T10:00:00.000Z'),
        author: 'Test Author',
        url: 'https://example.com/article',
        sourceName: 'Test Source',
      );
      final tArticleModels = [tArticleModel];

      test('should call SharedPreferences to cache the data', () async {
        // arrange
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockSharedPreferences.setInt(any(), any()),
        ).thenAnswer((_) async => true);

        // act
        await dataSource.cacheArticles(tArticleModels);

        // assert
        final expectedJsonString = json.encode(
          tArticleModels.map((a) => a.toJson()).toList(),
        );
        verify(
          () => mockSharedPreferences.setString(
            cachedArticlesKey,
            expectedJsonString,
          ),
        );
      });

      test('should store timestamp when caching articles', () async {
        // arrange
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockSharedPreferences.setInt(any(), any()),
        ).thenAnswer((_) async => true);

        // act
        await dataSource.cacheArticles(tArticleModels);

        // assert
        verify(() => mockSharedPreferences.setInt(cachedTimestampKey, any()));
      });
    });

    group('getCachedTimestamp', () {
      test('should return DateTime when timestamp exists', () async {
        // arrange
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        when(() => mockSharedPreferences.getInt(any())).thenReturn(timestamp);

        // act
        final result = await dataSource.getCachedTimestamp();

        // assert
        verify(() => mockSharedPreferences.getInt(cachedTimestampKey));
        expect(result, isA<DateTime>());
        expect(result?.millisecondsSinceEpoch, timestamp);
      });

      test('should return null when no timestamp exists', () async {
        // arrange
        when(() => mockSharedPreferences.getInt(any())).thenReturn(null);

        // act
        final result = await dataSource.getCachedTimestamp();

        // assert
        expect(result, isNull);
      });
    });
  });
}
