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

  static Future<void> setCachedResumeHash(String resumeName, String hash) async {
    final sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setString('resumeHash_$resumeName', hash);
  }

  static Future<String?> getCachedResumeHash(String resumeName) async {
    final sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.getString('resumeHash_$resumeName');
  }

  static Future<void> setCachedResumeNames(List<String> resumeNames) async {
    final sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setStringList('resumeNames', resumeNames);
  }

  static Future<List<String>> getCachedResumeNames() async {
    final sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.getStringList('resumeNames') ?? [];
  }

  static Future<void> setCachedTranslation(String cacheKey, String translation) async {
    final sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.setString('translation_$cacheKey', translation);
  }

  static Future<String?> getCachedTranslation(String cacheKey) async {
    final sharedPreferences = await _getSharedPreferences();
    return sharedPreferences.getString('translation_$cacheKey');
  }
}
