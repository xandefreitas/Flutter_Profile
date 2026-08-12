import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/certificate_screen_mode.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_profile/screens/CertificatesScreen/certificates_form_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows a validation error and does not call addCertificate when required fields are empty', (tester) async {
    Certificate? added;
    await pumpLocalizedApp(
      tester,
      CertificatesFormScreen(
        title: 'Add certificate',
        screenMode: CertificateScreenMode.ADD.value,
        addCertificate: (certificate) => added = certificate,
        updateCertificate: null,
        removeCertificate: null,
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(added, null);
    expect(find.text('Required Field'), findsWidgets);
  });

  testWidgets('calls addCertificate with the filled-in fields when the form is valid', (tester) async {
    Certificate? added;
    await pumpLocalizedApp(
      tester,
      CertificatesFormScreen(
        title: 'Add certificate',
        screenMode: CertificateScreenMode.ADD.value,
        addCertificate: (certificate) => added = certificate,
        updateCertificate: null,
        removeCertificate: null,
      ),
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Duration'), '2.5');
    await tester.enterText(find.widgetWithText(TextFormField, 'Course'), 'Dart Course');
    await tester.enterText(find.widgetWithText(TextFormField, 'Institution'), 'Some Institution');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Some description');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(added, isNotNull);
    expect(added!.course, 'Dart Course');
    expect(added!.institution, 'Some Institution');
    expect(added!.description, 'Some description');
    expect(added!.duration, '2.5');
  });

  testWidgets('BUG: a non-numeric duration silently becomes an empty string instead of failing validation', (tester) async {
    Certificate? added;
    await pumpLocalizedApp(
      tester,
      CertificatesFormScreen(
        title: 'Add certificate',
        screenMode: CertificateScreenMode.ADD.value,
        addCertificate: (certificate) => added = certificate,
        updateCertificate: null,
        removeCertificate: null,
      ),
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Duration'), 'abc');
    await tester.enterText(find.widgetWithText(TextFormField, 'Course'), 'Dart Course');
    await tester.enterText(find.widgetWithText(TextFormField, 'Institution'), 'Some Institution');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Some description');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(added, isNotNull);
    expect(added!.duration, '');
  });

  testWidgets('update mode pre-fills the fields and shows the delete icon', (tester) async {
    final certificate = Certificate(
      id: '1',
      course: 'Dart Course',
      institution: 'Some Institution',
      description: 'Some description',
      credentialUrl: 'url',
      date: DateTime(2024).toIso8601String(),
      duration: '2.5',
    );

    await pumpLocalizedApp(
      tester,
      CertificatesFormScreen(
        title: 'Edit certificate',
        screenMode: CertificateScreenMode.UPDATE.value,
        certificate: certificate,
        addCertificate: null,
        updateCertificate: (_) {},
        removeCertificate: (_) {},
      ),
    );

    expect(find.widgetWithText(TextFormField, 'Dart Course'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('confirming delete invokes removeCertificate with the certificate id', (tester) async {
    String? removedId;
    final certificate = Certificate(
      id: '1',
      course: 'Dart Course',
      institution: 'Some Institution',
      description: 'Some description',
      credentialUrl: 'url',
      date: DateTime(2024).toIso8601String(),
      duration: '2.5',
    );

    await pumpLocalizedApp(
      tester,
      CertificatesFormScreen(
        title: 'Edit certificate',
        screenMode: CertificateScreenMode.UPDATE.value,
        certificate: certificate,
        addCertificate: null,
        updateCertificate: (_) {},
        removeCertificate: (id) => removedId = id,
      ),
    );

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(removedId, '1');
  });
}
