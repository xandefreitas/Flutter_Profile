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

    test('parses int-valued relationship/iconIndex (real Firebase shape)', () {
      final deposition = Deposition.fromMap({'uid': 'uid1', 'name': 'Alexandre', 'relationship': 3, 'deposition': 'text', 'iconIndex': 2});

      expect(deposition.relationship, 3);
      expect(deposition.iconIndex, 2);
    });

    test('defaults missing fields', () {
      final deposition = Deposition.fromMap({'relationship': '0', 'iconIndex': '0'});
      expect(deposition.uid, '');
      expect(deposition.name, '');
      expect(deposition.deposition, '');
      expect(deposition.isAnonymous, false);
    });
  });

  test('toJson/fromJson round-trip', () {
    final deposition = Deposition(id: '1', name: 'Alexandre', relationship: 2, deposition: 'text', iconIndex: 5, uid: 'uid1', isAnonymous: true);
    final restored = Deposition.fromJson(deposition.toJson());
    expect(restored, deposition);
  });

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
