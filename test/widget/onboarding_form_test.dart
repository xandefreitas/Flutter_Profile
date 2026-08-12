import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_profile/screens/OnboardingScreen/components/onboarding_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthWebclient extends Mock implements AuthWebclient {}

class FakeUserCredential extends Fake implements UserCredential {}

/// Mirrors `OnboardingPhoneBody`: the SAME `OnboardingForm` instance persists
/// across index transitions (parent rebuilds it in place with a new
/// `verificationStatusIndex`), so its State (and e.g. `resendCodeTimer`) is
/// preserved rather than re-initialized — exactly like production.
class _Harness extends StatefulWidget {
  final AuthWebclient authWebclient;
  final int initialIndex;
  const _Harness({required this.authWebclient, this.initialIndex = 0});

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  late int verificationStatusIndex = widget.initialIndex;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OnboardingForm(
      formKey: formKey,
      verificationStatusIndex: verificationStatusIndex,
      nextVerificationStatusIndex: () => setState(() => verificationStatusIndex += 1),
      firstVerificationStatusIndex: () => setState(() => verificationStatusIndex = 0),
      auth: MockFirebaseAuth(),
      authWebclient: widget.authWebclient,
    );
  }
}

Future<void> pumpHarness(WidgetTester tester, {required AuthWebclient authWebclient, int initialIndex = 0}) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: _Harness(authWebclient: authWebclient, initialIndex: initialIndex)),
    ),
  );
}

void main() {
  group('name field (verificationStatusIndex 2)', () {
    testWidgets('shows the min-length error and does not call updateDisplayName for a short name', (tester) async {
      final authWebclient = MockAuthWebclient();
      await pumpHarness(tester, authWebclient: authWebclient, initialIndex: OTPVerification.INPUTNAME.value);
      final formKey = tester.state<_HarnessState>(find.byType(_Harness)).formKey;

      await tester.enterText(find.byType(TextFormField), 'Al');
      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Name must have more than 4 letters'), findsOneWidget);
      verifyNever(() => authWebclient.updateDisplayName(any()));
    });

    testWidgets('calls updateDisplayName for a valid name once validated', (tester) async {
      final authWebclient = MockAuthWebclient();
      when(() => authWebclient.updateDisplayName(any())).thenAnswer((_) async {});
      await pumpHarness(tester, authWebclient: authWebclient, initialIndex: OTPVerification.INPUTNAME.value);
      final formKey = tester.state<_HarnessState>(find.byType(_Harness)).formKey;

      await tester.enterText(find.byType(TextFormField), 'Alexandre');
      formKey.currentState!.validate();
      await tester.pump();

      verify(() => authWebclient.updateDisplayName('Alexandre')).called(1);
    });
  });

  group('phone field (verificationStatusIndex 0)', () {
    testWidgets('shows an error and does not call verifyNumber when the number is empty', (tester) async {
      final authWebclient = MockAuthWebclient();
      await pumpHarness(tester, authWebclient: authWebclient);

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text('Invalid Number'), findsOneWidget);
      verifyNever(
        () => authWebclient.verifyNumber(
          phoneNumber: any(named: 'phoneNumber'),
          timeoutDuration: any(named: 'timeoutDuration'),
          whenVerified: any(named: 'whenVerified'),
          onError: any(named: 'onError'),
        ),
      );
    });

    testWidgets('calls verifyNumber and advances to the OTP screen on whenVerified for a valid number', (tester) async {
      final authWebclient = MockAuthWebclient();
      when(
        () => authWebclient.verifyNumber(
          phoneNumber: any(named: 'phoneNumber'),
          timeoutDuration: any(named: 'timeoutDuration'),
          whenVerified: any(named: 'whenVerified'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final whenVerified = invocation.namedArguments[#whenVerified] as void Function();
        whenVerified();
      });
      await pumpHarness(tester, authWebclient: authWebclient);

      await tester.enterText(find.byType(TextFormField), '911234567');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      verify(
        () => authWebclient.verifyNumber(
          phoneNumber: any(named: 'phoneNumber'),
          timeoutDuration: any(named: 'timeoutDuration'),
          whenVerified: any(named: 'whenVerified'),
          onError: any(named: 'onError'),
        ),
      ).called(1);
      // Advancing to the OTP screen swaps the phone field for the pin field.
      expect(find.byType(EditableText), findsWidgets);

      // Let the resend countdown (started by whenVerified) run out so its
      // periodic Timer self-cancels before the test ends.
      await tester.pump(const Duration(seconds: 61));
    });
  });

  group('OTP field (verificationStatusIndex 1, reached via the phone flow)', () {
    Future<AuthWebclient> driveToOtpScreen(WidgetTester tester) async {
      final authWebclient = MockAuthWebclient();
      when(
        () => authWebclient.verifyNumber(
          phoneNumber: any(named: 'phoneNumber'),
          timeoutDuration: any(named: 'timeoutDuration'),
          whenVerified: any(named: 'whenVerified'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        (invocation.namedArguments[#whenVerified] as void Function())();
      });
      await pumpHarness(tester, authWebclient: authWebclient);
      await tester.enterText(find.byType(TextFormField), '911234567');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      return authWebclient;
    }

    testWidgets('calls signIn with the completed pin and the resend timer self-cancels on completion', (tester) async {
      final authWebclient = await driveToOtpScreen(tester);
      when(() => authWebclient.signIn(pin: any(named: 'pin'))).thenAnswer((_) async => FakeUserCredential());

      await tester.enterText(find.byType(EditableText).first, '123456');
      await tester.pump();

      verify(() => authWebclient.signIn(pin: '123456')).called(1);
    });

    testWidgets(
      'BUG: when signIn fails, the surrounding try/catch never runs because signIn is async — '
      'the error escapes unhandled instead of showing the intended "Code is Invalid!" snackbar',
      (tester) async {
        final authWebclient = await driveToOtpScreen(tester);
        when(() => authWebclient.signIn(pin: any(named: 'pin'))).thenAnswer((_) async => throw Exception('invalid code'));

        Object? escaped;
        await runZonedGuarded(() async {
          await tester.enterText(find.byType(EditableText).first, '123456');
          await tester.pump();
        }, (error, stack) => escaped = error);

        // The catch block in onCompleted wraps only the synchronous call to
        // signIn(), not its Future, so the rejection is never caught there —
        // it escapes to the zone instead of showing the intended snackbar.
        expect(escaped, isNotNull);
        expect(find.text('Code is Invalid!'), findsNothing);
      },
    );
  });
}
