import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../enums/user_role.dart';
import '../models/personal_data.dart';

class AuthWebclient {
  final FirebaseAuth auth;
  AuthWebclient({required this.auth});
  String _verificationId = '';

  Future<void> verifyNumber({
    required String phoneNumber,
    required int timeoutDuration,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneCredential) {},
      verificationFailed: (FirebaseException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationID, int? resendToken) async {
        _verificationId = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        _verificationId = verificationID;
      },
      timeout: Duration(seconds: timeoutDuration),
    );
  }

  signIn({required String pin}) async {
    final UserCredential userCredential = await auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: pin,
      ),
    );
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
    try {
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "phoneNumber": user.phoneNumber,
        "displayName": user.displayName ?? '',
        "roleValue": 0,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> getUserRole() async {
    User user = FirebaseAuth.instance.currentUser!;
    if (!user.isAnonymous) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return snapshot['roleValue'] == UserRole.ADMIN.value;
    }
    return false;
  }

  static Future<PersonalData> getPersonalData() async {
    final response = await FirebaseFirestore.instance.collection('profileData').doc('data').get();
    if (response.data()?.isNotEmpty ?? false) {
      return PersonalData.fromMap(response.data()!);
    } else {
      return PersonalData();
    }
  }
}
