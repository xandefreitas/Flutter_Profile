import 'package:flutter_profile/common/models/personal_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test('defaults aboutMeTexts to three empty strings when absent', () {
      final personalData = PersonalData.fromMap({});
      expect(personalData.aboutMeTexts, ['', '', '']);
    });

    test('parses aboutMeTexts when present', () {
      final personalData = PersonalData.fromMap({
        'aboutMeTexts': ['a', 'b', 'c'],
      });
      expect(personalData.aboutMeTexts, ['a', 'b', 'c']);
    });

    test('defaults all string fields to empty string when absent', () {
      final personalData = PersonalData.fromMap({});
      expect(personalData.email, '');
      expect(personalData.phoneNumberBR, '');
      expect(personalData.phoneNumberSE, '');
      expect(personalData.linkedinUrl, '');
      expect(personalData.gitHubUrl, '');
    });
  });

  test('toJson/fromJson round-trip', () {
    final personalData = PersonalData(
      email: 'a@b.com',
      phoneNumberBR: '123',
      phoneNumberSE: '456',
      linkedinUrl: 'linkedin',
      gitHubUrl: 'github',
      aboutMeTexts: ['a', 'b', 'c'],
    );
    final restored = PersonalData.fromJson(personalData.toJson());
    expect(restored, personalData);
  });

  test('copyWith overrides only given fields', () {
    final personalData = PersonalData(email: 'a@b.com');
    final copy = personalData.copyWith(email: 'c@d.com');
    expect(copy.email, 'c@d.com');
    expect(copy.phoneNumberBR, personalData.phoneNumberBR);
  });

  test('equality uses listEquals for aboutMeTexts', () {
    final a = PersonalData(email: 'a@b.com', aboutMeTexts: ['x', 'y', 'z']);
    final b = PersonalData(email: 'a@b.com', aboutMeTexts: ['x', 'y', 'z']);
    expect(a, b);
  });
}
