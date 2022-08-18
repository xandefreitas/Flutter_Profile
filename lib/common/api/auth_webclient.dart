import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../enums/user_role.dart';

class AuthWebclient {
  final FirebaseAuth auth;
  AuthWebclient({required this.auth});
  String verificationId = '';

  Future<void> verifyNumber({required String phoneNumber, required int timeoutDuration}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneCredential) {
        auth.signInWithCredential(phoneCredential);
      },
      verificationFailed: (FirebaseException e) {
        print(e);
      },
      codeSent: (String verificationID, int? resendToken) async {
        verificationId = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        verificationId = verificationID;
      },
      timeout: Duration(seconds: timeoutDuration),
    );
  }

  Future<UserCredential> signIn(String pin) async {
    final UserCredential userCredential = await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin));
    if (userCredential.user?.displayName == null) createUser(auth.currentUser!);
    return userCredential;
  }

  Future<UserCredential> signInAnonymously() async {
    final userCredential = await auth.signInAnonymously();
    return userCredential;
  }

  Future<void> updateDisplayName(String name) async {
    final User user = auth.currentUser!;
    await user.updateDisplayName(name);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "displayName": name,
    });
  }

  Future<void> createUser(User user) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "phoneNumber": user.phoneNumber,
      "displayName": user.displayName ?? '',
      "roleValue": 0,
    });
  }

  static Future<bool> getUserRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    if (!user.isAnonymous) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return snapshot['roleValue'] == UserRole.ADMIN.value;
    }
    return false;
  }
}
