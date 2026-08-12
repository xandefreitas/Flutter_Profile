import 'dart:convert';

import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test('occupations absent defaults to empty list', () {
      final company = Company.fromMap({'name': 'Acme'});
      expect(company.occupations, isEmpty);
    });

    test('parses occupations when the list is explicitly List<Map<String, dynamic>>', () {
      final company = Company.fromMap({
        'name': 'Acme',
        'occupations': <Map<String, dynamic>>[
          {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
        ],
      });
      expect(company.occupations, [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    });

    test('parses occupations from real JSON decoding (List<dynamic> of Map<String,dynamic>)', () {
      final realisticJson = jsonDecode(
        jsonEncode({
          'name': 'Acme',
          'occupations': [
            {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
          ],
        }),
      );

      final company = Company.fromMap(realisticJson as Map<String, dynamic>);

      expect(company.occupations, [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    });
  });

  test('toJson/fromJson round-trip', () {
    final company = Company(name: 'Acme', occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)]);
    final restored = Company.fromJson(company.toJson());
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
