import 'package:intl/intl.dart';

abstract class DateUtil {
  static formatDate(String? date) {
    if (date != null && date != '') {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }
    return '';
  }
}
