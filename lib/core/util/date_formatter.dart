/// Utility class for date formatting operations.
///
/// Provides methods to format dates in a human-readable format,
/// such as "Today", "Yesterday", or "X days ago".
abstract class DateFormatter {
  /// Formats a [DateTime] to a relative date string.
  ///
  /// Returns:
  /// - "Today" if the date is today
  /// - "Yesterday" if the date is yesterday
  /// - "X days ago" for other cases
  static String formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(date).inDays;

    return switch (difference) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => '$difference days ago',
    };
  }
}
