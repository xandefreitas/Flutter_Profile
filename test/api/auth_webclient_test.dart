import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('signIn', () {
    test('creates a user document when the signed-in user has no displayName yet', () async {
      final firestore = FakeFirebaseFirestore();
      final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'uid1', phoneNumber: '+100', displayName: null));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      await webClient.signIn(pin: '123456');

      final doc = await firestore.collection('users').doc('uid1').get();
      expect(doc.exists, true);
      expect(doc.data()!['uid'], 'uid1');
      expect(doc.data()!['roleValue'], 0);
    });

    test('does not create a user document when displayName is already set', () async {
      final firestore = FakeFirebaseFirestore();
      final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'uid1', displayName: 'Alexandre'));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      await webClient.signIn(pin: '123456');

      final doc = await firestore.collection('users').doc('uid1').get();
      expect(doc.exists, false);
    });
  });

  test('reauthenticate returns a UserCredential for the current user', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
    final webClient = AuthWebclient(auth: auth, firestore: FakeFirebaseFirestore());

    final credential = await webClient.reauthenticate(pin: '123456');

    expect(credential.user?.uid, 'uid1');
  });

  test('signInAnonymously signs in an anonymous user', () async {
    final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'uid1', isAnonymous: true));
    final webClient = AuthWebclient(auth: auth, firestore: FakeFirebaseFirestore());

    final credential = await webClient.signInAnonymously();

    expect(credential.user?.isAnonymous, true);
  });

  test('updateDisplayName updates both the Auth profile and the Firestore user document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('uid1').set({'uid': 'uid1', 'displayName': ''});
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
    final webClient = AuthWebclient(auth: auth, firestore: firestore);

    await webClient.updateDisplayName('Alexandre');

    expect(auth.currentUser!.displayName, 'Alexandre');
    final doc = await firestore.collection('users').doc('uid1').get();
    expect(doc.data()!['displayName'], 'Alexandre');
  });

  group('updateFcmToken', () {
    test('merges the token into an existing user document without clobbering other fields', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('uid1').set({'uid': 'uid1', 'roleValue': 1});
      final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      await webClient.updateFcmToken('token-abc');

      final doc = await firestore.collection('users').doc('uid1').get();
      expect(doc.data(), {'uid': 'uid1', 'roleValue': 1, 'fcmToken': 'token-abc'});
    });

    test('creates the document when none exists yet', () async {
      final firestore = FakeFirebaseFirestore();
      final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      await webClient.updateFcmToken('token-abc');

      final doc = await firestore.collection('users').doc('uid1').get();
      expect(doc.data(), {'fcmToken': 'token-abc'});
    });
  });

  test('createUser writes the expected fields to Firestore', () async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth(mockUser: MockUser(uid: 'uid1'));
    final webClient = AuthWebclient(auth: auth, firestore: firestore);

    await webClient.createUser(MockUser(uid: 'uid1', phoneNumber: '+100', displayName: 'Alexandre'));

    final doc = await firestore.collection('users').doc('uid1').get();
    expect(doc.data(), {'uid': 'uid1', 'phoneNumber': '+100', 'displayName': 'Alexandre', 'roleValue': 0});
  });

  test('deleteUser removes the Firestore user document', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('uid1').set({'uid': 'uid1'});
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
    final webClient = AuthWebclient(auth: auth, firestore: firestore);

    await webClient.deleteUser(auth.currentUser!);

    final doc = await firestore.collection('users').doc('uid1').get();
    expect(doc.exists, false);
  });

  group('getUserRole', () {
    test('returns false without touching Firestore for an anonymous user', () async {
      final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', isAnonymous: true));
      final webClient = AuthWebclient(auth: auth, firestore: FakeFirebaseFirestore());

      expect(await webClient.getUserRole(), false);
    });

    test('returns true for a non-anonymous user with the admin role value', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('uid1').set({'roleValue': UserRole.ADMIN.value});
      final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      expect(await webClient.getUserRole(), true);
    });

    test('returns false for a non-anonymous user without the admin role value', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('uid1').set({'roleValue': UserRole.USER.value});
      final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1'));
      final webClient = AuthWebclient(auth: auth, firestore: firestore);

      expect(await webClient.getUserRole(), false);
    });
  });

  group('getPersonalData', () {
    test('returns default PersonalData when the document is empty', () async {
      final webClient = AuthWebclient(auth: MockFirebaseAuth(), firestore: FakeFirebaseFirestore());

      final personalData = await webClient.getPersonalData();

      expect(personalData.email, '');
    });

    test('parses the document when populated', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('profileData').doc('data').set({'email': 'a@b.com'});
      final webClient = AuthWebclient(auth: MockFirebaseAuth(), firestore: firestore);

      final personalData = await webClient.getPersonalData();

      expect(personalData.email, 'a@b.com');
    });

    test('honors an explicit Source.cache read', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('profileData').doc('data').set({'email': 'a@b.com'});
      final webClient = AuthWebclient(auth: MockFirebaseAuth(), firestore: firestore);

      final personalData = await webClient.getPersonalData(source: Source.cache);

      expect(personalData.email, 'a@b.com');
    });
  });
}
