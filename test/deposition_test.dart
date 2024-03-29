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
}
