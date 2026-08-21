import 'package:flutter_profile/common/network/database/deep_cast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deepCastDatabaseValue', () {
    test('returns scalars unchanged', () {
      expect(deepCastDatabaseValue('text'), 'text');
      expect(deepCastDatabaseValue(1), 1);
      expect(deepCastDatabaseValue(true), true);
      expect(deepCastDatabaseValue(null), null);
    });

    test('casts a Map<Object?, Object?> to Map<String, dynamic>, string-keying non-string keys', () {
      final Map<Object?, Object?> raw = {'name': 'Alexandre', 1: 'ignored-key-type'};

      final result = deepCastDatabaseValue(raw);

      expect(result, isA<Map<String, dynamic>>());
      expect(result, {'name': 'Alexandre', '1': 'ignored-key-type'});
    });

    test('recurses into nested maps', () {
      final Map<Object?, Object?> raw = {
        'company': {'name': 'Acme', 'websiteUrl': 'acme.test'},
      };

      final result = deepCastDatabaseValue(raw) as Map<String, dynamic>;

      expect(result['company'], isA<Map<String, dynamic>>());
      expect(result['company'], {'name': 'Acme', 'websiteUrl': 'acme.test'});
    });

    test('recurses into a List, casting each Map element (the array-like RTDB shape)', () {
      final List<Object?> raw = [
        {'role': 'Engineer', 'isCurrentOccupation': true},
        {'role': 'Manager', 'isCurrentOccupation': false},
      ];

      final result = deepCastDatabaseValue(raw) as List<dynamic>;

      expect(result, hasLength(2));
      expect(result[0], isA<Map<String, dynamic>>());
      expect(result[0], {'role': 'Engineer', 'isCurrentOccupation': true});
      expect(result[1], {'role': 'Manager', 'isCurrentOccupation': false});
    });

    test('handles a doubly-nested List<Map> (occupations -> occupationSkills shape)', () {
      final Map<Object?, Object?> raw = {
        'occupations': [
          {
            'role': 'Engineer',
            'occupationSkills': [
              {'title': 'Dart'},
              {'title': 'Flutter'},
            ],
          },
        ],
      };

      final result = deepCastDatabaseValue(raw) as Map<String, dynamic>;
      final occupations = result['occupations'] as List<dynamic>;
      final occupation = occupations.first as Map<String, dynamic>;
      final skills = occupation['occupationSkills'] as List<dynamic>;

      expect(skills, [{'title': 'Dart'}, {'title': 'Flutter'}]);
    });
  });

  group('deepCastDatabaseMap', () {
    test('returns an empty map for a null value', () {
      expect(deepCastDatabaseMap(null), <String, dynamic>{});
    });

    test('returns an empty map for a non-map value (e.g. the node does not exist as an object)', () {
      expect(deepCastDatabaseMap('not a map'), <String, dynamic>{});
    });

    test('returns the cast map for a populated value', () {
      final Map<Object?, Object?> raw = {'id1': {'title': 'Dart'}};

      expect(deepCastDatabaseMap(raw), {
        'id1': {'title': 'Dart'},
      });
    });
  });
}
