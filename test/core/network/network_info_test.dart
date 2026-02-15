import 'package:flutter_news_portfolio/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockConnectionChecker;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockConnectionChecker);
  });

  group('NetworkInfoImpl', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);
        when(
          () => mockConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnectionFuture);

        // act
        final result = networkInfo.isConnected;

        // assert
        verify(() => mockConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );

    test('should return true when device is connected', () async {
      // arrange
      when(
        () => mockConnectionChecker.hasConnection,
      ).thenAnswer((_) async => true);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, true);
    });

    test('should return false when device is not connected', () async {
      // arrange
      when(
        () => mockConnectionChecker.hasConnection,
      ).thenAnswer((_) async => false);

      // act
      final result = await networkInfo.isConnected;

      // assert
      expect(result, false);
    });
  });
}
