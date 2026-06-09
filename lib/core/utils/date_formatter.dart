import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String relative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return DateFormat.yMMMd().format(dateTime);
  }

  static String time(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static String messageTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final isToday = now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;

    if (isToday) {
      return DateFormat.jm().format(dateTime);
    }

    return DateFormat('MMM d, h:mm a').format(dateTime);
  }
}
