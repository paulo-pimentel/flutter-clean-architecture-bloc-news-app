import 'package:flutter/material.dart';

/// Widget displaying an error message with optional retry button.
///
/// Shows a user-friendly error message with an appropriate icon.
/// The retry button is hidden for configuration errors (API key issues).
class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({required this.message, this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  /// Returns `true` if this is a configuration error (API key issue).
  bool get _isConfigError => message.contains('API key');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isConfigError ? Icons.key_off : Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            ),
            // Only show retry button for non-configuration errors
            if (!_isConfigError && onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
