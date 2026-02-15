import 'dart:convert';

import 'package:flutter_clean_architecture_bloc_news_app/features/articles/data/models/article_model.dart';
import 'package:flutter_clean_architecture_bloc_news_app/features/articles/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tArticleModel = ArticleModel(
    title: 'Test Article Title',
    description: 'This is a test article description.',
    imageUrl: 'https://example.com/image.jpg',
    publishedAt: DateTime.fromMillisecondsSinceEpoch(0),
    author: 'John Doe',
    url: 'https://example.com/article',
    sourceName: 'Test News',
  );

  group('ArticleModel', () {
    test('should be a subclass of Article entity', () {
      // assert
      expect(tArticleModel, isA<Article>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final jsonMap =
            json.decode(fixture('articles.json')) as Map<String, dynamic>;
        final articlesJson = jsonMap['articles'] as List<dynamic>;
        final firstArticleJson = articlesJson[0] as Map<String, dynamic>;

        // act
        final result = ArticleModel.fromJson(firstArticleJson);

        // assert
        expect(result.title, 'Test Article Title');
        expect(result.description, 'This is a test article description.');
        expect(result.imageUrl, 'https://example.com/image.jpg');
        expect(result.author, 'John Doe');
        expect(result.url, 'https://example.com/article');
        expect(result.sourceName, 'Test News');
      });

      test('should handle null values with defaults', () {
        // arrange
        final jsonMap =
            json.decode(fixture('articles.json')) as Map<String, dynamic>;
        final articlesJson = jsonMap['articles'] as List<dynamic>;
        final secondArticleJson = articlesJson[1] as Map<String, dynamic>;

        // act
        final result = ArticleModel.fromJson(secondArticleJson);

        // assert
        expect(result.title, 'Second Article');
        expect(result.description, ''); // null -> empty string
        expect(result.imageUrl, ''); // null -> empty string
        expect(result.author, ''); // null -> empty string
        expect(result.sourceName, 'Another Source');
      });

      test('should handle missing date with epoch default', () {
        // arrange
        final jsonMap = <String, dynamic>{
          'title': 'Test',
          'publishedAt': null,
          'source': {'name': 'Test'},
        };

        // act
        final result = ArticleModel.fromJson(jsonMap);

        // assert
        expect(result.publishedAt, DateTime.fromMillisecondsSinceEpoch(0));
      });

      test('should handle invalid date with epoch default', () {
        // arrange
        final jsonMap = <String, dynamic>{
          'title': 'Test',
          'publishedAt': 'invalid-date',
          'source': {'name': 'Test'},
        };

        // act
        final result = ArticleModel.fromJson(jsonMap);

        // assert
        expect(result.publishedAt, DateTime.fromMillisecondsSinceEpoch(0));
      });

      test('should handle missing source object', () {
        // arrange
        final jsonMap = <String, dynamic>{
          'title': 'Test',
          'publishedAt': '2025-02-14T10:00:00Z',
        };

        // act
        final result = ArticleModel.fromJson(jsonMap);

        // assert
        expect(result.sourceName, '');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () {
        // arrange
        final model = ArticleModel(
          title: 'Test Title',
          description: 'Test Description',
          imageUrl: 'https://example.com/image.jpg',
          publishedAt: DateTime.parse('2025-02-14T10:00:00.000Z'),
          author: 'Test Author',
          url: 'https://example.com/article',
          sourceName: 'Test Source',
        );

        // act
        final result = model.toJson();

        // assert
        expect(result['title'], 'Test Title');
        expect(result['description'], 'Test Description');
        expect(result['urlToImage'], 'https://example.com/image.jpg');
        expect(result['publishedAt'], '2025-02-14T10:00:00.000Z');
        expect(result['author'], 'Test Author');
        expect(result['url'], 'https://example.com/article');
        expect(result['source'], {'name': 'Test Source'});
      });

      test('should produce JSON that can be parsed back', () {
        // arrange
        final model = ArticleModel(
          title: 'Round Trip Test',
          description: 'Testing JSON round trip',
          imageUrl: 'https://example.com/image.jpg',
          publishedAt: DateTime.parse('2025-02-14T10:00:00.000Z'),
          author: 'Author',
          url: 'https://example.com/article',
          sourceName: 'Source',
        );

        // act
        final json = model.toJson();
        final parsed = ArticleModel.fromJson(json);

        // assert
        expect(parsed.title, model.title);
        expect(parsed.description, model.description);
        expect(parsed.imageUrl, model.imageUrl);
        expect(parsed.author, model.author);
        expect(parsed.url, model.url);
        expect(parsed.sourceName, model.sourceName);
      });
    });
  });
}
