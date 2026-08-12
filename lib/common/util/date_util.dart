import 'package:intl/intl.dart';

abstract class DateUtil {
  static String formatDate(String? date) {
    if (date != null && date != '') {
      final parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
    }
    return '';
  }
}
