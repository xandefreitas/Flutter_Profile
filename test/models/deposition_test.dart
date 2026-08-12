import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Should return name when deposition added', () {
    final deposition = Deposition(name: 'Alexandre', relationship: 1, deposition: 'sou muito criativo', iconIndex: 0, uid: '');
    expect(deposition.name, 'Alexandre');
  });

  test('Should show error when create a deposition with icon index higher than 11', () {
    expect(() => Deposition(name: 'Alexandre', relationship: 1, deposition: 'sou muito criativo', iconIndex: 12, uid: ''), throwsAssertionError);
  });

  group('fromMap', () {
    test('parses string-valued relationship/iconIndex (works today)', () {
      final deposition = Deposition.fromMap({
        'id': 'abc',
        'uid': 'uid1',
        'name': 'Alexandre',
        'relationship': '3',
        'deposition': 'text',
        'iconIndex': '2',
        'isAnonymous': true,
      });

      expect(deposition.id, 'abc');
      expect(deposition.relationship, 3);
      expect(deposition.iconIndex, 2);
      expect(deposition.isAnonymous, true);
    });

    test(
      'BUG: throws when relationship/iconIndex are already int (real Firebase shape), '
      'because fromMap calls int.tryParse on a non-String value',
      () {
        expect(
          () => Deposition.fromMap({'uid': 'uid1', 'name': 'Alexandre', 'relationship': 3, 'deposition': 'text', 'iconIndex': 2}),
          throwsA(isA<TypeError>()),
        );
      },
    );

    test('defaults missing fields', () {
      final deposition = Deposition.fromMap({'relationship': '0', 'iconIndex': '0'});
      expect(deposition.uid, '');
      expect(deposition.name, '');
      expect(deposition.deposition, '');
      expect(deposition.isAnonymous, false);
    });
  });

  test(
    'BUG: toJson/fromJson round-trip is broken by the same int.tryParse bug, since toMap '
    'always encodes relationship/iconIndex as real ints',
    () {
      final deposition = Deposition(id: '1', name: 'Alexandre', relationship: 2, deposition: 'text', iconIndex: 5, uid: 'uid1', isAnonymous: true);
      expect(() => Deposition.fromJson(deposition.toJson()), throwsA(isA<TypeError>()));
    },
  );

  test('copyWith overrides only given fields', () {
    final deposition = Deposition(id: '1', name: 'Alexandre', relationship: 2, deposition: 'text', iconIndex: 5, uid: 'uid1');
    final copy = deposition.copyWith(name: 'Other');
    expect(copy.name, 'Other');
    expect(copy.id, deposition.id);
    expect(copy.relationship, deposition.relationship);
  });

  test('equality and hashCode are field-based', () {
    final a = Deposition(id: '1', name: 'Alexandre', relationship: 2, deposition: 'text', iconIndex: 5, uid: 'uid1');
    final b = Deposition(id: '1', name: 'Alexandre', relationship: 2, deposition: 'text', iconIndex: 5, uid: 'uid1');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
