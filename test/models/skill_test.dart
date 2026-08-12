import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test('parses a normal map with an int likesQuantity', () {
      final skill = Skill.fromMap({'id': '1', 'title': 'Dart', 'likesQuantity': 5, 'isRecommended': true});
      expect(skill.id, '1');
      expect(skill.title, 'Dart');
      expect(skill.likesQuantity, 5);
      expect(skill.isRecommended, true);
    });

    test('defaults id/title to empty string and isRecommended to false when absent', () {
      final skill = Skill.fromMap({'likesQuantity': 0});
      expect(skill.id, '');
      expect(skill.title, '');
      expect(skill.isRecommended, false);
    });

    test('defaults likesQuantity to 0 when absent', () {
      final skill = Skill.fromMap({'title': 'Dart'});
      expect(skill.likesQuantity, 0);
    });
  });

  test('toJson/fromJson round-trip', () {
    final skill = Skill(id: '1', title: 'Dart', likesQuantity: 3, isRecommended: true);
    final restored = Skill.fromJson(skill.toJson());
    expect(restored, skill);
  });

  test('copyWith overrides only given fields', () {
    final skill = Skill(id: '1', title: 'Dart', likesQuantity: 3);
    final copy = skill.copyWith(likesQuantity: 4);
    expect(copy.likesQuantity, 4);
    expect(copy.title, skill.title);
  });

  test('equality and hashCode are field-based', () {
    final a = Skill(id: '1', title: 'Dart', likesQuantity: 3);
    final b = Skill(id: '1', title: 'Dart', likesQuantity: 3);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
