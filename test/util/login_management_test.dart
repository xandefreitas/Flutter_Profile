import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_profile/common/util/login_management.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  // mock_exceptions keys its registry by MockUser equality (uid included),
  // and that registry is a global, test-run-persistent map — so each test
  // needs its own distinct uid or an earlier test's registered exception
  // leaks into a later test that happens to construct an "equal" MockUser.

  test('returns true and does not sign out when reload/getIdToken succeed', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid-success'));

    final result = await reauthenticateUser(auth);

    expect(result, true);
    expect(auth.currentUser, isNotNull);
  });

  test('keeps the cached session (returns true, does not sign out) when reload throws a non-session error', () async {
    final mockUser = MockUser(uid: 'uid-network-error');
    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    whenCalling(Invocation.method(#reload, [])).on(mockUser).thenThrow(Exception('network error'));

    final result = await reauthenticateUser(auth);

    expect(result, true);
    expect(auth.currentUser, isNotNull);
  });

  test('signs out and returns false when reload throws a dead-session FirebaseAuthException', () async {
    final mockUser = MockUser(uid: 'uid-token-expired');
    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    whenCalling(Invocation.method(#reload, [])).on(mockUser).thenThrow(FirebaseAuthException(code: 'user-token-expired'));

    final result = await reauthenticateUser(auth);

    expect(result, false);
    expect(auth.currentUser, isNull);
  });

  test('keeps the cached session when reload throws a FirebaseAuthException with an unrecognized code', () async {
    final mockUser = MockUser(uid: 'uid-unrecognized-code');
    final auth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
    whenCalling(Invocation.method(#reload, [])).on(mockUser).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

    final result = await reauthenticateUser(auth);

    expect(result, true);
    expect(auth.currentUser, isNotNull);
  });
}
