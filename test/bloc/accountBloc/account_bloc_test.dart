import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/bloc/accountBloc/account_bloc.dart';
import 'package:flutter_profile/common/bloc/accountBloc/account_event.dart';
import 'package:flutter_profile/common/bloc/accountBloc/account_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthWebclient extends Mock implements AuthWebclient {}

class FakeUserCredential extends Fake implements UserCredential {}

void main() {
  late MockAuthWebclient authWebclient;
  late MockFirebaseAuth auth;

  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  setUp(() {
    authWebclient = MockAuthWebclient();
    auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', phoneNumber: '+100'));
  });

  blocTest<AccountBloc, AccountState>(
    'emits [SendingCode, CodeSent] when verifyNumber calls whenVerified',
    build: () {
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
      return AccountBloc(auth: auth, webClient: authWebclient);
    },
    act: (bloc) => bloc.add(AccountDeleteEvent()),
    expect: () => [AccountSendingCodeState(), AccountCodeSentState()],
    verify: (_) {
      verify(() => authWebclient.verifyNumber(phoneNumber: '+100', timeoutDuration: 60, whenVerified: any(named: 'whenVerified'), onError: any(named: 'onError'))).called(1);
    },
  );

  blocTest<AccountBloc, AccountState>(
    'emits [SendingCode, Error] when verifyNumber calls onError',
    build: () {
      when(
        () => authWebclient.verifyNumber(
          phoneNumber: any(named: 'phoneNumber'),
          timeoutDuration: any(named: 'timeoutDuration'),
          whenVerified: any(named: 'whenVerified'),
          onError: any(named: 'onError'),
        ),
      ).thenAnswer((invocation) async {
        final onError = invocation.namedArguments[#onError] as void Function(String, String);
        onError('too-many-requests', 'You exceeded the limit of requests for now, please try again later.');
      });
      return AccountBloc(auth: auth, webClient: authWebclient);
    },
    act: (bloc) => bloc.add(AccountDeleteEvent()),
    expect: () => [
      AccountSendingCodeState(),
      isA<AccountErrorState>().having((s) => s.exception, 'exception', 'You exceeded the limit of requests for now, please try again later.'),
    ],
  );

  blocTest<AccountBloc, AccountState>(
    'emits [VerifyingOtp, Deleted] and signs the user out when reauthenticate/deleteUser succeed',
    build: () {
      when(() => authWebclient.reauthenticate(pin: any(named: 'pin'))).thenAnswer((_) async => FakeUserCredential());
      when(() => authWebclient.deleteUser(any())).thenAnswer((_) async {});
      return AccountBloc(auth: auth, webClient: authWebclient);
    },
    act: (bloc) => bloc.add(const AccountVerifyOtpEvent(pin: '123456')),
    expect: () => [AccountVerifyingOtpState(), AccountDeletedState()],
    verify: (_) {
      verify(() => authWebclient.reauthenticate(pin: '123456')).called(1);
      verify(() => authWebclient.deleteUser(any())).called(1);
      expect(auth.currentUser, null);
    },
  );

  blocTest<AccountBloc, AccountState>(
    'emits [VerifyingOtp, Error] when reauthenticate throws (e.g. wrong pin)',
    build: () {
      when(() => authWebclient.reauthenticate(pin: any(named: 'pin'))).thenThrow(Exception('invalid pin'));
      return AccountBloc(auth: auth, webClient: authWebclient);
    },
    act: (bloc) => bloc.add(const AccountVerifyOtpEvent(pin: '000000')),
    expect: () => [AccountVerifyingOtpState(), isA<AccountErrorState>()],
    verify: (_) {
      verifyNever(() => authWebclient.deleteUser(any()));
    },
  );
}
