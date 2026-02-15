import 'package:flutter_clean_architecture_bloc_news_app/core/util/date_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateFormatter', () {
    group('formatRelativeDate', () {
      test('should return "Today" for today\'s date', () {
        // arrange
        final today = DateTime.now();

        // act
        final result = DateFormatter.formatRelativeDate(today);

        // assert
        expect(result, 'Today');
      });

      test('should return "Yesterday" for yesterday\'s date', () {
        // arrange
        final yesterday = DateTime.now().subtract(const Duration(days: 1));

        // act
        final result = DateFormatter.formatRelativeDate(yesterday);

        // assert
        expect(result, 'Yesterday');
      });

      test('should return "X days ago" for older dates', () {
        // arrange
        final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));

        // act
        final result = DateFormatter.formatRelativeDate(threeDaysAgo);

        // assert
        expect(result, '3 days ago');
      });

      test('should return "X days ago" for dates over a week old', () {
        // arrange
        final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));

        // act
        final result = DateFormatter.formatRelativeDate(twoWeeksAgo);

        // assert
        expect(result, '14 days ago');
      });
    });
  });
}
