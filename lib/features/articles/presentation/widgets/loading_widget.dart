import 'package:flutter/material.dart';

/// Widget displaying a centered loading indicator.
///
/// Used when articles are being fetched for the first time.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
