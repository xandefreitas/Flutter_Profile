import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test('prefers descriptionEn over description when both present', () {
      final occupation = Occupation.fromMap({'descriptionEn': 'English', 'description': 'Portuguese'});
      expect(occupation.description, 'English');
    });

    test('falls back to description then empty string', () {
      expect(Occupation.fromMap({'description': 'Portuguese'}).description, 'Portuguese');
      expect(Occupation.fromMap({}).description, '');
    });

    test('occupationSkills is null when key absent', () {
      final occupation = Occupation.fromMap({});
      expect(occupation.occupationSkills, null);
    });

    test('occupationSkills parses nested Skill maps when present', () {
      final occupation = Occupation.fromMap({
        'occupationSkills': [
          {'id': '1', 'title': 'Dart', 'likesQuantity': 1},
        ],
      });
      expect(occupation.occupationSkills, [Skill(id: '1', title: 'Dart', likesQuantity: 1)]);
    });

    test('defaults role/startDate/endDate/isCurrentOccupation', () {
      final occupation = Occupation.fromMap({});
      expect(occupation.role, '');
      expect(occupation.startDate, '');
      expect(occupation.endDate, '');
      expect(occupation.isCurrentOccupation, false);
    });
  });

  test('toJson/fromJson round-trip', () {
    final occupation = Occupation(
      role: 'Developer',
      startDate: '2020',
      endDate: '2022',
      description: 'Desc',
      isCurrentOccupation: false,
      occupationSkills: [Skill(id: '1', title: 'Dart')],
    );
    final restored = Occupation.fromJson(occupation.toJson());
    expect(restored, occupation);
  });

  test('copyWith overrides only given fields', () {
    final occupation = Occupation(role: 'Developer', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false);
    final copy = occupation.copyWith(role: 'Senior Developer');
    expect(copy.role, 'Senior Developer');
    expect(copy.startDate, occupation.startDate);
  });

  test('equality uses listEquals for occupationSkills', () {
    final a = Occupation(
      role: 'Developer',
      startDate: '2020',
      endDate: '2022',
      description: 'Desc',
      isCurrentOccupation: false,
      occupationSkills: [Skill(id: '1', title: 'Dart')],
    );
    final b = Occupation(
      role: 'Developer',
      startDate: '2020',
      endDate: '2022',
      description: 'Desc',
      isCurrentOccupation: false,
      occupationSkills: [Skill(id: '1', title: 'Dart')],
    );
    expect(a, b);
  });
}
