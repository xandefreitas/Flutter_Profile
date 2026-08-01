import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesUtil {
  static Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  static Future<Locale> setLocale(Locale locale) async {
    final sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setString('language', locale.languageCode);
    return getLocale();
  }

  static Future<Locale> getLocale() async {
    final sharedPreferences = await _getSharedPreferences();
    final locale = sharedPreferences.getString('language') ?? 'en';
    return Locale(locale);
  }
}
