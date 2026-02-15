import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/articles/data/datasources/article_local_data_source.dart';
import 'features/articles/data/datasources/article_remote_data_source.dart';
import 'features/articles/data/repositories/article_repository_impl.dart';
import 'features/articles/domain/repositories/article_repository.dart';
import 'features/articles/domain/usecases/get_articles.dart';
import 'features/articles/presentation/bloc/article_bloc.dart';

final GetIt sl = GetIt.instance;

/// Initializes the dependency injection container.
///
/// Must be called before [runApp] in [main].
Future<void> init() async {
  sl
    // BLoC (Creates new instance each time)
    ..registerFactory(() => ArticleBloc(getArticles: sl()))
    // Use cases (Created once when first accessed)
    ..registerLazySingleton(() => GetArticles(sl()))
    // Repository
    ..registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    )
    // Data sources
    ..registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<ArticleLocalDataSource>(
      () => ArticleLocalDataSourceImpl(sharedPreferences: sl()),
    )
    // Core
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    // SharedPreferences
    ..registerLazySingleton(() => sharedPreferences)
    // HTTP client
    ..registerLazySingleton(http.Client.new)
    // Internet connection checker
    ..registerLazySingleton(InternetConnectionChecker.createInstance);
}
