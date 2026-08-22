import 'package:flutter_profile/common/util/shared_preferences_util.dart';
import 'package:flutter_profile/common/util/translation_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('returns a translation persisted from a previous session without needing the network', () async {
    // A unique cache key per test avoids colliding with TranslationCache's
    // shared, process-lifetime in-memory singleton across other test files.
    const text = 'text seeded straight into the persisted cache';
    await SharedPreferencesUtil.setCachedTranslation('${text}_pt', 'texto pré-armazenado no cache persistido');

    final translated = await TranslationCache.instance.translate(
      text: text,
      targetLanguageCode: 'pt',
      cacheKeyPrefix: text,
    );

    expect(translated, 'texto pré-armazenado no cache persistido');
  });
}
