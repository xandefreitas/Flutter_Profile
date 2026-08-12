import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('getLocale defaults to en when nothing is stored', () async {
    expect(await SharedPreferencesUtil.getLocale(), const Locale('en'));
  });

  test('setLocale persists and getLocale round-trips the new locale', () async {
    final result = await SharedPreferencesUtil.setLocale(const Locale('pt'));
    expect(result, const Locale('pt'));
    expect(await SharedPreferencesUtil.getLocale(), const Locale('pt'));
  });
}
