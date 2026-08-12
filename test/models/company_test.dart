import 'dart:convert';

import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test(
      'BUG: throws even when occupations is absent, because the `?? []` fallback list literal '
      'is inferred as List<dynamic> and still fails the List<Map<String, dynamic>> cast',
      () {
        expect(() => Company.fromMap({'name': 'Acme'}), throwsA(isA<TypeError>()));
      },
    );

    test('parses occupations when the list is explicitly List<Map<String, dynamic>>', () {
      final company = Company.fromMap({
        'name': 'Acme',
        'occupations': <Map<String, dynamic>>[
          {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
        ],
      });
      expect(company.occupations, [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    });

    test(
      'BUG: throws when occupations comes from real JSON decoding (List<dynamic> of Map<String,dynamic>), '
      'because fromMap casts directly to List<Map<String, dynamic>> instead of using List<dynamic>',
      () {
        final realisticJson = jsonDecode(
          jsonEncode({
            'name': 'Acme',
            'occupations': [
              {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
            ],
          }),
        );

        expect(() => Company.fromMap(realisticJson as Map<String, dynamic>), throwsA(isA<TypeError>()));
      },
    );
  });

  test('toJson/fromJson round-trip via explicit typed occupations', () {
    final company = Company(name: 'Acme', occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    final decoded = jsonDecode(company.toJson()) as Map<String, dynamic>;
    final restored = _fromMapWithTypedOccupations(decoded);
    expect(restored, company);
  });

  test('equality uses listEquals for occupations', () {
    final a = Company(name: 'Acme', occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    final b = Company(name: 'Acme', occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    expect(a, b);
  });

  test('copyWith overrides only given fields', () {
    final company = Company(name: 'Acme', occupations: const []);
    final copy = company.copyWith(name: 'New Name');
    expect(copy.name, 'New Name');
    expect(copy.occupations, company.occupations);
  });
}

/// Rebuilds a decoded JSON map with `occupations` re-typed as
/// `List<Map<String, dynamic>>` to work around the cast bug documented above,
/// so the round-trip test can exercise `Company.fromMap` without tripping it.
Company _fromMapWithTypedOccupations(Map<String, dynamic> map) {
  final occupations = (map['occupations'] as List).cast<Map<String, dynamic>>();
  return Company.fromMap({...map, 'occupations': occupations});
}
