import 'package:equatable/equatable.dart';

/// Sealed class representing failure states in the application.
///
/// Using sealed classes enables exhaustive pattern matching in switch expressions,
/// ensuring all failure cases are handled at compile time.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

/// Failure indicating a server-side error occurred.
///
/// This is returned when API requests fail due to network issues,
/// server errors, or invalid responses.
final class ServerFailure extends Failure {
  const ServerFailure();
}

/// Failure indicating no cached data is available.
///
/// This is returned when the app is offline and no previously
/// cached data exists.
final class CacheFailure extends Failure {
  const CacheFailure();
}

/// Failure indicating the API key is not configured.
///
/// This is returned when the NEWS_API_KEY environment variable
/// is not set during app build.
final class ApiKeyNotConfiguredFailure extends Failure {
  const ApiKeyNotConfiguredFailure();
}
