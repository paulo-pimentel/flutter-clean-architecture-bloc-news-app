import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/articles/presentation/bloc/article_bloc.dart';
import 'injection_container.dart';
import 'router/app_router.dart';

/// Root widget of the application.
///
/// Sets up:
/// - Material 3 theming
/// - BLoC providers
/// - Navigation with go_router
class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<ArticleBloc>()..add(const FetchArticles()),
    child: MaterialApp.router(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      // Router configuration
      routerConfig: appRouter,
    ),
  );
}
