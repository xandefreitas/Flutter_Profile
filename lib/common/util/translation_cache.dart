import 'package:translator/translator.dart';

/// Caches machine translations for the lifetime of the app so the same text
/// isn't re-translated over the network every time its widget rebuilds.
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

    final translation = await _translator.translate(text, to: targetLanguageCode);
    _cache[cacheKey] = translation.text;
    return translation.text;
  }
}
