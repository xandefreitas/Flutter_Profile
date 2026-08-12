import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fromMap', () {
    test('prefers descriptionEn over description when both present', () {
      final certificate = Certificate.fromMap({'descriptionEn': 'English', 'description': 'Portuguese'});
      expect(certificate.description, 'English');
    });

    test('falls back to description when descriptionEn absent', () {
      final certificate = Certificate.fromMap({'description': 'Portuguese'});
      expect(certificate.description, 'Portuguese');
    });

    test('falls back to empty string when both absent', () {
      final certificate = Certificate.fromMap({});
      expect(certificate.description, '');
    });

    test('defaults missing fields to empty string, keeps id/imageUrl null when absent', () {
      final certificate = Certificate.fromMap({});
      expect(certificate.course, '');
      expect(certificate.institution, '');
      expect(certificate.credentialUrl, '');
      expect(certificate.date, '');
      expect(certificate.duration, '');
      expect(certificate.id, null);
      expect(certificate.imageUrl, null);
    });

    test('passes through provided values', () {
      final certificate = Certificate.fromMap({
        'id': '1',
        'imageUrl': 'img.png',
        'course': 'Course',
        'institution': 'Institution',
        'description': 'Desc',
        'credentialUrl': 'url',
        'date': '2024-01-01',
        'duration': '2.5',
      });
      expect(certificate.id, '1');
      expect(certificate.imageUrl, 'img.png');
      expect(certificate.course, 'Course');
      expect(certificate.institution, 'Institution');
      expect(certificate.credentialUrl, 'url');
      expect(certificate.date, '2024-01-01');
      expect(certificate.duration, '2.5');
    });
  });

  test('toJson/fromJson round-trip', () {
    final certificate = Certificate(
      id: '1',
      imageUrl: 'img.png',
      course: 'Course',
      institution: 'Institution',
      description: 'Desc',
      credentialUrl: 'url',
      date: '2024-01-01',
      duration: '2.5',
    );
    final restored = Certificate.fromJson(certificate.toJson());
    expect(restored, certificate);
  });

  test('copyWith with no args returns an equal but not identical copy', () {
    final certificate = Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');
    final copy = certificate.copyWith();
    expect(copy, certificate);
    expect(identical(copy, certificate), false);
  });

  test('copyWith overrides only given fields', () {
    final certificate = Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');
    final copy = certificate.copyWith(course: 'New Course');
    expect(copy.course, 'New Course');
    expect(copy.institution, certificate.institution);
  });

  test('equality and hashCode are field-based', () {
    final a = Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');
    final b = Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
