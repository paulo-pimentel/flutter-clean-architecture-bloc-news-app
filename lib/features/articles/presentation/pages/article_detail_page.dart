import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/article.dart';

/// Detail page displaying article content in a WebView.
///
/// Features:
/// - Loading progress indicator
/// - JavaScript enabled for full page functionality
/// - Back navigation to article list
class ArticleDetailPage extends StatefulWidget {
  /// Creates an [ArticleDetailPage] with the given [article].
  const ArticleDetailPage({required this.article, super.key});

  /// The article to display.
  final Article article;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late final WebViewController _controller;
  var _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  /// Initializes the WebView controller with settings and URL.
  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (_) {
            setState(() {
              _loadingProgress = 0;
            });
          },
          onPageFinished: (_) {
            setState(() {
              _loadingProgress = 100;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.article.sourceName.isNotEmpty
            ? widget.article.sourceName
            : 'Article',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      // Loading progress indicator
      bottom: _loadingProgress < 100
          ? PreferredSize(
              preferredSize: const Size.fromHeight(2),
              child: LinearProgressIndicator(value: _loadingProgress / 100),
            )
          : null,
    ),
    body: WebViewWidget(controller: _controller),
  );
}
