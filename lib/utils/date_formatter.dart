import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('d-MMM-yyyy h:mm a').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }
}
