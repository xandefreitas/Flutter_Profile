import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPreferencesUtil {
  static Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  static Future<Locale> setLocale(Locale locale) async {
    var sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setString("language", locale.languageCode);
    return await getLocale();
  }

  static Future<Locale> getLocale() async {
    var sharedPreferences = await _getSharedPreferences();
    var locale = sharedPreferences.getString("language") ?? 'pt';
    return Locale(locale);
  }
}
