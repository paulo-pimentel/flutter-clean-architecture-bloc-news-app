import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract interface for checking network connectivity.
///
/// This abstraction allows for easy mocking in tests and
/// decouples the app from the specific connectivity implementation.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using [InternetConnectionChecker].
///
/// This class forwards connectivity checks to the underlying library.
class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl(this.connectionChecker);

  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
