import 'package:flutter_profile/common/util/date_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns empty string for null', () {
    expect(DateUtil.formatDate(null), '');
  });

  test('returns empty string for empty string', () {
    expect(DateUtil.formatDate(''), '');
  });

  test('formats a valid ISO8601 date as dd/MM/yyyy', () {
    expect(DateUtil.formatDate('2024-03-05'), '05/03/2024');
  });

  test('returns empty string for an invalid non-empty date string', () {
    expect(DateUtil.formatDate('not-a-date'), '');
  });
}
