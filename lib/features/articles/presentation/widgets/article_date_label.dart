import 'package:flutter/material.dart';

import '../../../../core/util/date_formatter.dart';

/// Widget displaying article publication date.
///
/// Shows relative date ("Today", "Yesterday", "X days ago").
class ArticleDateLabel extends StatelessWidget {
  const ArticleDateLabel({required this.publishedAt, super.key});

  final DateTime publishedAt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      DateFormatter.formatRelativeDate(publishedAt),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }
}
