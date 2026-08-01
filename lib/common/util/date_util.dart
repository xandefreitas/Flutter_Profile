import 'package:intl/intl.dart';

abstract class DateUtil {
  static String formatDate(String? date) {
    if (date != null && date != '') {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }
    return '';
  }
}
