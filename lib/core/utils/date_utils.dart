import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  static DateTime? parseDateTime(String? dateString) {
    if (dateString == null) return null;
    return DateTime.tryParse(dateString);
  }
}