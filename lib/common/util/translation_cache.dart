import 'package:translator/translator.dart';

import 'shared_preferences_util.dart';

/// Caches machine translations both in memory (so the same text isn't
/// re-translated over the network every time its widget rebuilds) and on
/// disk (so a translation already seen in a previous session is available
/// immediately, and survives switching languages with no connection).
class TranslationCache {
  TranslationCache._();

  static final TranslationCache instance = TranslationCache._();

  final Map<String, String> _cache = {};
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translate({
    required String text,
    required String targetLanguageCode,
    required String cacheKeyPrefix,
  }) async {
    final cacheKey = '${cacheKeyPrefix}_$targetLanguageCode';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    final persisted = await SharedPreferencesUtil.getCachedTranslation(cacheKey);
    if (persisted != null) {
      _cache[cacheKey] = persisted;
      return persisted;
    }

    try {
      final translation = await _translator.translate(text, to: targetLanguageCode);
      _cache[cacheKey] = translation.text;
      await SharedPreferencesUtil.setCachedTranslation(cacheKey, translation.text);
      return translation.text;
    } catch (e) {
      // Offline with nothing cached yet for this text/language pair — show
      // the original text instead of leaving the caller's Future rejected.
      return text;
    }
  }
}
